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
  Money plannedSavingsRemaining = Money.zero,
  int totalDays = 30,
  int daysRemaining = 30,
}) => BudgetInputs(
  carryOverIn: carryOverIn,
  incomeReceived: incomeReceived,
  incomePlanned: incomePlanned,
  expenses: expenses,
  unpaidCharges: unpaidCharges,
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
}
