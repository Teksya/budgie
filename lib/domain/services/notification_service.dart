import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/l10n/app_localizations.dart';
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

  /// The translations last handed to [init], reused by the notification details
  /// built deeper down. Null until the first init, which `main` always runs.
  L? _l;

  /// [l] names the Android notification channel, which the user sees in the
  /// system settings. Re-creating a channel with the same id updates its name,
  /// so switching language in-app renames it on the next launch.
  Future<void> init(L l) async {
    _l = l;
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
            AndroidNotificationChannel(
              _channelId,
              l.notifChannelName,
              description: l.notifChannelDescription,
              importance: Importance.defaultImportance,
            ),
          );
      _ready = true;
    } on Object catch (e) {
      debugPrint('NotificationService.init failed: $e');
    }
  }

  /// Asks for the OS notification permission. Returns true if granted.
  Future<bool> requestPermission(L l) async {
    try {
      await init(l);
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
  Future<void> syncChargeReminders(L l, List<RecurrenceInstance> pending) async {
    try {
      await init(l);
      if (!_ready) return;
      await _plugin.cancelAll();

      final now = DateTime.now();
      for (final c in pending) {
        final amount = Money(c.actualAmountCents ?? c.estimatedAmountCents);
        await _scheduleAt(
          id: c.id * 2,
          when: _at9(c.dueDate),
          now: now,
          title: l.notifDueTodayTitle(c.label),
          body: l.notifDueTodayBody(amount.format()),
        );
        await _scheduleAt(
          id: c.id * 2 + 1,
          when: _at9(c.dueDate.subtract(const Duration(days: 3))),
          now: now,
          title: l.notifDueSoonTitle(c.label),
          body: l.notifDueSoonBody(amount.format(), c.dueDate.day),
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
  Future<void> scheduleDailyReminder(L l, {int hour = 20}) async {
    try {
      await init(l);
      if (!_ready) return;
      final now = tz.TZDateTime.now(tz.local);
      var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);
      if (!when.isAfter(now)) when = when.add(const Duration(days: 1));
      await _plugin.zonedSchedule(
        id: _dailyReminderId,
        title: l.notifDailyTitle,
        body: l.notifDailyBody,
        scheduledDate: when,
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        // Repeats every day at the same time.
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } on Object catch (e) {
      debugPrint('scheduleDailyReminder failed: $e');
    }
  }

  // Fixed id, outside the charge-instance id space, for the month recap.
  static const _recapId = 900001;

  /// One notification the morning after a period closes, pointing at the
  /// recap. Not a reminder to do something — a reason to come back.
  Future<void> scheduleMonthRecap(L l, DateTime periodEnd) async {
    try {
      await init(l);
      if (!_ready) return;
      final when = tz.TZDateTime.from(
        DateTime(periodEnd.year, periodEnd.month, periodEnd.day, 10)
            .add(const Duration(days: 1)),
        tz.local,
      );
      if (!when.isAfter(tz.TZDateTime.now(tz.local))) return;

      await _plugin.zonedSchedule(
        id: _recapId,
        title: l.notifRecapTitle,
        body: l.notifRecapBody,
        scheduledDate: when,
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } on Object catch (e) {
      debugPrint('scheduleMonthRecap failed: $e');
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
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  /// Android reads the channel name from the channel itself; these strings only
  /// matter on the versions that predate channels, hence the plain fallback.
  NotificationDetails get _details => NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      _l?.notifChannelName ?? 'Reminders',
      channelDescription: _l?.notifChannelDescription,
    ),
  );

  static DateTime _at9(DateTime day) =>
      DateTime(day.year, day.month, day.day, 9);
}
