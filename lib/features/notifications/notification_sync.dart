import 'dart:async';

import 'package:budget/app/providers.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/data/db/setting_keys.dart';
import 'package:budget/data/repositories/settings_repository.dart';
import 'package:budget/domain/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Keeps the OS-scheduled charge reminders in sync with the current period's
/// unpaid charges and the user's notification preference. Renders [child]
/// untouched — it only listens.
class NotificationSync extends ConsumerWidget {
  const NotificationSync({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
      ..listen(chargesProvider, (_, _) => unawaited(_sync(ref)))
      ..listen(settingsProvider, (_, _) => unawaited(_sync(ref)));
    return child;
  }

  Future<void> _sync(WidgetRef ref) async {
    final settings = ref.read(settingsProvider).value ?? const {};
    final enabled = settings.notificationsEnabled;
    final service = NotificationService.instance;
    if (!enabled) {
      unawaited(service.cancelAll());
      return;
    }
    // Notification text is read outside the app, so it comes from the resolved
    // language rather than a BuildContext. This is also what initialises the
    // service — `main` cannot, it runs before the language is known.
    final l = await ref.read(translationsProvider.future);
    final charges = ref.read(chargesProvider).value ?? const [];
    final pending =
        charges.where((c) => c.status != InstanceStatus.paid).toList();
    // Wipes every scheduled notification before re-creating the charge ones,
    // so anything else the app had booked has to be booked again below.
    await service.syncChargeReminders(l, pending);

    if (settings[SettingKeys.dailyReminder] == 'true') {
      await service.scheduleDailyReminder(l);
    }

    // The recap fires the morning after the current period ends. Re-scheduling
    // on the same fixed id every sync keeps it correct when the user changes
    // the period start day.
    final period = ref.read(openPeriodProvider).value;
    if (period != null) {
      await service.scheduleMonthRecap(l, period.endDate);
    }
  }
}
