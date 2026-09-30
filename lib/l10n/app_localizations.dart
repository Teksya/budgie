import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L
/// returned by `L.of(context)`.
///
/// Applications need to include `L.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L.localizationsDelegates,
///   supportedLocales: L.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L.supportedLocales
/// property.
abstract class L {
  L(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L of(BuildContext context) {
    return Localizations.of<L>(context, L)!;
  }

  static const LocalizationsDelegate<L> delegate = _LDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Budgie'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navHome;

  /// No description provided for @navTransactions.
  ///
  /// In fr, this message translates to:
  /// **'Transactions'**
  String get navTransactions;

  /// No description provided for @navBudgets.
  ///
  /// In fr, this message translates to:
  /// **'Budgets'**
  String get navBudgets;

  /// No description provided for @navStats.
  ///
  /// In fr, this message translates to:
  /// **'Stats'**
  String get navStats;

  /// No description provided for @actionAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get actionAdd;

  /// No description provided for @actionSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get actionSave;

  /// No description provided for @actionCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get actionDelete;

  /// No description provided for @actionContinue.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get actionContinue;

  /// No description provided for @actionBack.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get actionBack;

  /// No description provided for @actionConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get actionConfirm;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réglages'**
  String get settingsTitle;

  /// No description provided for @history.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get history;

  /// No description provided for @remainingToSpend.
  ///
  /// In fr, this message translates to:
  /// **'Reste à vivre'**
  String get remainingToSpend;

  /// No description provided for @perDay.
  ///
  /// In fr, this message translates to:
  /// **'{amount} / jour'**
  String perDay(String amount);

  /// No description provided for @daysLeft.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 jour restant} other{{count} jours restants}}'**
  String daysLeft(int count);

  /// No description provided for @healthComfortable.
  ///
  /// In fr, this message translates to:
  /// **'Confortable'**
  String get healthComfortable;

  /// No description provided for @healthTight.
  ///
  /// In fr, this message translates to:
  /// **'Serré'**
  String get healthTight;

  /// No description provided for @healthOver.
  ///
  /// In fr, this message translates to:
  /// **'Dépassé'**
  String get healthOver;

  /// No description provided for @upcomingCharges.
  ///
  /// In fr, this message translates to:
  /// **'Prochaines échéances'**
  String get upcomingCharges;

  /// No description provided for @recentTransactions.
  ///
  /// In fr, this message translates to:
  /// **'Dernières transactions'**
  String get recentTransactions;

  /// No description provided for @noChargesToPay.
  ///
  /// In fr, this message translates to:
  /// **'Aucune charge à payer. 🎉'**
  String get noChargesToPay;

  /// No description provided for @firstExpenseTitle.
  ///
  /// In fr, this message translates to:
  /// **'Note ta première dépense'**
  String get firstExpenseTitle;

  /// No description provided for @firstExpenseBody.
  ///
  /// In fr, this message translates to:
  /// **'Appuie ici dès que tu dépenses quelque chose. Ton reste à vivre se met à jour tout seul.'**
  String get firstExpenseBody;

  /// No description provided for @onboardWelcomeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Reprends la main\nsur ton budget'**
  String get onboardWelcomeTitle;

  /// No description provided for @onboardWelcomeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'On met tout en place ensemble, ça prend 2 minutes.'**
  String get onboardWelcomeSubtitle;

  /// No description provided for @onboardHl1Title.
  ///
  /// In fr, this message translates to:
  /// **'Ton reste à vivre en un coup d\'œil'**
  String get onboardHl1Title;

  /// No description provided for @onboardHl1Body.
  ///
  /// In fr, this message translates to:
  /// **'Combien tu peux encore dépenser d\'ici la fin du mois.'**
  String get onboardHl1Body;

  /// No description provided for @onboardHl2Title.
  ///
  /// In fr, this message translates to:
  /// **'Tes charges gérées toutes seules'**
  String get onboardHl2Title;

  /// No description provided for @onboardHl2Body.
  ///
  /// In fr, this message translates to:
  /// **'Loyer, élec, abonnements : elles reviennent chaque mois.'**
  String get onboardHl2Body;

  /// No description provided for @onboardHl3Title.
  ///
  /// In fr, this message translates to:
  /// **'Des alertes au bon moment'**
  String get onboardHl3Title;

  /// No description provided for @onboardHl3Body.
  ///
  /// In fr, this message translates to:
  /// **'Avant une échéance ou un dépassement de budget.'**
  String get onboardHl3Body;

  /// No description provided for @onboardHl4Title.
  ///
  /// In fr, this message translates to:
  /// **'100 % privé, hors ligne'**
  String get onboardHl4Title;

  /// No description provided for @onboardHl4Body.
  ///
  /// In fr, this message translates to:
  /// **'Tes données restent sur ton téléphone, point.'**
  String get onboardHl4Body;

  /// No description provided for @onboardStart.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get onboardStart;

  /// No description provided for @onboardDone.
  ///
  /// In fr, this message translates to:
  /// **'C\'est parti !'**
  String get onboardDone;

  /// No description provided for @settingsCurrency.
  ///
  /// In fr, this message translates to:
  /// **'Devise'**
  String get settingsCurrency;

  /// No description provided for @settingsLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get settingsLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In fr, this message translates to:
  /// **'Langue du système'**
  String get languageSystem;

  /// No description provided for @languageFrench.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageEnglish.
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @newExpense.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle dépense'**
  String get newExpense;

  /// No description provided for @newIncome.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau revenu'**
  String get newIncome;

  /// No description provided for @moveMoney.
  ///
  /// In fr, this message translates to:
  /// **'Basculer de l\'argent'**
  String get moveMoney;

  /// No description provided for @edit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get edit;

  /// No description provided for @expense.
  ///
  /// In fr, this message translates to:
  /// **'Dépense'**
  String get expense;

  /// No description provided for @income.
  ///
  /// In fr, this message translates to:
  /// **'Revenu'**
  String get income;

  /// No description provided for @transferShort.
  ///
  /// In fr, this message translates to:
  /// **'Basculer'**
  String get transferShort;

  /// No description provided for @scanReceipt.
  ///
  /// In fr, this message translates to:
  /// **'Scanner un ticket'**
  String get scanReceipt;

  /// No description provided for @readingReceipt.
  ///
  /// In fr, this message translates to:
  /// **'Lecture du ticket…'**
  String get readingReceipt;

  /// No description provided for @takePhoto.
  ///
  /// In fr, this message translates to:
  /// **'Prendre en photo'**
  String get takePhoto;

  /// No description provided for @fromGallery.
  ///
  /// In fr, this message translates to:
  /// **'Depuis la galerie'**
  String get fromGallery;

  /// No description provided for @category.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get category;

  /// No description provided for @noteOptional.
  ///
  /// In fr, this message translates to:
  /// **'Note (facultatif)'**
  String get noteOptional;

  /// No description provided for @sharedExpense.
  ///
  /// In fr, this message translates to:
  /// **'Dépense partagée'**
  String get sharedExpense;

  /// No description provided for @sharedHint.
  ///
  /// In fr, this message translates to:
  /// **'Le montant ci-dessus est ta part ; indique le total ci-dessous.'**
  String get sharedHint;

  /// No description provided for @sharedTotal.
  ///
  /// In fr, this message translates to:
  /// **'Montant total (partagé)'**
  String get sharedTotal;

  /// No description provided for @receiptPhoto.
  ///
  /// In fr, this message translates to:
  /// **'Photo du ticket'**
  String get receiptPhoto;

  /// No description provided for @receiptAttached.
  ///
  /// In fr, this message translates to:
  /// **'Ticket joint'**
  String get receiptAttached;

  /// No description provided for @alreadyReceived.
  ///
  /// In fr, this message translates to:
  /// **'Déjà perçu'**
  String get alreadyReceived;

  /// No description provided for @addedToBalance.
  ///
  /// In fr, this message translates to:
  /// **'Ajouté au solde'**
  String get addedToBalance;

  /// No description provided for @plannedNotReceived.
  ///
  /// In fr, this message translates to:
  /// **'Prévu, pas encore encaissé'**
  String get plannedNotReceived;

  /// No description provided for @transferInfo.
  ///
  /// In fr, this message translates to:
  /// **'Déplace de l\'argent d\'un de tes comptes vers un autre. Ça n\'ajoute ni dépense ni revenu : ton reste à vivre ne bouge pas.'**
  String get transferInfo;

  /// No description provided for @from.
  ///
  /// In fr, this message translates to:
  /// **'Depuis'**
  String get from;

  /// No description provided for @to.
  ///
  /// In fr, this message translates to:
  /// **'Vers'**
  String get to;

  /// No description provided for @needSecondAccount.
  ///
  /// In fr, this message translates to:
  /// **'Crée un deuxième compte pour pouvoir basculer de l\'argent.'**
  String get needSecondAccount;

  /// No description provided for @date.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @account.
  ///
  /// In fr, this message translates to:
  /// **'Compte'**
  String get account;

  /// No description provided for @whichAmount.
  ///
  /// In fr, this message translates to:
  /// **'Quel est le montant ?'**
  String get whichAmount;

  /// No description provided for @tapReceiptTotal.
  ///
  /// In fr, this message translates to:
  /// **'Appuie sur le total du ticket.'**
  String get tapReceiptTotal;

  /// No description provided for @enterManually.
  ///
  /// In fr, this message translates to:
  /// **'Saisir à la main'**
  String get enterManually;

  /// No description provided for @amountNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Montant non trouvé'**
  String get amountNotFound;

  /// No description provided for @receiptReadNoTotal.
  ///
  /// In fr, this message translates to:
  /// **'Le ticket a été lu mais je n\'ai pas repéré de total. Saisis le montant à la main — la photo reste jointe.'**
  String get receiptReadNoTotal;

  /// No description provided for @cannotReadReceipt.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de lire le ticket. Réessaie plus près, bien à plat et avec un bon éclairage.'**
  String get cannotReadReceipt;

  /// No description provided for @textRead.
  ///
  /// In fr, this message translates to:
  /// **'Texte lu :'**
  String get textRead;

  /// No description provided for @settingsAppearance.
  ///
  /// In fr, this message translates to:
  /// **'Apparence'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get settingsTheme;

  /// No description provided for @themeLight.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get themeSystem;

  /// No description provided for @dynamicColors.
  ///
  /// In fr, this message translates to:
  /// **'Couleurs dynamiques'**
  String get dynamicColors;

  /// No description provided for @dynamicColorsSub.
  ///
  /// In fr, this message translates to:
  /// **'S\'adapte au fond d\'écran (Material You)'**
  String get dynamicColorsSub;

  /// No description provided for @settingsGeneral.
  ///
  /// In fr, this message translates to:
  /// **'Général'**
  String get settingsGeneral;

  /// No description provided for @settingsPeriod.
  ///
  /// In fr, this message translates to:
  /// **'Période budgétaire'**
  String get settingsPeriod;

  /// No description provided for @settingsOrganisation.
  ///
  /// In fr, this message translates to:
  /// **'Organisation'**
  String get settingsOrganisation;

  /// No description provided for @settingsSecurity.
  ///
  /// In fr, this message translates to:
  /// **'Sécurité'**
  String get settingsSecurity;

  /// No description provided for @settingsData.
  ///
  /// In fr, this message translates to:
  /// **'Données'**
  String get settingsData;

  /// No description provided for @accounts.
  ///
  /// In fr, this message translates to:
  /// **'Comptes'**
  String get accounts;

  /// No description provided for @categories.
  ///
  /// In fr, this message translates to:
  /// **'Catégories'**
  String get categories;

  /// No description provided for @recurringLabel.
  ///
  /// In fr, this message translates to:
  /// **'Charges & revenus récurrents'**
  String get recurringLabel;

  /// No description provided for @debtsCredits.
  ///
  /// In fr, this message translates to:
  /// **'Dettes & crédits'**
  String get debtsCredits;

  /// No description provided for @biometricLock.
  ///
  /// In fr, this message translates to:
  /// **'Verrouillage biométrique'**
  String get biometricLock;

  /// No description provided for @dueReminders.
  ///
  /// In fr, this message translates to:
  /// **'Rappels d\'échéance'**
  String get dueReminders;

  /// No description provided for @dailyReminder.
  ///
  /// In fr, this message translates to:
  /// **'Rappel quotidien de saisie'**
  String get dailyReminder;

  /// No description provided for @backup.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarder'**
  String get backup;

  /// No description provided for @restore.
  ///
  /// In fr, this message translates to:
  /// **'Restaurer'**
  String get restore;

  /// No description provided for @startOver.
  ///
  /// In fr, this message translates to:
  /// **'Repartir de zéro'**
  String get startOver;

  /// No description provided for @quickExpenses.
  ///
  /// In fr, this message translates to:
  /// **'Dépenses rapides'**
  String get quickExpenses;

  /// No description provided for @newFavorite.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau'**
  String get newFavorite;

  /// No description provided for @frequencyMonthly.
  ///
  /// In fr, this message translates to:
  /// **'Mensuelle'**
  String get frequencyMonthly;

  /// No description provided for @frequencyBimonthly.
  ///
  /// In fr, this message translates to:
  /// **'Tous les 2 mois'**
  String get frequencyBimonthly;

  /// No description provided for @frequencyQuarterly.
  ///
  /// In fr, this message translates to:
  /// **'Trimestrielle'**
  String get frequencyQuarterly;

  /// No description provided for @frequencyBiannual.
  ///
  /// In fr, this message translates to:
  /// **'Semestrielle'**
  String get frequencyBiannual;

  /// No description provided for @frequencyAnnual.
  ///
  /// In fr, this message translates to:
  /// **'Annuelle'**
  String get frequencyAnnual;

  /// No description provided for @accountChecking.
  ///
  /// In fr, this message translates to:
  /// **'Compte courant'**
  String get accountChecking;

  /// No description provided for @accountSavings.
  ///
  /// In fr, this message translates to:
  /// **'Épargne'**
  String get accountSavings;

  /// No description provided for @accountCash.
  ///
  /// In fr, this message translates to:
  /// **'Espèces'**
  String get accountCash;

  /// No description provided for @natureFixedCharge.
  ///
  /// In fr, this message translates to:
  /// **'Charge fixe'**
  String get natureFixedCharge;

  /// No description provided for @natureSubscription.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement'**
  String get natureSubscription;

  /// No description provided for @natureSalary.
  ///
  /// In fr, this message translates to:
  /// **'Salaire'**
  String get natureSalary;

  /// No description provided for @natureLoanPayment.
  ///
  /// In fr, this message translates to:
  /// **'Mensualité de crédit'**
  String get natureLoanPayment;

  /// No description provided for @statusPending.
  ///
  /// In fr, this message translates to:
  /// **'À payer'**
  String get statusPending;

  /// No description provided for @statusPaid.
  ///
  /// In fr, this message translates to:
  /// **'Payée'**
  String get statusPaid;

  /// No description provided for @statusLate.
  ///
  /// In fr, this message translates to:
  /// **'En retard'**
  String get statusLate;

  /// No description provided for @debtCredit.
  ///
  /// In fr, this message translates to:
  /// **'Crédit'**
  String get debtCredit;

  /// No description provided for @debtOwed.
  ///
  /// In fr, this message translates to:
  /// **'Je dois'**
  String get debtOwed;

  /// No description provided for @debtLent.
  ///
  /// In fr, this message translates to:
  /// **'On me doit'**
  String get debtLent;

  /// No description provided for @debtInstallment.
  ///
  /// In fr, this message translates to:
  /// **'Paiement en plusieurs fois'**
  String get debtInstallment;

  /// No description provided for @spokenPercent.
  ///
  /// In fr, this message translates to:
  /// **'{percent} pour cent'**
  String spokenPercent(int percent);

  /// No description provided for @notifChannelName.
  ///
  /// In fr, this message translates to:
  /// **'Rappels d\'échéance'**
  String get notifChannelName;

  /// No description provided for @notifChannelDescription.
  ///
  /// In fr, this message translates to:
  /// **'Rappels avant une charge à payer'**
  String get notifChannelDescription;

  /// No description provided for @notifDueTodayTitle.
  ///
  /// In fr, this message translates to:
  /// **'Échéance aujourd\'hui : {name}'**
  String notifDueTodayTitle(String name);

  /// No description provided for @notifDueTodayBody.
  ///
  /// In fr, this message translates to:
  /// **'{amount} à payer.'**
  String notifDueTodayBody(String amount);

  /// No description provided for @notifDueSoonTitle.
  ///
  /// In fr, this message translates to:
  /// **'Dans 3 jours : {name}'**
  String notifDueSoonTitle(String name);

  /// No description provided for @notifDueSoonBody.
  ///
  /// In fr, this message translates to:
  /// **'{amount} à prévoir le {day}.'**
  String notifDueSoonBody(String amount, int day);

  /// No description provided for @notifDailyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pense à noter tes dépenses 💸'**
  String get notifDailyTitle;

  /// No description provided for @notifDailyBody.
  ///
  /// In fr, this message translates to:
  /// **'2 minutes pour rester à jour sur ton budget.'**
  String get notifDailyBody;

  /// No description provided for @shortcutAddExpense.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une dépense'**
  String get shortcutAddExpense;

  /// No description provided for @widgetRemainingLabel.
  ///
  /// In fr, this message translates to:
  /// **'Reste à vivre · {period}'**
  String widgetRemainingLabel(String period);

  /// No description provided for @widgetBillDue.
  ///
  /// In fr, this message translates to:
  /// **'échéance le {date}'**
  String widgetBillDue(String date);

  /// No description provided for @widgetNothingDue.
  ///
  /// In fr, this message translates to:
  /// **'Rien à payer 🎉'**
  String get widgetNothingDue;

  /// No description provided for @unlockReason.
  ///
  /// In fr, this message translates to:
  /// **'Déverrouille ton budget'**
  String get unlockReason;

  /// No description provided for @lockedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Budget verrouillé'**
  String get lockedTitle;

  /// No description provided for @unlock.
  ///
  /// In fr, this message translates to:
  /// **'Déverrouiller'**
  String get unlock;

  /// No description provided for @backupUnreadableFile.
  ///
  /// In fr, this message translates to:
  /// **'Fichier illisible.'**
  String get backupUnreadableFile;

  /// No description provided for @backupWrongPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe incorrect ou fichier corrompu.'**
  String get backupWrongPassword;

  /// No description provided for @backupShareSubject.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde Budget'**
  String get backupShareSubject;

  /// No description provided for @uncategorized.
  ///
  /// In fr, this message translates to:
  /// **'Non catégorisé'**
  String get uncategorized;

  /// No description provided for @catHousing.
  ///
  /// In fr, this message translates to:
  /// **'Logement'**
  String get catHousing;

  /// No description provided for @catFood.
  ///
  /// In fr, this message translates to:
  /// **'Alimentation'**
  String get catFood;

  /// No description provided for @catGroceries.
  ///
  /// In fr, this message translates to:
  /// **'Courses'**
  String get catGroceries;

  /// No description provided for @catRestaurant.
  ///
  /// In fr, this message translates to:
  /// **'Restaurant'**
  String get catRestaurant;

  /// No description provided for @catBakery.
  ///
  /// In fr, this message translates to:
  /// **'Boulangerie'**
  String get catBakery;

  /// No description provided for @catTransport.
  ///
  /// In fr, this message translates to:
  /// **'Transport'**
  String get catTransport;

  /// No description provided for @catFuel.
  ///
  /// In fr, this message translates to:
  /// **'Carburant'**
  String get catFuel;

  /// No description provided for @catPublicTransport.
  ///
  /// In fr, this message translates to:
  /// **'Transports en commun'**
  String get catPublicTransport;

  /// No description provided for @catVehicleUpkeep.
  ///
  /// In fr, this message translates to:
  /// **'Entretien'**
  String get catVehicleUpkeep;

  /// No description provided for @catBills.
  ///
  /// In fr, this message translates to:
  /// **'Factures & abonnements'**
  String get catBills;

  /// No description provided for @catElectricity.
  ///
  /// In fr, this message translates to:
  /// **'Électricité'**
  String get catElectricity;

  /// No description provided for @catWater.
  ///
  /// In fr, this message translates to:
  /// **'Eau'**
  String get catWater;

  /// No description provided for @catInternet.
  ///
  /// In fr, this message translates to:
  /// **'Internet'**
  String get catInternet;

  /// No description provided for @catPhone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get catPhone;

  /// No description provided for @catInsurance.
  ///
  /// In fr, this message translates to:
  /// **'Assurances'**
  String get catInsurance;

  /// No description provided for @catSubscriptions.
  ///
  /// In fr, this message translates to:
  /// **'Abonnements'**
  String get catSubscriptions;

  /// No description provided for @catHealth.
  ///
  /// In fr, this message translates to:
  /// **'Santé'**
  String get catHealth;

  /// No description provided for @catLeisure.
  ///
  /// In fr, this message translates to:
  /// **'Loisirs'**
  String get catLeisure;

  /// No description provided for @catShopping.
  ///
  /// In fr, this message translates to:
  /// **'Shopping'**
  String get catShopping;

  /// No description provided for @catSport.
  ///
  /// In fr, this message translates to:
  /// **'Sport'**
  String get catSport;

  /// No description provided for @catEducation.
  ///
  /// In fr, this message translates to:
  /// **'Éducation'**
  String get catEducation;

  /// No description provided for @catTravel.
  ///
  /// In fr, this message translates to:
  /// **'Voyages'**
  String get catTravel;

  /// No description provided for @catGifts.
  ///
  /// In fr, this message translates to:
  /// **'Cadeaux'**
  String get catGifts;

  /// No description provided for @catPets.
  ///
  /// In fr, this message translates to:
  /// **'Animaux'**
  String get catPets;

  /// No description provided for @catTaxes.
  ///
  /// In fr, this message translates to:
  /// **'Impôts'**
  String get catTaxes;

  /// No description provided for @catSavings.
  ///
  /// In fr, this message translates to:
  /// **'Épargne'**
  String get catSavings;

  /// No description provided for @catDebts.
  ///
  /// In fr, this message translates to:
  /// **'Crédits & dettes'**
  String get catDebts;

  /// No description provided for @catSalary.
  ///
  /// In fr, this message translates to:
  /// **'Salaire'**
  String get catSalary;

  /// No description provided for @catBonus.
  ///
  /// In fr, this message translates to:
  /// **'Prime'**
  String get catBonus;

  /// No description provided for @catBenefits.
  ///
  /// In fr, this message translates to:
  /// **'Allocations'**
  String get catBenefits;

  /// No description provided for @catFreelance.
  ///
  /// In fr, this message translates to:
  /// **'Freelance'**
  String get catFreelance;

  /// No description provided for @catRefund.
  ///
  /// In fr, this message translates to:
  /// **'Remboursement'**
  String get catRefund;

  /// No description provided for @catOtherIncome.
  ///
  /// In fr, this message translates to:
  /// **'Autre revenu'**
  String get catOtherIncome;

  /// No description provided for @errorWith.
  ///
  /// In fr, this message translates to:
  /// **'Erreur : {message}'**
  String errorWith(String message);

  /// No description provided for @balance.
  ///
  /// In fr, this message translates to:
  /// **'solde'**
  String get balance;

  /// No description provided for @deleteNamedQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer « {name} » ?'**
  String deleteNamedQuestion(String name);

  /// No description provided for @deleteAccountWarning.
  ///
  /// In fr, this message translates to:
  /// **'Les transactions de ce compte seront supprimées. Cette action est irréversible.'**
  String get deleteAccountWarning;

  /// No description provided for @cannotDeleteLastAccount.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de supprimer le dernier compte.'**
  String get cannotDeleteLastAccount;

  /// No description provided for @editAccount.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le compte'**
  String get editAccount;

  /// No description provided for @newAccount.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau compte'**
  String get newAccount;

  /// No description provided for @createAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer le compte'**
  String get createAccount;

  /// No description provided for @fieldName.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get fieldName;

  /// No description provided for @accountNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Compte courant, Livret A…'**
  String get accountNameHint;

  /// No description provided for @initialBalance.
  ///
  /// In fr, this message translates to:
  /// **'Solde initial'**
  String get initialBalance;

  /// No description provided for @initialBalanceHelp.
  ///
  /// In fr, this message translates to:
  /// **'Le solde du compte au moment où tu commences'**
  String get initialBalanceHelp;

  /// No description provided for @fieldType.
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get fieldType;

  /// No description provided for @fieldIcon.
  ///
  /// In fr, this message translates to:
  /// **'Icône'**
  String get fieldIcon;

  /// No description provided for @fieldColour.
  ///
  /// In fr, this message translates to:
  /// **'Couleur'**
  String get fieldColour;

  /// No description provided for @actionCreate.
  ///
  /// In fr, this message translates to:
  /// **'Créer'**
  String get actionCreate;

  /// No description provided for @amount.
  ///
  /// In fr, this message translates to:
  /// **'Montant'**
  String get amount;

  /// No description provided for @amountOptional.
  ///
  /// In fr, this message translates to:
  /// **'Montant (facultatif)'**
  String get amountOptional;

  /// No description provided for @favoriteAdded.
  ///
  /// In fr, this message translates to:
  /// **'« {name} » ajouté'**
  String favoriteAdded(String name);

  /// No description provided for @newFavoriteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle dépense type'**
  String get newFavoriteTitle;

  /// No description provided for @favoriteNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Café, Ticket resto…'**
  String get favoriteNameHint;

  /// No description provided for @favoriteAmountHelp.
  ///
  /// In fr, this message translates to:
  /// **'Vide = te demander le montant à chaque fois'**
  String get favoriteAmountHelp;

  /// No description provided for @savingsGoals.
  ///
  /// In fr, this message translates to:
  /// **'Objectifs d\'épargne'**
  String get savingsGoals;

  /// No description provided for @goal.
  ///
  /// In fr, this message translates to:
  /// **'Objectif'**
  String get goal;

  /// No description provided for @goalByDate.
  ///
  /// In fr, this message translates to:
  /// **'pour le {date}'**
  String goalByDate(String date);

  /// No description provided for @archive.
  ///
  /// In fr, this message translates to:
  /// **'Archiver'**
  String get archive;

  /// No description provided for @goalProgressOf.
  ///
  /// In fr, this message translates to:
  /// **'Progression de l’objectif {name}'**
  String goalProgressOf(String name);

  /// No description provided for @goalReached.
  ///
  /// In fr, this message translates to:
  /// **'Atteint 🎉'**
  String get goalReached;

  /// No description provided for @goalRemaining.
  ///
  /// In fr, this message translates to:
  /// **'reste {amount}'**
  String goalRemaining(String amount);

  /// No description provided for @goalMonthlySetAside.
  ///
  /// In fr, this message translates to:
  /// **'{amount} / mois réservés'**
  String goalMonthlySetAside(String amount);

  /// No description provided for @addToGoal.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter à « {name} »'**
  String addToGoal(String name);

  /// No description provided for @noGoalsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun objectif'**
  String get noGoalsTitle;

  /// No description provided for @noGoalsBody.
  ///
  /// In fr, this message translates to:
  /// **'Fixe-toi un but (vacances, matelas de sécurité…) et réserve un montant chaque mois.'**
  String get noGoalsBody;

  /// No description provided for @debtSettled.
  ///
  /// In fr, this message translates to:
  /// **'Soldé'**
  String get debtSettled;

  /// No description provided for @debtRepaymentOf.
  ///
  /// In fr, this message translates to:
  /// **'Remboursement de {name}'**
  String debtRepaymentOf(String name);

  /// No description provided for @debtLeftToCollect.
  ///
  /// In fr, this message translates to:
  /// **'Reste à récupérer'**
  String get debtLeftToCollect;

  /// No description provided for @debtOutstanding.
  ///
  /// In fr, this message translates to:
  /// **'Capital restant dû'**
  String get debtOutstanding;

  /// No description provided for @debtInstalmentCount.
  ///
  /// In fr, this message translates to:
  /// **'{paid} / {total} échéances'**
  String debtInstalmentCount(int paid, int total);

  /// No description provided for @perMonth.
  ///
  /// In fr, this message translates to:
  /// **'{amount}/mois'**
  String perMonth(String amount);

  /// No description provided for @debtRepaid.
  ///
  /// In fr, this message translates to:
  /// **'Remboursé'**
  String get debtRepaid;

  /// No description provided for @debtPayInstalment.
  ///
  /// In fr, this message translates to:
  /// **'Payer une échéance'**
  String get debtPayInstalment;

  /// No description provided for @debtPaymentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paiement · {name}'**
  String debtPaymentTitle(String name);

  /// No description provided for @noDebtsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune dette'**
  String get noDebtsTitle;

  /// No description provided for @noDebtsBody.
  ///
  /// In fr, this message translates to:
  /// **'Suis tes crédits, tes paiements en plusieurs fois, ou l\'argent qu\'on te doit.'**
  String get noDebtsBody;

  /// No description provided for @newDebtTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle dette / crédit'**
  String get newDebtTitle;

  /// No description provided for @debtNameHintLent.
  ///
  /// In fr, this message translates to:
  /// **'Prêt à un ami…'**
  String get debtNameHintLent;

  /// No description provided for @debtNameHintOwed.
  ///
  /// In fr, this message translates to:
  /// **'Crédit auto, canapé 4x…'**
  String get debtNameHintOwed;

  /// No description provided for @debtAmountLent.
  ///
  /// In fr, this message translates to:
  /// **'Montant prêté'**
  String get debtAmountLent;

  /// No description provided for @debtAmountOwed.
  ///
  /// In fr, this message translates to:
  /// **'Montant total dû'**
  String get debtAmountOwed;

  /// No description provided for @debtMonthlyPayment.
  ///
  /// In fr, this message translates to:
  /// **'Mensualité'**
  String get debtMonthlyPayment;

  /// No description provided for @debtInstalmentsCount.
  ///
  /// In fr, this message translates to:
  /// **'Nb échéances'**
  String get debtInstalmentsCount;

  /// No description provided for @recurringIncomes.
  ///
  /// In fr, this message translates to:
  /// **'Revenus récurrents'**
  String get recurringIncomes;

  /// No description provided for @recurringCharges.
  ///
  /// In fr, this message translates to:
  /// **'Charges fixes & abonnements'**
  String get recurringCharges;

  /// No description provided for @recurrenceVariable.
  ///
  /// In fr, this message translates to:
  /// **'variable'**
  String get recurrenceVariable;

  /// No description provided for @recurrenceDisabled.
  ///
  /// In fr, this message translates to:
  /// **'désactivé'**
  String get recurrenceDisabled;

  /// No description provided for @historyAndAverage.
  ///
  /// In fr, this message translates to:
  /// **'Historique & moyenne'**
  String get historyAndAverage;

  /// No description provided for @disable.
  ///
  /// In fr, this message translates to:
  /// **'Désactiver'**
  String get disable;

  /// No description provided for @enable.
  ///
  /// In fr, this message translates to:
  /// **'Activer'**
  String get enable;

  /// No description provided for @deleteRecurrenceWarning.
  ///
  /// In fr, this message translates to:
  /// **'La récurrence ne générera plus de nouvelles échéances. Les échéances déjà créées ce mois-ci restent.'**
  String get deleteRecurrenceWarning;

  /// No description provided for @savedChanges.
  ///
  /// In fr, this message translates to:
  /// **'Modifié'**
  String get savedChanges;

  /// No description provided for @recurringIncomeAdded.
  ///
  /// In fr, this message translates to:
  /// **'Revenu récurrent ajouté'**
  String get recurringIncomeAdded;

  /// No description provided for @chargeAdded.
  ///
  /// In fr, this message translates to:
  /// **'Charge ajoutée'**
  String get chargeAdded;

  /// No description provided for @recurringIncome.
  ///
  /// In fr, this message translates to:
  /// **'Revenu récurrent'**
  String get recurringIncome;

  /// No description provided for @newFixedCharge.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle charge fixe'**
  String get newFixedCharge;

  /// No description provided for @incomeNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Salaire, Allocation, Pension…'**
  String get incomeNameHint;

  /// No description provided for @chargeNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Loyer, Électricité, Internet…'**
  String get chargeNameHint;

  /// No description provided for @netAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant net'**
  String get netAmount;

  /// No description provided for @estimatedAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant estimé'**
  String get estimatedAmount;

  /// No description provided for @variableAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant variable'**
  String get variableAmount;

  /// No description provided for @variableAmountHelp.
  ///
  /// In fr, this message translates to:
  /// **'Comme l\'électricité ou l\'eau : tu corriges le montant réel à réception de la facture.'**
  String get variableAmountHelp;

  /// No description provided for @frequency.
  ///
  /// In fr, this message translates to:
  /// **'Périodicité'**
  String get frequency;

  /// No description provided for @payDayLabel.
  ///
  /// In fr, this message translates to:
  /// **'Jour de versement'**
  String get payDayLabel;

  /// No description provided for @dueDayLabel.
  ///
  /// In fr, this message translates to:
  /// **'Jour d\'échéance'**
  String get dueDayLabel;

  /// No description provided for @dueDayOn.
  ///
  /// In fr, this message translates to:
  /// **'{label} : le {day}'**
  String dueDayOn(String label, int day);

  /// No description provided for @saveIncome.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer le revenu'**
  String get saveIncome;

  /// No description provided for @saveCharge.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer la charge'**
  String get saveCharge;

  /// No description provided for @fixedCharge.
  ///
  /// In fr, this message translates to:
  /// **'Charge fixe'**
  String get fixedCharge;

  /// No description provided for @leftToPayThisMonth.
  ///
  /// In fr, this message translates to:
  /// **'Reste à payer ce mois-ci'**
  String get leftToPayThisMonth;

  /// No description provided for @paidOn.
  ///
  /// In fr, this message translates to:
  /// **'payée le {date}'**
  String paidOn(String date);

  /// No description provided for @payNamed.
  ///
  /// In fr, this message translates to:
  /// **'Payer « {name} »'**
  String payNamed(String name);

  /// No description provided for @actualAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant réel'**
  String get actualAmount;

  /// No description provided for @recurringChargesShort.
  ///
  /// In fr, this message translates to:
  /// **'Charges récurrentes'**
  String get recurringChargesShort;

  /// No description provided for @envelopes.
  ///
  /// In fr, this message translates to:
  /// **'Enveloppes'**
  String get envelopes;

  /// No description provided for @envelope.
  ///
  /// In fr, this message translates to:
  /// **'Enveloppe'**
  String get envelope;

  /// No description provided for @envelopesIntro.
  ///
  /// In fr, this message translates to:
  /// **'Fixe un plafond mensuel par catégorie (ex. Courses : 300 €) pour suivre tes dépenses et être alerté avant de déraper.'**
  String get envelopesIntro;

  /// No description provided for @envelopeOf.
  ///
  /// In fr, this message translates to:
  /// **'Enveloppe {name}'**
  String envelopeOf(String name);

  /// No description provided for @envelopeOverBy.
  ///
  /// In fr, this message translates to:
  /// **'Dépassé de {amount}'**
  String envelopeOverBy(String amount);

  /// No description provided for @envelopeLeft.
  ///
  /// In fr, this message translates to:
  /// **'Reste {amount}'**
  String envelopeLeft(String amount);

  /// No description provided for @deleteEnvelopeQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer l\'enveloppe « {name} » ?'**
  String deleteEnvelopeQuestion(String name);

  /// No description provided for @noChargesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune charge fixe'**
  String get noChargesTitle;

  /// No description provided for @noChargesBody.
  ///
  /// In fr, this message translates to:
  /// **'Ajoute ton loyer, l\'électricité, l\'eau, internet… Elles apparaîtront chaque mois automatiquement.'**
  String get noChargesBody;

  /// No description provided for @settingsNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @accountsSub.
  ///
  /// In fr, this message translates to:
  /// **'Courant, épargne, espèces'**
  String get accountsSub;

  /// No description provided for @recurringSub.
  ///
  /// In fr, this message translates to:
  /// **'Loyer, abonnements, salaire…'**
  String get recurringSub;

  /// No description provided for @categoriesSub.
  ///
  /// In fr, this message translates to:
  /// **'Créer, renommer, couleur et icône'**
  String get categoriesSub;

  /// No description provided for @debtsSub.
  ///
  /// In fr, this message translates to:
  /// **'Crédits, paiements en plusieurs fois'**
  String get debtsSub;

  /// No description provided for @dueRemindersSub.
  ///
  /// In fr, this message translates to:
  /// **'Un rappel 3 jours avant et le jour même de chaque charge'**
  String get dueRemindersSub;

  /// No description provided for @notificationsDenied.
  ///
  /// In fr, this message translates to:
  /// **'Autorise les notifications dans les réglages Android.'**
  String get notificationsDenied;

  /// No description provided for @dailyReminderSub.
  ///
  /// In fr, this message translates to:
  /// **'Chaque soir à 20 h, « pense à noter tes dépenses »'**
  String get dailyReminderSub;

  /// No description provided for @biometricLockSub.
  ///
  /// In fr, this message translates to:
  /// **'Empreinte ou code de l\'appareil à l\'ouverture'**
  String get biometricLockSub;

  /// No description provided for @backupNeverSub.
  ///
  /// In fr, this message translates to:
  /// **'Fichier chiffré par mot de passe · jamais sauvegardé'**
  String get backupNeverSub;

  /// No description provided for @backupLastSub.
  ///
  /// In fr, this message translates to:
  /// **'Fichier chiffré · dernière sauvegarde {when}'**
  String backupLastSub(String when);

  /// No description provided for @restoreSub.
  ///
  /// In fr, this message translates to:
  /// **'Remplace les données actuelles'**
  String get restoreSub;

  /// No description provided for @startOverSub.
  ///
  /// In fr, this message translates to:
  /// **'Efface tout et relance la configuration'**
  String get startOverSub;

  /// No description provided for @agoToday.
  ///
  /// In fr, this message translates to:
  /// **'aujourd\'hui'**
  String get agoToday;

  /// No description provided for @agoYesterday.
  ///
  /// In fr, this message translates to:
  /// **'hier'**
  String get agoYesterday;

  /// No description provided for @agoDays.
  ///
  /// In fr, this message translates to:
  /// **'il y a {days} jours'**
  String agoDays(int days);

  /// No description provided for @resetAllTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tout effacer ?'**
  String get resetAllTitle;

  /// No description provided for @resetAllBody.
  ///
  /// In fr, this message translates to:
  /// **'Toutes tes données seront supprimées et tu recommenceras la configuration de départ. Cette action est irréversible.'**
  String get resetAllBody;

  /// No description provided for @backupPasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe de la sauvegarde'**
  String get backupPasswordTitle;

  /// No description provided for @backupFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échec de la sauvegarde : {message}'**
  String backupFailed(String message);

  /// No description provided for @restorePasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe du fichier'**
  String get restorePasswordTitle;

  /// No description provided for @restoreTitle.
  ///
  /// In fr, this message translates to:
  /// **'Restaurer ?'**
  String get restoreTitle;

  /// No description provided for @restoreBody.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les données actuelles seront remplacées.'**
  String get restoreBody;

  /// No description provided for @restoreDone.
  ///
  /// In fr, this message translates to:
  /// **'Restauration réussie. Redémarre l\'app.'**
  String get restoreDone;

  /// No description provided for @password.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get password;

  /// No description provided for @pickCurrency.
  ///
  /// In fr, this message translates to:
  /// **'Choisis ta devise'**
  String get pickCurrency;

  /// No description provided for @periodStartsOn.
  ///
  /// In fr, this message translates to:
  /// **'Le mois budgétaire commence le'**
  String get periodStartsOn;

  /// No description provided for @periodStartFirst.
  ///
  /// In fr, this message translates to:
  /// **'le 1er de chaque mois'**
  String get periodStartFirst;

  /// No description provided for @periodStartNth.
  ///
  /// In fr, this message translates to:
  /// **'le {day} de chaque mois (utile si ton salaire tombe en fin de mois)'**
  String periodStartNth(int day);

  /// No description provided for @dayOrdinal.
  ///
  /// In fr, this message translates to:
  /// **'le {day}'**
  String dayOrdinal(int day);

  /// No description provided for @actionRemove.
  ///
  /// In fr, this message translates to:
  /// **'Retirer'**
  String get actionRemove;

  /// No description provided for @none.
  ///
  /// In fr, this message translates to:
  /// **'Aucun'**
  String get none;

  /// No description provided for @chargeRent.
  ///
  /// In fr, this message translates to:
  /// **'Loyer'**
  String get chargeRent;

  /// No description provided for @debitDayHelp.
  ///
  /// In fr, this message translates to:
  /// **'Jour du prélèvement'**
  String get debitDayHelp;

  /// No description provided for @debitedOn.
  ///
  /// In fr, this message translates to:
  /// **'Prélevé le {day}'**
  String debitedOn(int day);

  /// No description provided for @debitedOnEveryMonth.
  ///
  /// In fr, this message translates to:
  /// **'Prélevé le {day} de chaque mois'**
  String debitedOnEveryMonth(int day);

  /// No description provided for @monthlyAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant mensuel'**
  String get monthlyAmount;

  /// No description provided for @monthlyCap.
  ///
  /// In fr, this message translates to:
  /// **'Plafond mensuel'**
  String get monthlyCap;

  /// No description provided for @previousDay.
  ///
  /// In fr, this message translates to:
  /// **'Jour précédent'**
  String get previousDay;

  /// No description provided for @nextDay.
  ///
  /// In fr, this message translates to:
  /// **'Jour suivant'**
  String get nextDay;

  /// No description provided for @periodStartFirstShort.
  ///
  /// In fr, this message translates to:
  /// **'le 1er'**
  String get periodStartFirstShort;

  /// No description provided for @periodStartFirstShortCap.
  ///
  /// In fr, this message translates to:
  /// **'Le 1er'**
  String get periodStartFirstShortCap;

  /// No description provided for @dayOrdinalCap.
  ///
  /// In fr, this message translates to:
  /// **'Le {day}'**
  String dayOrdinalCap(int day);

  /// No description provided for @onboardStartDayTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ton mois commence quand ?'**
  String get onboardStartDayTitle;

  /// No description provided for @onboardStartDayBody.
  ///
  /// In fr, this message translates to:
  /// **'Choisis le jour où débute ton budget. Le 1er par défaut, ou le jour de ta paie si ton salaire tombe en fin de mois.'**
  String get onboardStartDayBody;

  /// No description provided for @onboardSalaryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Quel est ton revenu mensuel ?'**
  String get onboardSalaryTitle;

  /// No description provided for @onboardSalaryBody.
  ///
  /// In fr, this message translates to:
  /// **'Ton salaire net habituel. Il sera pré-rempli chaque mois — tu pourras l\'ajuster à tout moment. Tu peux aussi laisser vide.'**
  String get onboardSalaryBody;

  /// No description provided for @onboardChargesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tes charges fixes'**
  String get onboardChargesTitle;

  /// No description provided for @onboardChargesBody.
  ///
  /// In fr, this message translates to:
  /// **'Coche celles que tu as, indique le montant et le jour du prélèvement. Elles reviendront automatiquement chaque mois.'**
  String get onboardChargesBody;

  /// No description provided for @onboardSubsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tes abonnements'**
  String get onboardSubsTitle;

  /// No description provided for @onboardSubsBody.
  ///
  /// In fr, this message translates to:
  /// **'Touche ceux auxquels tu es abonné. On te demandera la date de prélèvement et le montant.'**
  String get onboardSubsBody;

  /// No description provided for @onboardSubsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 abonnement · {total} par mois} other{{count} abonnements · {total} par mois}}'**
  String onboardSubsCount(int count, String total);

  /// No description provided for @onboardEnvelopesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tes budgets du mois'**
  String get onboardEnvelopesTitle;

  /// No description provided for @onboardEnvelopesBody.
  ///
  /// In fr, this message translates to:
  /// **'Fixe-toi un plafond sur ce qui dérape facilement. Tout est facultatif — tu pourras en ajouter plus tard.'**
  String get onboardEnvelopesBody;

  /// No description provided for @onboardAnotherBudget.
  ///
  /// In fr, this message translates to:
  /// **'Un autre budget ?'**
  String get onboardAnotherBudget;

  /// No description provided for @onboardOptionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Presque fini !'**
  String get onboardOptionsTitle;

  /// No description provided for @onboardOptionsBody.
  ///
  /// In fr, this message translates to:
  /// **'Deux options pour t\'aider au quotidien. Tu peux les changer plus tard dans les réglages.'**
  String get onboardOptionsBody;

  /// No description provided for @onboardRemindersSub.
  ///
  /// In fr, this message translates to:
  /// **'3 jours avant et le jour de chaque charge'**
  String get onboardRemindersSub;

  /// No description provided for @onboardBiometricSub.
  ///
  /// In fr, this message translates to:
  /// **'Empreinte ou code à l\'ouverture'**
  String get onboardBiometricSub;

  /// No description provided for @ringCharges.
  ///
  /// In fr, this message translates to:
  /// **'Charges'**
  String get ringCharges;

  /// No description provided for @ringOther.
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get ringOther;

  /// No description provided for @ringFree.
  ///
  /// In fr, this message translates to:
  /// **'Libre'**
  String get ringFree;

  /// No description provided for @onboardRecapTitle.
  ///
  /// In fr, this message translates to:
  /// **'Voilà ton mois'**
  String get onboardRecapTitle;

  /// No description provided for @onboardRecapWithSalary.
  ///
  /// In fr, this message translates to:
  /// **'Sur {income} de revenu, voilà comment ton budget est réparti.'**
  String onboardRecapWithSalary(String income);

  /// No description provided for @onboardRecapNoSalary.
  ///
  /// In fr, this message translates to:
  /// **'Voilà comment ton budget est réparti. Ajoute ton revenu quand tu veux pour voir ce qu\'il te reste.'**
  String get onboardRecapNoSalary;

  /// No description provided for @onboardRecapSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Répartition de ton budget : {breakdown}.'**
  String onboardRecapSemantics(String breakdown);

  /// No description provided for @onboardYouWillHaveLeft.
  ///
  /// In fr, this message translates to:
  /// **'Il te restera'**
  String get onboardYouWillHaveLeft;

  /// No description provided for @onboardCommitted.
  ///
  /// In fr, this message translates to:
  /// **'Engagé'**
  String get onboardCommitted;

  /// No description provided for @onboardOverBudget.
  ///
  /// In fr, this message translates to:
  /// **'Tes charges et budgets dépassent ton revenu de {amount}. Ce n\'est pas grave : ajuste-les quand tu veux depuis l\'onglet Budgets.'**
  String onboardOverBudget(String amount);

  /// No description provided for @ringOthers.
  ///
  /// In fr, this message translates to:
  /// **'Autres'**
  String get ringOthers;

  /// No description provided for @previousMonth.
  ///
  /// In fr, this message translates to:
  /// **'Mois précédent'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In fr, this message translates to:
  /// **'Mois suivant'**
  String get nextMonth;

  /// No description provided for @noTransactionsThatMonth.
  ///
  /// In fr, this message translates to:
  /// **'Aucune transaction ce mois-là.'**
  String get noTransactionsThatMonth;

  /// No description provided for @carriedToNextMonth.
  ///
  /// In fr, this message translates to:
  /// **'reporté sur le mois suivant'**
  String get carriedToNextMonth;

  /// No description provided for @carryInLabel.
  ///
  /// In fr, this message translates to:
  /// **'Report du mois précédent'**
  String get carryInLabel;

  /// No description provided for @carryCorrected.
  ///
  /// In fr, this message translates to:
  /// **'corrigé'**
  String get carryCorrected;

  /// No description provided for @incomeReceived.
  ///
  /// In fr, this message translates to:
  /// **'Revenus perçus'**
  String get incomeReceived;

  /// No description provided for @incomePlanned.
  ///
  /// In fr, this message translates to:
  /// **'Revenus prévus'**
  String get incomePlanned;

  /// No description provided for @expenses.
  ///
  /// In fr, this message translates to:
  /// **'Dépenses'**
  String get expenses;

  /// No description provided for @unpaidCharges.
  ///
  /// In fr, this message translates to:
  /// **'Charges non payées ({count})'**
  String unpaidCharges(int count);

  /// No description provided for @fixCarry.
  ///
  /// In fr, this message translates to:
  /// **'Corriger le report'**
  String get fixCarry;

  /// No description provided for @fixCarryBody.
  ///
  /// In fr, this message translates to:
  /// **'Force le report entrant de ce mois. Les mois suivants sont recalculés en conséquence.'**
  String get fixCarryBody;

  /// No description provided for @carryShort.
  ///
  /// In fr, this message translates to:
  /// **'Report'**
  String get carryShort;

  /// No description provided for @restoreAuto.
  ///
  /// In fr, this message translates to:
  /// **'Rétablir l\'auto'**
  String get restoreAuto;

  /// No description provided for @actionApply.
  ///
  /// In fr, this message translates to:
  /// **'Appliquer'**
  String get actionApply;

  /// No description provided for @deleteTransactionQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer cette transaction ?'**
  String get deleteTransactionQuestion;

  /// No description provided for @deleteTransactionBody.
  ///
  /// In fr, this message translates to:
  /// **'Le solde de ce mois et le report des mois suivants seront recalculés.'**
  String get deleteTransactionBody;

  /// No description provided for @noDataTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée'**
  String get noDataTitle;

  /// No description provided for @noDataBody.
  ///
  /// In fr, this message translates to:
  /// **'Les mois passés apparaîtront ici au fil du temps.'**
  String get noDataBody;

  /// No description provided for @statsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques'**
  String get statsTitle;

  /// No description provided for @noSpendingThisMonth.
  ///
  /// In fr, this message translates to:
  /// **'Aucune dépense ce mois-ci.'**
  String get noSpendingThisMonth;

  /// No description provided for @donutSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Répartition des dépenses par catégorie. Total {total}.'**
  String donutSemantics(String total);

  /// No description provided for @noDataYet.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de données.'**
  String get noDataYet;

  /// No description provided for @barsMonthSummary.
  ///
  /// In fr, this message translates to:
  /// **'{month} : revenus {income}, dépenses {expense}'**
  String barsMonthSummary(String month, String income, String expense);

  /// No description provided for @barsSummary.
  ///
  /// In fr, this message translates to:
  /// **'Revenus et dépenses sur {count} mois. {months}.'**
  String barsSummary(int count, String months);

  /// No description provided for @deficit.
  ///
  /// In fr, this message translates to:
  /// **'Déficit'**
  String get deficit;

  /// No description provided for @saved.
  ///
  /// In fr, this message translates to:
  /// **'Épargné'**
  String get saved;

  /// No description provided for @currentEstimate.
  ///
  /// In fr, this message translates to:
  /// **'Estimé actuel'**
  String get currentEstimate;

  /// No description provided for @actualAverage.
  ///
  /// In fr, this message translates to:
  /// **'Moyenne réelle'**
  String get actualAverage;

  /// No description provided for @noPaidBillYet.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de facture payée pour cette charge. L\'historique apparaîtra ici au fil des mois.'**
  String get noPaidBillYet;

  /// No description provided for @estimateDriftTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ton estimé s\'écarte de la réalité'**
  String get estimateDriftTitle;

  /// No description provided for @estimateDriftBelow.
  ///
  /// In fr, this message translates to:
  /// **'La moyenne réelle est {average}, sous l\'estimé de {gap}.'**
  String estimateDriftBelow(String average, String gap);

  /// No description provided for @estimateDriftAbove.
  ///
  /// In fr, this message translates to:
  /// **'La moyenne réelle est {average}, au-dessus de l\'estimé de {gap}.'**
  String estimateDriftAbove(String average, String gap);

  /// No description provided for @retuneEstimate.
  ///
  /// In fr, this message translates to:
  /// **'Réajuster l\'estimé à {amount}'**
  String retuneEstimate(String amount);

  /// No description provided for @searchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher…'**
  String get searchHint;

  /// No description provided for @clearSearch.
  ///
  /// In fr, this message translates to:
  /// **'Effacer la recherche'**
  String get clearSearch;

  /// No description provided for @filterAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout'**
  String get filterAll;

  /// No description provided for @moveLabel.
  ///
  /// In fr, this message translates to:
  /// **'Basculement'**
  String get moveLabel;

  /// No description provided for @betweenAccounts.
  ///
  /// In fr, this message translates to:
  /// **'entre comptes'**
  String get betweenAccounts;

  /// No description provided for @plannedTapToReceive.
  ///
  /// In fr, this message translates to:
  /// **'prévu — appuie pour encaisser'**
  String get plannedTapToReceive;

  /// No description provided for @noResults.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat'**
  String get noResults;

  /// No description provided for @noTransactionsThisMonth.
  ///
  /// In fr, this message translates to:
  /// **'Aucune transaction ce mois-ci'**
  String get noTransactionsThisMonth;

  /// No description provided for @noTransactionsBody.
  ///
  /// In fr, this message translates to:
  /// **'Appuie sur + pour ajouter ta première dépense ou ton salaire.'**
  String get noTransactionsBody;

  /// No description provided for @systemCategory.
  ///
  /// In fr, this message translates to:
  /// **'catégorie système'**
  String get systemCategory;

  /// No description provided for @deleteCategoryWarning.
  ///
  /// In fr, this message translates to:
  /// **'Les transactions de cette catégorie deviendront « Non catégorisé ». Les sous-catégories seront aussi supprimées.'**
  String get deleteCategoryWarning;

  /// No description provided for @editCategory.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la catégorie'**
  String get editCategory;

  /// No description provided for @newCategory.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle catégorie'**
  String get newCategory;

  /// No description provided for @createCategory.
  ///
  /// In fr, this message translates to:
  /// **'Créer la catégorie'**
  String get createCategory;

  /// No description provided for @newGoal.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel objectif'**
  String get newGoal;

  /// No description provided for @goalNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Vacances, matelas de sécurité…'**
  String get goalNameHint;

  /// No description provided for @goalTarget.
  ///
  /// In fr, this message translates to:
  /// **'Montant à atteindre'**
  String get goalTarget;

  /// No description provided for @goalMonthly.
  ///
  /// In fr, this message translates to:
  /// **'À réserver chaque mois (facultatif)'**
  String get goalMonthly;

  /// No description provided for @goalMonthlyHelp.
  ///
  /// In fr, this message translates to:
  /// **'Déduit du reste à vivre pour te forcer à épargner'**
  String get goalMonthlyHelp;

  /// No description provided for @createGoal.
  ///
  /// In fr, this message translates to:
  /// **'Créer l\'objectif'**
  String get createGoal;

  /// No description provided for @envelopeRollover.
  ///
  /// In fr, this message translates to:
  /// **'Reporter le non-dépensé'**
  String get envelopeRollover;

  /// No description provided for @envelopeRolloverSub.
  ///
  /// In fr, this message translates to:
  /// **'Ce qui n\'est pas dépensé s\'ajoute au plafond du mois suivant.'**
  String get envelopeRolloverSub;

  /// No description provided for @backupNudgeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pense à sauvegarder'**
  String get backupNudgeTitle;

  /// No description provided for @backupNudgeNever.
  ///
  /// In fr, this message translates to:
  /// **'Tes données n\'existent que sur ce téléphone. Une sauvegarde chiffrée te met à l’abri.'**
  String get backupNudgeNever;

  /// No description provided for @backupNudgeDays.
  ///
  /// In fr, this message translates to:
  /// **'Ta dernière sauvegarde date de {days} jours.'**
  String backupNudgeDays(int days);

  /// No description provided for @actionLater.
  ///
  /// In fr, this message translates to:
  /// **'Plus tard'**
  String get actionLater;

  /// No description provided for @closingBalance.
  ///
  /// In fr, this message translates to:
  /// **'Solde de fin de mois'**
  String get closingBalance;

  /// No description provided for @goalTargetDate.
  ///
  /// In fr, this message translates to:
  /// **'Date cible (facultatif)'**
  String get goalTargetDate;

  /// No description provided for @clearDate.
  ///
  /// In fr, this message translates to:
  /// **'Effacer la date'**
  String get clearDate;

  /// No description provided for @total.
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @actionOk.
  ///
  /// In fr, this message translates to:
  /// **'OK'**
  String get actionOk;

  /// No description provided for @actionUndo.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get actionUndo;

  /// No description provided for @transactionDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Transaction supprimée'**
  String get transactionDeleted;

  /// No description provided for @duplicateToday.
  ///
  /// In fr, this message translates to:
  /// **'Dupliquer à aujourd\'hui'**
  String get duplicateToday;

  /// No description provided for @duplicated.
  ///
  /// In fr, this message translates to:
  /// **'Dupliquée'**
  String get duplicated;

  /// No description provided for @projectedEndTitle.
  ///
  /// In fr, this message translates to:
  /// **'À ce rythme'**
  String get projectedEndTitle;

  /// No description provided for @projectedEndBody.
  ///
  /// In fr, this message translates to:
  /// **'tu finis le mois à {amount}'**
  String projectedEndBody(String amount);

  /// No description provided for @vsLastMonthLess.
  ///
  /// In fr, this message translates to:
  /// **'{percent} % de moins que le mois dernier'**
  String vsLastMonthLess(int percent);

  /// No description provided for @vsLastMonthMore.
  ///
  /// In fr, this message translates to:
  /// **'{percent} % de plus que le mois dernier'**
  String vsLastMonthMore(int percent);

  /// No description provided for @vsLastMonthSame.
  ///
  /// In fr, this message translates to:
  /// **'Au même rythme que le mois dernier'**
  String get vsLastMonthSame;

  /// No description provided for @noRecurrencesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune récurrence'**
  String get noRecurrencesTitle;

  /// No description provided for @noRecurrencesBody.
  ///
  /// In fr, this message translates to:
  /// **'Ajoute ce qui revient chaque mois : loyer, abonnements, salaire. Tu n\'auras plus à y penser.'**
  String get noRecurrencesBody;

  /// No description provided for @exportMonth.
  ///
  /// In fr, this message translates to:
  /// **'Exporter ce mois (CSV)'**
  String get exportMonth;

  /// No description provided for @exportSubject.
  ///
  /// In fr, this message translates to:
  /// **'Budgie — {period}'**
  String exportSubject(String period);

  /// No description provided for @exportEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Rien à exporter pour ce mois.'**
  String get exportEmpty;

  /// No description provided for @csvDate.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get csvDate;

  /// No description provided for @csvType.
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get csvType;

  /// No description provided for @csvCategory.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get csvCategory;

  /// No description provided for @csvAccount.
  ///
  /// In fr, this message translates to:
  /// **'Compte'**
  String get csvAccount;

  /// No description provided for @csvNote.
  ///
  /// In fr, this message translates to:
  /// **'Note'**
  String get csvNote;

  /// No description provided for @csvAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant'**
  String get csvAmount;

  /// No description provided for @suggestRecurrenceTitle.
  ///
  /// In fr, this message translates to:
  /// **'« {name} » revient chaque mois'**
  String suggestRecurrenceTitle(String name);

  /// No description provided for @suggestRecurrenceBody.
  ///
  /// In fr, this message translates to:
  /// **'Payé {count} mois de suite, environ {amount} vers le {day}. En faire un abonnement le fera apparaître tout seul.'**
  String suggestRecurrenceBody(int count, String amount, int day);

  /// No description provided for @suggestMakeItRecurring.
  ///
  /// In fr, this message translates to:
  /// **'En faire un abonnement'**
  String get suggestMakeItRecurring;

  /// No description provided for @suggestEnvelopeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Un plafond sur « {name} » ?'**
  String suggestEnvelopeTitle(String name);

  /// No description provided for @suggestEnvelopeBody.
  ///
  /// In fr, this message translates to:
  /// **'Tu y dépenses {amount} par mois en moyenne sur {count} mois. Un plafond à {limit} te préviendrait avant de déraper.'**
  String suggestEnvelopeBody(int count, String amount, String limit);

  /// No description provided for @suggestSetTheCap.
  ///
  /// In fr, this message translates to:
  /// **'Créer l\'enveloppe'**
  String get suggestSetTheCap;

  /// No description provided for @suggestNoThanks.
  ///
  /// In fr, this message translates to:
  /// **'Non merci'**
  String get suggestNoThanks;

  /// No description provided for @recapTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ton mois'**
  String get recapTitle;

  /// No description provided for @recapSaved.
  ///
  /// In fr, this message translates to:
  /// **'Épargné'**
  String get recapSaved;

  /// No description provided for @recapOverspent.
  ///
  /// In fr, this message translates to:
  /// **'Dépassé de'**
  String get recapOverspent;

  /// No description provided for @recapSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Revenus {income}, dépenses {expenses}.'**
  String recapSemantics(String income, String expenses);

  /// No description provided for @recapAdviceSaved.
  ///
  /// In fr, this message translates to:
  /// **'{amount} de plus que ce que tu as dépensé. C\'est autant de gagné pour le mois prochain.'**
  String recapAdviceSaved(String amount);

  /// No description provided for @recapAdviceOver.
  ///
  /// In fr, this message translates to:
  /// **'Tu as dépensé plus que tu n\'as reçu ce mois-ci. Le solde est reporté sur le mois suivant.'**
  String get recapAdviceOver;

  /// No description provided for @recapWhereItWent.
  ///
  /// In fr, this message translates to:
  /// **'Où c\'est parti'**
  String get recapWhereItWent;

  /// No description provided for @recapShare.
  ///
  /// In fr, this message translates to:
  /// **'{amount} · {percent} %'**
  String recapShare(String amount, int percent);

  /// No description provided for @recapSeeMonth.
  ///
  /// In fr, this message translates to:
  /// **'Voir le récap du mois'**
  String get recapSeeMonth;

  /// No description provided for @notifRecapTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ton mois est bouclé 📊'**
  String get notifRecapTitle;

  /// No description provided for @notifRecapBody.
  ///
  /// In fr, this message translates to:
  /// **'Ouvre Budgie pour voir où est parti ton argent.'**
  String get notifRecapBody;

  /// No description provided for @accountCurrency.
  ///
  /// In fr, this message translates to:
  /// **'Devise du compte'**
  String get accountCurrency;

  /// No description provided for @accountCurrencySameAsApp.
  ///
  /// In fr, this message translates to:
  /// **'Comme l\'app ({code})'**
  String accountCurrencySameAsApp(String code);

  /// No description provided for @settingsRates.
  ///
  /// In fr, this message translates to:
  /// **'Taux de change'**
  String get settingsRates;

  /// No description provided for @settingsRatesSub.
  ///
  /// In fr, this message translates to:
  /// **'Pour tes comptes en devise étrangère'**
  String get settingsRatesSub;

  /// No description provided for @ratesIntro.
  ///
  /// In fr, this message translates to:
  /// **'Budgie ne va jamais sur internet : c\'est toi qui donnes les taux, et tu les corriges quand tu veux. Ils ne servent qu\'à convertir au moment de la saisie — tes mois passés ne bougent pas.'**
  String get ratesIntro;

  /// No description provided for @ratesOneUnitEquals.
  ///
  /// In fr, this message translates to:
  /// **'1 {code} ='**
  String ratesOneUnitEquals(String code);

  /// No description provided for @ratesNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucun taux. Ajoute-en un quand tu crées un compte en devise étrangère.'**
  String get ratesNone;

  /// No description provided for @ratesAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un taux'**
  String get ratesAdd;

  /// No description provided for @ratesMissing.
  ///
  /// In fr, this message translates to:
  /// **'Aucun taux pour {code} — le montant sera pris tel quel.'**
  String ratesMissing(String code);

  /// No description provided for @ratesConverted.
  ///
  /// In fr, this message translates to:
  /// **'≈ {amount} une fois converti'**
  String ratesConverted(String amount);

  /// No description provided for @statsRangeMonths.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 mois} other{{count} mois}}'**
  String statsRangeMonths(int count);

  /// No description provided for @statsTrend.
  ///
  /// In fr, this message translates to:
  /// **'Évolution'**
  String get statsTrend;

  /// No description provided for @statsByCategory.
  ///
  /// In fr, this message translates to:
  /// **'Par catégorie'**
  String get statsByCategory;

  /// No description provided for @statsRepeatOffenders.
  ///
  /// In fr, this message translates to:
  /// **'Ce qui revient le plus'**
  String get statsRepeatOffenders;

  /// No description provided for @statsAveragePerMonth.
  ///
  /// In fr, this message translates to:
  /// **'{amount} par mois en moyenne'**
  String statsAveragePerMonth(String amount);

  /// No description provided for @statsDeltaPercent.
  ///
  /// In fr, this message translates to:
  /// **'{percent} %'**
  String statsDeltaPercent(int percent);

  /// No description provided for @statsShareOfTotal.
  ///
  /// In fr, this message translates to:
  /// **'{percent} pour cent du total'**
  String statsShareOfTotal(int percent);

  /// No description provided for @statsTimes.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 fois} other{{count} fois}}'**
  String statsTimes(int count);
}

class _LDelegate extends LocalizationsDelegate<L> {
  const _LDelegate();

  @override
  Future<L> load(Locale locale) {
    return SynchronousFuture<L>(lookupL(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_LDelegate old) => false;
}

L lookupL(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return LEn();
    case 'fr':
      return LFr();
  }

  throw FlutterError(
    'L.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
