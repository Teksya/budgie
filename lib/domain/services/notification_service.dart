import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Local, on-device reminders for upcoming charge due dates.
///
/// Every entry point is wrapped so a denied permission or a platform quirk can
/// never crash the app — budgeting must keep working without notifications.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  static const _channelId = 'charge_reminders';

  Future<void> init() async {
    if (_ready) return;
    try {
      tz.initializeTimeZones();
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      await _plugin.initialize(
        settings: const InitializationSettings(android: android),
      );
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              _channelId,
              "Rappels d'échéance",
              description: 'Rappels avant une charge à payer',
              importance: Importance.defaultImportance,
            ),
          );
      _ready = true;
    } on Object catch (e) {
      debugPrint('NotificationService.init failed: $e');
    }
  }

  /// Asks for the OS notification permission. Returns true if granted.
  Future<bool> requestPermission() async {
    try {
      await init();
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final granted = await android?.requestNotificationsPermission();
      return granted ?? false;
    } on Object catch (e) {
      debugPrint('NotificationService.requestPermission failed: $e');
      return false;
    }
  }

  /// Replaces all scheduled reminders with ones for the given pending charges:
  /// a heads-up three days before and one on the due date, each at 09:00.
  Future<void> syncChargeReminders(List<RecurrenceInstance> pending) async {
    try {
      await init();
      if (!_ready) return;
      await _plugin.cancelAll();

      final now = DateTime.now();
      for (final c in pending) {
        final amount = Money(c.actualAmountCents ?? c.estimatedAmountCents);
        await _scheduleAt(
          id: c.id * 2,
          when: _at9(c.dueDate),
          now: now,
          title: "Échéance aujourd'hui : ${c.label}",
          body: '${amount.format()} à payer.',
        );
        await _scheduleAt(
          id: c.id * 2 + 1,
          when: _at9(c.dueDate.subtract(const Duration(days: 3))),
          now: now,
          title: 'Dans 3 jours : ${c.label}',
          body: '${amount.format()} à prévoir le ${c.dueDate.day}.',
        );
      }
    } on Object catch (e) {
      debugPrint('NotificationService.syncChargeReminders failed: $e');
    }
  }

  Future<void> cancelAll() async {
    try {
      await _plugin.cancelAll();
    } on Object catch (_) {
      // Nothing to do; cancelling is best-effort.
    }
  }

  // Fixed id, outside the charge-instance id space, for the daily nudge.
  static const _dailyReminderId = 900000;

  /// A gentle daily reminder to log expenses, repeating at [hour]:00 local.
  Future<void> scheduleDailyReminder({int hour = 20}) async {
    try {
      await init();
      if (!_ready) return;
      final now = tz.TZDateTime.now(tz.local);
      var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);
      if (!when.isAfter(now)) when = when.add(const Duration(days: 1));
      await _plugin.zonedSchedule(
        id: _dailyReminderId,
        title: 'Pense à noter tes dépenses 💸',
        body: '2 minutes pour rester à jour sur ton budget.',
        scheduledDate: when,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            "Rappels d'échéance",
            channelDescription: 'Rappels avant une charge à payer',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        // Repeats every day at the same time.
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } on Object catch (e) {
      debugPrint('scheduleDailyReminder failed: $e');
    }
  }

  Future<void> cancelDailyReminder() async {
    try {
      await _plugin.cancel(id: _dailyReminderId);
    } on Object catch (_) {}
  }

  Future<void> _scheduleAt({
    required int id,
    required DateTime when,
    required DateTime now,
    required String title,
    required String body,
  }) async {
    if (!when.isAfter(now)) return; // never schedule in the past
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(when, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          "Rappels d'échéance",
          channelDescription: 'Rappels avant une charge à payer',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static DateTime _at9(DateTime day) =>
      DateTime(day.year, day.month, day.day, 9);
}
