import 'package:flutter/material.dart';
import '../shapes/shape_morph.dart';
import '../shapes/material_shapes.dart';

/// A container transform that morphs shape during the transition.
class ShapeContainerTransform extends StatefulWidget {
  const ShapeContainerTransform({
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
  State<ShapeContainerTransform> createState() =>
      _ShapeContainerTransformState();
}

class _ShapeContainerTransformState extends State<ShapeContainerTransform> {
  void _open() {
    Navigator.of(context).push(
      _ShapeTransformRoute(
        closedShape: widget.closedShape ?? MaterialShapes.circle,
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
    final shape = widget.closedShape ?? MaterialShapes.circle;
    return SizedBox(
      width: widget.closedSize,
      height: widget.closedSize,
      child: Material(
        color: color,
        shape: MorphableShapeBorder(points: shape),
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
               final points = lerpShapePoints(
                 closedShape,
                 MaterialShapes.square,
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
    final path = Path();
    if (points.isEmpty) return path..addRect(Offset.zero & size);
    path.moveTo(points[0].dx * size.width, points[0].dy * size.height);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx * size.width, points[i].dy * size.height);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_ShapeClipper old) => points != old.points;
}
