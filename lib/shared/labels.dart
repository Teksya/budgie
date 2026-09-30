import 'package:budget/data/db/enums.dart';
import 'package:budget/l10n/app_localizations.dart';

/// UI labels for the code-side enums. Code stays English, the screen follows
/// the user's language — this is the single translation seam for enums.
///
/// These take the translations rather than a `BuildContext` so the notification
/// service and the home-screen widget, which have no context, can use them too.
extension FrequencyLabel on Frequency {
  String label(L l) => switch (this) {
    Frequency.monthly => l.frequencyMonthly,
    Frequency.bimonthly => l.frequencyBimonthly,
    Frequency.quarterly => l.frequencyQuarterly,
    Frequency.biannual => l.frequencyBiannual,
    Frequency.annual => l.frequencyAnnual,
  };
}

extension AccountTypeLabel on AccountType {
  String label(L l) => switch (this) {
    AccountType.checking => l.accountChecking,
    AccountType.savings => l.accountSavings,
    AccountType.cash => l.accountCash,
  };
}

extension RecurrenceNatureLabel on RecurrenceNature {
  String label(L l) => switch (this) {
    RecurrenceNature.fixedCharge => l.natureFixedCharge,
    RecurrenceNature.subscription => l.natureSubscription,
    RecurrenceNature.salary => l.natureSalary,
    RecurrenceNature.loanPayment => l.natureLoanPayment,
  };
}

extension InstanceStatusLabel on InstanceStatus {
  String label(L l) => switch (this) {
    InstanceStatus.pending => l.statusPending,
    InstanceStatus.paid => l.statusPaid,
    InstanceStatus.late => l.statusLate,
  };
}

extension DebtKindLabel on DebtKind {
  String label(L l) => switch (this) {
    DebtKind.credit => l.debtCredit,
    DebtKind.debtOwed => l.debtOwed,
    DebtKind.debtLent => l.debtLent,
    DebtKind.installment => l.debtInstallment,
  };
}

/// A 0–1 ratio spoken as a percentage, for the `semanticsValue` of progress
/// bars. "70 %" would be read out as "70" alone by TalkBack.
String spokenPercent(L l, double ratio) =>
    l.spokenPercent((ratio.clamp(0.0, 1.0) * 100).round());
