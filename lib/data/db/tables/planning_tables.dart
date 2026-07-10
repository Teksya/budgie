import 'package:budget/data/db/enums.dart';
import 'package:budget/data/db/tables/core_tables.dart';
import 'package:budget/data/db/tables/ledger_tables.dart';
import 'package:drift/drift.dart';

/// The *template*: "loyer, 750 €, tous les mois, le 5".
/// Also covers subscriptions, the recurring salary, and loan instalments.
@DataClassName('Recurrence')
class Recurrences extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get type => textEnum<TxnType>()();
  TextColumn get nature => textEnum<RecurrenceNature>()();

  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id, onDelete: KeyAction.setNull)();
  IntColumn get accountId =>
      integer().references(Accounts, #id, onDelete: KeyAction.cascade)();

  IntColumn get estimatedAmountCents => integer()();

  /// Electricity and water swing month to month: the estimate is a placeholder
  /// until the real bill arrives.
  BoolColumn get isVariable => boolean().withDefault(const Constant(false))();

  TextColumn get frequency => textEnum<Frequency>()();
  IntColumn get dueDayOfMonth => integer()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();

  IntColumn get debtId =>
      integer().nullable().references(Debts, #id, onDelete: KeyAction.cascade)();
}

/// A concrete occurrence of a [Recurrences] row inside one period — or a
/// one-off charge when [recurrenceId] is null.
@DataClassName('RecurrenceInstance')
class RecurrenceInstances extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recurrenceId =>
      integer().nullable().references(Recurrences, #id, onDelete: KeyAction.cascade)();
  IntColumn get periodId =>
      integer().references(Periods, #id, onDelete: KeyAction.cascade)();

  /// Copied from the recurrence so renaming it later does not rewrite history.
  TextColumn get label => text()();

  DateTimeColumn get dueDate => dateTime()();
  IntColumn get estimatedAmountCents => integer()();

  /// Null until the real bill is known. The budget engine prefers this.
  IntColumn get actualAmountCents => integer().nullable()();

  TextColumn get status => textEnum<InstanceStatus>()();
  DateTimeColumn get paidDate => dateTime().nullable()();

  IntColumn get transactionId =>
      integer().nullable().references(Transactions, #id, onDelete: KeyAction.setNull)();

  /// Makes `materialize()` idempotent: re-running it can never duplicate a due
  /// date. SQLite treats NULLs as distinct, so ad-hoc charges are unaffected.
  @override
  List<Set<Column>> get uniqueKeys => [
    {recurrenceId, dueDate},
  ];
}

/// A spending envelope: "Courses, 300 € ce mois-ci".
@DataClassName('Budget')
class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get periodId =>
      integer().references(Periods, #id, onDelete: KeyAction.cascade)();
  IntColumn get categoryId =>
      integer().references(Categories, #id, onDelete: KeyAction.cascade)();
  IntColumn get limitCents => integer()();

  /// Unspent money rolls into next month's envelope.
  BoolColumn get rollover => boolean().withDefault(const Constant(false))();
  IntColumn get rolloverInCents => integer().withDefault(const Constant(0))();

  @override
  List<Set<Column>> get uniqueKeys => [
    {periodId, categoryId},
  ];
}

@DataClassName('SavingsGoal')
class SavingsGoals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  IntColumn get targetCents => integer()();
  DateTimeColumn get targetDate => dateTime().nullable()();
  IntColumn get accountId =>
      integer().nullable().references(Accounts, #id, onDelete: KeyAction.setNull)();

  /// Deducted from the "reste à vivre" as planned savings.
  IntColumn get monthlyPlannedCents => integer().withDefault(const Constant(0))();
  TextColumn get iconKey => text().withDefault(const Constant('target'))();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
}

@DataClassName('GoalContribution')
class GoalContributions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get goalId =>
      integer().references(SavingsGoals, #id, onDelete: KeyAction.cascade)();
  IntColumn get periodId =>
      integer().references(Periods, #id, onDelete: KeyAction.cascade)();
  IntColumn get amountCents => integer()();
  DateTimeColumn get date => dateTime()();
}

@DataClassName('Debt')
class Debts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get kind => textEnum<DebtKind>()();
  IntColumn get principalCents => integer()();
  IntColumn get remainingCents => integer()();
  IntColumn get installmentCents => integer().withDefault(const Constant(0))();
  IntColumn get installmentsTotal => integer().nullable()();
  IntColumn get installmentsPaid => integer().withDefault(const Constant(0))();

  /// Annual rate in basis points (3.75 % → 375). Integer, like every other
  /// number that must not drift.
  IntColumn get annualRateBps => integer().withDefault(const Constant(0))();

  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  BoolColumn get settled => boolean().withDefault(const Constant(false))();
}

/// A one-tap "typical expense": pick it and the transaction is pre-built (or
/// created instantly when it carries a fixed amount).
@DataClassName('Favorite')
class Favorites extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label => text().withLength(min: 1, max: 40)();
  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id, onDelete: KeyAction.setNull)();
  IntColumn get accountId =>
      integer().nullable().references(Accounts, #id, onDelete: KeyAction.setNull)();

  /// Null means "ask the amount when tapped".
  IntColumn get amountCents => integer().nullable()();
  TextColumn get iconKey => text().withDefault(const Constant('tag'))();
  IntColumn get colorValue => integer().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

@DataClassName('DebtPayment')
class DebtPayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get debtId =>
      integer().references(Debts, #id, onDelete: KeyAction.cascade)();
  IntColumn get transactionId =>
      integer().nullable().references(Transactions, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get date => dateTime()();
  IntColumn get amountCents => integer()();
  IntColumn get principalCents => integer()();
  IntColumn get interestCents => integer().withDefault(const Constant(0))();
}
