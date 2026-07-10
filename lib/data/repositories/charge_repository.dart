import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/domain/services/period_service.dart';
import 'package:drift/drift.dart';

class ChargeRepository {
  ChargeRepository(this._db) : _periods = PeriodService(_db);

  final AppDatabase _db;
  final PeriodService _periods;

  Stream<List<RecurrenceInstance>> watchForPeriod(int periodId) =>
      (_db.select(_db.recurrenceInstances)
            ..where((i) => i.periodId.equals(periodId))
            ..orderBy([(i) => OrderingTerm.asc(i.dueDate)]))
          .watch();

  /// Marks a charge paid: records the real amount, creates the matching
  /// expense, links the two, and reflows the carry-over.
  Future<void> markPaid(
    RecurrenceInstance instance, {
    required int actualAmountCents,
    required int accountId,
    int? categoryId,
    DateTime? paidDate,
  }) async {
    final when = paidDate ?? DateTime.now();
    await _db.transaction(() async {
      final txnId = await _db.into(_db.transactions).insert(
        TransactionsCompanion.insert(
          date: when,
          type: TxnType.expense,
          amountCents: actualAmountCents,
          categoryId: Value(categoryId),
          accountId: accountId,
          periodId: instance.periodId,
          note: Value(instance.label),
        ),
      );

      await (_db.update(_db.recurrenceInstances)
            ..where((i) => i.id.equals(instance.id)))
          .write(
        RecurrenceInstancesCompanion(
          actualAmountCents: Value(actualAmountCents),
          status: const Value(InstanceStatus.paid),
          paidDate: Value(when),
          transactionId: Value(txnId),
        ),
      );
    });

    await _periods.recomputeCarryOverFrom(instance.periodId);
  }

  /// Reverts a payment: deletes the linked expense and reopens the charge.
  Future<void> markUnpaid(RecurrenceInstance instance) async {
    await _db.transaction(() async {
      if (instance.transactionId != null) {
        await (_db.delete(_db.transactions)
              ..where((t) => t.id.equals(instance.transactionId!)))
            .go();
      }
      await (_db.update(_db.recurrenceInstances)
            ..where((i) => i.id.equals(instance.id)))
          .write(
        const RecurrenceInstancesCompanion(
          status: Value(InstanceStatus.pending),
          paidDate: Value(null),
          transactionId: Value(null),
        ),
      );
    });
    await _periods.recomputeCarryOverFrom(instance.periodId);
  }
}
