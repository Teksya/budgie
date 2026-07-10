import 'package:flutter/material.dart';

/// Expressive motion is spring-based rather than curve-based: things overshoot
/// slightly and settle. Flutter ships the M3 `Durations` and `Easing` tokens,
/// so we build on those instead of inventing magic numbers.
abstract final class AppMotion {
  /// Small state changes: a chip selecting, a checkbox.
  static const Duration quick = Durations.short4;

  /// Standard container transitions.
  static const Duration standard = Durations.medium2;

  /// Hero moments: the balance updating, a sheet opening.
  static const Duration emphasized = Durations.long2;

  static const Curve enter = Easing.emphasizedDecelerate;
  static const Curve exit = Easing.emphasizedAccelerate;
  static const Curve standardCurve = Easing.standard;

  /// Bouncy but not silly. Used by the FAB shape morph and amount counters.
  static const SpringDescription expressiveSpring = SpringDescription(
    mass: 1,
    stiffness: 380,
    damping: 30,
  );

  /// Almost no overshoot — for large surfaces where bounce reads as jank.
  static const SpringDescription gentleSpring = SpringDescription(
    mass: 1,
    stiffness: 200,
    damping: 26,
  );
}
