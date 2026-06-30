import 'package:flutter/material.dart';

/// Motion tokens: durations and curves.
class ExpressiveMotionTokens {
  const ExpressiveMotionTokens({
    required this.durationExtraShort,
    required this.durationShort,
    required this.durationMedium,
    required this.durationLong,
    required this.durationExtraLong,
    required this.curveStandard,
    required this.curveDecelerate,
    required this.curveAccelerate,
    required this.curveEmphasized,
    required this.curveEmphasizedDecelerate,
    required this.curveEmphasizedAccelerate,
    required this.curveSpring,
  });

  static const standard = ExpressiveMotionTokens(
    durationExtraShort: Duration(milliseconds: 100),
    durationShort: Duration(milliseconds: 200),
    durationMedium: Duration(milliseconds: 300),
    durationLong: Duration(milliseconds: 450),
    durationExtraLong: Duration(milliseconds: 700),
    curveStandard: Curves.easeInOut,
    curveDecelerate: Curves.easeOut,
    curveAccelerate: Curves.easeIn,
    curveEmphasized: Easing.standard,
    curveEmphasizedDecelerate: Easing.emphasizedDecelerate,
    curveEmphasizedAccelerate: Easing.emphasizedAccelerate,
    curveSpring: Curves.elasticOut,
  );

  final Duration durationExtraShort;
  final Duration durationShort;
  final Duration durationMedium;
  final Duration durationLong;
  final Duration durationExtraLong;
  final Curve curveStandard;
  final Curve curveDecelerate;
  final Curve curveAccelerate;
  final Curve curveEmphasized;
  final Curve curveEmphasizedDecelerate;
  final Curve curveEmphasizedAccelerate;
  final Curve curveSpring;
}
