import 'package:budget/app/providers.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_db.dart';

/// Paying a charge reads the account to debit from a callback, not from a
/// `build`. Riverpod 3 auto-disposes providers, so a plain
/// `ref.read(accountsProvider).value` is null there and the payment used to be
/// dropped without a word.
void main() {
  late AppDatabase db;

  setUp(() => db = newTestDb());
  tearDown(() => db.close());

  ProviderContainer container() {
    final c = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(c.dispose);
    return c;
  }

  test('an unwatched accounts read is empty — the bug this guards', () {
    expect(container().read(accountsProvider).value, isNull);
  });

  test('the default account resolves without anything watching it', () async {
    final id = await container().read(accountRepositoryProvider).defaultId();
    expect(id, isNotNull);
  });

  test('paying a charge flips it to paid and books the expense', () async {
    final c = container();
    final period = await c.read(openPeriodProvider.future);

    final instanceId = await db.into(db.recurrenceInstances).insert(
      RecurrenceInstancesCompanion.insert(
        periodId: period.id,
        label: 'Loyer',
        dueDate: DateTime.now(),
        estimatedAmountCents: Money.fromEuros(800).cents,
        status: InstanceStatus.pending,
      ),
    );
    final instance = await (db.select(db.recurrenceInstances)
          ..where((i) => i.id.equals(instanceId)))
        .getSingle();

    final accountId = await c.read(accountRepositoryProvider).defaultId();
    await c.read(chargeRepositoryProvider).markPaid(
      instance,
      actualAmountCents: Money.fromEuros(820).cents,
      accountId: accountId!,
    );

    final paid = await (db.select(db.recurrenceInstances)
          ..where((i) => i.id.equals(instanceId)))
        .getSingle();
    expect(paid.status, InstanceStatus.paid);
    expect(paid.actualAmountCents, Money.fromEuros(820).cents);
    expect(paid.transactionId, isNotNull);

    final txn = await (db.select(db.transactions)
          ..where((t) => t.id.equals(paid.transactionId!)))
        .getSingle();
    expect(txn.type, TxnType.expense);
    expect(txn.amountCents, Money.fromEuros(820).cents);

    // And back: the expense must not survive the cancellation.
    await c.read(chargeRepositoryProvider).markUnpaid(paid);
    final reopened = await (db.select(db.recurrenceInstances)
          ..where((i) => i.id.equals(instanceId)))
        .getSingle();
    expect(reopened.status, InstanceStatus.pending);
    expect(await db.select(db.transactions).get(), isEmpty);
  });
}
