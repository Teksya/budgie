import 'dart:async';

import 'package:budget/app/providers.dart';
import 'package:budget/app/router.dart';
import 'package:budget/core/date_x.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/domain/services/budget_engine.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:quick_actions/quick_actions.dart';

/// Pushes app state out to the OS surfaces: the home-screen widgets and the
/// launcher shortcut. Also routes taps on the quick-add widget to the add
/// screen.
///
/// Every string here is user-visible outside the app, where there is no
/// `BuildContext`, so they come from [translationsProvider].
class HomeWidgetSync extends ConsumerStatefulWidget {
  const HomeWidgetSync({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<HomeWidgetSync> createState() => _HomeWidgetSyncState();
}

class _HomeWidgetSyncState extends ConsumerState<HomeWidgetSync> {
  // Fully-qualified names: they must track the Android applicationId, or the
  // home-screen widgets silently stop refreshing.
  static const _budgetProvider = 'com.olivierd.budgie.BudgetWidgetProvider';
  static const _billProvider = 'com.olivierd.budgie.BillWidgetProvider';
  StreamSubscription<Uri?>? _clicks;

  @override
  void initState() {
    super.initState();
    // Cold launch from the quick-add widget.
    unawaited(HomeWidget.initiallyLaunchedFromHomeWidget().then(_handleUri));
    // Taps while the app is running.
    _clicks = HomeWidget.widgetClicked.listen(_handleUri);
  }

  @override
  void dispose() {
    unawaited(_clicks?.cancel());
    super.dispose();
  }

  void _handleUri(Uri? uri) {
    if (uri?.host == 'add') {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => unawaited(appRouter.push('/add')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..listen(snapshotProvider, (_, next) {
        final snapshot = next.value;
        if (snapshot != null) unawaited(_push(snapshot));
      })
      // The launcher shortcut is registered in `main` so a cold start catches
      // the intent; only its label waits for the language to be known.
      ..listen(translationsProvider, (_, next) {
        final l = next.value;
        if (l != null) unawaited(_pushShortcut(l));
      });
    return widget.child;
  }

  Future<void> _pushShortcut(L l) async {
    try {
      await const QuickActions().setShortcutItems([
        ShortcutItem(type: 'add_expense', localizedTitle: l.shortcutAddExpense),
      ]);
    } on Object catch (e) {
      debugPrint('setShortcutItems failed: $e');
    }
  }

  Future<void> _push(BudgetSnapshot snapshot) async {
    try {
      final l = await ref.read(translationsProvider.future);
      final label = ref.read(currentPeriodRangeProvider).label;
      await HomeWidget.saveWidgetData<String>(
        'remaining',
        snapshot.remaining.format(),
      );
      await HomeWidget.saveWidgetData<String>(
        'label',
        l.widgetRemainingLabel(label),
      );
      await HomeWidget.updateWidget(qualifiedAndroidName: _budgetProvider);

      // Next unpaid charge, soonest first.
      final charges = (ref.read(chargesProvider).value ?? const [])
          .where((c) => c.status != InstanceStatus.paid)
          .toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
      if (charges.isNotEmpty) {
        final next = charges.first;
        final amount =
            Money(next.actualAmountCents ?? next.estimatedAmountCents);
        await HomeWidget.saveWidgetData<String>(
          'bill_name',
          '${next.label} · ${amount.format()}',
        );
        await HomeWidget.saveWidgetData<String>(
          'bill_due',
          l.widgetBillDue(next.dueDate.shortLabel),
        );
      } else {
        await HomeWidget.saveWidgetData<String>('bill_name', l.widgetNothingDue);
        await HomeWidget.saveWidgetData<String>('bill_due', '');
      }
      await HomeWidget.updateWidget(qualifiedAndroidName: _billProvider);
    } on Object catch (e) {
      debugPrint('HomeWidgetSync failed: $e');
    }
  }
}
