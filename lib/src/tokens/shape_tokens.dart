import 'dart:math' as math;

import 'package:flutter/painting.dart';

import 'radius_tokens.dart';

/// Shape category in the expressive design system.
enum ExpressiveShapeType { rounded, squircle, organic, full }

/// Shape tokens for the Expressive design system.
class ExpressiveShapeTokens {
  const ExpressiveShapeTokens({
    this.type = ExpressiveShapeType.rounded,
    this.radius = ExpressiveRadiusTokens.standard,
  });

  final ExpressiveShapeType type;

  /// Corner radii used by the [xs]..[xxl] getters.
  final ExpressiveRadiusTokens radius;

  /// A [ShapeBorder] of this [type] with the given corner radius.
  ShapeBorder shape(double cornerRadius) {
    switch (type) {
      case ExpressiveShapeType.rounded:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadius),
        );
      case ExpressiveShapeType.squircle:
        return ExpressiveSquircleBorder(radius: cornerRadius);
      case ExpressiveShapeType.organic:
        return ExpressiveOrganicBorder(radius: cornerRadius);
      case ExpressiveShapeType.full:
        return const StadiumBorder();
    }
  }

  ShapeBorder get xs => shape(radius.xs);
  ShapeBorder get sm => shape(radius.sm);
  ShapeBorder get md => shape(radius.md);
  ShapeBorder get lg => shape(radius.lg);
  ShapeBorder get xl => shape(radius.xl);
  ShapeBorder get xxl => shape(radius.xxl);
  ShapeBorder get full => const StadiumBorder();
}

/// Squircle (superellipse) border.
class ExpressiveSquircleBorder extends OutlinedBorder {
  const ExpressiveSquircleBorder({this.radius = 0, super.side});

  final double radius;

  @override
  ShapeBorder scale(double t) =>
      ExpressiveSquircleBorder(radius: radius * t, side: side.scale(t));

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _squirclePath(rect.deflate(side.width), radius);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _squirclePath(rect, radius);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none) return;
    canvas.drawPath(
      getOuterPath(rect, textDirection: textDirection),
      side.toPaint(),
    );
  }

  @override
  OutlinedBorder copyWith({BorderSide? side}) {
    return ExpressiveSquircleBorder(radius: radius, side: side ?? this.side);
  }

  static Path _squirclePath(Rect rect, double radius) {
    final r = math.min(radius, math.min(rect.width, rect.height) / 2);
    final path = Path();
    final cx = rect.center.dx;
    final cy = rect.center.dy;
    final hw = rect.width / 2;
    final hh = rect.height / 2;
    const smoothness = 0.6;
    final sr = r * smoothness;

    path.moveTo(cx, rect.top);
    path.cubicTo(
      cx + hw - sr,
      rect.top,
      rect.right,
      cy - hh + sr,
      rect.right,
      cy,
    );
    path.cubicTo(
      rect.right,
      cy + hh - sr,
      cx + hw - sr,
      rect.bottom,
      cx,
      rect.bottom,
    );
    path.cubicTo(
      cx - hw + sr,
      rect.bottom,
      rect.left,
      cy + hh - sr,
      rect.left,
      cy,
    );
    path.cubicTo(rect.left, cy - hh + sr, cx - hw + sr, rect.top, cx, rect.top);
    path.close();
    return path;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpressiveSquircleBorder &&
          radius == other.radius &&
          side == other.side;

  @override
  int get hashCode => Object.hash(radius, side);
}

/// Organic blob-like border shape.
class ExpressiveOrganicBorder extends OutlinedBorder {
  const ExpressiveOrganicBorder({this.radius = 0, super.side});

  final double radius;

  @override
  ShapeBorder scale(double t) =>
      ExpressiveOrganicBorder(radius: radius * t, side: side.scale(t));

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _organicPath(rect.deflate(side.width), radius);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _organicPath(rect, radius);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none) return;
    canvas.drawPath(
      getOuterPath(rect, textDirection: textDirection),
      side.toPaint(),
    );
  }

  @override
  OutlinedBorder copyWith({BorderSide? side}) {
    return ExpressiveOrganicBorder(radius: radius, side: side ?? this.side);
  }

  static Path _organicPath(Rect rect, double radius) {
    final path = Path();
    final w = rect.width;
    final h = rect.height;
    final l = rect.left;
    final t = rect.top;
    final factor = math.min(radius / 28.0, 1.0);
    final offset = factor * math.min(w, h) * 0.06;

    path.moveTo(l + w * 0.5, t);
    path.cubicTo(
      l + w * 0.75 + offset,
      t - offset * 0.3,
      l + w + offset * 0.3,
      t + h * 0.25 - offset,
      l + w,
      t + h * 0.5,
    );
    path.cubicTo(
      l + w + offset * 0.2,
      t + h * 0.75 + offset * 0.5,
      l + w * 0.75 + offset * 0.5,
      t + h + offset * 0.2,
      l + w * 0.5,
      t + h,
    );
    path.cubicTo(
      l + w * 0.25 - offset * 0.5,
      t + h + offset * 0.3,
      l - offset * 0.3,
      t + h * 0.75 + offset,
      l,
      t + h * 0.5,
    );
    path.cubicTo(
      l - offset * 0.2,
      t + h * 0.25 - offset * 0.5,
      l + w * 0.25 - offset,
      t - offset * 0.2,
      l + w * 0.5,
      t,
    );
    path.close();
    return path;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpressiveOrganicBorder &&
          radius == other.radius &&
          side == other.side;

  @override
  int get hashCode => Object.hash(radius, side);
}

// ---- Deprecated aliases (removed in 1.0.0) ----

@Deprecated('Use ExpressiveSquircleBorder instead. Will be removed in 1.0.0.')
typedef SquircleBorder = ExpressiveSquircleBorder;

@Deprecated('Use ExpressiveOrganicBorder instead. Will be removed in 1.0.0.')
typedef OrganicBorder = ExpressiveOrganicBorder;
