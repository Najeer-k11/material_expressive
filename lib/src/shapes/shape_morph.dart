import 'package:flutter/material.dart';

/// Builds a smooth closed path through points using Catmull-Rom spline.
Path _smoothPath(List<Offset> points, Size size) {
  final scaled = points
      .map((p) => Offset(p.dx * size.width, p.dy * size.height))
      .toList();
  return _smoothPathFromScaled(scaled);
}

/// Builds a smooth closed path from already-scaled points.
Path _smoothPathFromScaled(List<Offset> pts) {
  if (pts.length < 3) {
    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 1; i < pts.length; i++) {
      path.lineTo(pts[i].dx, pts[i].dy);
    }
    path.close();
    return path;
  }

  final path = Path();
  final n = pts.length;

  // Catmull-Rom to cubic bezier conversion
  path.moveTo(pts[0].dx, pts[0].dy);
  for (int i = 0; i < n; i++) {
    final p0 = pts[(i - 1 + n) % n];
    final p1 = pts[i];
    final p2 = pts[(i + 1) % n];
    final p3 = pts[(i + 2) % n];

    // Control points from Catmull-Rom
    final cp1x = p1.dx + (p2.dx - p0.dx) / 6;
    final cp1y = p1.dy + (p2.dy - p0.dy) / 6;
    final cp2x = p2.dx - (p3.dx - p1.dx) / 6;
    final cp2y = p2.dy - (p3.dy - p1.dy) / 6;

    path.cubicTo(cp1x, cp1y, cp2x, cp2y, p2.dx, p2.dy);
  }
  path.close();
  return path;
}

/// Interpolates between two shape point lists.
List<Offset> lerpShapePoints(List<Offset> a, List<Offset> b, double t) {
  // Ensure same length by resampling
  final targetLen = a.length > b.length ? a.length : b.length;
  final aa = _resample(a, targetLen);
  final bb = _resample(b, targetLen);
  return List.generate(targetLen, (i) => Offset.lerp(aa[i], bb[i], t)!);
}

List<Offset> _resample(List<Offset> points, int count) {
  if (points.length == count) return points;
  final result = <Offset>[];
  for (int i = 0; i < count; i++) {
    final t = i / count * points.length;
    final idx = t.floor() % points.length;
    final frac = t - t.floor();
    final p1 = points[idx];
    final p2 = points[(idx + 1) % points.length];
    result.add(
      Offset(p1.dx + (p2.dx - p1.dx) * frac, p1.dy + (p2.dy - p1.dy) * frac),
    );
  }
  return result;
}

/// A widget that morphs between two MaterialShapes with animation.
class ShapeMorph extends StatefulWidget {
  const ShapeMorph({
    super.key,
    required this.shape,
    this.size = 64,
    this.color,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
    this.child,
    this.border,
  });

  /// Target shape points (use MaterialShapes.circle, etc).
  final List<Offset> shape;
  final double size;
  final Color? color;
  final Duration duration;
  final Curve curve;
  final Widget? child;
  final BorderSide? border;

  @override
  State<ShapeMorph> createState() => _ShapeMorphState();
}

class _ShapeMorphState extends State<ShapeMorph>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late List<Offset> _fromShape;
  late List<Offset> _toShape;

  @override
  void initState() {
    super.initState();
    _fromShape = widget.shape;
    _toShape = widget.shape;
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
  }

  @override
  void didUpdateWidget(ShapeMorph old) {
    super.didUpdateWidget(old);
    if (widget.shape != old.shape) {
      _fromShape = _currentPoints();
      _toShape = widget.shape;
      _controller.forward(from: 0);
    }
  }

  List<Offset> _currentPoints() {
    return lerpShapePoints(_fromShape, _toShape, _animation.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final points = lerpShapePoints(
            _fromShape,
            _toShape,
            _animation.value,
          );
          return CustomPaint(
            painter: _ShapePainter(
              points: points,
              color: color,
              border: widget.border,
            ),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

class _ShapePainter extends CustomPainter {
  _ShapePainter({required this.points, required this.color, this.border});

  final List<Offset> points;
  final Color color;
  final BorderSide? border;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final path = _smoothPath(points, size);
    canvas.drawPath(path, Paint()..color = color);

    if (border != null && border!.style != BorderStyle.none) {
      canvas.drawPath(
        path,
        Paint()
          ..color = border!.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = border!.width,
      );
    }
  }

  @override
  bool shouldRepaint(_ShapePainter old) =>
      points != old.points || color != old.color;
}

/// A ShapeBorder that renders any MaterialShapes polygon.
class MorphableShapeBorder extends OutlinedBorder {
  const MorphableShapeBorder({required this.points, super.side});

  final List<Offset> points;

  @override
  ShapeBorder scale(double t) => this;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _buildPath(rect.deflate(side.width));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _buildPath(rect);
  }

  Path _buildPath(Rect rect) {
    if (points.isEmpty) return Path()..addRect(rect);
    // Scale points to rect
    final scaled = points
        .map(
          (p) => Offset(
            rect.left + p.dx * rect.width,
            rect.top + p.dy * rect.height,
          ),
        )
        .toList();
    return _smoothPathFromScaled(scaled);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none) return;
    canvas.drawPath(getOuterPath(rect), side.toPaint());
  }

  @override
  OutlinedBorder copyWith({BorderSide? side}) =>
      MorphableShapeBorder(points: points, side: side ?? this.side);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MorphableShapeBorder &&
          points == other.points &&
          side == other.side;

  @override
  int get hashCode => Object.hash(points, side);
}
