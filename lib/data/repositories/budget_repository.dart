import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/domain/services/budget_engine.dart';
import 'package:rxdart/rxdart.dart';

/// Feeds the [BudgetEngine] with live data for one period.
class BudgetRepository {
  const BudgetRepository(this._db);

  final AppDatabase _db;

  /// A snapshot that recomputes whenever the period's money moves — a new
  /// expense, an income marked received, a charge paid.
  Stream<BudgetSnapshot> watchSnapshot({
    required Period period,
    required DateTime now,
  }) {
    final txns = (_db.select(_db.transactions)
          ..where((t) => t.periodId.equals(period.id)))
        .watch();

    final instances = (_db.select(_db.recurrenceInstances)
          ..where((i) => i.periodId.equals(period.id)))
        .watch();

    final goals = (_db.select(_db.savingsGoals)
          ..where((g) => g.archived.equals(false)))
        .watch();

    return Rx.combineLatest3(
      txns,
      instances,
      goals,
      (t, i, g) {
        final incomeReceived = t
            .where((x) =>
                x.type == TxnType.income &&
                x.incomeStatus == IncomeStatus.received)
            .map((x) => Money(x.amountCents))
            .sum;

        final incomePlanned = t
            .where((x) =>
                x.type == TxnType.income &&
                x.incomeStatus == IncomeStatus.planned)
            .map((x) => Money(x.amountCents))
            .sum;

        final expenses = t
            .where((x) => x.type == TxnType.expense)
            .map((x) => Money(x.amountCents))
            .sum;

        // Unpaid charges use the real amount once it is known.
        final unpaidCharges = i
            .where((x) => x.status != InstanceStatus.paid)
            .map((x) => Money(x.actualAmountCents ?? x.estimatedAmountCents))
            .sum;

        // Paying a charge creates an expense, so this is the slice of
        // `expenses` that is a one-off rather than a spending habit.
        final chargesPaid = i
            .where((x) => x.status == InstanceStatus.paid)
            .map((x) => Money(x.actualAmountCents ?? x.estimatedAmountCents))
            .sum;

        // The planned monthly savings are reserved from the "reste à vivre"
        // for the whole period, regardless of how much has been moved yet —
        // a stable reserve is easier to reason about than one that grows the
        // budget as you save.
        final plannedSavings =
            g.map((x) => Money(x.monthlyPlannedCents)).sum;

        return BudgetEngine.compute(
          BudgetInputs(
            carryOverIn: Money(period.carryOverInCents),
            incomeReceived: incomeReceived,
            incomePlanned: incomePlanned,
            expenses: expenses,
            unpaidCharges: unpaidCharges,
            chargesPaid: chargesPaid,
            plannedSavingsRemaining: plannedSavings,
            totalDays: period.endDate.difference(period.startDate).inDays + 1,
            daysRemaining: _daysRemaining(period, now),
          ),
        );
      },
    );
  }

  static int _daysRemaining(Period period, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    if (today.isBefore(period.startDate)) {
      return period.endDate.difference(period.startDate).inDays + 1;
    }
    if (today.isAfter(period.endDate)) return 0;
    return period.endDate.difference(today).inDays + 1;
  }
}
