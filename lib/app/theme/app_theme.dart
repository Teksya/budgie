import 'package:budget/app/theme/shapes.dart';
import 'package:flutter/material.dart';

/// Fallback seed when the device exposes no wallpaper colours (Material You is
/// unavailable, or the user turned dynamic colour off).
const Color kFallbackSeed = Color(0xFF6A4DFF);

abstract final class AppTheme {
  static ThemeData light(ColorScheme? dynamicScheme) =>
      _build(_scheme(dynamicScheme, Brightness.light));

  static ThemeData dark(ColorScheme? dynamicScheme) =>
      _build(_scheme(dynamicScheme, Brightness.dark));

  /// `DynamicSchemeVariant.expressive` is what makes the palette Expressive:
  /// it pushes secondary and tertiary hues far away from the seed instead of
  /// keeping everything in one tonal family.
  static ColorScheme _scheme(ColorScheme? dynamicScheme, Brightness brightness) {
    if (dynamicScheme != null) {
      return dynamicScheme.brightness == brightness
          ? dynamicScheme
          : ColorScheme.fromSeed(
              seedColor: dynamicScheme.primary,
              brightness: brightness,
              dynamicSchemeVariant: DynamicSchemeVariant.expressive,
            );
    }
    return ColorScheme.fromSeed(
      seedColor: kFallbackSeed,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.expressive,
    );
  }

  static ThemeData _build(ColorScheme scheme) {
    final base = ThemeData(colorScheme: scheme);

    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      splashFactory: InkSparkle.splashFactory,
      textTheme: _tabularNumbers(base.textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        shape: AppShapes.card,
        elevation: 0,
        color: scheme.surfaceContainerLow,
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.secondaryContainer,
        elevation: 0,
        height: 76,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: AppShapes.fabResting,
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        elevation: 1,
        focusElevation: 1,
        hoverElevation: 2,
        highlightElevation: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: AppShapes.pill,
          minimumSize: const Size(0, 52),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: AppShapes.pill,
          minimumSize: const Size(0, 52),
        ),
      ),
      chipTheme: const ChipThemeData(
        shape: AppShapes.pill,
        side: BorderSide.none,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: AppShapes.sheet,
        backgroundColor: scheme.surfaceContainerLow,
        showDragHandle: true,
      ),
      dialogTheme: const DialogThemeData(shape: AppShapes.hero),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          borderSide: BorderSide.none,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        space: 1,
        thickness: 1,
      ),
    );
  }

  /// Amounts must line up vertically in lists, which proportional digits
  /// break. Applied globally: every digit in the app is the same width.
  static TextTheme _tabularNumbers(TextTheme theme) {
    const features = [FontFeature.tabularFigures()];
    TextStyle? f(TextStyle? s) => s?.copyWith(fontFeatures: features);
    return theme.copyWith(
      displayLarge: f(theme.displayLarge),
      displayMedium: f(theme.displayMedium),
      displaySmall: f(theme.displaySmall),
      headlineLarge: f(theme.headlineLarge),
      headlineMedium: f(theme.headlineMedium),
      headlineSmall: f(theme.headlineSmall),
      titleLarge: f(theme.titleLarge),
      titleMedium: f(theme.titleMedium),
      titleSmall: f(theme.titleSmall),
      bodyLarge: f(theme.bodyLarge),
      bodyMedium: f(theme.bodyMedium),
      bodySmall: f(theme.bodySmall),
      labelLarge: f(theme.labelLarge),
      labelMedium: f(theme.labelMedium),
      labelSmall: f(theme.labelSmall),
    );
  }
}

/// Semantic colours for budget state. Derived from the scheme so they stay in
/// harmony with whatever wallpaper the user picked.
extension BudgetColors on ColorScheme {
  /// Comfortable: spending is on track.
  Color get healthy => brightness == Brightness.light
      ? const Color(0xFF2E7D4F)
      : const Color(0xFF7EE0A6);

  Color get onHealthyContainer =>
      brightness == Brightness.light ? const Color(0xFF00210F) : const Color(0xFFB7F5CE);

  Color get healthyContainer => brightness == Brightness.light
      ? const Color(0xFFB7F5CE)
      : const Color(0xFF00522B);

  /// Tight: close to the limit.
  Color get caution => brightness == Brightness.light
      ? const Color(0xFF8A5A00)
      : const Color(0xFFFFC46B);

  Color get cautionContainer => brightness == Brightness.light
      ? const Color(0xFFFFDFB0)
      : const Color(0xFF5A3A00);

  /// Overspent.
  Color get danger => error;
  Color get dangerContainer => errorContainer;
}
