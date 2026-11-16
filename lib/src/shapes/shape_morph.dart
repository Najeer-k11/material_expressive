import 'package:material_ui/material_ui.dart';

import 'expressive_shapes.dart';

/// Builds a smooth closed path through points using Catmull-Rom spline.
Path _smoothPath(List<Offset> points, Size size) {
  final scaled = points
      .map((p) => Offset(p.dx * size.width, p.dy * size.height))
      .toList();
  return ExpressiveShapes.smoothPath(scaled);
}

/// Deprecated: use [ExpressiveShapes.smoothPath].
@Deprecated(
  'Use ExpressiveShapes.smoothPath instead. Will be removed in 1.0.0.',
)
Path smoothPathFromScaled(List<Offset> pts) => ExpressiveShapes.smoothPath(pts);

/// Deprecated: use [ExpressiveShapes.lerp].
@Deprecated('Use ExpressiveShapes.lerp instead. Will be removed in 1.0.0.')
List<Offset> lerpShapePoints(List<Offset> a, List<Offset> b, double t) =>
    ExpressiveShapes.lerp(a, b, t);

/// A widget that morphs between two ExpressiveShapes with animation.
class ExpressiveShapeMorph extends StatefulWidget {
  const ExpressiveShapeMorph({
    super.key,
    required this.shape,
    this.size = 64,
    this.color,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
    this.child,
    this.border,
  });

  /// Target shape points (use ExpressiveShapes.circle, etc).
  final List<Offset> shape;
  final double size;
  final Color? color;
  final Duration duration;
  final Curve curve;
  final Widget? child;
  final BorderSide? border;

  @override
  State<ExpressiveShapeMorph> createState() => _ShapeMorphState();
}

class _ShapeMorphState extends State<ExpressiveShapeMorph>
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
  void didUpdateWidget(ExpressiveShapeMorph old) {
    super.didUpdateWidget(old);
    if (widget.shape != old.shape) {
      _fromShape = _currentPoints();
      _toShape = widget.shape;
      _controller.forward(from: 0);
    }
  }

  List<Offset> _currentPoints() {
    return ExpressiveShapes.lerp(_fromShape, _toShape, _animation.value);
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
          final points = ExpressiveShapes.lerp(
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

/// A ShapeBorder that renders any ExpressiveShapes polygon.
class ExpressiveMorphableShapeBorder extends OutlinedBorder {
  const ExpressiveMorphableShapeBorder({required this.points, super.side});

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
    return ExpressiveShapes.smoothPath(scaled);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none) return;
    canvas.drawPath(getOuterPath(rect), side.toPaint());
  }

  @override
  OutlinedBorder copyWith({BorderSide? side}) =>
      ExpressiveMorphableShapeBorder(points: points, side: side ?? this.side);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpressiveMorphableShapeBorder &&
          points == other.points &&
          side == other.side;

  @override
  int get hashCode => Object.hash(points, side);
}

// ---- Deprecated aliases (removed in 1.0.0) ----

@Deprecated('Use ExpressiveShapeMorph instead. Will be removed in 1.0.0.')
typedef ShapeMorph = ExpressiveShapeMorph;

@Deprecated(
  'Use ExpressiveMorphableShapeBorder instead. Will be removed in 1.0.0.',
)
typedef MorphableShapeBorder = ExpressiveMorphableShapeBorder;
