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
      'Appuie sur « Ajouter » en bas dès que tu dépenses quelque chose. Ton reste à vivre se met à jour tout seul.';

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
}
