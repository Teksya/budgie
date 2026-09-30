/// Keys of the `settings_entries` table. Values are stored as strings.
abstract final class SettingKeys {
  /// Day of the month a budget period starts on. `'1'` by default.
  static const periodStartDay = 'period_start_day';

  /// `system` | `light` | `dark`
  static const themeMode = 'theme_mode';

  static const useDynamicColor = 'use_dynamic_color';

  /// ARGB int as a string, used when dynamic colour is off or unavailable.
  static const seedColor = 'seed_color';

  static const biometricEnabled = 'biometric_enabled';
  static const notificationsEnabled = 'notifications_enabled';

  /// Percentage at which an envelope raises a warning. `'80'` by default.
  static const alertThresholdPercent = 'alert_threshold_percent';

  /// ISO-8601 timestamp of the last successful backup.
  static const lastBackupAt = 'last_backup_at';

  /// ISO-8601 timestamp the backup clock starts from when no backup has ever
  /// been made. Without it a fresh install would be nagged from day one.
  static const firstLaunchAt = 'first_launch_at';

  /// ISO-8601 timestamp before which the backup reminder stays hidden.
  static const backupReminderSnoozedUntil = 'backup_reminder_snoozed_until';

  /// Set once the first-launch seed has run.
  static const seeded = 'seeded';

  /// Set once the user has finished (or skipped via demo) the welcome flow.
  static const onboarded = 'onboarded';

  /// ISO currency code (`EUR`, `USD`…). Drives amount formatting.
  static const currency = 'currency';

  /// `system` | `fr` | `en`. `system` follows the device language.
  static const language = 'language';

  /// Daily "log your expenses" reminder at 20:00.
  static const dailyReminder = 'daily_reminder';

  /// Newline-separated keys of the suggestions the user has waved away, so
  /// they are not offered again next month.
  static const dismissedSuggestions = 'dismissed_suggestions';
}

abstract final class SettingDefaults {
  static const Map<String, String> values = {
    SettingKeys.periodStartDay: '1',
    SettingKeys.themeMode: 'system',
    SettingKeys.useDynamicColor: 'true',
    SettingKeys.biometricEnabled: 'false',
    SettingKeys.notificationsEnabled: 'false',
    SettingKeys.currency: 'EUR',
    SettingKeys.alertThresholdPercent: '80',
  };
}
