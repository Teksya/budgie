enum AccountType { checking, savings, cash }

enum CategoryKind { expense, income }

enum PeriodStatus { open, closed }

enum TxnType { expense, income, transfer }

/// A planned income counts towards the "reste à vivre" but has not hit the
/// account balance yet.
enum IncomeStatus { planned, received }

enum RecurrenceNature { fixedCharge, subscription, salary, loanPayment }

enum Frequency {
  monthly(1),
  bimonthly(2),
  quarterly(3),
  biannual(6),
  annual(12);

  const Frequency(this.monthStep);

  /// Number of months between two occurrences.
  final int monthStep;
}

enum InstanceStatus { pending, paid, late }

enum DebtKind {
  /// A loan: fixed monthly payment, interest, end date.
  credit,

  /// I owe someone.
  debtOwed,

  /// Someone owes me.
  debtLent,

  /// Split payment (3x, 4x…), no interest.
  installment,
}
