import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/setting_keys.dart';

class SettingsRepository {
  const SettingsRepository(this._db);

  final AppDatabase _db;

  Stream<Map<String, String>> watchAll() => _db
      .select(_db.settingsEntries)
      .watch()
      .map((rows) => {for (final row in rows) row.key: row.value});

  Future<void> put(String key, String value) => _db
      .into(_db.settingsEntries)
      .insertOnConflictUpdate(
        SettingsEntriesCompanion.insert(key: key, value: value),
      );

  Future<void> putBool(String key, {required bool value}) =>
      put(key, value ? 'true' : 'false');

  Future<void> putInt(String key, int value) => put(key, '$value');

  Future<void> putDate(String key, DateTime value) =>
      put(key, value.toIso8601String());
}

/// Typed reads over the raw string map, with the defaults applied.
extension SettingsX on Map<String, String> {
  String _raw(String key) => this[key] ?? SettingDefaults.values[key] ?? '';

  int get periodStartDay =>
      int.tryParse(_raw(SettingKeys.periodStartDay))?.clamp(1, 31) ?? 1;

  bool get useDynamicColor => _raw(SettingKeys.useDynamicColor) == 'true';

  bool get biometricEnabled => _raw(SettingKeys.biometricEnabled) == 'true';

  bool get notificationsEnabled =>
      _raw(SettingKeys.notificationsEnabled) == 'true';

  int get alertThresholdPercent =>
      int.tryParse(_raw(SettingKeys.alertThresholdPercent))?.clamp(1, 100) ??
      80;

  int? get seedColor => int.tryParse(_raw(SettingKeys.seedColor));

  bool get isOnboarded => this[SettingKeys.onboarded] == 'true';

  String get currency =>
      _raw(SettingKeys.currency).isEmpty ? 'EUR' : _raw(SettingKeys.currency);

  DateTime? _date(String key) => DateTime.tryParse(this[key] ?? '');

  DateTime? get lastBackupAt => _date(SettingKeys.lastBackupAt);

  DateTime? get firstLaunchAt => _date(SettingKeys.firstLaunchAt);

  DateTime? get backupReminderSnoozedUntil =>
      _date(SettingKeys.backupReminderSnoozedUntil);

  /// The clock the backup reminder counts from: the last backup, or failing
  /// that the day the app was first opened.
  DateTime? get backupClockStart => lastBackupAt ?? firstLaunchAt;
}
