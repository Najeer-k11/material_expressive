import 'package:flutter/material.dart';
import '../tokens/motion_tokens.dart';

/// A motion specification combining duration and curve.
class MotionSpec {
  const MotionSpec({
    required this.duration,
    required this.curve,
    this.reverseCurve,
  });

  final Duration duration;
  final Curve curve;
  final Curve? reverseCurve;

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

/// Predefined motion specs.
class ExpressiveMotion {
  ExpressiveMotion._();

  static const tokens = ExpressiveMotionTokens.standard;

  static const quick = MotionSpec(
    duration: Duration(milliseconds: 100),
    curve: Curves.easeOut,
  );

  static const standard = MotionSpec(
    duration: Duration(milliseconds: 300),
    curve: Easing.standard,
    reverseCurve: Easing.standard,
  );

  static const enter = MotionSpec(
    duration: Duration(milliseconds: 400),
    curve: Curves.easeOut,
  );

  static const exit = MotionSpec(
    duration: Duration(milliseconds: 200),
    curve: Curves.easeIn,
  );

  static const expressive = MotionSpec(
    duration: Duration(milliseconds: 500),
    curve: Easing.standard,
  );

  static const spring = MotionSpec(
    duration: Duration(milliseconds: 600),
    curve: Curves.elasticOut,
  );

  static const bounce = MotionSpec(
    duration: Duration(milliseconds: 500),
    curve: Curves.bounceOut,
  );
}
