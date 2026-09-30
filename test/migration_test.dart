import 'dart:io';

import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/data/db/setting_keys.dart';
// `isNull`/`isNotNull` exist in both drift and matcher; the test wants matcher's.
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as raw;

/// What a Play Store update actually does to a user's data.
///
/// `drift_dev schema dump` would normally generate these fixtures, but
/// drift_dev > 2.34.0 needs analyzer 13, which the pinned Flutter SDK refuses
/// (see ARCHITECTURE.md). So instead of a synthetic schema snapshot we build a
/// v1-shaped database by undoing what the migrations add, then let the real
/// `AppDatabase` migrate it — which exercises the shipped code path rather than
/// a generated copy of it.
void main() {
  late Directory dir;
  late File file;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('budgie_migration');
    file = File('${dir.path}/budget.sqlite');
  });

  // A database whose open failed keeps its file handle on Windows, so the
  // cleanup of a temp directory is best-effort.
  tearDown(() async {
    try {
      await dir.delete(recursive: true);
    } on FileSystemException {
      // The OS reclaims it.
    }
  });

  /// Creates the database at the current version, runs [seed] against it, then
  /// strips every post-v1 schema change and stamps it as v1 — the state of a
  /// phone that installed the very first release and never updated.
  Future<void> makeV1Database(Future<void> Function(AppDatabase db) seed) async {
    final db = AppDatabase.forTesting(NativeDatabase(file));
    await seed(db);
    await db.close();

    raw.sqlite3.open(file.path)
      ..execute('DROP TABLE favorites') // added in v4
      ..execute('ALTER TABLE transactions DROP COLUMN recurrence_id') // v2
      ..execute('ALTER TABLE accounts DROP COLUMN currency_code') // v7
      ..execute(
        "DELETE FROM settings_entries WHERE key IN ('onboarded', 'first_launch_at')",
      ) // v3 and v5
      ..execute('PRAGMA user_version = 1')
      ..close();
  }

  int schemaVersionOf(File f) {
    final sqlite = raw.sqlite3.open(f.path);
    try {
      return sqlite.select('PRAGMA user_version').first.values.first! as int;
    } finally {
      sqlite.close();
    }
  }

  test('v1 to v7 keeps every row the user entered', () async {
    late int accountId;
    late int periodId;
    late int categoryId;
    late int categoryCount;

    await makeV1Database((db) async {
      accountId = (await db.select(db.accounts).getSingle()).id;
      periodId = (await db.select(db.periods).getSingle()).id;
      final categories = await db.select(db.categories).get();
      categoryId = categories.first.id;
      categoryCount = categories.length;

      await db
          .into(db.transactions)
          .insert(
            TransactionsCompanion.insert(
              date: DateTime(2026, 3, 14),
              type: TxnType.expense,
              amountCents: 4250,
              accountId: accountId,
              periodId: periodId,
              categoryId: Value(categoryId),
              note: const Value('Courses avant la mise à jour'),
            ),
          );
    });

    // Read through the *migrated* database from here on.
    final db = AppDatabase.forTesting(NativeDatabase(file));
    addTearDown(db.close);

    final txn = await db.select(db.transactions).getSingle();
    expect(txn.amountCents, 4250, reason: 'the amount must survive untouched');
    expect(txn.note, 'Courses avant la mise à jour');
    expect(txn.categoryId, categoryId);
    expect(txn.accountId, accountId);
    expect(txn.periodId, periodId);
    expect(txn.recurrenceId, isNull, reason: 'v2 column, empty for old rows');

    // v4 brought the table back; it must exist and be readable, not missing.
    expect(await db.select(db.favorites).get(), isEmpty);

    final settings = {
      for (final row in await db.select(db.settingsEntries).get())
        row.key: row.value,
    };
    expect(
      settings[SettingKeys.onboarded],
      'true',
      reason: 'v3: an existing user must not be shown the welcome flow again',
    );
    expect(
      DateTime.tryParse(settings[SettingKeys.firstLaunchAt] ?? ''),
      isNotNull,
      reason: 'v5: the backup clock has to start somewhere',
    );

    // The seed must not have run a second time on top of the existing data.
    expect(await db.select(db.categories).get(), hasLength(categoryCount));
    expect(await db.select(db.accounts).get(), hasLength(1));

    expect(schemaVersionOf(file), 7);
  });

  test('a migration that fails rolls back the steps that had succeeded', () async {
    await makeV1Database((db) async {
      await db
          .into(db.transactions)
          .insert(
            TransactionsCompanion.insert(
              date: DateTime(2026, 3, 14),
              type: TxnType.expense,
              amountCents: 999,
              accountId: (await db.select(db.accounts).getSingle()).id,
              periodId: (await db.select(db.periods).getSingle()).id,
            ),
          );
    });

    // Moving `settings_entries` out of the way makes the v3 step fail — after
    // the v2 step has already added its column. That is the only interesting
    // kind of botched upgrade: one that dies halfway through.
    raw.sqlite3.open(file.path)
      ..execute('ALTER TABLE settings_entries RENAME TO settings_entries_bak')
      ..close();

    final broken = AppDatabase.forTesting(NativeDatabase(file));
    await expectLater(
      broken.select(broken.transactions).get(),
      throwsA(anything),
    );
    await broken.close();

    expect(
      schemaVersionOf(file),
      1,
      reason: 'the version must not advance past a failed migration',
    );

    final after = raw.sqlite3.open(file.path);
    final amounts = after.select('SELECT amount_cents FROM transactions');
    final columns = after
        .select('PRAGMA table_info(transactions)')
        .map((r) => r['name'])
        .toList();
    after.close();

    expect(amounts.single['amount_cents'], 999, reason: 'data is untouched');
    // This is what the transaction wrapper buys. Without it the column stays
    // behind, and because the version never advanced, the next launch replays
    // the chain and dies on "duplicate column name" — on every launch, forever.
    expect(
      columns,
      isNot(contains('recurrence_id')),
      reason: 'the v2 step must be rolled back along with the failed one',
    );
  });

  test('v6 sweeps up the phantom periods but keeps anything with data', () async {
    late int keptWithTxn;
    late int keptManualCarry;
    late int keptOpen;
    late int purgedA;
    late int purgedB;

    final db = AppDatabase.forTesting(NativeDatabase(file));
    // The seed opens one period; everything below is added around it.
    keptOpen = (await db.select(db.periods).getSingle()).id;

    Future<int> closedPeriod(DateTime start, {int? manualCarry}) => db
        .into(db.periods)
        .insert(
          PeriodsCompanion.insert(
            startDate: start,
            endDate: start.add(const Duration(days: 29)),
            status: PeriodStatus.closed,
            carryOverManualCents: Value(manualCarry),
          ),
        );

    keptWithTxn = await closedPeriod(DateTime(2026, 1));
    keptManualCarry = await closedPeriod(DateTime(2026, 2), manualCarry: 1500);
    // The slider artefacts: consecutive days, nothing attached to them.
    purgedA = await closedPeriod(DateTime(2026, 3, 11));
    purgedB = await closedPeriod(DateTime(2026, 3, 12));

    await db
        .into(db.transactions)
        .insert(
          TransactionsCompanion.insert(
            date: DateTime(2026, 1, 12),
            type: TxnType.expense,
            amountCents: 1234,
            accountId: (await db.select(db.accounts).getSingle()).id,
            periodId: keptWithTxn,
          ),
        );
    await db.close();

    raw.sqlite3.open(file.path)
      // Rewind the schema to v5 in shape as well as in number, or the v7 step
      // trips over a column that is already there.
      ..execute('ALTER TABLE accounts DROP COLUMN currency_code')
      ..execute('PRAGMA user_version = 5')
      ..close();

    final migrated = AppDatabase.forTesting(NativeDatabase(file));
    addTearDown(migrated.close);
    final ids = (await migrated.select(migrated.periods).get())
        .map((p) => p.id)
        .toSet();

    expect(ids, contains(keptWithTxn), reason: 'it holds a transaction');
    expect(ids, contains(keptManualCarry), reason: 'the carry was hand-typed');
    expect(ids, contains(keptOpen), reason: 'never touch the open period');
    expect(ids, isNot(contains(purgedA)));
    expect(ids, isNot(contains(purgedB)));

    // The purge must not have taken the transaction down with the period.
    expect(await migrated.select(migrated.transactions).get(), hasLength(1));
    expect(schemaVersionOf(file), 7);
  });

  test('a database from a newer build is refused instead of corrupted', () async {
    final db = AppDatabase.forTesting(NativeDatabase(file));
    await db.select(db.accounts).get();
    await db.close();

    raw.sqlite3.open(file.path)
      ..execute('PRAGMA user_version = 99')
      ..close();

    final older = AppDatabase.forTesting(NativeDatabase(file));
    await expectLater(older.select(older.accounts).get(), throwsA(anything));
    await older.close();

    expect(
      schemaVersionOf(file),
      99,
      reason: 'a downgrade must not stamp the newer schema with an older number',
    );
  });
}
