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
  /// **'Appuie sur « Ajouter » en bas dès que tu dépenses quelque chose. Ton reste à vivre se met à jour tout seul.'**
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
