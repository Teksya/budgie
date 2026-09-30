/// How long the data may go unsaved before the app nudges the user.
const kBackupReminderDays = 30;

/// How long "Plus tard" silences the nudge.
const kBackupSnoozeDays = 7;

/// Whether to show the "back up your data" nudge.
///
/// [clockStart] is the last backup, or the first launch when none was ever
/// made — a fresh install must not be nagged on day one. A null clock means we
/// have no idea how old the data is, and we stay quiet rather than guess.
bool isBackupReminderDue({
  required DateTime now,
  DateTime? clockStart,
  DateTime? snoozedUntil,
}) {
  if (clockStart == null) return false;
  if (snoozedUntil != null && now.isBefore(snoozedUntil)) return false;
  return now.difference(clockStart).inDays >= kBackupReminderDays;
}
