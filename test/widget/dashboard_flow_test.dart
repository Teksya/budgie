import 'package:budget/app/providers.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/domain/services/budget_engine.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../support/test_db.dart';

/// Exercises the provider graph end-to-end on an in-memory database: opening
/// the period, materialising charges, and recomputing the snapshot when money
/// moves. This is the runtime wiring that static analysis can't catch.
void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

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

  test('the open period is created and reused', () async {
    final c = container();
    final period = await c.read(openPeriodProvider.future);
    expect(period.status, PeriodStatus.open);

    // Reading again must not create a second period.
    await c.read(openPeriodProvider.future);
    expect(await db.select(db.periods).get(), hasLength(1));
  });

  test('snapshot reflects an added income and expense', () async {
    final c = container();
    final period = await c.read(openPeriodProvider.future);

    // Prime the snapshot stream.
    final sub = c.listen(snapshotProvider, (_, _) {});
    addTearDown(sub.close);

    final repo = c.read(transactionRepositoryProvider);
    await repo.add(
      TransactionsCompanion.insert(
        date: DateTime.now(),
        type: TxnType.income,
        amountCents: Money.fromEuros(2000).cents,
        accountId: 1,
        periodId: period.id,
        incomeStatus: const Value(IncomeStatus.received),
      ),
    );
    await repo.add(
      TransactionsCompanion.insert(
        date: DateTime.now(),
        type: TxnType.expense,
        amountCents: Money.fromEuros(150).cents,
        accountId: 1,
        periodId: period.id,
      ),
    );

    // Let the combined stream settle.
    await Future<void>.delayed(const Duration(milliseconds: 50));

    final snapshot = await c.read(snapshotProvider.future);
    expect(snapshot.totalAvailable, Money.fromEuros(2000));
    expect(snapshot.remaining, Money.fromEuros(1850));
    expect(snapshot.health, BudgetHealth.healthy);
  });

  testWidgets('dashboard renders the reste-à-vivre without throwing', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(
          home: _ProbeDashboard(),
        ),
      ),
    );
    // Let the async providers resolve.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(tester.takeException(), isNull);
    expect(find.text('Reste à vivre'), findsOneWidget);
  });
}

/// Minimal host that shows just the headline figure, avoiding go_router setup.
class _ProbeDashboard extends ConsumerWidget {
  const _ProbeDashboard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(snapshotProvider);
    return Scaffold(
      body: Center(
        child: snapshot.when(
          loading: () => const Text('…'),
          error: (e, _) => Text('Erreur : $e'),
          data: (s) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Reste à vivre'),
              Text(s.remaining.format()),
            ],
          ),
        ),
      ),
    );
  }
}
