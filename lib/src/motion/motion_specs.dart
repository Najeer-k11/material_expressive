import 'package:material_ui/material_ui.dart';

import '../tokens/motion_tokens.dart';
import 'motion_scheme.dart';

/// A tween-based motion specification: a duration plus a curve.
///
/// For physics-based motion use [ExpressiveMotionScheme] springs instead.
class ExpressiveMotionSpec {
  const ExpressiveMotionSpec({
    required this.duration,
    required this.curve,
    this.reverseCurve,
  });

  final Duration duration;
  final Curve curve;
  final Curve? reverseCurve;

  // -- Presets (tween-based). Values follow ExpressiveMotionTokens.standard
  //    where a matching token exists. --

  static const quick = ExpressiveMotionSpec(
    duration: Duration(milliseconds: 100),
    curve: Curves.easeOut,
  );

  static const standard = ExpressiveMotionSpec(
    duration: Duration(milliseconds: 300),
    curve: Easing.standard,
    reverseCurve: Easing.standard,
  );

  static const enter = ExpressiveMotionSpec(
    duration: Duration(milliseconds: 400),
    curve: Curves.easeOut,
  );

  static const exit = ExpressiveMotionSpec(
    duration: Duration(milliseconds: 200),
    curve: Curves.easeIn,
  );

  static const expressive = ExpressiveMotionSpec(
    duration: Duration(milliseconds: 500),
    curve: Easing.standard,
  );

  static const spring = ExpressiveMotionSpec(
    duration: Duration(milliseconds: 600),
    curve: Curves.elasticOut,
  );

  static const bounce = ExpressiveMotionSpec(
    duration: Duration(milliseconds: 500),
    curve: Curves.bounceOut,
  );

  AnimationController createController(TickerProvider vsync) {
    return AnimationController(vsync: vsync, duration: duration);
  }

  CurvedAnimation createAnimation(AnimationController controller) {
    return CurvedAnimation(
      parent: controller,
      curve: curve,
      reverseCurve: reverseCurve ?? curve,
    );
  }
}

// ---- Deprecated aliases (removed in 1.0.0) ----

@Deprecated('Use ExpressiveMotionSpec instead. Will be removed in 1.0.0.')
typedef MotionSpec = ExpressiveMotionSpec;

/// Deprecated: the presets moved to [ExpressiveMotionSpec].
@Deprecated(
  'Use ExpressiveMotionSpec presets instead. Will be removed in 1.0.0.',
)
class ExpressiveMotion {
  ExpressiveMotion._();

  static const tokens = ExpressiveMotionTokens.standard;
  static const quick = ExpressiveMotionSpec.quick;
  static const standard = ExpressiveMotionSpec.standard;
  static const enter = ExpressiveMotionSpec.enter;
  static const exit = ExpressiveMotionSpec.exit;
  static const expressive = ExpressiveMotionSpec.expressive;
  static const spring = ExpressiveMotionSpec.spring;
  static const bounce = ExpressiveMotionSpec.bounce;
}
