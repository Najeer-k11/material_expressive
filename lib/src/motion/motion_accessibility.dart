import 'package:material_ui/material_ui.dart';

import 'motion_scheme.dart';

/// Accessibility-aware motion utilities.
///
/// Respects [MediaQuery.disableAnimations] and provides reduced-motion
/// alternatives.
class ExpressiveMotionAccessibility {
  ExpressiveMotionAccessibility._();

  /// Check if animations should be reduced.
  static bool shouldReduceMotion(BuildContext context) {
    return MediaQuery.disableAnimationsOf(context);
  }

  /// Returns [reduced] (default [Duration.zero]) if motion should be
  /// reduced, otherwise [normal].
  static Duration adaptiveDuration(
    BuildContext context,
    Duration normal, {
    Duration reduced = Duration.zero,
  }) {
    return shouldReduceMotion(context) ? reduced : normal;
  }

  /// Get an appropriate spring — returns a critically-damped (no bounce)
  /// spring if motion should be reduced.
  static ExpressiveSpring adaptiveSpring(
    BuildContext context,
    ExpressiveSpring normal,
  ) {
    if (shouldReduceMotion(context)) {
      return ExpressiveSpring(
        stiffness: normal.stiffness * 2,
        dampingRatio: 1.0, // critically damped = no oscillation
        mass: normal.mass,
      );
    }
    return normal;
  }

  /// Returns [Curves.linear] if motion is disabled, otherwise [normal].
  static Curve adaptiveCurve(BuildContext context, Curve normal) {
    if (shouldReduceMotion(context)) return Curves.linear;
    return normal;
  }

  @Deprecated('Use adaptiveDuration instead. Will be removed in 1.0.0.')
  static Duration duration(
    BuildContext context, {
    Duration normal = const Duration(milliseconds: 300),
    Duration reduced = Duration.zero,
  }) => adaptiveDuration(context, normal, reduced: reduced);
}

// ---- Deprecated aliases (removed in 1.0.0) ----

@Deprecated(
  'Use ExpressiveMotionAccessibility instead. Will be removed in 1.0.0.',
)
typedef MotionAccessibility = ExpressiveMotionAccessibility;
