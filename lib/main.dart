import 'dart:async';

import 'package:budget/app/app.dart';
import 'package:budget/app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quick_actions/quick_actions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Month and weekday names are not compiled in by default; without this,
  // every `DateFormat` throws at runtime. No argument loads every locale, which
  // is what lets the language setting switch date formats at runtime.
  await initializeDateFormatting();

  _setUpQuickActions();

  runApp(const ProviderScope(child: BudgetApp()));
}

/// Long-press the app icon → "Add an expense" jumps straight to the form.
///
/// Registered here rather than in the widget tree so a cold start catches the
/// launch intent. The shortcut's *label* needs the user's language, which is
/// only known once settings load — `HomeWidgetSync` sets it from there.
void _setUpQuickActions() {
  unawaited(
    const QuickActions().initialize((type) {
      if (type == 'add_expense') {
        // Defer so the router is mounted before we push.
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => appRouter.push('/add'),
        );
      }
    }),
  );
}
