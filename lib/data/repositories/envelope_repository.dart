import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:drift/drift.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class EnvelopeView {
  const EnvelopeView({
    required this.budget,
    required this.category,
    required this.spent,
  });

  final Budget budget;
  final Category category;

  /// Total spent this period against this envelope, sub-categories included.
  final Money spent;

  Money get limit => Money(budget.limitCents) + Money(budget.rolloverInCents);
  Money get remaining => limit - spent;
  double get ratio => spent.ratioOf(limit);
  bool get isOver => spent > limit;
  bool get isNear => !isOver && ratio >= 0.8;
}

class EnvelopeRepository {
  const EnvelopeRepository(this._db);

  final AppDatabase _db;

  /// Envelopes for [periodId] with live spend. Spending on a sub-category
  /// counts towards its parent's envelope, which is where users usually set
  /// the limit (a "Alimentation" cap, spending logged under "Courses").
  Stream<List<EnvelopeView>> watchForPeriod(int periodId) {
    final budgets = (_db.select(_db.budgets)
          ..where((b) => b.periodId.equals(periodId)))
        .watch();
    final txns = (_db.select(_db.transactions)
          ..where(
            (t) =>
                t.periodId.equals(periodId) &
                t.type.equalsValue(TxnType.expense),
          ))
        .watch();
    final categories = _db.select(_db.categories).watch();

    return Rx.combineLatest3(budgets, txns, categories, (bs, ts, cs) {
      final byId = {for (final c in cs) c.id: c};
      final parentOf = {
        for (final c in cs)
          if (c.parentId != null) c.id: c.parentId!,
      };

      Money spentFor(int categoryId) {
        var cents = 0;
        for (final t in ts) {
          final cat = t.categoryId;
          if (cat == null) continue;
          if (cat == categoryId || parentOf[cat] == categoryId) {
            cents += t.amountCents;
          }
        }
        return Money(cents);
      }

      return bs
          .where((b) => byId.containsKey(b.categoryId))
          .map(
            (b) => EnvelopeView(
              budget: b,
              category: byId[b.categoryId]!,
              spent: spentFor(b.categoryId),
            ),
          )
          .toList()
        ..sort((a, b) => b.ratio.compareTo(a.ratio));
    });
  }

  Future<void> upsert({
    required int periodId,
    required int categoryId,
    required int limitCents,
    required bool rollover,
  }) => _db.into(_db.budgets).insert(
    BudgetsCompanion.insert(
      periodId: periodId,
      categoryId: categoryId,
      limitCents: limitCents,
      rollover: Value(rollover),
    ),
    onConflict: DoUpdate(
      (_) => BudgetsCompanion(
        limitCents: Value(limitCents),
        rollover: Value(rollover),
      ),
      target: [_db.budgets.periodId, _db.budgets.categoryId],
    ),
  );

  Future<void> delete(int budgetId) =>
      (_db.delete(_db.budgets)..where((b) => b.id.equals(budgetId))).go();
}
