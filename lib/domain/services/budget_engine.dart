import 'package:budget/core/money.dart';
import 'package:meta/meta.dart';

/// How healthy the current spending pace is. Drives the colour of the hero
/// figure on the dashboard.
enum BudgetHealth {
  /// Comfortable margin.
  healthy,

  /// Getting tight — worth slowing down.
  caution,

  /// Overspent: the "reste à vivre" is negative.
  danger,
}

/// Everything the [BudgetEngine] needs, already aggregated. Kept free of any
/// database or Flutter type so the engine can be unit-tested exhaustively.
@immutable
class BudgetInputs {
  const BudgetInputs({
    required this.carryOverIn,
    required this.incomeReceived,
    required this.incomePlanned,
    required this.expenses,
    required this.unpaidCharges,
    required this.plannedSavingsRemaining,
    required this.totalDays,
    required this.daysRemaining,
    this.chargesPaid = Money.zero,
  });

  /// Leftover carried from the previous period (may be negative).
  final Money carryOverIn;

  /// Incomes already in the account.
  final Money incomeReceived;

  /// Incomes expected but not yet received. Count towards what can be spent,
  /// but not towards the real balance.
  final Money incomePlanned;

  /// Expenses already made this period — the user's own share. This already
  /// includes any charge that has been paid (paying a charge creates an
  /// expense), so paid charges must NOT be counted again below.
  final Money expenses;

  /// Charges still due this period (pending or late). Uses the real amount
  /// when known, the estimate otherwise.
  final Money unpaidCharges;

  /// Charges already paid this period. Subtracted from [expenses] to isolate
  /// day-to-day spending: rent leaving on the 5th is not a "pace", and folding
  /// it into the daily rate would make every early-month forecast catastrophic.
  final Money chargesPaid;

  /// Savings the user planned to set aside this period and has not yet moved.
  final Money plannedSavingsRemaining;

  final int totalDays;
  final int daysRemaining;
}

/// The computed picture shown on the dashboard.
@immutable
class BudgetSnapshot {
  const BudgetSnapshot({
    required this.remaining,
    required this.perDay,
    required this.totalAvailable,
    required this.totalCommitted,
    required this.health,
    required this.daysRemaining,
    this.projectedRemaining,
  });

  /// The headline: money left to freely spend until the period ends.
  final Money remaining;

  /// [remaining] spread over the days left. Equal to [remaining] on the last
  /// day (it never divides by zero).
  final Money perDay;

  /// Carry-over + every income (received and planned).
  final Money totalAvailable;

  /// Expenses + unpaid charges + remaining planned savings.
  final Money totalCommitted;

  final BudgetHealth health;
  final int daysRemaining;

  /// What [remaining] becomes if day-to-day spending carries on at the pace set
  /// so far. Null when there is nothing to extrapolate from — the first days of
  /// a period, or a period already over.
  final Money? projectedRemaining;

  /// True when the projection lands in the red while the budget is still in the
  /// black: the one case where the forecast tells the user something the
  /// headline figure does not.
  bool get projectionWarns =>
      projectedRemaining != null &&
      projectedRemaining!.isNegative &&
      !remaining.isNegative;

  /// Fraction of the available money already committed, clamped to `[0, 1]`.
  /// Drives the progress ring.
  double get committedRatio => totalCommitted.ratioOf(totalAvailable);
}

/// Pure computation of the "reste à vivre". No I/O, no state.
abstract final class BudgetEngine {
  /// Below this fraction of available money still free, the state is caution.
  static const double _cautionThreshold = 0.15;

  static BudgetSnapshot compute(BudgetInputs input) {
    final available =
        input.carryOverIn + input.incomeReceived + input.incomePlanned;

    final committed =
        input.expenses + input.unpaidCharges + input.plannedSavingsRemaining;

    final remaining = available - committed;
    final perDay = remaining.dividedBy(input.daysRemaining);

    return BudgetSnapshot(
      remaining: remaining,
      perDay: perDay,
      totalAvailable: available,
      totalCommitted: committed,
      health: _health(remaining, available),
      daysRemaining: input.daysRemaining,
      projectedRemaining: _project(input, remaining),
    );
  }

  /// Below this many elapsed days a "pace" is one shopping trip, not a habit.
  static const int _minDaysForProjection = 3;

  /// `remaining − (daily pace × days left)`.
  ///
  /// Only day-to-day spending is extrapolated: charges already paid are one-off
  /// and charges still due are already deducted from [remaining] at their real
  /// amount, so neither belongs in a rate.
  static Money? _project(BudgetInputs input, Money remaining) {
    final daysElapsed = input.totalDays - input.daysRemaining;
    if (daysElapsed < _minDaysForProjection || input.daysRemaining <= 0) {
      return null;
    }

    final discretionary = input.expenses - input.chargesPaid;
    // A period whose only outgoings are charges has no pace to speak of.
    if (!discretionary.isPositive) return remaining;

    final perDay = discretionary.cents / daysElapsed;
    return remaining - Money((perDay * input.daysRemaining).round());
  }

  static BudgetHealth _health(Money remaining, Money available) {
    if (remaining.isNegative) return BudgetHealth.danger;
    // With nothing available, anything non-negative is as good as it gets.
    if (available.cents <= 0) return BudgetHealth.healthy;
    final freeRatio = remaining.cents / available.cents;
    if (freeRatio < _cautionThreshold) return BudgetHealth.caution;
    return BudgetHealth.healthy;
  }
}
