import 'package:budget/app/providers.dart';
import 'package:budget/app/router.dart';
import 'package:budget/app/theme/app_theme.dart';
import 'package:budget/features/lock/app_lock.dart';
import 'package:budget/features/notifications/notification_sync.dart';
import 'package:budget/features/onboarding/onboarding_flow.dart';
import 'package:budget/features/shared/splash_screen.dart';
import 'package:budget/features/widget/home_widget_sync.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetApp extends ConsumerWidget {
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final useDynamic = ref.watch(useDynamicColorProvider);
    // Configure amount formatting; rebuilds the tree when the currency changes.
    ref.watch(currencyProvider);

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        // Harmonising the wallpaper palette against our own seed keeps the
        // category colours readable on any wallpaper.
        final light = useDynamic ? lightDynamic?.harmonized() : null;
        final dark = useDynamic ? darkDynamic?.harmonized() : null;

        return MaterialApp.router(
          title: 'Budget',
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
          builder: (context, child) => _Gate(
            child: AppLock(
              child: NotificationSync(
                child: HomeWidgetSync(
                  child: child ?? const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          themeMode: themeMode,
          theme: AppTheme.light(light),
          darkTheme: AppTheme.dark(dark),
          // Null follows the device language; the setting can force fr / en.
          locale: ref.watch(languageProvider),
          supportedLocales: L.supportedLocales,
          localizationsDelegates: L.localizationsDelegates,
        );
      },
    );
  }
}

/// Shows the welcome flow until the user has completed setup (or loaded the
/// demo). A blank frame while settings load prevents a flash of the wrong UI.
class _Gate extends ConsumerWidget {
  const _Gate({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarded = ref.watch(onboardedProvider);
    if (onboarded == null) return const SplashScreen();
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: onboarded
          ? child
          // The welcome flow is shown from MaterialApp.builder, above the
          // router's Navigator — so it has no Overlay of its own. Widgets like
          // Slider, Tooltip and text-selection need one, so we provide it here.
          : Overlay(
              key: const ValueKey('onboarding'),
              initialEntries: [
                OverlayEntry(builder: (_) => const OnboardingFlow()),
              ],
            ),
    );
  }
}
