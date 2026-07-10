import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/domain/services/period_service.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_db.dart';

void main() {
  group('closingBalance', () {
    test('carry + received income − expenses', () {
      final balance = PeriodService.closingBalance(
        carryOverIn: Money.fromEuros(100),
        incomeReceived: Money.fromEuros(2000),
        expenses: Money.fromEuros(1500),
      );
      expect(balance, Money.fromEuros(600));
    });

    test('can go negative', () {
      final balance = PeriodService.closingBalance(
        carryOverIn: Money.zero,
        incomeReceived: Money.fromEuros(100),
        expenses: Money.fromEuros(250),
      );
      expect(balance, -Money.fromEuros(150));
    });
  });

  group('recomputeCarryOverFrom', () {
    late AppDatabase db;
    late PeriodService service;

    setUp(() {
      db = newTestDb();
      service = PeriodService(db);
    });
    tearDown(() => db.close());

    /// Replaces the auto-seeded period with three consecutive empty months so
    /// the cascade has a known chain to work on.
    Future<List<int>> threeMonths() async {
      await db.delete(db.periods).go();
      final ids = <int>[];
      for (var m = 1; m <= 3; m++) {
        ids.add(
          await db.into(db.periods).insert(
            PeriodsCompanion.insert(
              startDate: DateTime(2026, m),
              endDate: DateTime(2026, m + 1, 0),
              status: PeriodStatus.closed,
            ),
          ),
        );
      }
      return ids;
    }

    Future<void> addIncome(int periodId, double euros) =>
        db.into(db.transactions).insert(
          TransactionsCompanion.insert(
            date: DateTime(2026, 1, 15),
            type: TxnType.income,
            amountCents: Money.fromEuros(euros).cents,
            accountId: 1,
            periodId: periodId,
            incomeStatus: const Value(IncomeStatus.received),
          ),
        );

    Future<void> addExpense(int periodId, double euros) =>
        db.into(db.transactions).insert(
          TransactionsCompanion.insert(
            date: DateTime(2026, 1, 16),
            type: TxnType.expense,
            amountCents: Money.fromEuros(euros).cents,
            accountId: 1,
            periodId: periodId,
          ),
        );

    Future<Money> carryOf(int id) async {
      final p = await (db.select(db.periods)..where((t) => t.id.equals(id)))
          .getSingle();
      return Money(p.carryOverInCents);
    }

    test('leftover of one month becomes next month carry-over', () async {
      final ids = await threeMonths();
      await addIncome(ids[0], 2000);
      await addExpense(ids[0], 1500);

      await service.recomputeCarryOverFrom(ids[0]);

      // Month 1 has no predecessor → carry 0. Leftover 500 → month 2.
      expect(await carryOf(ids[0]), Money.zero);
      expect(await carryOf(ids[1]), Money.fromEuros(500));
    });

    test('cascades across every later month', () async {
      final ids = await threeMonths();
      await addIncome(ids[0], 2000);
      await addExpense(ids[0], 1500); // +500
      await addExpense(ids[1], 200); // month 2 spends 200 of the 500

      await service.recomputeCarryOverFrom(ids[0]);

      expect(await carryOf(ids[1]), Money.fromEuros(500));
      expect(await carryOf(ids[2]), Money.fromEuros(300));
    });

    test('planned income does not move the carry-over', () async {
      final ids = await threeMonths();
      await db.into(db.transactions).insert(
        TransactionsCompanion.insert(
          date: DateTime(2026, 1, 15),
          type: TxnType.income,
          amountCents: Money.fromEuros(999).cents,
          accountId: 1,
          periodId: ids[0],
          incomeStatus: const Value(IncomeStatus.planned),
        ),
      );

      await service.recomputeCarryOverFrom(ids[0]);

      expect(await carryOf(ids[1]), Money.zero);
    });

    test('a manual carry-over overrides and reseeds the cascade', () async {
      final ids = await threeMonths();
      await addIncome(ids[0], 2000);
      await addExpense(ids[0], 1500); // would push 500 into month 2

      // The user corrects month 2 to 1000 by hand.
      await (db.update(db.periods)..where((p) => p.id.equals(ids[1]))).write(
        const PeriodsCompanion(carryOverManualCents: Value(100000)),
      );

      await service.recomputeCarryOverFrom(ids[0]);

      // Month 2 keeps the manual 1000, not the computed 500…
      expect(await carryOf(ids[1]), Money.fromEuros(1000));
      // …and month 3 continues from that 1000.
      expect(await carryOf(ids[2]), Money.fromEuros(1000));
    });

    test('editing an old month reflows into the present', () async {
      final ids = await threeMonths();
      await addIncome(ids[0], 2000);
      await addExpense(ids[0], 1500);
      await service.recomputeCarryOverFrom(ids[0]);
      expect(await carryOf(ids[2]), Money.fromEuros(500));

      // A forgotten 300 expense surfaces in month 1.
      await addExpense(ids[0], 300);
      await service.recomputeCarryOverFrom(ids[0]);

      expect(await carryOf(ids[1]), Money.fromEuros(200));
      expect(await carryOf(ids[2]), Money.fromEuros(200));
    });
  });

  group('ensureOpenPeriodFor', () {
    late AppDatabase db;
    late PeriodService service;

    setUp(() {
      db = newTestDb();
      service = PeriodService(db);
    });
    tearDown(() => db.close());

    test('reuses the seeded period instead of creating a duplicate', () async {
      final before = await db.select(db.periods).get();
      expect(before, hasLength(1));

      await service.ensureOpenPeriodFor(
        before.single.startDate.add(const Duration(days: 2)),
        startDay: 1,
      );

      expect(await db.select(db.periods).get(), hasLength(1));
    });

    test('opens the next month with the right carry-over', () async {
      final seeded = await (db.select(db.periods)..limit(1)).getSingle();
      // 400 left over in the seeded month.
      await addTxn(db, seeded.id, TxnType.income, 1000, IncomeStatus.received);
      await addTxn(db, seeded.id, TxnType.expense, 600, null);

      final nextStart = seeded.endDate.add(const Duration(days: 1));
      final next = await service.ensureOpenPeriodFor(nextStart, startDay: 1);

      expect(next.status, PeriodStatus.open);
      expect(Money(next.carryOverInCents), Money.fromEuros(400));

      // The old period was closed as the clock moved on.
      final old = await (db.select(db.periods)
            ..where((p) => p.id.equals(seeded.id)))
          .getSingle();
      expect(old.status, PeriodStatus.closed);
    });
  });
}

Future<void> addTxn(
  AppDatabase db,
  int periodId,
  TxnType type,
  double euros,
  IncomeStatus? status,
) => db.into(db.transactions).insert(
  TransactionsCompanion.insert(
    date: DateTime(2026, 7, 15),
    type: type,
    amountCents: Money.fromEuros(euros).cents,
    accountId: 1,
    periodId: periodId,
    incomeStatus: Value(status),
  ),
);
