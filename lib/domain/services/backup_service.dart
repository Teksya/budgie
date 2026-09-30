import 'dart:convert';
import 'dart:io';

import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/setting_keys.dart';
import 'package:budget/data/repositories/settings_repository.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart' show InsertMode;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Encrypted, password-protected backup of the whole database to a
/// `.budgetbak` file, and restore from one.
///
/// Format (JSON): `{v, salt, nonce, mac, data}` where `data` is the AES-GCM
/// ciphertext (base64) of the JSON table dump, and the key is derived from the
/// user's password with PBKDF2-HMAC-SHA256.
class BackupService {
  BackupService(this._db, this._settings);

  final AppDatabase _db;
  final SettingsRepository _settings;

  static const _iterations = 120000;

  final _pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: _iterations,
    bits: 256,
  );
  final _aes = AesGcm.with256bits();

  /// Builds the encrypted file and hands it to the OS share sheet.
  Future<void> exportAndShare(L l, String password) async {
    final dump = await _dumpTables();
    final plain = utf8.encode(jsonEncode(dump));

    final salt = SecretKeyData.random(length: 16).bytes;
    final key = await _pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );
    final box = await _aes.encrypt(plain, secretKey: key);

    final envelope = jsonEncode({
      'v': 1,
      'salt': base64Encode(salt),
      'nonce': base64Encode(box.nonce),
      'mac': base64Encode(box.mac.bytes),
      'data': base64Encode(box.cipherText),
    });

    final dir = await getTemporaryDirectory();
    final stamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final file = File('${dir.path}/budget-$stamp.budgetbak');
    await file.writeAsString(envelope);

    final result = await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: l.backupShareSubject,
      ),
    );

    // Android often reports `unavailable` rather than naming the target app, so
    // only an outright dismissal counts as "no backup was made".
    if (result.status == ShareResultStatus.dismissed) return;
    await _settings.putDate(SettingKeys.lastBackupAt, DateTime.now());
  }

  /// Decrypts [file] with [password] and replaces the current data. Throws
  /// [BackupException], already phrased in the user's language, on a wrong
  /// password or a corrupt file.
  Future<void> restore(L l, File file, String password) async {
    final Map<String, dynamic> envelope;
    try {
      envelope = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    } on Object {
      throw BackupException(l.backupUnreadableFile);
    }

    try {
      final salt = base64Decode(envelope['salt'] as String);
      final key = await _pbkdf2.deriveKey(
        secretKey: SecretKey(utf8.encode(password)),
        nonce: salt,
      );
      final clear = await _aes.decrypt(
        SecretBox(
          base64Decode(envelope['data'] as String),
          nonce: base64Decode(envelope['nonce'] as String),
          mac: Mac(base64Decode(envelope['mac'] as String)),
        ),
        secretKey: key,
      );
      final dump = jsonDecode(utf8.decode(clear)) as Map<String, dynamic>;
      await _restoreTables(dump);
    } on BackupException {
      rethrow;
    } on Object {
      // AES-GCM authentication fails on a wrong password or tampered file.
      throw BackupException(l.backupWrongPassword);
    }
  }

  Future<Map<String, dynamic>> _dumpTables() async {
    final dump = await _dumpEveryTable();
    // `restore` empties every table before reinserting, so a table present in
    // the schema but absent here is silently wiped on restore — which is what
    // happened to `favorites`. Fail loudly at the next schema addition instead
    // of eating the user's data.
    assert(
      _db.allTables.every((t) => dump.containsKey(t.actualTableName)),
      'These tables are in the schema but not in the dump, so restore() would '
      'wipe them: ${_db.allTables.map((t) => t.actualTableName).where((n) => !dump.containsKey(n)).join(', ')}',
    );
    return dump;
  }

  Future<Map<String, dynamic>> _dumpEveryTable() async => {
    'accounts': (await _db.select(_db.accounts).get())
        .map((e) => e.toJson())
        .toList(),
    'categories': (await _db.select(_db.categories).get())
        .map((e) => e.toJson())
        .toList(),
    'settings_entries': (await _db.select(_db.settingsEntries).get())
        .map((e) => e.toJson())
        .toList(),
    'periods': (await _db.select(_db.periods).get())
        .map((e) => e.toJson())
        .toList(),
    'transactions': (await _db.select(_db.transactions).get())
        .map((e) => e.toJson())
        .toList(),
    'recurrences': (await _db.select(_db.recurrences).get())
        .map((e) => e.toJson())
        .toList(),
    'recurrence_instances': (await _db.select(_db.recurrenceInstances).get())
        .map((e) => e.toJson())
        .toList(),
    'budgets': (await _db.select(_db.budgets).get())
        .map((e) => e.toJson())
        .toList(),
    'savings_goals': (await _db.select(_db.savingsGoals).get())
        .map((e) => e.toJson())
        .toList(),
    'goal_contributions': (await _db.select(_db.goalContributions).get())
        .map((e) => e.toJson())
        .toList(),
    'debts': (await _db.select(_db.debts).get())
        .map((e) => e.toJson())
        .toList(),
    'debt_payments': (await _db.select(_db.debtPayments).get())
        .map((e) => e.toJson())
        .toList(),
    'favorites': (await _db.select(_db.favorites).get())
        .map((e) => e.toJson())
        .toList(),
  };

  Future<void> _restoreTables(Map<String, dynamic> dump) async {
    List<Map<String, dynamic>> rows(String key) =>
        ((dump[key] as List<dynamic>?) ?? const [])
            .cast<Map<String, dynamic>>();

    await _db.transaction(() async {
      // SQLite ignores `PRAGMA foreign_keys` inside a transaction, so turning
      // them off here never worked. It does not need to: deletes are safe in
      // any order (every reference is `cascade` or `setNull`), and the inserts
      // below are ordered parents-before-children.
      for (final table in _db.allTables) {
        await _db.delete(table).go();
      }

      await _db.batch((b) {
        b
          ..insertAll(
            _db.accounts,
            rows('accounts').map(Account.fromJson).toList(),
          )
          ..insertAll(
            _db.categories,
            rows('categories').map(Category.fromJson).toList(),
          )
          ..insertAll(
            _db.settingsEntries,
            rows('settings_entries').map(SettingEntry.fromJson).toList(),
          )
          ..insertAll(
            _db.periods,
            rows('periods').map(Period.fromJson).toList(),
          )
          ..insertAll(
            _db.transactions,
            rows('transactions').map(Txn.fromJson).toList(),
          )
          ..insertAll(
            _db.recurrences,
            rows('recurrences').map(Recurrence.fromJson).toList(),
          )
          ..insertAll(
            _db.recurrenceInstances,
            rows(
              'recurrence_instances',
            ).map(RecurrenceInstance.fromJson).toList(),
          )
          ..insertAll(
            _db.budgets,
            rows('budgets').map(Budget.fromJson).toList(),
          )
          ..insertAll(
            _db.savingsGoals,
            rows('savings_goals').map(SavingsGoal.fromJson).toList(),
          )
          ..insertAll(
            _db.goalContributions,
            rows('goal_contributions').map(GoalContribution.fromJson).toList(),
          )
          ..insertAll(_db.debts, rows('debts').map(Debt.fromJson).toList())
          ..insertAll(
            _db.debtPayments,
            rows('debt_payments').map(DebtPayment.fromJson).toList(),
          )
          ..insertAll(
            _db.favorites,
            rows('favorites').map(Favorite.fromJson).toList(),
          );
      });

      // A file written before the backup clock existed carries no
      // `firstLaunchAt`, which would leave the reminder permanently silent.
      // `insertOrIgnore` starts the clock only when the dump didn't bring one.
      await _db
          .into(_db.settingsEntries)
          .insert(
            SettingsEntriesCompanion.insert(
              key: SettingKeys.firstLaunchAt,
              value: DateTime.now().toIso8601String(),
            ),
            mode: InsertMode.insertOrIgnore,
          );
    });
  }
}

class BackupException implements Exception {
  const BackupException(this.message);
  final String message;

  @override
  String toString() => message;
}
