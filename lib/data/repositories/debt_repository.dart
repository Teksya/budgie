import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/domain/services/period_service.dart';
import 'package:drift/drift.dart';

class DebtRepository {
  DebtRepository(this._db) : _periods = PeriodService(_db);

  final AppDatabase _db;
  final PeriodService _periods;

  Stream<List<Debt>> watchAll() => (_db.select(_db.debts)
        ..orderBy([
          (d) => OrderingTerm.asc(d.settled),
          (d) => OrderingTerm.desc(d.startDate),
        ]))
      .watch();

  Future<int> add(DebtsCompanion entry) => _db.into(_db.debts).insert(entry);

  Future<void> delete(int id) =>
      (_db.delete(_db.debts)..where((d) => d.id.equals(id))).go();

  /// Records a payment against [debt]:
  /// - creates a real expense in the open period (so it hits the budget),
  /// - logs a debt_payment row,
  /// - reduces the remaining balance and bumps the instalment counter,
  /// - marks the debt settled once nothing is left to pay.
  Future<void> recordPayment(
    Debt debt, {
    required int amountCents,
    required int accountId,
    int? categoryId,
    DateTime? date,
  }) async {
    final when = date ?? DateTime.now();
    final open = await (_db.select(_db.periods)
          ..where((p) => p.status.equalsValue(PeriodStatus.open))
          ..limit(1))
        .getSingleOrNull();

    await _db.transaction(() async {
      int? txnId;
      if (open != null) {
        txnId = await _db.into(_db.transactions).insert(
          TransactionsCompanion.insert(
            date: when,
            type: TxnType.expense,
            amountCents: amountCents,
            categoryId: Value(categoryId),
            accountId: accountId,
            periodId: open.id,
            note: Value('Remboursement · ${debt.name}'),
          ),
        );
      }

      await _db.into(_db.debtPayments).insert(
        DebtPaymentsCompanion.insert(
          debtId: debt.id,
          transactionId: Value(txnId),
          date: when,
          amountCents: amountCents,
          principalCents: amountCents,
        ),
      );

      final remaining = (debt.remainingCents - amountCents).clamp(0, 1 << 62);
      await (_db.update(_db.debts)..where((d) => d.id.equals(debt.id))).write(
        DebtsCompanion(
          remainingCents: Value(remaining),
          installmentsPaid: Value(debt.installmentsPaid + 1),
          settled: Value(remaining == 0),
        ),
      );
    });

    if (open != null) await _periods.recomputeCarryOverFrom(open.id);
  }
}
