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
      'Tap here as soon as you spend something. What you have left updates on its own.';

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

  @override
  String get frequencyMonthly => 'Monthly';

  @override
  String get frequencyBimonthly => 'Every 2 months';

  @override
  String get frequencyQuarterly => 'Quarterly';

  @override
  String get frequencyBiannual => 'Twice a year';

  @override
  String get frequencyAnnual => 'Yearly';

  @override
  String get accountChecking => 'Current account';

  @override
  String get accountSavings => 'Savings';

  @override
  String get accountCash => 'Cash';

  @override
  String get natureFixedCharge => 'Fixed bill';

  @override
  String get natureSubscription => 'Subscription';

  @override
  String get natureSalary => 'Salary';

  @override
  String get natureLoanPayment => 'Loan payment';

  @override
  String get statusPending => 'To pay';

  @override
  String get statusPaid => 'Paid';

  @override
  String get statusLate => 'Overdue';

  @override
  String get debtCredit => 'Loan';

  @override
  String get debtOwed => 'I owe';

  @override
  String get debtLent => 'Owed to me';

  @override
  String get debtInstallment => 'Instalment plan';

  @override
  String spokenPercent(int percent) {
    return '$percent percent';
  }

  @override
  String get notifChannelName => 'Bill reminders';

  @override
  String get notifChannelDescription => 'Reminders before a bill is due';

  @override
  String notifDueTodayTitle(String name) {
    return 'Due today: $name';
  }

  @override
  String notifDueTodayBody(String amount) {
    return '$amount to pay.';
  }

  @override
  String notifDueSoonTitle(String name) {
    return 'In 3 days: $name';
  }

  @override
  String notifDueSoonBody(String amount, int day) {
    return '$amount due on the $day.';
  }

  @override
  String get notifDailyTitle => 'Remember to log your spending 💸';

  @override
  String get notifDailyBody => '2 minutes to stay on top of your budget.';

  @override
  String get shortcutAddExpense => 'Add an expense';

  @override
  String widgetRemainingLabel(String period) {
    return 'Left to spend · $period';
  }

  @override
  String widgetBillDue(String date) {
    return 'due $date';
  }

  @override
  String get widgetNothingDue => 'Nothing to pay 🎉';

  @override
  String get unlockReason => 'Unlock your budget';

  @override
  String get lockedTitle => 'Budget locked';

  @override
  String get unlock => 'Unlock';

  @override
  String get backupUnreadableFile => 'Unreadable file.';

  @override
  String get backupWrongPassword => 'Wrong password, or the file is corrupted.';

  @override
  String get backupShareSubject => 'Budget backup';

  @override
  String get uncategorized => 'Uncategorised';

  @override
  String get catHousing => 'Housing';

  @override
  String get catFood => 'Food';

  @override
  String get catGroceries => 'Groceries';

  @override
  String get catRestaurant => 'Eating out';

  @override
  String get catBakery => 'Bakery';

  @override
  String get catTransport => 'Transport';

  @override
  String get catFuel => 'Fuel';

  @override
  String get catPublicTransport => 'Public transport';

  @override
  String get catVehicleUpkeep => 'Vehicle upkeep';

  @override
  String get catBills => 'Bills & subscriptions';

  @override
  String get catElectricity => 'Electricity';

  @override
  String get catWater => 'Water';

  @override
  String get catInternet => 'Internet';

  @override
  String get catPhone => 'Phone';

  @override
  String get catInsurance => 'Insurance';

  @override
  String get catSubscriptions => 'Subscriptions';

  @override
  String get catHealth => 'Health';

  @override
  String get catLeisure => 'Leisure';

  @override
  String get catShopping => 'Shopping';

  @override
  String get catSport => 'Sport';

  @override
  String get catEducation => 'Education';

  @override
  String get catTravel => 'Travel';

  @override
  String get catGifts => 'Gifts';

  @override
  String get catPets => 'Pets';

  @override
  String get catTaxes => 'Taxes';

  @override
  String get catSavings => 'Savings';

  @override
  String get catDebts => 'Loans & debts';

  @override
  String get catSalary => 'Salary';

  @override
  String get catBonus => 'Bonus';

  @override
  String get catBenefits => 'Benefits';

  @override
  String get catFreelance => 'Freelance';

  @override
  String get catRefund => 'Refund';

  @override
  String get catOtherIncome => 'Other income';

  @override
  String errorWith(String message) {
    return 'Error: $message';
  }

  @override
  String get balance => 'balance';

  @override
  String deleteNamedQuestion(String name) {
    return 'Delete “$name”?';
  }

  @override
  String get deleteAccountWarning =>
      'The transactions on this account will be deleted too. This cannot be undone.';

  @override
  String get cannotDeleteLastAccount => 'You cannot delete your last account.';

  @override
  String get editAccount => 'Edit account';

  @override
  String get newAccount => 'New account';

  @override
  String get createAccount => 'Create account';

  @override
  String get fieldName => 'Name';

  @override
  String get accountNameHint => 'Current account, savings…';

  @override
  String get initialBalance => 'Starting balance';

  @override
  String get initialBalanceHelp => 'What the account holds the day you start';

  @override
  String get fieldType => 'Type';

  @override
  String get fieldIcon => 'Icon';

  @override
  String get fieldColour => 'Colour';

  @override
  String get actionCreate => 'Create';

  @override
  String get amount => 'Amount';

  @override
  String get amountOptional => 'Amount (optional)';

  @override
  String favoriteAdded(String name) {
    return '“$name” added';
  }

  @override
  String get newFavoriteTitle => 'New typical expense';

  @override
  String get favoriteNameHint => 'Coffee, lunch…';

  @override
  String get favoriteAmountHelp => 'Leave empty to be asked each time';

  @override
  String get savingsGoals => 'Savings goals';

  @override
  String get goal => 'Goal';

  @override
  String goalByDate(String date) {
    return 'by $date';
  }

  @override
  String get archive => 'Archive';

  @override
  String goalProgressOf(String name) {
    return 'Progress towards $name';
  }

  @override
  String get goalReached => 'Reached 🎉';

  @override
  String goalRemaining(String amount) {
    return '$amount to go';
  }

  @override
  String goalMonthlySetAside(String amount) {
    return '$amount set aside monthly';
  }

  @override
  String addToGoal(String name) {
    return 'Add to “$name”';
  }

  @override
  String get noGoalsTitle => 'No goals yet';

  @override
  String get noGoalsBody =>
      'Set yourself a target (a holiday, a safety net…) and put money aside each month.';

  @override
  String get debtSettled => 'Settled';

  @override
  String debtRepaymentOf(String name) {
    return 'Repayment of $name';
  }

  @override
  String get debtLeftToCollect => 'Left to collect';

  @override
  String get debtOutstanding => 'Outstanding balance';

  @override
  String debtInstalmentCount(int paid, int total) {
    return '$paid / $total instalments';
  }

  @override
  String perMonth(String amount) {
    return '$amount/month';
  }

  @override
  String get debtRepaid => 'Repaid';

  @override
  String get debtPayInstalment => 'Pay an instalment';

  @override
  String debtPaymentTitle(String name) {
    return 'Payment · $name';
  }

  @override
  String get noDebtsTitle => 'No debts';

  @override
  String get noDebtsBody =>
      'Track your loans, instalment plans, and money people owe you.';

  @override
  String get newDebtTitle => 'New debt or loan';

  @override
  String get debtNameHintLent => 'Lent to a friend…';

  @override
  String get debtNameHintOwed => 'Car loan, sofa in 4 payments…';

  @override
  String get debtAmountLent => 'Amount lent';

  @override
  String get debtAmountOwed => 'Total amount owed';

  @override
  String get debtMonthlyPayment => 'Monthly payment';

  @override
  String get debtInstalmentsCount => 'No. of instalments';

  @override
  String get recurringIncomes => 'Recurring income';

  @override
  String get recurringCharges => 'Fixed bills & subscriptions';

  @override
  String get recurrenceVariable => 'variable';

  @override
  String get recurrenceDisabled => 'disabled';

  @override
  String get historyAndAverage => 'History & average';

  @override
  String get disable => 'Turn off';

  @override
  String get enable => 'Turn on';

  @override
  String get deleteRecurrenceWarning =>
      'This will stop generating new bills. The ones already created this month stay.';

  @override
  String get savedChanges => 'Saved';

  @override
  String get recurringIncomeAdded => 'Recurring income added';

  @override
  String get chargeAdded => 'Bill added';

  @override
  String get recurringIncome => 'Recurring income';

  @override
  String get newFixedCharge => 'New fixed bill';

  @override
  String get incomeNameHint => 'Salary, benefits, pension…';

  @override
  String get chargeNameHint => 'Rent, electricity, internet…';

  @override
  String get netAmount => 'Net amount';

  @override
  String get estimatedAmount => 'Estimated amount';

  @override
  String get variableAmount => 'Variable amount';

  @override
  String get variableAmountHelp =>
      'Like electricity or water: you correct the real amount when the bill arrives.';

  @override
  String get frequency => 'Frequency';

  @override
  String get payDayLabel => 'Payday';

  @override
  String get dueDayLabel => 'Due day';

  @override
  String dueDayOn(String label, int day) {
    return '$label: the $day';
  }

  @override
  String get saveIncome => 'Save income';

  @override
  String get saveCharge => 'Save bill';

  @override
  String get fixedCharge => 'Fixed bill';

  @override
  String get leftToPayThisMonth => 'Left to pay this month';

  @override
  String paidOn(String date) {
    return 'paid $date';
  }

  @override
  String payNamed(String name) {
    return 'Pay “$name”';
  }

  @override
  String get actualAmount => 'Actual amount';

  @override
  String get recurringChargesShort => 'Recurring bills';

  @override
  String get envelopes => 'Envelopes';

  @override
  String get envelope => 'Envelope';

  @override
  String get envelopesIntro =>
      'Set a monthly cap per category (groceries: 300, say) to track your spending and get a nudge before you overshoot.';

  @override
  String envelopeOf(String name) {
    return '$name envelope';
  }

  @override
  String envelopeOverBy(String amount) {
    return '$amount over';
  }

  @override
  String envelopeLeft(String amount) {
    return '$amount left';
  }

  @override
  String deleteEnvelopeQuestion(String name) {
    return 'Delete the “$name” envelope?';
  }

  @override
  String get noChargesTitle => 'No fixed bills';

  @override
  String get noChargesBody =>
      'Add your rent, electricity, water, internet… They will show up every month on their own.';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get accountsSub => 'Current, savings, cash';

  @override
  String get recurringSub => 'Rent, subscriptions, salary…';

  @override
  String get categoriesSub => 'Create, rename, colour and icon';

  @override
  String get debtsSub => 'Loans, instalment plans';

  @override
  String get dueRemindersSub =>
      'A reminder 3 days before and on the day of each bill';

  @override
  String get notificationsDenied =>
      'Allow notifications in your Android settings.';

  @override
  String get dailyReminderSub =>
      'Every evening at 8 pm: “remember to log your spending”';

  @override
  String get biometricLockSub =>
      'Fingerprint or device PIN when you open the app';

  @override
  String get backupNeverSub => 'Password-encrypted file · never backed up';

  @override
  String backupLastSub(String when) {
    return 'Encrypted file · last backup $when';
  }

  @override
  String get restoreSub => 'Replaces your current data';

  @override
  String get startOverSub => 'Erase everything and start setup again';

  @override
  String get agoToday => 'today';

  @override
  String get agoYesterday => 'yesterday';

  @override
  String agoDays(int days) {
    return '$days days ago';
  }

  @override
  String get resetAllTitle => 'Erase everything?';

  @override
  String get resetAllBody =>
      'All your data will be deleted and you will go through setup again. This cannot be undone.';

  @override
  String get backupPasswordTitle => 'Backup password';

  @override
  String backupFailed(String message) {
    return 'Backup failed: $message';
  }

  @override
  String get restorePasswordTitle => 'File password';

  @override
  String get restoreTitle => 'Restore?';

  @override
  String get restoreBody => 'All your current data will be replaced.';

  @override
  String get restoreDone => 'Restored. Restart the app.';

  @override
  String get password => 'Password';

  @override
  String get pickCurrency => 'Pick your currency';

  @override
  String get periodStartsOn => 'The budget month starts on';

  @override
  String get periodStartFirst => 'the 1st of each month';

  @override
  String periodStartNth(int day) {
    return 'the $day of each month (handy if you are paid late in the month)';
  }

  @override
  String dayOrdinal(int day) {
    return 'the $day';
  }

  @override
  String get actionRemove => 'Remove';

  @override
  String get none => 'None';

  @override
  String get chargeRent => 'Rent';

  @override
  String get debitDayHelp => 'Payment day';

  @override
  String debitedOn(int day) {
    return 'Taken on the $day';
  }

  @override
  String debitedOnEveryMonth(int day) {
    return 'Taken on the $day of each month';
  }

  @override
  String get monthlyAmount => 'Monthly amount';

  @override
  String get monthlyCap => 'Monthly cap';

  @override
  String get previousDay => 'Previous day';

  @override
  String get nextDay => 'Next day';

  @override
  String get periodStartFirstShort => 'the 1st';

  @override
  String get periodStartFirstShortCap => 'The 1st';

  @override
  String dayOrdinalCap(int day) {
    return 'The $day';
  }

  @override
  String get onboardStartDayTitle => 'When does your month start?';

  @override
  String get onboardStartDayBody =>
      'Pick the day your budget starts. The 1st by default, or your payday if you are paid late in the month.';

  @override
  String get onboardSalaryTitle => 'What is your monthly income?';

  @override
  String get onboardSalaryBody =>
      'Your usual take-home pay. It gets filled in every month and you can adjust it any time. Leaving it empty is fine too.';

  @override
  String get onboardChargesTitle => 'Your fixed bills';

  @override
  String get onboardChargesBody =>
      'Tick the ones you have, then set the amount and the day it is taken. They will come back every month on their own.';

  @override
  String get onboardSubsTitle => 'Your subscriptions';

  @override
  String get onboardSubsBody =>
      'Tap the ones you pay for. We will ask for the payment date and the amount.';

  @override
  String onboardSubsCount(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count subscriptions · $total a month',
      one: '1 subscription · $total a month',
    );
    return '$_temp0';
  }

  @override
  String get onboardEnvelopesTitle => 'Your budgets for the month';

  @override
  String get onboardEnvelopesBody =>
      'Set a cap on whatever tends to run away from you. All optional — you can add more later.';

  @override
  String get onboardAnotherBudget => 'Another budget?';

  @override
  String get onboardOptionsTitle => 'Almost done!';

  @override
  String get onboardOptionsBody =>
      'Two options to help you day to day. You can change them later in settings.';

  @override
  String get onboardRemindersSub => '3 days before and on the day of each bill';

  @override
  String get onboardBiometricSub => 'Fingerprint or PIN when you open the app';

  @override
  String get ringCharges => 'Bills';

  @override
  String get ringOther => 'Other';

  @override
  String get ringFree => 'Free';

  @override
  String get onboardRecapTitle => 'Here is your month';

  @override
  String onboardRecapWithSalary(String income) {
    return 'Out of $income of income, here is how your budget breaks down.';
  }

  @override
  String get onboardRecapNoSalary =>
      'Here is how your budget breaks down. Add your income whenever you like to see what is left.';

  @override
  String onboardRecapSemantics(String breakdown) {
    return 'Your budget breakdown: $breakdown.';
  }

  @override
  String get onboardYouWillHaveLeft => 'You will have left';

  @override
  String get onboardCommitted => 'Committed';

  @override
  String onboardOverBudget(String amount) {
    return 'Your bills and budgets are $amount over your income. Not a problem — adjust them any time from the Budgets tab.';
  }

  @override
  String get ringOthers => 'Other';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get noTransactionsThatMonth => 'No transactions that month.';

  @override
  String get carriedToNextMonth => 'carried over to next month';

  @override
  String get carryInLabel => 'Carried over from last month';

  @override
  String get carryCorrected => 'corrected';

  @override
  String get incomeReceived => 'Income received';

  @override
  String get incomePlanned => 'Income expected';

  @override
  String get expenses => 'Spending';

  @override
  String unpaidCharges(int count) {
    return 'Unpaid bills ($count)';
  }

  @override
  String get fixCarry => 'Correct the carry-over';

  @override
  String get fixCarryBody =>
      'Overrides this month\'s incoming carry-over. Later months are recalculated to match.';

  @override
  String get carryShort => 'Carry-over';

  @override
  String get restoreAuto => 'Back to automatic';

  @override
  String get actionApply => 'Apply';

  @override
  String get deleteTransactionQuestion => 'Delete this transaction?';

  @override
  String get deleteTransactionBody =>
      'This month\'s balance and the carry-over of later months will be recalculated.';

  @override
  String get noDataTitle => 'No data';

  @override
  String get noDataBody => 'Past months will show up here as time goes by.';

  @override
  String get statsTitle => 'Statistics';

  @override
  String get noSpendingThisMonth => 'No spending this month.';

  @override
  String donutSemantics(String total) {
    return 'Spending broken down by category. Total $total.';
  }

  @override
  String get noDataYet => 'No data yet.';

  @override
  String barsMonthSummary(String month, String income, String expense) {
    return '$month: income $income, spending $expense';
  }

  @override
  String barsSummary(int count, String months) {
    return 'Income and spending over $count months. $months.';
  }

  @override
  String get deficit => 'Shortfall';

  @override
  String get saved => 'Saved';

  @override
  String get currentEstimate => 'Current estimate';

  @override
  String get actualAverage => 'Actual average';

  @override
  String get noPaidBillYet =>
      'No bill paid for this one yet. The history will build up here month by month.';

  @override
  String get estimateDriftTitle => 'Your estimate is drifting';

  @override
  String estimateDriftBelow(String average, String gap) {
    return 'The real average is $average, $gap below your estimate.';
  }

  @override
  String estimateDriftAbove(String average, String gap) {
    return 'The real average is $average, $gap above your estimate.';
  }

  @override
  String retuneEstimate(String amount) {
    return 'Retune the estimate to $amount';
  }

  @override
  String get searchHint => 'Search…';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get filterAll => 'All';

  @override
  String get moveLabel => 'Money moved';

  @override
  String get betweenAccounts => 'between accounts';

  @override
  String get plannedTapToReceive => 'expected — tap to mark received';

  @override
  String get noResults => 'No results';

  @override
  String get noTransactionsThisMonth => 'No transactions this month';

  @override
  String get noTransactionsBody =>
      'Tap + to add your first expense or your salary.';

  @override
  String get systemCategory => 'system category';

  @override
  String get deleteCategoryWarning =>
      'Transactions in this category become “Uncategorised”. Its sub-categories are deleted too.';

  @override
  String get editCategory => 'Edit category';

  @override
  String get newCategory => 'New category';

  @override
  String get createCategory => 'Create category';

  @override
  String get newGoal => 'New goal';

  @override
  String get goalNameHint => 'Holiday, safety net…';

  @override
  String get goalTarget => 'Target amount';

  @override
  String get goalMonthly => 'Set aside monthly (optional)';

  @override
  String get goalMonthlyHelp =>
      'Taken off what is left to spend, so the saving actually happens';

  @override
  String get createGoal => 'Create goal';

  @override
  String get envelopeRollover => 'Roll over what is unspent';

  @override
  String get envelopeRolloverSub =>
      'Whatever you do not spend is added to next month\'s cap.';

  @override
  String get backupNudgeTitle => 'Time for a backup';

  @override
  String get backupNudgeNever =>
      'Your data lives on this phone only. An encrypted backup keeps it safe.';

  @override
  String backupNudgeDays(int days) {
    return 'Your last backup was $days days ago.';
  }

  @override
  String get actionLater => 'Later';

  @override
  String get closingBalance => 'End-of-month balance';

  @override
  String get goalTargetDate => 'Target date (optional)';

  @override
  String get clearDate => 'Clear date';

  @override
  String get total => 'Total';

  @override
  String get actionOk => 'OK';

  @override
  String get actionUndo => 'Undo';

  @override
  String get transactionDeleted => 'Transaction deleted';

  @override
  String get duplicateToday => 'Duplicate to today';

  @override
  String get duplicated => 'Duplicated';

  @override
  String get projectedEndTitle => 'At this rate';

  @override
  String projectedEndBody(String amount) {
    return 'you finish the month at $amount';
  }

  @override
  String vsLastMonthLess(int percent) {
    return '$percent% less than last month';
  }

  @override
  String vsLastMonthMore(int percent) {
    return '$percent% more than last month';
  }

  @override
  String get vsLastMonthSame => 'Same pace as last month';

  @override
  String get noRecurrencesTitle => 'Nothing recurring yet';

  @override
  String get noRecurrencesBody =>
      'Add what comes back every month: rent, subscriptions, salary. Then stop thinking about it.';

  @override
  String get exportMonth => 'Export this month (CSV)';

  @override
  String exportSubject(String period) {
    return 'Budgie — $period';
  }

  @override
  String get exportEmpty => 'Nothing to export for this month.';

  @override
  String get csvDate => 'Date';

  @override
  String get csvType => 'Type';

  @override
  String get csvCategory => 'Category';

  @override
  String get csvAccount => 'Account';

  @override
  String get csvNote => 'Note';

  @override
  String get csvAmount => 'Amount';

  @override
  String suggestRecurrenceTitle(String name) {
    return '“$name” comes back every month';
  }

  @override
  String suggestRecurrenceBody(int count, String amount, int day) {
    return 'Paid $count months running, about $amount around the $day. Make it a subscription and it will show up on its own.';
  }

  @override
  String get suggestMakeItRecurring => 'Make it recurring';

  @override
  String suggestEnvelopeTitle(String name) {
    return 'Cap “$name”?';
  }

  @override
  String suggestEnvelopeBody(int count, String amount, String limit) {
    return 'You spend $amount a month there on average over $count months. A cap at $limit would warn you before you overshoot.';
  }

  @override
  String get suggestSetTheCap => 'Set the cap';

  @override
  String get suggestNoThanks => 'No thanks';

  @override
  String get recapTitle => 'Your month';

  @override
  String get recapSaved => 'Saved';

  @override
  String get recapOverspent => 'Overspent by';

  @override
  String recapSemantics(String income, String expenses) {
    return 'Income $income, spending $expenses.';
  }

  @override
  String recapAdviceSaved(String amount) {
    return '$amount more than you spent. That is a head start on next month.';
  }

  @override
  String get recapAdviceOver =>
      'You spent more than you took in this month. The balance carries over to next month.';

  @override
  String get recapWhereItWent => 'Where it went';

  @override
  String recapShare(String amount, int percent) {
    return '$amount · $percent%';
  }

  @override
  String get recapSeeMonth => 'See the month\'s recap';

  @override
  String get notifRecapTitle => 'Your month is done 📊';

  @override
  String get notifRecapBody => 'Open Budgie to see where your money went.';

  @override
  String get accountCurrency => 'Account currency';

  @override
  String accountCurrencySameAsApp(String code) {
    return 'Same as the app ($code)';
  }

  @override
  String get settingsRates => 'Exchange rates';

  @override
  String get settingsRatesSub => 'For your foreign-currency accounts';

  @override
  String get ratesIntro =>
      'Budgie never goes online, so the rates are yours to enter and to correct. They only convert at the moment you type an amount — your past months never move.';

  @override
  String ratesOneUnitEquals(String code) {
    return '1 $code =';
  }

  @override
  String get ratesNone =>
      'No rates yet. Add one when you create a foreign-currency account.';

  @override
  String get ratesAdd => 'Add a rate';

  @override
  String ratesMissing(String code) {
    return 'No rate for $code — the amount will be taken as typed.';
  }

  @override
  String ratesConverted(String amount) {
    return '≈ $amount once converted';
  }

  @override
  String statsRangeMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months',
      one: '1 month',
    );
    return '$_temp0';
  }

  @override
  String get statsTrend => 'Trend';

  @override
  String get statsByCategory => 'By category';

  @override
  String get statsRepeatOffenders => 'What comes back most';

  @override
  String statsAveragePerMonth(String amount) {
    return '$amount a month on average';
  }

  @override
  String statsDeltaPercent(int percent) {
    return '$percent%';
  }

  @override
  String statsShareOfTotal(int percent) {
    return '$percent percent of the total';
  }

  @override
  String statsTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count times',
      one: 'once',
    );
    return '$_temp0';
  }
}
