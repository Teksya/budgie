// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class LFr extends L {
  LFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Budgie';

  @override
  String get navHome => 'Accueil';

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navBudgets => 'Budgets';

  @override
  String get navStats => 'Stats';

  @override
  String get actionAdd => 'Ajouter';

  @override
  String get actionSave => 'Enregistrer';

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionDelete => 'Supprimer';

  @override
  String get actionContinue => 'Continuer';

  @override
  String get actionBack => 'Retour';

  @override
  String get actionConfirm => 'Confirmer';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get history => 'Historique';

  @override
  String get remainingToSpend => 'Reste à vivre';

  @override
  String perDay(String amount) {
    return '$amount / jour';
  }

  @override
  String daysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours restants',
      one: '1 jour restant',
    );
    return '$_temp0';
  }

  @override
  String get healthComfortable => 'Confortable';

  @override
  String get healthTight => 'Serré';

  @override
  String get healthOver => 'Dépassé';

  @override
  String get upcomingCharges => 'Prochaines échéances';

  @override
  String get recentTransactions => 'Dernières transactions';

  @override
  String get noChargesToPay => 'Aucune charge à payer. 🎉';

  @override
  String get firstExpenseTitle => 'Note ta première dépense';

  @override
  String get firstExpenseBody =>
      'Appuie ici dès que tu dépenses quelque chose. Ton reste à vivre se met à jour tout seul.';

  @override
  String get onboardWelcomeTitle => 'Reprends la main\nsur ton budget';

  @override
  String get onboardWelcomeSubtitle =>
      'On met tout en place ensemble, ça prend 2 minutes.';

  @override
  String get onboardHl1Title => 'Ton reste à vivre en un coup d\'œil';

  @override
  String get onboardHl1Body =>
      'Combien tu peux encore dépenser d\'ici la fin du mois.';

  @override
  String get onboardHl2Title => 'Tes charges gérées toutes seules';

  @override
  String get onboardHl2Body =>
      'Loyer, élec, abonnements : elles reviennent chaque mois.';

  @override
  String get onboardHl3Title => 'Des alertes au bon moment';

  @override
  String get onboardHl3Body =>
      'Avant une échéance ou un dépassement de budget.';

  @override
  String get onboardHl4Title => '100 % privé, hors ligne';

  @override
  String get onboardHl4Body => 'Tes données restent sur ton téléphone, point.';

  @override
  String get onboardStart => 'Commencer';

  @override
  String get onboardDone => 'C\'est parti !';

  @override
  String get settingsCurrency => 'Devise';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get languageSystem => 'Langue du système';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageEnglish => 'English';

  @override
  String get newExpense => 'Nouvelle dépense';

  @override
  String get newIncome => 'Nouveau revenu';

  @override
  String get moveMoney => 'Basculer de l\'argent';

  @override
  String get edit => 'Modifier';

  @override
  String get expense => 'Dépense';

  @override
  String get income => 'Revenu';

  @override
  String get transferShort => 'Basculer';

  @override
  String get scanReceipt => 'Scanner un ticket';

  @override
  String get readingReceipt => 'Lecture du ticket…';

  @override
  String get takePhoto => 'Prendre en photo';

  @override
  String get fromGallery => 'Depuis la galerie';

  @override
  String get category => 'Catégorie';

  @override
  String get noteOptional => 'Note (facultatif)';

  @override
  String get sharedExpense => 'Dépense partagée';

  @override
  String get sharedHint =>
      'Le montant ci-dessus est ta part ; indique le total ci-dessous.';

  @override
  String get sharedTotal => 'Montant total (partagé)';

  @override
  String get receiptPhoto => 'Photo du ticket';

  @override
  String get receiptAttached => 'Ticket joint';

  @override
  String get alreadyReceived => 'Déjà perçu';

  @override
  String get addedToBalance => 'Ajouté au solde';

  @override
  String get plannedNotReceived => 'Prévu, pas encore encaissé';

  @override
  String get transferInfo =>
      'Déplace de l\'argent d\'un de tes comptes vers un autre. Ça n\'ajoute ni dépense ni revenu : ton reste à vivre ne bouge pas.';

  @override
  String get from => 'Depuis';

  @override
  String get to => 'Vers';

  @override
  String get needSecondAccount =>
      'Crée un deuxième compte pour pouvoir basculer de l\'argent.';

  @override
  String get date => 'Date';

  @override
  String get account => 'Compte';

  @override
  String get whichAmount => 'Quel est le montant ?';

  @override
  String get tapReceiptTotal => 'Appuie sur le total du ticket.';

  @override
  String get enterManually => 'Saisir à la main';

  @override
  String get amountNotFound => 'Montant non trouvé';

  @override
  String get receiptReadNoTotal =>
      'Le ticket a été lu mais je n\'ai pas repéré de total. Saisis le montant à la main — la photo reste jointe.';

  @override
  String get cannotReadReceipt =>
      'Impossible de lire le ticket. Réessaie plus près, bien à plat et avec un bon éclairage.';

  @override
  String get textRead => 'Texte lu :';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeSystem => 'Système';

  @override
  String get dynamicColors => 'Couleurs dynamiques';

  @override
  String get dynamicColorsSub => 'S\'adapte au fond d\'écran (Material You)';

  @override
  String get settingsGeneral => 'Général';

  @override
  String get settingsPeriod => 'Période budgétaire';

  @override
  String get settingsOrganisation => 'Organisation';

  @override
  String get settingsSecurity => 'Sécurité';

  @override
  String get settingsData => 'Données';

  @override
  String get accounts => 'Comptes';

  @override
  String get categories => 'Catégories';

  @override
  String get recurringLabel => 'Charges & revenus récurrents';

  @override
  String get debtsCredits => 'Dettes & crédits';

  @override
  String get biometricLock => 'Verrouillage biométrique';

  @override
  String get dueReminders => 'Rappels d\'échéance';

  @override
  String get dailyReminder => 'Rappel quotidien de saisie';

  @override
  String get backup => 'Sauvegarder';

  @override
  String get restore => 'Restaurer';

  @override
  String get startOver => 'Repartir de zéro';

  @override
  String get quickExpenses => 'Dépenses rapides';

  @override
  String get newFavorite => 'Nouveau';

  @override
  String get frequencyMonthly => 'Mensuelle';

  @override
  String get frequencyBimonthly => 'Tous les 2 mois';

  @override
  String get frequencyQuarterly => 'Trimestrielle';

  @override
  String get frequencyBiannual => 'Semestrielle';

  @override
  String get frequencyAnnual => 'Annuelle';

  @override
  String get accountChecking => 'Compte courant';

  @override
  String get accountSavings => 'Épargne';

  @override
  String get accountCash => 'Espèces';

  @override
  String get natureFixedCharge => 'Charge fixe';

  @override
  String get natureSubscription => 'Abonnement';

  @override
  String get natureSalary => 'Salaire';

  @override
  String get natureLoanPayment => 'Mensualité de crédit';

  @override
  String get statusPending => 'À payer';

  @override
  String get statusPaid => 'Payée';

  @override
  String get statusLate => 'En retard';

  @override
  String get debtCredit => 'Crédit';

  @override
  String get debtOwed => 'Je dois';

  @override
  String get debtLent => 'On me doit';

  @override
  String get debtInstallment => 'Paiement en plusieurs fois';

  @override
  String spokenPercent(int percent) {
    return '$percent pour cent';
  }

  @override
  String get notifChannelName => 'Rappels d\'échéance';

  @override
  String get notifChannelDescription => 'Rappels avant une charge à payer';

  @override
  String notifDueTodayTitle(String name) {
    return 'Échéance aujourd\'hui : $name';
  }

  @override
  String notifDueTodayBody(String amount) {
    return '$amount à payer.';
  }

  @override
  String notifDueSoonTitle(String name) {
    return 'Dans 3 jours : $name';
  }

  @override
  String notifDueSoonBody(String amount, int day) {
    return '$amount à prévoir le $day.';
  }

  @override
  String get notifDailyTitle => 'Pense à noter tes dépenses 💸';

  @override
  String get notifDailyBody => '2 minutes pour rester à jour sur ton budget.';

  @override
  String get shortcutAddExpense => 'Ajouter une dépense';

  @override
  String widgetRemainingLabel(String period) {
    return 'Reste à vivre · $period';
  }

  @override
  String widgetBillDue(String date) {
    return 'échéance le $date';
  }

  @override
  String get widgetNothingDue => 'Rien à payer 🎉';

  @override
  String get unlockReason => 'Déverrouille ton budget';

  @override
  String get lockedTitle => 'Budget verrouillé';

  @override
  String get unlock => 'Déverrouiller';

  @override
  String get backupUnreadableFile => 'Fichier illisible.';

  @override
  String get backupWrongPassword =>
      'Mot de passe incorrect ou fichier corrompu.';

  @override
  String get backupShareSubject => 'Sauvegarde Budget';

  @override
  String get uncategorized => 'Non catégorisé';

  @override
  String get catHousing => 'Logement';

  @override
  String get catFood => 'Alimentation';

  @override
  String get catGroceries => 'Courses';

  @override
  String get catRestaurant => 'Restaurant';

  @override
  String get catBakery => 'Boulangerie';

  @override
  String get catTransport => 'Transport';

  @override
  String get catFuel => 'Carburant';

  @override
  String get catPublicTransport => 'Transports en commun';

  @override
  String get catVehicleUpkeep => 'Entretien';

  @override
  String get catBills => 'Factures & abonnements';

  @override
  String get catElectricity => 'Électricité';

  @override
  String get catWater => 'Eau';

  @override
  String get catInternet => 'Internet';

  @override
  String get catPhone => 'Téléphone';

  @override
  String get catInsurance => 'Assurances';

  @override
  String get catSubscriptions => 'Abonnements';

  @override
  String get catHealth => 'Santé';

  @override
  String get catLeisure => 'Loisirs';

  @override
  String get catShopping => 'Shopping';

  @override
  String get catSport => 'Sport';

  @override
  String get catEducation => 'Éducation';

  @override
  String get catTravel => 'Voyages';

  @override
  String get catGifts => 'Cadeaux';

  @override
  String get catPets => 'Animaux';

  @override
  String get catTaxes => 'Impôts';

  @override
  String get catSavings => 'Épargne';

  @override
  String get catDebts => 'Crédits & dettes';

  @override
  String get catSalary => 'Salaire';

  @override
  String get catBonus => 'Prime';

  @override
  String get catBenefits => 'Allocations';

  @override
  String get catFreelance => 'Freelance';

  @override
  String get catRefund => 'Remboursement';

  @override
  String get catOtherIncome => 'Autre revenu';

  @override
  String errorWith(String message) {
    return 'Erreur : $message';
  }

  @override
  String get balance => 'solde';

  @override
  String deleteNamedQuestion(String name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String get deleteAccountWarning =>
      'Les transactions de ce compte seront supprimées. Cette action est irréversible.';

  @override
  String get cannotDeleteLastAccount =>
      'Impossible de supprimer le dernier compte.';

  @override
  String get editAccount => 'Modifier le compte';

  @override
  String get newAccount => 'Nouveau compte';

  @override
  String get createAccount => 'Créer le compte';

  @override
  String get fieldName => 'Nom';

  @override
  String get accountNameHint => 'Compte courant, Livret A…';

  @override
  String get initialBalance => 'Solde initial';

  @override
  String get initialBalanceHelp =>
      'Le solde du compte au moment où tu commences';

  @override
  String get fieldType => 'Type';

  @override
  String get fieldIcon => 'Icône';

  @override
  String get fieldColour => 'Couleur';

  @override
  String get actionCreate => 'Créer';

  @override
  String get amount => 'Montant';

  @override
  String get amountOptional => 'Montant (facultatif)';

  @override
  String favoriteAdded(String name) {
    return '« $name » ajouté';
  }

  @override
  String get newFavoriteTitle => 'Nouvelle dépense type';

  @override
  String get favoriteNameHint => 'Café, Ticket resto…';

  @override
  String get favoriteAmountHelp =>
      'Vide = te demander le montant à chaque fois';

  @override
  String get savingsGoals => 'Objectifs d\'épargne';

  @override
  String get goal => 'Objectif';

  @override
  String goalByDate(String date) {
    return 'pour le $date';
  }

  @override
  String get archive => 'Archiver';

  @override
  String goalProgressOf(String name) {
    return 'Progression de l’objectif $name';
  }

  @override
  String get goalReached => 'Atteint 🎉';

  @override
  String goalRemaining(String amount) {
    return 'reste $amount';
  }

  @override
  String goalMonthlySetAside(String amount) {
    return '$amount / mois réservés';
  }

  @override
  String addToGoal(String name) {
    return 'Ajouter à « $name »';
  }

  @override
  String get noGoalsTitle => 'Aucun objectif';

  @override
  String get noGoalsBody =>
      'Fixe-toi un but (vacances, matelas de sécurité…) et réserve un montant chaque mois.';

  @override
  String get debtSettled => 'Soldé';

  @override
  String debtRepaymentOf(String name) {
    return 'Remboursement de $name';
  }

  @override
  String get debtLeftToCollect => 'Reste à récupérer';

  @override
  String get debtOutstanding => 'Capital restant dû';

  @override
  String debtInstalmentCount(int paid, int total) {
    return '$paid / $total échéances';
  }

  @override
  String perMonth(String amount) {
    return '$amount/mois';
  }

  @override
  String get debtRepaid => 'Remboursé';

  @override
  String get debtPayInstalment => 'Payer une échéance';

  @override
  String debtPaymentTitle(String name) {
    return 'Paiement · $name';
  }

  @override
  String get noDebtsTitle => 'Aucune dette';

  @override
  String get noDebtsBody =>
      'Suis tes crédits, tes paiements en plusieurs fois, ou l\'argent qu\'on te doit.';

  @override
  String get newDebtTitle => 'Nouvelle dette / crédit';

  @override
  String get debtNameHintLent => 'Prêt à un ami…';

  @override
  String get debtNameHintOwed => 'Crédit auto, canapé 4x…';

  @override
  String get debtAmountLent => 'Montant prêté';

  @override
  String get debtAmountOwed => 'Montant total dû';

  @override
  String get debtMonthlyPayment => 'Mensualité';

  @override
  String get debtInstalmentsCount => 'Nb échéances';

  @override
  String get recurringIncomes => 'Revenus récurrents';

  @override
  String get recurringCharges => 'Charges fixes & abonnements';

  @override
  String get recurrenceVariable => 'variable';

  @override
  String get recurrenceDisabled => 'désactivé';

  @override
  String get historyAndAverage => 'Historique & moyenne';

  @override
  String get disable => 'Désactiver';

  @override
  String get enable => 'Activer';

  @override
  String get deleteRecurrenceWarning =>
      'La récurrence ne générera plus de nouvelles échéances. Les échéances déjà créées ce mois-ci restent.';

  @override
  String get savedChanges => 'Modifié';

  @override
  String get recurringIncomeAdded => 'Revenu récurrent ajouté';

  @override
  String get chargeAdded => 'Charge ajoutée';

  @override
  String get recurringIncome => 'Revenu récurrent';

  @override
  String get newFixedCharge => 'Nouvelle charge fixe';

  @override
  String get incomeNameHint => 'Salaire, Allocation, Pension…';

  @override
  String get chargeNameHint => 'Loyer, Électricité, Internet…';

  @override
  String get netAmount => 'Montant net';

  @override
  String get estimatedAmount => 'Montant estimé';

  @override
  String get variableAmount => 'Montant variable';

  @override
  String get variableAmountHelp =>
      'Comme l\'électricité ou l\'eau : tu corriges le montant réel à réception de la facture.';

  @override
  String get frequency => 'Périodicité';

  @override
  String get payDayLabel => 'Jour de versement';

  @override
  String get dueDayLabel => 'Jour d\'échéance';

  @override
  String dueDayOn(String label, int day) {
    return '$label : le $day';
  }

  @override
  String get saveIncome => 'Enregistrer le revenu';

  @override
  String get saveCharge => 'Enregistrer la charge';

  @override
  String get fixedCharge => 'Charge fixe';

  @override
  String get leftToPayThisMonth => 'Reste à payer ce mois-ci';

  @override
  String paidOn(String date) {
    return 'payée le $date';
  }

  @override
  String payNamed(String name) {
    return 'Payer « $name »';
  }

  @override
  String get actualAmount => 'Montant réel';

  @override
  String get recurringChargesShort => 'Charges récurrentes';

  @override
  String get envelopes => 'Enveloppes';

  @override
  String get envelope => 'Enveloppe';

  @override
  String get envelopesIntro =>
      'Fixe un plafond mensuel par catégorie (ex. Courses : 300 €) pour suivre tes dépenses et être alerté avant de déraper.';

  @override
  String envelopeOf(String name) {
    return 'Enveloppe $name';
  }

  @override
  String envelopeOverBy(String amount) {
    return 'Dépassé de $amount';
  }

  @override
  String envelopeLeft(String amount) {
    return 'Reste $amount';
  }

  @override
  String deleteEnvelopeQuestion(String name) {
    return 'Supprimer l\'enveloppe « $name » ?';
  }

  @override
  String get noChargesTitle => 'Aucune charge fixe';

  @override
  String get noChargesBody =>
      'Ajoute ton loyer, l\'électricité, l\'eau, internet… Elles apparaîtront chaque mois automatiquement.';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get accountsSub => 'Courant, épargne, espèces';

  @override
  String get recurringSub => 'Loyer, abonnements, salaire…';

  @override
  String get categoriesSub => 'Créer, renommer, couleur et icône';

  @override
  String get debtsSub => 'Crédits, paiements en plusieurs fois';

  @override
  String get dueRemindersSub =>
      'Un rappel 3 jours avant et le jour même de chaque charge';

  @override
  String get notificationsDenied =>
      'Autorise les notifications dans les réglages Android.';

  @override
  String get dailyReminderSub =>
      'Chaque soir à 20 h, « pense à noter tes dépenses »';

  @override
  String get biometricLockSub =>
      'Empreinte ou code de l\'appareil à l\'ouverture';

  @override
  String get backupNeverSub =>
      'Fichier chiffré par mot de passe · jamais sauvegardé';

  @override
  String backupLastSub(String when) {
    return 'Fichier chiffré · dernière sauvegarde $when';
  }

  @override
  String get restoreSub => 'Remplace les données actuelles';

  @override
  String get startOverSub => 'Efface tout et relance la configuration';

  @override
  String get agoToday => 'aujourd\'hui';

  @override
  String get agoYesterday => 'hier';

  @override
  String agoDays(int days) {
    return 'il y a $days jours';
  }

  @override
  String get resetAllTitle => 'Tout effacer ?';

  @override
  String get resetAllBody =>
      'Toutes tes données seront supprimées et tu recommenceras la configuration de départ. Cette action est irréversible.';

  @override
  String get backupPasswordTitle => 'Mot de passe de la sauvegarde';

  @override
  String backupFailed(String message) {
    return 'Échec de la sauvegarde : $message';
  }

  @override
  String get restorePasswordTitle => 'Mot de passe du fichier';

  @override
  String get restoreTitle => 'Restaurer ?';

  @override
  String get restoreBody => 'Toutes les données actuelles seront remplacées.';

  @override
  String get restoreDone => 'Restauration réussie. Redémarre l\'app.';

  @override
  String get password => 'Mot de passe';

  @override
  String get pickCurrency => 'Choisis ta devise';

  @override
  String get periodStartsOn => 'Le mois budgétaire commence le';

  @override
  String get periodStartFirst => 'le 1er de chaque mois';

  @override
  String periodStartNth(int day) {
    return 'le $day de chaque mois (utile si ton salaire tombe en fin de mois)';
  }

  @override
  String dayOrdinal(int day) {
    return 'le $day';
  }

  @override
  String get actionRemove => 'Retirer';

  @override
  String get none => 'Aucun';

  @override
  String get chargeRent => 'Loyer';

  @override
  String get debitDayHelp => 'Jour du prélèvement';

  @override
  String debitedOn(int day) {
    return 'Prélevé le $day';
  }

  @override
  String debitedOnEveryMonth(int day) {
    return 'Prélevé le $day de chaque mois';
  }

  @override
  String get monthlyAmount => 'Montant mensuel';

  @override
  String get monthlyCap => 'Plafond mensuel';

  @override
  String get previousDay => 'Jour précédent';

  @override
  String get nextDay => 'Jour suivant';

  @override
  String get periodStartFirstShort => 'le 1er';

  @override
  String get periodStartFirstShortCap => 'Le 1er';

  @override
  String dayOrdinalCap(int day) {
    return 'Le $day';
  }

  @override
  String get onboardStartDayTitle => 'Ton mois commence quand ?';

  @override
  String get onboardStartDayBody =>
      'Choisis le jour où débute ton budget. Le 1er par défaut, ou le jour de ta paie si ton salaire tombe en fin de mois.';

  @override
  String get onboardSalaryTitle => 'Quel est ton revenu mensuel ?';

  @override
  String get onboardSalaryBody =>
      'Ton salaire net habituel. Il sera pré-rempli chaque mois — tu pourras l\'ajuster à tout moment. Tu peux aussi laisser vide.';

  @override
  String get onboardChargesTitle => 'Tes charges fixes';

  @override
  String get onboardChargesBody =>
      'Coche celles que tu as, indique le montant et le jour du prélèvement. Elles reviendront automatiquement chaque mois.';

  @override
  String get onboardSubsTitle => 'Tes abonnements';

  @override
  String get onboardSubsBody =>
      'Touche ceux auxquels tu es abonné. On te demandera la date de prélèvement et le montant.';

  @override
  String onboardSubsCount(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count abonnements · $total par mois',
      one: '1 abonnement · $total par mois',
    );
    return '$_temp0';
  }

  @override
  String get onboardEnvelopesTitle => 'Tes budgets du mois';

  @override
  String get onboardEnvelopesBody =>
      'Fixe-toi un plafond sur ce qui dérape facilement. Tout est facultatif — tu pourras en ajouter plus tard.';

  @override
  String get onboardAnotherBudget => 'Un autre budget ?';

  @override
  String get onboardOptionsTitle => 'Presque fini !';

  @override
  String get onboardOptionsBody =>
      'Deux options pour t\'aider au quotidien. Tu peux les changer plus tard dans les réglages.';

  @override
  String get onboardRemindersSub => '3 jours avant et le jour de chaque charge';

  @override
  String get onboardBiometricSub => 'Empreinte ou code à l\'ouverture';

  @override
  String get ringCharges => 'Charges';

  @override
  String get ringOther => 'Autre';

  @override
  String get ringFree => 'Libre';

  @override
  String get onboardRecapTitle => 'Voilà ton mois';

  @override
  String onboardRecapWithSalary(String income) {
    return 'Sur $income de revenu, voilà comment ton budget est réparti.';
  }

  @override
  String get onboardRecapNoSalary =>
      'Voilà comment ton budget est réparti. Ajoute ton revenu quand tu veux pour voir ce qu\'il te reste.';

  @override
  String onboardRecapSemantics(String breakdown) {
    return 'Répartition de ton budget : $breakdown.';
  }

  @override
  String get onboardYouWillHaveLeft => 'Il te restera';

  @override
  String get onboardCommitted => 'Engagé';

  @override
  String onboardOverBudget(String amount) {
    return 'Tes charges et budgets dépassent ton revenu de $amount. Ce n\'est pas grave : ajuste-les quand tu veux depuis l\'onglet Budgets.';
  }

  @override
  String get ringOthers => 'Autres';

  @override
  String get previousMonth => 'Mois précédent';

  @override
  String get nextMonth => 'Mois suivant';

  @override
  String get noTransactionsThatMonth => 'Aucune transaction ce mois-là.';

  @override
  String get carriedToNextMonth => 'reporté sur le mois suivant';

  @override
  String get carryInLabel => 'Report du mois précédent';

  @override
  String get carryCorrected => 'corrigé';

  @override
  String get incomeReceived => 'Revenus perçus';

  @override
  String get incomePlanned => 'Revenus prévus';

  @override
  String get expenses => 'Dépenses';

  @override
  String unpaidCharges(int count) {
    return 'Charges non payées ($count)';
  }

  @override
  String get fixCarry => 'Corriger le report';

  @override
  String get fixCarryBody =>
      'Force le report entrant de ce mois. Les mois suivants sont recalculés en conséquence.';

  @override
  String get carryShort => 'Report';

  @override
  String get restoreAuto => 'Rétablir l\'auto';

  @override
  String get actionApply => 'Appliquer';

  @override
  String get deleteTransactionQuestion => 'Supprimer cette transaction ?';

  @override
  String get deleteTransactionBody =>
      'Le solde de ce mois et le report des mois suivants seront recalculés.';

  @override
  String get noDataTitle => 'Aucune donnée';

  @override
  String get noDataBody => 'Les mois passés apparaîtront ici au fil du temps.';

  @override
  String get statsTitle => 'Statistiques';

  @override
  String get noSpendingThisMonth => 'Aucune dépense ce mois-ci.';

  @override
  String donutSemantics(String total) {
    return 'Répartition des dépenses par catégorie. Total $total.';
  }

  @override
  String get noDataYet => 'Pas encore de données.';

  @override
  String barsMonthSummary(String month, String income, String expense) {
    return '$month : revenus $income, dépenses $expense';
  }

  @override
  String barsSummary(int count, String months) {
    return 'Revenus et dépenses sur $count mois. $months.';
  }

  @override
  String get deficit => 'Déficit';

  @override
  String get saved => 'Épargné';

  @override
  String get currentEstimate => 'Estimé actuel';

  @override
  String get actualAverage => 'Moyenne réelle';

  @override
  String get noPaidBillYet =>
      'Pas encore de facture payée pour cette charge. L\'historique apparaîtra ici au fil des mois.';

  @override
  String get estimateDriftTitle => 'Ton estimé s\'écarte de la réalité';

  @override
  String estimateDriftBelow(String average, String gap) {
    return 'La moyenne réelle est $average, sous l\'estimé de $gap.';
  }

  @override
  String estimateDriftAbove(String average, String gap) {
    return 'La moyenne réelle est $average, au-dessus de l\'estimé de $gap.';
  }

  @override
  String retuneEstimate(String amount) {
    return 'Réajuster l\'estimé à $amount';
  }

  @override
  String get searchHint => 'Rechercher…';

  @override
  String get clearSearch => 'Effacer la recherche';

  @override
  String get filterAll => 'Tout';

  @override
  String get moveLabel => 'Basculement';

  @override
  String get betweenAccounts => 'entre comptes';

  @override
  String get plannedTapToReceive => 'prévu — appuie pour encaisser';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get noTransactionsThisMonth => 'Aucune transaction ce mois-ci';

  @override
  String get noTransactionsBody =>
      'Appuie sur + pour ajouter ta première dépense ou ton salaire.';

  @override
  String get systemCategory => 'catégorie système';

  @override
  String get deleteCategoryWarning =>
      'Les transactions de cette catégorie deviendront « Non catégorisé ». Les sous-catégories seront aussi supprimées.';

  @override
  String get editCategory => 'Modifier la catégorie';

  @override
  String get newCategory => 'Nouvelle catégorie';

  @override
  String get createCategory => 'Créer la catégorie';

  @override
  String get newGoal => 'Nouvel objectif';

  @override
  String get goalNameHint => 'Vacances, matelas de sécurité…';

  @override
  String get goalTarget => 'Montant à atteindre';

  @override
  String get goalMonthly => 'À réserver chaque mois (facultatif)';

  @override
  String get goalMonthlyHelp =>
      'Déduit du reste à vivre pour te forcer à épargner';

  @override
  String get createGoal => 'Créer l\'objectif';

  @override
  String get envelopeRollover => 'Reporter le non-dépensé';

  @override
  String get envelopeRolloverSub =>
      'Ce qui n\'est pas dépensé s\'ajoute au plafond du mois suivant.';

  @override
  String get backupNudgeTitle => 'Pense à sauvegarder';

  @override
  String get backupNudgeNever =>
      'Tes données n\'existent que sur ce téléphone. Une sauvegarde chiffrée te met à l’abri.';

  @override
  String backupNudgeDays(int days) {
    return 'Ta dernière sauvegarde date de $days jours.';
  }

  @override
  String get actionLater => 'Plus tard';

  @override
  String get closingBalance => 'Solde de fin de mois';

  @override
  String get goalTargetDate => 'Date cible (facultatif)';

  @override
  String get clearDate => 'Effacer la date';

  @override
  String get total => 'Total';

  @override
  String get actionOk => 'OK';

  @override
  String get actionUndo => 'Annuler';

  @override
  String get transactionDeleted => 'Transaction supprimée';

  @override
  String get duplicateToday => 'Dupliquer à aujourd\'hui';

  @override
  String get duplicated => 'Dupliquée';

  @override
  String get projectedEndTitle => 'À ce rythme';

  @override
  String projectedEndBody(String amount) {
    return 'tu finis le mois à $amount';
  }

  @override
  String vsLastMonthLess(int percent) {
    return '$percent % de moins que le mois dernier';
  }

  @override
  String vsLastMonthMore(int percent) {
    return '$percent % de plus que le mois dernier';
  }

  @override
  String get vsLastMonthSame => 'Au même rythme que le mois dernier';

  @override
  String get noRecurrencesTitle => 'Aucune récurrence';

  @override
  String get noRecurrencesBody =>
      'Ajoute ce qui revient chaque mois : loyer, abonnements, salaire. Tu n\'auras plus à y penser.';

  @override
  String get exportMonth => 'Exporter ce mois (CSV)';

  @override
  String exportSubject(String period) {
    return 'Budgie — $period';
  }

  @override
  String get exportEmpty => 'Rien à exporter pour ce mois.';

  @override
  String get csvDate => 'Date';

  @override
  String get csvType => 'Type';

  @override
  String get csvCategory => 'Catégorie';

  @override
  String get csvAccount => 'Compte';

  @override
  String get csvNote => 'Note';

  @override
  String get csvAmount => 'Montant';

  @override
  String suggestRecurrenceTitle(String name) {
    return '« $name » revient chaque mois';
  }

  @override
  String suggestRecurrenceBody(int count, String amount, int day) {
    return 'Payé $count mois de suite, environ $amount vers le $day. En faire un abonnement le fera apparaître tout seul.';
  }

  @override
  String get suggestMakeItRecurring => 'En faire un abonnement';

  @override
  String suggestEnvelopeTitle(String name) {
    return 'Un plafond sur « $name » ?';
  }

  @override
  String suggestEnvelopeBody(int count, String amount, String limit) {
    return 'Tu y dépenses $amount par mois en moyenne sur $count mois. Un plafond à $limit te préviendrait avant de déraper.';
  }

  @override
  String get suggestSetTheCap => 'Créer l\'enveloppe';

  @override
  String get suggestNoThanks => 'Non merci';

  @override
  String get recapTitle => 'Ton mois';

  @override
  String get recapSaved => 'Épargné';

  @override
  String get recapOverspent => 'Dépassé de';

  @override
  String recapSemantics(String income, String expenses) {
    return 'Revenus $income, dépenses $expenses.';
  }

  @override
  String recapAdviceSaved(String amount) {
    return '$amount de plus que ce que tu as dépensé. C\'est autant de gagné pour le mois prochain.';
  }

  @override
  String get recapAdviceOver =>
      'Tu as dépensé plus que tu n\'as reçu ce mois-ci. Le solde est reporté sur le mois suivant.';

  @override
  String get recapWhereItWent => 'Où c\'est parti';

  @override
  String recapShare(String amount, int percent) {
    return '$amount · $percent %';
  }

  @override
  String get recapSeeMonth => 'Voir le récap du mois';

  @override
  String get notifRecapTitle => 'Ton mois est bouclé 📊';

  @override
  String get notifRecapBody =>
      'Ouvre Budgie pour voir où est parti ton argent.';

  @override
  String get accountCurrency => 'Devise du compte';

  @override
  String accountCurrencySameAsApp(String code) {
    return 'Comme l\'app ($code)';
  }

  @override
  String get settingsRates => 'Taux de change';

  @override
  String get settingsRatesSub => 'Pour tes comptes en devise étrangère';

  @override
  String get ratesIntro =>
      'Budgie ne va jamais sur internet : c\'est toi qui donnes les taux, et tu les corriges quand tu veux. Ils ne servent qu\'à convertir au moment de la saisie — tes mois passés ne bougent pas.';

  @override
  String ratesOneUnitEquals(String code) {
    return '1 $code =';
  }

  @override
  String get ratesNone =>
      'Aucun taux. Ajoute-en un quand tu crées un compte en devise étrangère.';

  @override
  String get ratesAdd => 'Ajouter un taux';

  @override
  String ratesMissing(String code) {
    return 'Aucun taux pour $code — le montant sera pris tel quel.';
  }

  @override
  String ratesConverted(String amount) {
    return '≈ $amount une fois converti';
  }

  @override
  String statsRangeMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mois',
      one: '1 mois',
    );
    return '$_temp0';
  }

  @override
  String get statsTrend => 'Évolution';

  @override
  String get statsByCategory => 'Par catégorie';

  @override
  String get statsRepeatOffenders => 'Ce qui revient le plus';

  @override
  String statsAveragePerMonth(String amount) {
    return '$amount par mois en moyenne';
  }

  @override
  String statsDeltaPercent(int percent) {
    return '$percent %';
  }

  @override
  String statsShareOfTotal(int percent) {
    return '$percent pour cent du total';
  }

  @override
  String statsTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fois',
      one: '1 fois',
    );
    return '$_temp0';
  }
}
