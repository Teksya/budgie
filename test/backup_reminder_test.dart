import 'package:budget/domain/services/backup_reminder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 7, 14, 10);

  group('isBackupReminderDue', () {
    test('stays quiet when the clock has not started', () {
      expect(isBackupReminderDue(now: now), isFalse);
    });

    test('stays quiet on a fresh install', () {
      expect(
        isBackupReminderDue(now: now, clockStart: now),
        isFalse,
        reason: 'nagging on day one would be the first thing a new user sees',
      );
    });

    test('stays quiet the day before the threshold', () {
      expect(
        isBackupReminderDue(
          now: now,
          clockStart: now.subtract(const Duration(days: 29, hours: 23)),
        ),
        isFalse,
      );
    });

    test('fires on the 30th day', () {
      expect(
        isBackupReminderDue(
          now: now,
          clockStart: now.subtract(const Duration(days: 30)),
        ),
        isTrue,
      );
    });

    test('keeps firing well past the threshold', () {
      expect(
        isBackupReminderDue(
          now: now,
          clockStart: now.subtract(const Duration(days: 400)),
        ),
        isTrue,
      );
    });

    test('a snooze silences an otherwise due reminder', () {
      expect(
        isBackupReminderDue(
          now: now,
          clockStart: now.subtract(const Duration(days: 90)),
          snoozedUntil: now.add(const Duration(days: 3)),
        ),
        isFalse,
      );
    });

    test('the reminder comes back once the snooze lapses', () {
      expect(
        isBackupReminderDue(
          now: now,
          clockStart: now.subtract(const Duration(days: 90)),
          snoozedUntil: now.subtract(const Duration(minutes: 1)),
        ),
        isTrue,
      );
    });

    test('a stale snooze cannot resurrect a reminder that is not due', () {
      expect(
        isBackupReminderDue(
          now: now,
          clockStart: now.subtract(const Duration(days: 2)),
          snoozedUntil: now.subtract(const Duration(days: 1)),
        ),
        isFalse,
      );
    });
  });
}
