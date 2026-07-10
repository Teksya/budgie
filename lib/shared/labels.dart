import 'package:budget/data/db/enums.dart';

/// French UI labels for the code-side enums. Code stays English, the screen
/// stays French — this is the single translation seam.
extension FrequencyLabel on Frequency {
  String get label => switch (this) {
    Frequency.monthly => 'Mensuelle',
    Frequency.bimonthly => 'Tous les 2 mois',
    Frequency.quarterly => 'Trimestrielle',
    Frequency.biannual => 'Semestrielle',
    Frequency.annual => 'Annuelle',
  };
}

extension AccountTypeLabel on AccountType {
  String get label => switch (this) {
    AccountType.checking => 'Compte courant',
    AccountType.savings => 'Épargne',
    AccountType.cash => 'Espèces',
  };
}

extension RecurrenceNatureLabel on RecurrenceNature {
  String get label => switch (this) {
    RecurrenceNature.fixedCharge => 'Charge fixe',
    RecurrenceNature.subscription => 'Abonnement',
    RecurrenceNature.salary => 'Salaire',
    RecurrenceNature.loanPayment => 'Mensualité de crédit',
  };
}

extension InstanceStatusLabel on InstanceStatus {
  String get label => switch (this) {
    InstanceStatus.pending => 'À payer',
    InstanceStatus.paid => 'Payée',
    InstanceStatus.late => 'En retard',
  };
}

extension DebtKindLabel on DebtKind {
  String get label => switch (this) {
    DebtKind.credit => 'Crédit',
    DebtKind.debtOwed => 'Je dois',
    DebtKind.debtLent => 'On me doit',
    DebtKind.installment => 'Paiement en plusieurs fois',
  };
}
