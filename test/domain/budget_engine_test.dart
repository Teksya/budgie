import 'package:budget/core/money.dart';
import 'package:budget/domain/services/budget_engine.dart';
import 'package:flutter_test/flutter_test.dart';

/// Builds inputs with sensible zeros so each test only states what it cares
/// about.
BudgetInputs inputs({
  Money carryOverIn = Money.zero,
  Money incomeReceived = Money.zero,
  Money incomePlanned = Money.zero,
  Money expenses = Money.zero,
  Money unpaidCharges = Money.zero,
  Money chargesPaid = Money.zero,
  Money plannedSavingsRemaining = Money.zero,
  int totalDays = 30,
  int daysRemaining = 30,
}) => BudgetInputs(
  carryOverIn: carryOverIn,
  incomeReceived: incomeReceived,
  incomePlanned: incomePlanned,
  expenses: expenses,
  unpaidCharges: unpaidCharges,
  chargesPaid: chargesPaid,
  plannedSavingsRemaining: plannedSavingsRemaining,
  totalDays: totalDays,
  daysRemaining: daysRemaining,
);

void main() {
  group('BudgetEngine.compute', () {
    test('a fresh month with only a salary', () {
      final s = BudgetEngine.compute(
        inputs(incomeReceived: Money.fromEuros(2000)),
      );
      expect(s.remaining, Money.fromEuros(2000));
      expect(s.totalAvailable, Money.fromEuros(2000));
      expect(s.totalCommitted, Money.zero);
      expect(s.health, BudgetHealth.healthy);
    });

    test('a full realistic month', () {
      // 2000 salary + 300 carried over, minus 500 spent, 900 of charges still
      // due, 200 to save.
      final s = BudgetEngine.compute(
        inputs(
          carryOverIn: Money.fromEuros(300),
          incomeReceived: Money.fromEuros(2000),
          expenses: Money.fromEuros(500),
          unpaidCharges: Money.fromEuros(900),
          plannedSavingsRemaining: Money.fromEuros(200),
        ),
      );
      expect(s.totalAvailable, Money.fromEuros(2300));
      expect(s.totalCommitted, Money.fromEuros(1600));
      expect(s.remaining, Money.fromEuros(700));
    });

    test('planned income counts towards what can be spent', () {
      final s = BudgetEngine.compute(
        inputs(
          incomeReceived: Money.fromEuros(1000),
          incomePlanned: Money.fromEuros(500),
        ),
      );
      expect(s.remaining, Money.fromEuros(1500));
    });

    test('a negative carry-over eats into the budget', () {
      final s = BudgetEngine.compute(
        inputs(
          carryOverIn: -Money.fromEuros(150),
          incomeReceived: Money.fromEuros(1000),
        ),
      );
      expect(s.remaining, Money.fromEuros(850));
    });

    test('paid charges are not double-counted', () {
      // A paid charge shows up inside `expenses`; it must not also appear in
      // `unpaidCharges`. Here only the 300 unpaid rent remains.
      final s = BudgetEngine.compute(
        inputs(
          incomeReceived: Money.fromEuros(1000),
          expenses: Money.fromEuros(120), // e.g. an already-paid phone bill
          unpaidCharges: Money.fromEuros(300),
        ),
      );
      expect(s.remaining, Money.fromEuros(580));
    });
  });

  group('perDay', () {
    test('spreads the remaining money over the days left', () {
      final s = BudgetEngine.compute(
        inputs(incomeReceived: Money.fromEuros(300), daysRemaining: 10),
      );
      expect(s.perDay, Money.fromEuros(30));
    });

    test('on the last day equals the whole remaining amount', () {
      final s = BudgetEngine.compute(
        inputs(incomeReceived: Money.fromEuros(42), daysRemaining: 1),
      );
      expect(s.perDay, Money.fromEuros(42));
    });

    test('never divides by zero when the period is over', () {
      final s = BudgetEngine.compute(
        inputs(incomeReceived: Money.fromEuros(42), daysRemaining: 0),
      );
      expect(s.perDay, Money.fromEuros(42));
    });
  });

  group('health', () {
    test('negative remaining is danger', () {
      final s = BudgetEngine.compute(
        inputs(
          incomeReceived: Money.fromEuros(500),
          expenses: Money.fromEuros(600),
        ),
      );
      expect(s.health, BudgetHealth.danger);
      expect(s.remaining.isNegative, isTrue);
    });

    test('less than 15% of available left is caution', () {
      // 100 available, 90 committed → 10 free = 10 %.
      final s = BudgetEngine.compute(
        inputs(
          incomeReceived: Money.fromEuros(100),
          expenses: Money.fromEuros(90),
        ),
      );
      expect(s.health, BudgetHealth.caution);
    });

    test('exactly at the threshold is still healthy', () {
      // 100 available, 85 committed → 15 free = 15 %.
      final s = BudgetEngine.compute(
        inputs(
          incomeReceived: Money.fromEuros(100),
          expenses: Money.fromEuros(85),
        ),
      );
      expect(s.health, BudgetHealth.healthy);
    });

    test('no money at all is not flagged as danger', () {
      final s = BudgetEngine.compute(inputs());
      expect(s.remaining, Money.zero);
      expect(s.health, BudgetHealth.healthy);
    });
  });

  group('committedRatio', () {
    test('is the share of available money spoken for', () {
      final s = BudgetEngine.compute(
        inputs(
          incomeReceived: Money.fromEuros(1000),
          expenses: Money.fromEuros(250),
        ),
      );
      expect(s.committedRatio, 0.25);
    });

    test('is clamped to 1 when overspent', () {
      final s = BudgetEngine.compute(
        inputs(
          incomeReceived: Money.fromEuros(100),
          expenses: Money.fromEuros(300),
        ),
      );
      expect(s.committedRatio, 1.0);
    });

    test('is 0 when nothing is available', () {
      expect(BudgetEngine.compute(inputs()).committedRatio, 0.0);
    });
  });

  group('end-of-month projection', () {
    test('extends the current pace over the days left', () {
      // 10 days in, 200 € of day-to-day spending: 20 €/day over 20 more days.
      final s = BudgetEngine.compute(
        inputs(
          incomeReceived: Money.fromEuros(1000),
          expenses: Money.fromEuros(200),
          daysRemaining: 20,
        ),
      );
      expect(s.remaining, Money.fromEuros(800));
      expect(s.projectedRemaining, Money.fromEuros(400));
    });

    test('a paid charge is a one-off, not a pace', () {
      // Same 800 € spent, but 700 € of it was the rent. Only 100 € is habit.
      final s = BudgetEngine.compute(
        inputs(
          incomeReceived: Money.fromEuros(2000),
          expenses: Money.fromEuros(800),
          chargesPaid: Money.fromEuros(700),
          daysRemaining: 20,
        ),
      );
      expect(s.remaining, Money.fromEuros(1200));
      // 100 € over 10 days = 10 €/day, 20 days left → 200 € more.
      expect(s.projectedRemaining, Money.fromEuros(1000));
    });

    test('stays quiet in the first days, when a pace means nothing', () {
      final s = BudgetEngine.compute(
        inputs(
          incomeReceived: Money.fromEuros(1000),
          expenses: Money.fromEuros(150),
          daysRemaining: 28,
        ),
      );
      expect(s.projectedRemaining, isNull);
    });

    test('stays quiet once the period is over', () {
      final s = BudgetEngine.compute(
        inputs(
          incomeReceived: Money.fromEuros(1000),
          expenses: Money.fromEuros(150),
          daysRemaining: 0,
        ),
      );
      expect(s.projectedRemaining, isNull);
    });

    test('nothing spent day to day means nothing to extrapolate', () {
      final s = BudgetEngine.compute(
        inputs(
          incomeReceived: Money.fromEuros(1000),
          expenses: Money.fromEuros(300),
          chargesPaid: Money.fromEuros(300),
          daysRemaining: 20,
        ),
      );
      expect(s.projectedRemaining, s.remaining);
    });

    test('warns only when the forecast turns a healthy month red', () {
      final tooFast = BudgetEngine.compute(
        inputs(
          incomeReceived: Money.fromEuros(1000),
          expenses: Money.fromEuros(400),
          daysRemaining: 20,
        ),
      );
      expect(tooFast.remaining.isNegative, isFalse);
      expect(tooFast.projectedRemaining, Money.fromEuros(-200));
      expect(tooFast.projectionWarns, isTrue);

      final alreadyOver = BudgetEngine.compute(
        inputs(
          incomeReceived: Money.fromEuros(100),
          expenses: Money.fromEuros(400),
          daysRemaining: 20,
        ),
      );
      expect(
        alreadyOver.projectionWarns,
        isFalse,
        reason: 'the headline figure already says it',
      );
    });
  });
}
