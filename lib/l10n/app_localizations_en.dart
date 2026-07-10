// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class LEn extends L {
  LEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Budgie';

  @override
  String get navHome => 'Home';

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navBudgets => 'Budgets';

  @override
  String get navStats => 'Stats';

  @override
  String get actionAdd => 'Add';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionBack => 'Back';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get history => 'History';

  @override
  String get remainingToSpend => 'Left to spend';

  @override
  String perDay(String amount) {
    return '$amount / day';
  }

  @override
  String daysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days left',
      one: '1 day left',
    );
    return '$_temp0';
  }

  @override
  String get healthComfortable => 'Comfortable';

  @override
  String get healthTight => 'Tight';

  @override
  String get healthOver => 'Over budget';

  @override
  String get upcomingCharges => 'Upcoming bills';

  @override
  String get recentTransactions => 'Recent transactions';

  @override
  String get noChargesToPay => 'Nothing to pay. 🎉';

  @override
  String get firstExpenseTitle => 'Log your first expense';

  @override
  String get firstExpenseBody =>
      'Tap “Add” below whenever you spend something. Your left-to-spend updates on its own.';

  @override
  String get onboardWelcomeTitle => 'Take back control\nof your budget';

  @override
  String get onboardWelcomeSubtitle =>
      'Let\'s set everything up together — it takes 2 minutes.';

  @override
  String get onboardHl1Title => 'Your left-to-spend at a glance';

  @override
  String get onboardHl1Body =>
      'How much you can still spend before the month ends.';

  @override
  String get onboardHl2Title => 'Your bills handled automatically';

  @override
  String get onboardHl2Body =>
      'Rent, power, subscriptions: they come back every month.';

  @override
  String get onboardHl3Title => 'Alerts at the right time';

  @override
  String get onboardHl3Body => 'Before a due date or a budget overrun.';

  @override
  String get onboardHl4Title => '100% private, offline';

  @override
  String get onboardHl4Body => 'Your data stays on your phone, period.';

  @override
  String get onboardStart => 'Get started';

  @override
  String get onboardDone => 'Let\'s go!';

  @override
  String get settingsCurrency => 'Currency';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystem => 'System language';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageEnglish => 'English';

  @override
  String get newExpense => 'New expense';

  @override
  String get newIncome => 'New income';

  @override
  String get moveMoney => 'Move money';

  @override
  String get edit => 'Edit';

  @override
  String get expense => 'Expense';

  @override
  String get income => 'Income';

  @override
  String get transferShort => 'Move';

  @override
  String get scanReceipt => 'Scan a receipt';

  @override
  String get readingReceipt => 'Reading receipt…';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get fromGallery => 'From gallery';

  @override
  String get category => 'Category';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get sharedExpense => 'Shared expense';

  @override
  String get sharedHint =>
      'The amount above is your share; enter the total below.';

  @override
  String get sharedTotal => 'Total amount (shared)';

  @override
  String get receiptPhoto => 'Receipt photo';

  @override
  String get receiptAttached => 'Receipt attached';

  @override
  String get alreadyReceived => 'Already received';

  @override
  String get addedToBalance => 'Added to balance';

  @override
  String get plannedNotReceived => 'Planned, not received yet';

  @override
  String get transferInfo =>
      'Move money from one of your accounts to another. It adds neither an expense nor income: your left-to-spend doesn\'t change.';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get needSecondAccount =>
      'Create a second account to move money between them.';

  @override
  String get date => 'Date';

  @override
  String get account => 'Account';

  @override
  String get whichAmount => 'What\'s the amount?';

  @override
  String get tapReceiptTotal => 'Tap the receipt total.';

  @override
  String get enterManually => 'Enter manually';

  @override
  String get amountNotFound => 'Amount not found';

  @override
  String get receiptReadNoTotal =>
      'The receipt was read but I couldn\'t spot a total. Enter the amount manually — the photo stays attached.';

  @override
  String get cannotReadReceipt =>
      'Couldn\'t read the receipt. Try again closer, flat and well lit.';

  @override
  String get textRead => 'Text read:';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get dynamicColors => 'Dynamic colours';

  @override
  String get dynamicColorsSub => 'Adapts to your wallpaper (Material You)';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsPeriod => 'Budget period';

  @override
  String get settingsOrganisation => 'Organisation';

  @override
  String get settingsSecurity => 'Security';

  @override
  String get settingsData => 'Data';

  @override
  String get accounts => 'Accounts';

  @override
  String get categories => 'Categories';

  @override
  String get recurringLabel => 'Recurring bills & income';

  @override
  String get debtsCredits => 'Debts & credit';

  @override
  String get biometricLock => 'Biometric lock';

  @override
  String get dueReminders => 'Due-date reminders';

  @override
  String get dailyReminder => 'Daily logging reminder';

  @override
  String get backup => 'Back up';

  @override
  String get restore => 'Restore';

  @override
  String get startOver => 'Start over';

  @override
  String get quickExpenses => 'Quick expenses';

  @override
  String get newFavorite => 'New';
}
