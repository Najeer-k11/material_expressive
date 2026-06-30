import 'package:flutter/material.dart';
import 'motion_scheme.dart';

/// Accessibility-aware motion utilities.
///
/// Respects [MediaQuery.disableAnimations] and provides reduced-motion
/// alternatives.
class MotionAccessibility {
  MotionAccessibility._();

  /// Check if animations should be reduced.
  static bool shouldReduceMotion(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  /// Get an appropriate duration — returns Duration.zero if motion is disabled.
  static Duration adaptiveDuration(BuildContext context, Duration normal) {
    if (shouldReduceMotion(context)) return Duration.zero;
    return normal;
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

  /// Convenience: wrap a duration based on system setting.
  /// Useful for AnimatedContainer, AnimatedOpacity, etc.
  static Duration duration(
    BuildContext context, {
    Duration normal = const Duration(milliseconds: 300),
    Duration reduced = Duration.zero,
  }) {
    return shouldReduceMotion(context) ? reduced : normal;
  }
}
