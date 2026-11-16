import 'package:material_ui/material_ui.dart';

import '../shapes/shape_morph.dart';
import '../shapes/expressive_shapes.dart';

/// A container transform that morphs shape during the transition.
class ExpressiveShapeContainerTransform extends StatefulWidget {
  const ExpressiveShapeContainerTransform({
    super.key,
    required this.closedBuilder,
    required this.openBuilder,
    this.closedShape,
    this.closedSize = 56,
    this.closedColor,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
  });

  final Widget Function(BuildContext context, VoidCallback open) closedBuilder;
  final Widget Function(BuildContext context, VoidCallback close) openBuilder;
  final List<Offset>? closedShape;
  final double closedSize;
  final Color? closedColor;
  final Duration duration;
  final Curve curve;

  @override
  State<ExpressiveShapeContainerTransform> createState() =>
      _ShapeContainerTransformState();
}

class _ShapeContainerTransformState
    extends State<ExpressiveShapeContainerTransform> {
  void _open() {
    Navigator.of(context).push(
      _ShapeTransformRoute(
        closedShape: widget.closedShape ?? ExpressiveShapes.circle,
        openBuilder: widget.openBuilder,
        duration: widget.duration,
        curve: widget.curve,
        closedColor:
            widget.closedColor ??
            Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color =
        widget.closedColor ?? Theme.of(context).colorScheme.primaryContainer;
    final shape = widget.closedShape ?? ExpressiveShapes.circle;
    return SizedBox(
      width: widget.closedSize,
      height: widget.closedSize,
      child: Material(
        color: color,
        shape: ExpressiveMorphableShapeBorder(points: shape),
        clipBehavior: Clip.antiAlias,
        child: widget.closedBuilder(context, _open),
      ),
    );
  }
}

class _ShapeTransformRoute extends PageRouteBuilder<void> {
  _ShapeTransformRoute({
    required this.closedShape,
    required this.openBuilder,
    required Duration duration,
    required Curve curve,
    required this.closedColor,
  }) : super(
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         pageBuilder: (context, anim, secondaryAnim) =>
             openBuilder(context, () => Navigator.of(context).pop()),
         transitionsBuilder: (context, anim, secondaryAnim, child) {
           final curvedAnim = CurvedAnimation(parent: anim, curve: curve);
           return AnimatedBuilder(
             animation: curvedAnim,
             builder: (context, _) {
               final points = ExpressiveShapes.lerp(
                 closedShape,
                 ExpressiveShapes.square,
                 curvedAnim.value,
               );
               return ClipPath(
                 clipper: _ShapeClipper(points),
                 child: FadeTransition(opacity: curvedAnim, child: child),
               );
             },
           );
         },
       );

  final List<Offset> closedShape;
  final Widget Function(BuildContext, VoidCallback) openBuilder;
  final Color closedColor;
}

class _ShapeClipper extends CustomClipper<Path> {
  _ShapeClipper(this.points);
  final List<Offset> points;

  @override
  Path getClip(Size size) {
    if (points.isEmpty) return Path()..addRect(Offset.zero & size);
    final scaled = points
        .map((p) => Offset(p.dx * size.width, p.dy * size.height))
        .toList();
    return ExpressiveShapes.smoothPath(scaled);
  }

  @override
  bool shouldReclip(_ShapeClipper old) => points != old.points;
}

// ---- Deprecated aliases (removed in 1.0.0) ----

@Deprecated(
  'Use ExpressiveShapeContainerTransform instead. Will be removed in 1.0.0.',
)
typedef ShapeContainerTransform = ExpressiveShapeContainerTransform;
