import 'package:budget/data/db/enums.dart';
import 'package:drift/drift.dart';

@DataClassName('Account')
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 60)();
  TextColumn get type => textEnum<AccountType>()();
  IntColumn get initialBalanceCents => integer().withDefault(const Constant(0))();
  TextColumn get iconKey => text().withDefault(const Constant('wallet'))();
  IntColumn get colorValue => integer().nullable()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 60)();
  TextColumn get kind => textEnum<CategoryKind>()();

  /// One level of nesting only: a child never has children of its own.
  IntColumn get parentId =>
      integer().nullable().references(Categories, #id, onDelete: KeyAction.cascade)();

  TextColumn get iconKey => text().withDefault(const Constant('tag'))();
  IntColumn get colorValue => integer()();

  /// System categories cannot be deleted (e.g. "Non catégorisé"), only renamed.
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
}

/// Key/value store for user preferences. Kept in the database rather than in
/// shared_preferences so a backup restores settings along with the data.
@DataClassName('SettingEntry')
class SettingsEntries extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
