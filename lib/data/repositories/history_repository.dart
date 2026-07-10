import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/domain/services/period_service.dart';
import 'package:drift/drift.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

/// A read model for one past (or current) budget month.
@immutable
class PeriodSummary {
  const PeriodSummary({
    required this.period,
    required this.incomeReceived,
    required this.incomePlanned,
    required this.expenses,
    required this.unpaidCharges,
    required this.paidChargesCount,
    required this.pendingChargesCount,
  });

  final Period period;
  final Money incomeReceived;
  final Money incomePlanned;
  final Money expenses;
  final Money unpaidCharges;
  final int paidChargesCount;
  final int pendingChargesCount;

  Money get carryIn =>
      Money(period.carryOverManualCents ?? period.carryOverInCents);

  /// What actually remained at month end: real money handed to next month.
  Money get closingBalance => PeriodService.closingBalance(
    carryOverIn: carryIn,
    incomeReceived: incomeReceived,
    expenses: expenses,
  );

  /// Income minus spending, ignoring the carry-over — the month's own result.
  Money get net => incomeReceived - expenses;

  bool get isManualCarry => period.carryOverManualCents != null;
}

class HistoryRepository {
  const HistoryRepository(this._db);

  final AppDatabase _db;

  /// Every period, most recent first — the spine of the month navigator.
  Stream<List<Period>> watchPeriods() =>
      (_db.select(_db.periods)
            ..orderBy([(p) => OrderingTerm.desc(p.startDate)]))
          .watch();

  /// Live summary for [period], recomputed as its transactions change.
  Stream<PeriodSummary> watchSummary(Period period) {
    final txns = (_db.select(_db.transactions)
          ..where((t) => t.periodId.equals(period.id)))
        .watch();
    final charges = (_db.select(_db.recurrenceInstances)
          ..where((i) => i.periodId.equals(period.id)))
        .watch();

    return Rx.combineLatest2(txns, charges, (t, c) {
      Money sum(bool Function(Txn) test) =>
          t.where(test).map((x) => Money(x.amountCents)).sum;

      return PeriodSummary(
        period: period,
        incomeReceived: sum(
          (x) =>
              x.type == TxnType.income &&
              x.incomeStatus == IncomeStatus.received,
        ),
        incomePlanned: sum(
          (x) =>
              x.type == TxnType.income &&
              x.incomeStatus == IncomeStatus.planned,
        ),
        expenses: sum((x) => x.type == TxnType.expense),
        unpaidCharges: c
            .where((x) => x.status != InstanceStatus.paid)
            .map((x) => Money(x.actualAmountCents ?? x.estimatedAmountCents))
            .sum,
        paidChargesCount:
            c.where((x) => x.status == InstanceStatus.paid).length,
        pendingChargesCount:
            c.where((x) => x.status != InstanceStatus.paid).length,
      );
    });
  }

  /// Overrides a period's carry-over by hand and reflows every later month.
  /// This is the fix for a mis-typed amount discovered long after the fact.
  Future<void> setManualCarryOver(int periodId, Money? value) async {
    await (_db.update(_db.periods)..where((p) => p.id.equals(periodId))).write(
      PeriodsCompanion(carryOverManualCents: Value(value?.cents)),
    );
    await PeriodService(_db).recomputeCarryOverFrom(periodId);
  }
}
