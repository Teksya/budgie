import 'dart:async';

import 'package:budget/app/providers.dart';
import 'package:budget/data/db/enums.dart';
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
      ..listen(chargesProvider, (_, _) => _sync(ref))
      ..listen(settingsProvider, (_, _) => _sync(ref));
    return child;
  }

  void _sync(WidgetRef ref) {
    final enabled =
        ref.read(settingsProvider).value?.notificationsEnabled ?? false;
    final service = NotificationService.instance;
    if (!enabled) {
      unawaited(service.cancelAll());
      return;
    }
    final charges = ref.read(chargesProvider).value ?? const [];
    final pending =
        charges.where((c) => c.status != InstanceStatus.paid).toList();
    unawaited(service.syncChargeReminders(pending));
  }
}
