import 'package:budget/data/db/enums.dart';
import 'package:budget/data/db/tables/core_tables.dart';
import 'package:drift/drift.dart';

/// A budget "month". Exactly one period is `open` at any time.
@DataClassName('Period')
class Periods extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get status => textEnum<PeriodStatus>()();

  /// Computed leftover from the previous period, positive or negative.
  IntColumn get carryOverInCents => integer().withDefault(const Constant(0))();

  /// When set, overrides [carryOverInCents] and stops the recompute cascade —
  /// this is how a mis-typed amount in an old month gets corrected without
  /// rewriting history.
  IntColumn get carryOverManualCents => integer().nullable()();

  DateTimeColumn get closedAt => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {startDate},
  ];
}

/// Every movement of money. `Txn` rather than `Transaction` to avoid colliding
/// with drift's own transaction API.
@DataClassName('Txn')
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get type => textEnum<TxnType>()();

  /// Always the amount actually borne by the user. For a shared expense this
  /// is *my share*, not the bill total.
  IntColumn get amountCents => integer()();

  /// The full bill when the expense was split; informational only.
  IntColumn get sharedTotalCents => integer().nullable()();

  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id, onDelete: KeyAction.setNull)();

  @ReferenceName('outgoingTransactions')
  IntColumn get accountId =>
      integer().references(Accounts, #id, onDelete: KeyAction.cascade)();

  /// Destination account, transfers only.
  @ReferenceName('incomingTransfers')
  IntColumn get toAccountId =>
      integer().nullable().references(Accounts, #id, onDelete: KeyAction.cascade)();

  IntColumn get periodId =>
      integer().references(Periods, #id, onDelete: KeyAction.cascade)();

  TextColumn get note => text().nullable()();
  TextColumn get receiptPath => text().nullable()();

  /// Incomes only: planned vs actually received.
  TextColumn get incomeStatus => textEnum<IncomeStatus>().nullable()();

  /// The recurrence that generated this transaction, if any. Used to avoid
  /// materialising a recurring salary twice in the same period. Added in v2.
  IntColumn get recurrenceId => integer().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
