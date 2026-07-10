import 'package:flutter/material.dart';

/// Material 3 Expressive leans on a *wide* corner-radius range: small controls
/// stay tight, hero containers go very round. Using one radius everywhere is
/// what makes an M3 app look flat and generic.
abstract final class AppRadius {
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 28;
  static const double xxl = 36;
  static const double full = 999;
}

abstract final class AppShapes {
  static const RoundedRectangleBorder card = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
  );

  static const RoundedRectangleBorder hero = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(AppRadius.xxl)),
  );

  static const RoundedRectangleBorder sheet = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
  );

  static const StadiumBorder pill = StadiumBorder();

  /// The FAB's resting shape. It morphs towards [fabPressed] on touch down —
  /// see `ExpressiveFab`.
  static const RoundedRectangleBorder fabResting = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(AppRadius.xl)),
  );

  static const RoundedRectangleBorder fabPressed = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
  );
}

abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}
