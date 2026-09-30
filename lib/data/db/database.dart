import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:budget/core/date_x.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/data/db/setting_keys.dart';
import 'package:budget/data/db/tables/core_tables.dart';
import 'package:budget/data/db/tables/ledger_tables.dart';
import 'package:budget/data/db/tables/planning_tables.dart';
import 'package:budget/data/seed/default_categories.dart';
import 'package:budget/l10n/app_localizations.dart';
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
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedFirstLaunch();
    },
    // Drift does not wrap migrations itself, and it only writes `user_version`
    // once `onUpgrade` returns. A step failing halfway would therefore leave
    // the schema half-migrated but still labelled with the old version, and the
    // next launch would replay the whole chain: `createTable` is idempotent
    // (`IF NOT EXISTS`) but `addColumn` is not, so the app would then crash on
    // every start with no way out. One transaction makes each upgrade
    // all-or-nothing — SQLite rolls DDL back like anything else.
    onUpgrade: (m, from, to) => transaction(() async {
      // Play never serves an older build, but an Android auto-backup restored
      // onto one would. Silently accepting it rewrites `user_version` downwards
      // over a schema that is still shaped for the newer version, which corrupts
      // quietly; failing here is loud, diagnosable, and leaves the data intact.
      if (from > to) {
        throw StateError(
          'Database schema v$from is newer than this build (v$to). '
          'Install the latest version of the app.',
        );
      }
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
      // v5: start the backup clock for existing installs. Dating it from now
      // rather than from the install gives them 30 quiet days before the first
      // reminder, instead of one that fires on the next launch.
      if (from < 5) {
        await into(settingsEntries).insert(
          SettingsEntriesCompanion.insert(
            key: SettingKeys.firstLaunchAt,
            value: DateTime.now().toIso8601String(),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
      // v6: sweep up the phantom periods left by the start-day slider, which
      // used to commit on every tick of a drag — one budget period per day the
      // finger crossed. See `_purgeEmptyPeriods` for why this loses nothing.
      if (from < 6) {
        await _purgeEmptyPeriods();
      }
      // v7: accounts can be held in another currency. Null everywhere means
      // "the main one", so existing accounts need no backfill.
      if (from < 7) {
        await m.addColumn(accounts, accounts.currencyCode);
      }
    }),
    beforeOpen: (details) async {
      // Off by default in SQLite; without it every `references(...)` above is
      // decoration and orphan rows accumulate silently.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Deletes budget periods that hold nothing at all.
  ///
  /// "Nothing at all" is meant literally: no transaction, no envelope, no
  /// charge instance, no goal contribution, no manually corrected carry-over,
  /// and not the period currently open. Such a row carries only a computed
  /// carry-over, and since an empty period hands its carry-over straight
  /// through, removing it leaves every surviving period's figures untouched.
  ///
  /// Deliberately not scoped to duplicates: a genuinely empty past month is
  /// noise in the history screen too. Nothing the user typed can be lost here.
  Future<void> _purgeEmptyPeriods() async {
    Future<Set<int>> referenced<T extends HasResultSet, D>(
      ResultSetImplementation<T, D> table,
      GeneratedColumn<int> periodId,
    ) async {
      final rows = await (selectOnly(table, distinct: true)
            ..addColumns([periodId]))
          .get();
      return rows.map((r) => r.read(periodId)).nonNulls.toSet();
    }

    final keep = <int>{
      ...await referenced(transactions, transactions.periodId),
      ...await referenced(budgets, budgets.periodId),
      ...await referenced(recurrenceInstances, recurrenceInstances.periodId),
      ...await referenced(goalContributions, goalContributions.periodId),
    };

    await (delete(periods)..where(
          (p) =>
              p.id.isNotIn(keep) &
              p.status.equalsValue(PeriodStatus.closed) &
              p.carryOverManualCents.isNull(),
        ))
        .go();
  }

  /// Wipes every row and re-seeds the default categories, the "Principal"
  /// account and the current open period — the state of a brand-new install.
  /// Leaves the user un-onboarded so the welcome flow runs again.
  Future<void> wipeAndReseed() async {
    await transaction(() async {
      // No `PRAGMA foreign_keys = OFF` here: SQLite ignores that pragma inside
      // a transaction, so it never did anything. Deleting in any order is safe
      // anyway — every reference is `cascade` or `setNull`.
      for (final table in allTables) {
        await delete(table).go();
      }
    });
    await _seedFirstLaunch();
  }

  Future<void> _seedFirstLaunch() async {
    // Category names become editable user rows, so they are translated once,
    // here. The language setting cannot exist yet on a first launch — the
    // device language is by definition the right answer.
    final device = PlatformDispatcher.instance.locale;
    final locale = L.supportedLocales.any(
      (s) => s.languageCode == device.languageCode,
    )
        ? Locale(device.languageCode)
        : const Locale('en');
    final l = await L.delegate.load(locale);

    await transaction(() async {
      await batch((b) {
        b.insertAll(
          settingsEntries,
          SettingDefaults.values.entries
              .map(
                (e) =>
                    SettingsEntriesCompanion.insert(key: e.key, value: e.value),
              )
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
      for (final seed in defaultCategories(l)) {
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
      final startDay = int.parse(
        SettingDefaults.values[SettingKeys.periodStartDay]!,
      );
      final range = periodContaining(DateTime.now(), startDay: startDay);
      await into(periods).insert(
        PeriodsCompanion.insert(
          startDate: range.start,
          endDate: range.endInclusive,
          status: PeriodStatus.open,
        ),
      );

      await batch((b) {
        b.insertAll(settingsEntries, [
          SettingsEntriesCompanion.insert(
            key: SettingKeys.seeded,
            value: 'true',
          ),
          // Starts the backup clock: the first reminder lands 30 days from here.
          SettingsEntriesCompanion.insert(
            key: SettingKeys.firstLaunchAt,
            value: DateTime.now().toIso8601String(),
          ),
        ]);
      });
    });
  }
}
