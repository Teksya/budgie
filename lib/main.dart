import 'dart:async';

import 'package:budget/app/app.dart';
import 'package:budget/app/router.dart';
import 'package:budget/domain/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quick_actions/quick_actions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Month and weekday names are not compiled in by default; without this,
  // every `DateFormat(..., 'fr_FR')` throws at runtime.
  await initializeDateFormatting('fr_FR');
  await initializeDateFormatting('en');

  // Best-effort; the service swallows its own errors so a notification
  // problem never blocks startup.
  await NotificationService.instance.init();

  _setUpQuickActions();

  runApp(const ProviderScope(child: BudgetApp()));
}

/// Long-press the app icon → "Add an expense" jumps straight to the form.
void _setUpQuickActions() {
  const quickActions = QuickActions();
  unawaited(
    quickActions.initialize((type) {
      if (type == 'add_expense') {
        // Defer so the router is mounted before we push.
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => appRouter.push('/add'),
        );
      }
    }),
  );
  unawaited(
    quickActions.setShortcutItems(const [
      ShortcutItem(type: 'add_expense', localizedTitle: 'Ajouter une dépense'),
    ]),
  );
}
