import 'dart:convert';
import 'dart:io';

import 'package:budget/data/db/database.dart';
import 'package:cryptography/cryptography.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Encrypted, password-protected backup of the whole database to a
/// `.budgetbak` file, and restore from one.
///
/// Format (JSON): `{v, salt, nonce, mac, data}` where `data` is the AES-GCM
/// ciphertext (base64) of the JSON table dump, and the key is derived from the
/// user's password with PBKDF2-HMAC-SHA256.
class BackupService {
  BackupService(this._db);

  final AppDatabase _db;

  static const _iterations = 120000;

  final _pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: _iterations,
    bits: 256,
  );
  final _aes = AesGcm.with256bits();

  /// Builds the encrypted file and hands it to the OS share sheet.
  Future<void> exportAndShare(String password) async {
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

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: 'Sauvegarde Budget',
      ),
    );
  }

  /// Decrypts [file] with [password] and replaces the current data. Throws
  /// [BackupException] on a wrong password or a corrupt file.
  Future<void> restore(File file, String password) async {
    final Map<String, dynamic> envelope;
    try {
      envelope = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    } on Object {
      throw const BackupException('Fichier illisible.');
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
      throw const BackupException(
        'Mot de passe incorrect ou fichier corrompu.',
      );
    }
  }

  Future<Map<String, dynamic>> _dumpTables() async => {
    'accounts':
        (await _db.select(_db.accounts).get()).map((e) => e.toJson()).toList(),
    'categories':
        (await _db.select(_db.categories).get()).map((e) => e.toJson()).toList(),
    'settings_entries': (await _db.select(_db.settingsEntries).get())
        .map((e) => e.toJson())
        .toList(),
    'periods':
        (await _db.select(_db.periods).get()).map((e) => e.toJson()).toList(),
    'transactions': (await _db.select(_db.transactions).get())
        .map((e) => e.toJson())
        .toList(),
    'recurrences': (await _db.select(_db.recurrences).get())
        .map((e) => e.toJson())
        .toList(),
    'recurrence_instances': (await _db.select(_db.recurrenceInstances).get())
        .map((e) => e.toJson())
        .toList(),
    'budgets':
        (await _db.select(_db.budgets).get()).map((e) => e.toJson()).toList(),
    'savings_goals': (await _db.select(_db.savingsGoals).get())
        .map((e) => e.toJson())
        .toList(),
    'goal_contributions': (await _db.select(_db.goalContributions).get())
        .map((e) => e.toJson())
        .toList(),
    'debts':
        (await _db.select(_db.debts).get()).map((e) => e.toJson()).toList(),
    'debt_payments': (await _db.select(_db.debtPayments).get())
        .map((e) => e.toJson())
        .toList(),
  };

  Future<void> _restoreTables(Map<String, dynamic> dump) async {
    List<Map<String, dynamic>> rows(String key) =>
        ((dump[key] as List<dynamic>?) ?? const [])
            .cast<Map<String, dynamic>>();

    await _db.transaction(() async {
      await _db.customStatement('PRAGMA foreign_keys = OFF');
      for (final table in _db.allTables) {
        await _db.delete(table).go();
      }

      await _db.batch((b) {
        b
          ..insertAll(_db.accounts,
              rows('accounts').map(Account.fromJson).toList())
          ..insertAll(_db.categories,
              rows('categories').map(Category.fromJson).toList())
          ..insertAll(_db.settingsEntries,
              rows('settings_entries').map(SettingEntry.fromJson).toList())
          ..insertAll(
              _db.periods, rows('periods').map(Period.fromJson).toList())
          ..insertAll(_db.transactions,
              rows('transactions').map(Txn.fromJson).toList())
          ..insertAll(_db.recurrences,
              rows('recurrences').map(Recurrence.fromJson).toList())
          ..insertAll(
              _db.recurrenceInstances,
              rows('recurrence_instances')
                  .map(RecurrenceInstance.fromJson)
                  .toList())
          ..insertAll(
              _db.budgets, rows('budgets').map(Budget.fromJson).toList())
          ..insertAll(_db.savingsGoals,
              rows('savings_goals').map(SavingsGoal.fromJson).toList())
          ..insertAll(
              _db.goalContributions,
              rows('goal_contributions')
                  .map(GoalContribution.fromJson)
                  .toList())
          ..insertAll(_db.debts, rows('debts').map(Debt.fromJson).toList())
          ..insertAll(_db.debtPayments,
              rows('debt_payments').map(DebtPayment.fromJson).toList());
      });

      await _db.customStatement('PRAGMA foreign_keys = ON');
    });
  }
}

class BackupException implements Exception {
  const BackupException(this.message);
  final String message;

  @override
  String toString() => message;
}
