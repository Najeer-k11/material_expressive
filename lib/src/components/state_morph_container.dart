import 'package:material_ui/material_ui.dart';

import '../motion/motion_scheme.dart';
import '../shapes/expressive_shapes.dart';
import '../shapes/shape_morph.dart';

/// A widget that wraps a child with shape-morphing on state change.
///
/// Use this to make any widget morph shape when selected/pressed.
class ExpressiveStateMorphContainer extends StatefulWidget {
  const ExpressiveStateMorphContainer({
    super.key,
    required this.child,
    required this.isActive,
    this.activeShape,
    this.inactiveShape,
    this.activeColor,
    this.inactiveColor,
    this.size = 56,
    this.duration = const Duration(milliseconds: 400),
    this.spring,
  });

  final Widget child;
  final bool isActive;
  final List<Offset>? activeShape;
  final List<Offset>? inactiveShape;
  final Color? activeColor;
  final Color? inactiveColor;
  final double size;
  final Duration duration;
  final ExpressiveSpring? spring;

  @override
  State<ExpressiveStateMorphContainer> createState() =>
      _StateMorphContainerState();
}

class _StateMorphContainerState extends State<ExpressiveStateMorphContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: widget.isActive ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(ExpressiveStateMorphContainer old) {
    super.didUpdateWidget(old);
    if (widget.isActive != old.isActive) {
      if (widget.spring != null) {
        _ctrl.animateWithSpring(
          widget.spring!,
          target: widget.isActive ? 1.0 : 0.0,
        );
      } else {
        if (widget.isActive) {
          _ctrl.forward();
        } else {
          _ctrl.reverse();
        }
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final activeShape = widget.activeShape ?? ExpressiveShapes.circle;
    final inactiveShape = widget.inactiveShape ?? ExpressiveShapes.square;
    final activeColor = widget.activeColor ?? scheme.primaryContainer;
    final inactiveColor = widget.inactiveColor ?? scheme.surfaceContainerHigh;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final t = _ctrl.value;
        final points = ExpressiveShapes.lerp(inactiveShape, activeShape, t);
        final color = Color.lerp(inactiveColor, activeColor, t)!;

        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: color,
              shape: ExpressiveMorphableShapeBorder(points: points),
            ),
            child: child,
          ),
        );
      },
      child: Center(child: widget.child),
    );
  }
}

// ---- Deprecated aliases (removed in 1.0.0) ----

@Deprecated(
  'Use ExpressiveStateMorphContainer instead. Will be removed in 1.0.0.',
)
typedef StateMorphContainer = ExpressiveStateMorphContainer;
