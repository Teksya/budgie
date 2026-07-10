import 'package:budget/core/date_x.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/data/db/setting_keys.dart';
import 'package:budget/data/db/tables/core_tables.dart';
import 'package:budget/data/db/tables/ledger_tables.dart';
import 'package:budget/data/db/tables/planning_tables.dart';
import 'package:budget/data/seed/default_categories.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Accounts,
    Categories,
    SettingsEntries,
    Periods,
    Transactions,
    Recurrences,
    RecurrenceInstances,
    Budgets,
    SavingsGoals,
    GoalContributions,
    Debts,
    DebtPayments,
    Favorites,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'budget'));

  /// In-memory instance for tests. The parameter is named after the generated
  /// superclass constructor's, which both lint rules insist on.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedFirstLaunch();
    },
    onUpgrade: (m, from, to) async {
      // v2: link a transaction back to the recurrence that generated it, so a
      // recurring salary is not materialised twice in the same period.
      if (from < 2) {
        await m.addColumn(transactions, transactions.recurrenceId);
      }
      // v3: an existing user already has data, so mark them onboarded — the
      // welcome flow is only for genuinely fresh installs.
      if (from < 3) {
        await into(settingsEntries).insert(
          SettingsEntriesCompanion.insert(key: 'onboarded', value: 'true'),
          mode: InsertMode.insertOrReplace,
        );
      }
      // v4: one-tap "typical expense" favorites.
      if (from < 4) {
        await m.createTable(favorites);
      }
    },
    beforeOpen: (details) async {
      // Off by default in SQLite; without it every `references(...)` above is
      // decoration and orphan rows accumulate silently.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Wipes every row and re-seeds the default categories, the "Principal"
  /// account and the current open period — the state of a brand-new install.
  /// Leaves the user un-onboarded so the welcome flow runs again.
  Future<void> wipeAndReseed() async {
    await transaction(() async {
      await customStatement('PRAGMA foreign_keys = OFF');
      for (final table in allTables) {
        await delete(table).go();
      }
      await customStatement('PRAGMA foreign_keys = ON');
    });
    await _seedFirstLaunch();
  }

  Future<void> _seedFirstLaunch() async {
    await transaction(() async {
      await batch((b) {
        b.insertAll(
          settingsEntries,
          SettingDefaults.values.entries
              .map((e) => SettingsEntriesCompanion.insert(key: e.key, value: e.value))
              .toList(),
        );
      });

      await into(accounts).insert(
        AccountsCompanion.insert(
          name: 'Principal',
          type: AccountType.checking,
          iconKey: const Value('bank'),
        ),
      );

      var order = 0;
      for (final seed in kDefaultCategories) {
        final parentId = await into(categories).insert(
          CategoriesCompanion.insert(
            name: seed.name,
            kind: seed.kind,
            iconKey: Value(seed.iconKey),
            colorValue: seed.color,
            isSystem: Value(seed.isSystem),
            sortOrder: Value(order++),
          ),
        );
        for (final child in seed.children) {
          await into(categories).insert(
            CategoriesCompanion.insert(
              name: child.name,
              kind: child.kind,
              parentId: Value(parentId),
              iconKey: Value(child.iconKey),
              colorValue: child.color,
              sortOrder: Value(order++),
            ),
          );
        }
      }

      // Open the period we are currently in, so the app has somewhere to write
      // from the very first launch.
      final startDay =
          int.parse(SettingDefaults.values[SettingKeys.periodStartDay]!);
      final range = periodContaining(DateTime.now(), startDay: startDay);
      await into(periods).insert(
        PeriodsCompanion.insert(
          startDate: range.start,
          endDate: range.endInclusive,
          status: PeriodStatus.open,
        ),
      );

      await into(settingsEntries).insert(
        SettingsEntriesCompanion.insert(key: SettingKeys.seeded, value: 'true'),
      );
    });
  }
}
