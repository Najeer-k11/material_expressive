import 'package:flutter/material.dart';

/// RTL-aware shape utilities.
///
/// Flips directional shapes (arrows, fans) for RTL layouts.
class RtlShapes {
  RtlShapes._();

  /// Flip a shape horizontally (mirror around x=0.5).
  static List<Offset> flipHorizontal(List<Offset> points) {
    return points.map((p) => Offset(1.0 - p.dx, p.dy)).toList();
  }

  /// Flip a shape vertically (mirror around y=0.5).
  static List<Offset> flipVertical(List<Offset> points) {
    return points.map((p) => Offset(p.dx, 1.0 - p.dy)).toList();
  }

  /// Returns the shape flipped for RTL if the current directionality is RTL.
  static List<Offset> directional(BuildContext context, List<Offset> ltrShape) {
    final direction = Directionality.of(context);
    if (direction == TextDirection.rtl) {
      return flipHorizontal(ltrShape);
    }
    return ltrShape;
  }

  /// Rotate shape by [turns] (0.25 = 90°, 0.5 = 180°, etc).
  static List<Offset> rotate(List<Offset> points, double turns) {
    final angle = turns * 2 * 3.14159265358979;
    final cos = _cos(angle);
    final sin = _sin(angle);
    return points.map((p) {
      final dx = p.dx - 0.5;
      final dy = p.dy - 0.5;
      return Offset(0.5 + dx * cos - dy * sin, 0.5 + dx * sin + dy * cos);
    }).toList();
  }

  /// Scale shape uniformly around center.
  static List<Offset> scale(List<Offset> points, double factor) {
    return points.map((p) {
      final dx = (p.dx - 0.5) * factor + 0.5;
      final dy = (p.dy - 0.5) * factor + 0.5;
      return Offset(dx, dy);
    }).toList();
  }

  // Avoid importing dart:math for these trivial functions
  static double _cos(double x) {
    // Taylor approximation sufficient for our needs
    double result = 1.0;
    double term = 1.0;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i - 1) * (2 * i));
      result += term;
    }
    return result;
  }

  static double _sin(double x) {
    double result = x;
    double term = x;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i) * (2 * i + 1));
      result += term;
    }
    return result;
  }
}
