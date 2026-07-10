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

class StatsRepository {
  const StatsRepository(this._db);

  final AppDatabase _db;

  /// Expenses of [periodId] grouped by their (leaf) category, biggest first.
  /// Uncategorised spending is folded into a single "Non catégorisé" slice.
  Stream<List<CategorySlice>> watchCategoryBreakdown(int periodId) {
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
          categoryName: cat?.name ?? 'Non catégorisé',
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
