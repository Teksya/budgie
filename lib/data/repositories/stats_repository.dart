import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:drift/drift.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class CategorySlice {
  const CategorySlice({
    required this.categoryName,
    required this.colorValue,
    required this.total,
  });

  final String categoryName;
  final int colorValue;
  final Money total;
}

@immutable
class MonthPoint {
  const MonthPoint({
    required this.start,
    required this.income,
    required this.expense,
  });

  final DateTime start;
  final Money income;
  final Money expense;

  Money get net => income - expense;
}

/// Spending so far this period against the same stretch of the previous one.
///
/// Same *elapsed days*, not same totals: on the 8th of the month, comparing
/// against a full previous month would always look like a triumph.
@immutable
class SpendingComparison {
  const SpendingComparison({required this.current, required this.previous});

  final Money current;

  /// What had been spent by the same day of the previous period.
  final Money previous;

  Money get delta => current - previous;

  /// Signed share of change, e.g. `-0.12` for 12 % less than last month.
  /// Null when the previous period has nothing to compare against.
  double? get ratio =>
      previous.isPositive ? delta.cents / previous.cents : null;
}

/// One category over a stretch of months, next to what it cost over the
/// previous stretch of the same length.
@immutable
class CategoryStat {
  const CategoryStat({
    required this.name,
    required this.colorValue,
    required this.total,
    required this.previous,
  });

  final String name;
  final int colorValue;
  final Money total;

  /// The same category over the previous, equally long stretch.
  final Money previous;

  /// Signed change, e.g. `0.2` for a fifth more than last time. Null when
  /// there is nothing to compare against — a first month, or a brand-new
  /// category. Growth from zero is not "infinity percent", it is just new.
  double? get delta =>
      previous.isPositive ? (total - previous).cents / previous.cents : null;
}

/// Recurring notes — in practice, where the money actually goes. A category
/// says "groceries"; this says which shop.
@immutable
class MerchantStat {
  const MerchantStat({
    required this.label,
    required this.total,
    required this.count,
  });

  final String label;
  final Money total;
  final int count;
}

/// Everything the stats screen shows for the selected number of months.
@immutable
class RangeStats {
  const RangeStats({
    required this.months,
    required this.categories,
    required this.merchants,
    required this.income,
    required this.expenses,
  });

  static const empty = RangeStats(
    months: [],
    categories: [],
    merchants: [],
    income: Money.zero,
    expenses: Money.zero,
  );

  /// Chronological, oldest first — the order the bar chart draws them in.
  final List<MonthPoint> months;

  /// Biggest spend first.
  final List<CategoryStat> categories;
  final List<MerchantStat> merchants;

  final Money income;
  final Money expenses;

  Money get net => income - expenses;
  int get monthCount => months.length;

  Money get averageSpend =>
      monthCount == 0 ? Money.zero : Money(expenses.cents ~/ monthCount);

  bool get isEmpty => income.cents == 0 && expenses.cents == 0;
}

class StatsRepository {
  const StatsRepository(this._db);

  final AppDatabase _db;

  /// Compares [period]'s spending up to [now] with the previous period's
  /// spending over the same number of days.
  Stream<SpendingComparison?> watchSpendingComparison({
    required Period period,
    required DateTime now,
  }) {
    final previous = (_db.select(_db.periods)
          ..where((p) => p.startDate.isSmallerThanValue(period.startDate))
          ..orderBy([(p) => OrderingTerm.desc(p.startDate)])
          ..limit(1))
        .watchSingleOrNull();

    final expenses = (_db.select(_db.transactions)
          ..where((t) => t.type.equalsValue(TxnType.expense)))
        .watch();

    return Rx.combineLatest2(previous, expenses, (prev, txns) {
      if (prev == null) return null;

      // Days consumed so far, both bounds counted, clamped inside the period.
      final today = DateTime(now.year, now.month, now.day);
      final elapsed = today.isBefore(period.startDate)
          ? 0
          : today.difference(period.startDate).inDays + 1;
      if (elapsed <= 0) return null;

      // The same stretch of the previous period. `elapsed - 1` because the
      // start day itself is day one.
      final previousCutoff = prev.startDate.add(Duration(days: elapsed - 1));

      var current = 0;
      var before = 0;
      for (final t in txns) {
        if (t.periodId == period.id) {
          current += t.amountCents;
        } else if (t.periodId == prev.id && !t.date.isAfter(previousCutoff)) {
          before += t.amountCents;
        }
      }
      return SpendingComparison(
        current: Money(current),
        previous: Money(before),
      );
    });
  }

  /// Everything the stats screen needs for the last [months] budget periods,
  /// plus the [months] before them so each category can be shown against its
  /// own recent past.
  ///
  /// Budget periods, not calendar months: a user whose month starts on the 25th
  /// would otherwise see figures that match nothing else in the app.
  Stream<RangeStats> watchRangeStats({
    required int months,
    required String uncategorizedLabel,
  }) {
    final periods =
        (_db.select(_db.periods)
              ..orderBy([(p) => OrderingTerm.desc(p.startDate)])
              ..limit(months * 2))
            .watch();
    final txns = _db.select(_db.transactions).watch();
    final categories = _db.select(_db.categories).watch();

    return Rx.combineLatest3(periods, txns, categories, (ps, ts, cs) {
      if (ps.isEmpty) return RangeStats.empty;

      final current = ps.take(months).toList();
      final earlier = ps.skip(months).toList();
      final currentIds = current.map((p) => p.id).toSet();
      final earlierIds = earlier.map((p) => p.id).toSet();
      final byId = {for (final c in cs) c.id: c};

      var income = 0;
      var expenses = 0;
      final perPeriod = <int, (int income, int expense)>{};
      final byCategory = <int?, int>{};
      final byCategoryBefore = <int?, int>{};
      final byNote = <String, (int total, int count)>{};

      for (final t in ts) {
        final inCurrent = currentIds.contains(t.periodId);
        final inEarlier = earlierIds.contains(t.periodId);
        if (!inCurrent && !inEarlier) continue;

        if (t.type == TxnType.income) {
          if (inCurrent && t.incomeStatus == IncomeStatus.received) {
            income += t.amountCents;
            final row = perPeriod[t.periodId] ?? (0, 0);
            perPeriod[t.periodId] = (row.$1 + t.amountCents, row.$2);
          }
          continue;
        }
        if (t.type != TxnType.expense) continue;

        if (inEarlier) {
          byCategoryBefore[t.categoryId] =
              (byCategoryBefore[t.categoryId] ?? 0) + t.amountCents;
          continue;
        }

        expenses += t.amountCents;
        final row = perPeriod[t.periodId] ?? (0, 0);
        perPeriod[t.periodId] = (row.$1, row.$2 + t.amountCents);
        byCategory[t.categoryId] =
            (byCategory[t.categoryId] ?? 0) + t.amountCents;

        final note = t.note?.trim();
        if (note != null && note.isNotEmpty) {
          final key = note.toLowerCase();
          final seen = byNote[key] ?? (0, 0);
          byNote[key] = (seen.$1 + t.amountCents, seen.$2 + 1);
        }
      }

      final points = [
        for (final p in current.reversed)
          MonthPoint(
            start: p.startDate,
            income: Money(perPeriod[p.id]?.$1 ?? 0),
            expense: Money(perPeriod[p.id]?.$2 ?? 0),
          ),
      ];

      final stats =
          byCategory.entries.map((e) {
            final cat = e.key == null ? null : byId[e.key];
            return CategoryStat(
              name: cat?.name ?? uncategorizedLabel,
              colorValue: cat?.colorValue ?? 0xFF6B7280,
              total: Money(e.value),
              previous: Money(byCategoryBefore[e.key] ?? 0),
            );
          }).toList()
            ..sort((a, b) => b.total.cents.compareTo(a.total.cents));

      // Only notes seen more than once: a one-off purchase is not a habit and
      // would just push the real patterns off the list.
      final merchants =
          byNote.entries.where((e) => e.value.$2 > 1).map((e) {
            return MerchantStat(
              label: e.key,
              total: Money(e.value.$1),
              count: e.value.$2,
            );
          }).toList()
            ..sort((a, b) => b.total.cents.compareTo(a.total.cents));

      return RangeStats(
        months: points,
        categories: stats,
        merchants: merchants.take(5).toList(),
        income: Money(income),
        expenses: Money(expenses),
      );
    });
  }

  /// Expenses of [periodId] grouped by their (leaf) category, biggest first.
  /// Uncategorised spending is folded into a single slice named
  /// [uncategorizedLabel] — passed in because a repository has no business
  /// knowing the user's language.
  Stream<List<CategorySlice>> watchCategoryBreakdown(
    int periodId, {
    required String uncategorizedLabel,
  }) {
    final txns = (_db.select(_db.transactions)
          ..where(
            (t) =>
                t.periodId.equals(periodId) &
                t.type.equalsValue(TxnType.expense),
          ))
        .watch();
    final categories = _db.select(_db.categories).watch();

    return Rx.combineLatest2(txns, categories, (ts, cs) {
      final byId = {for (final c in cs) c.id: c};
      final totals = <int?, int>{};
      for (final t in ts) {
        totals[t.categoryId] = (totals[t.categoryId] ?? 0) + t.amountCents;
      }

      final slices = totals.entries.map((e) {
        final cat = e.key == null ? null : byId[e.key];
        return CategorySlice(
          categoryName: cat?.name ?? uncategorizedLabel,
          colorValue: cat?.colorValue ?? 0xFF6B7280,
          total: Money(e.value),
        );
      }).toList()..sort((a, b) => b.total.cents.compareTo(a.total.cents));
      return slices;
    });
  }

  /// Income (received) vs expense for every period, chronological.
  Stream<List<MonthPoint>> watchMonthlySeries() {
    final periods = (_db.select(_db.periods)
          ..orderBy([(p) => OrderingTerm.asc(p.startDate)]))
        .watch();
    final txns = _db.select(_db.transactions).watch();

    return Rx.combineLatest2(periods, txns, (ps, ts) {
      return ps.map((p) {
        var income = 0;
        var expense = 0;
        for (final t in ts) {
          if (t.periodId != p.id) continue;
          if (t.type == TxnType.income &&
              t.incomeStatus == IncomeStatus.received) {
            income += t.amountCents;
          } else if (t.type == TxnType.expense) {
            expense += t.amountCents;
          }
        }
        return MonthPoint(
          start: p.startDate,
          income: Money(income),
          expense: Money(expense),
        );
      }).toList();
    });
  }
}
