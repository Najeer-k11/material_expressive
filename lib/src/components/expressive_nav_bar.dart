import 'package:flutter/material.dart';
import '../shapes/material_shapes.dart';
import '../shapes/shape_morph.dart';
import '../motion/motion_scheme.dart';

/// Expressive navigation bar with shape-morphing indicator.
///
/// The selected item's indicator morphs shape on selection change
/// using spring physics.
class ExpressiveNavBarTheme {
  ExpressiveNavBarTheme._();

  /// Creates a NavigationBarThemeData with shape-morphing indicators.
  static NavigationBarThemeData morphing({
    required ColorScheme scheme,
    List<Offset> selectedShape = const [],
    List<Offset> unselectedShape = const [],
    double height = 88,
  }) {
    return NavigationBarThemeData(
      height: height,
      elevation: 0,
      backgroundColor: scheme.surfaceContainer,
      indicatorColor: scheme.secondaryContainer,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: scheme.onSecondaryContainer, size: 24);
        }
        return IconThemeData(color: scheme.onSurfaceVariant, size: 24);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          );
        }
        return TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: scheme.onSurfaceVariant,
        );
      }),
    );
  }
}

/// A widget that wraps a child with shape-morphing on state change.
///
/// Use this to make any widget morph shape when selected/pressed.
class StateMorphContainer extends StatefulWidget {
  const StateMorphContainer({
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
  State<StateMorphContainer> createState() => _StateMorphContainerState();
}

class _StateMorphContainerState extends State<StateMorphContainer>
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
  void didUpdateWidget(StateMorphContainer old) {
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
    final activeShape = widget.activeShape ?? MaterialShapes.circle;
    final inactiveShape = widget.inactiveShape ?? MaterialShapes.square;
    final activeColor = widget.activeColor ?? scheme.primaryContainer;
    final inactiveColor = widget.inactiveColor ?? scheme.surfaceContainerHigh;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final t = _ctrl.value;
        final points = lerpShapePoints(inactiveShape, activeShape, t);
        final color = Color.lerp(inactiveColor, activeColor, t)!;

        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: color,
              shape: MorphableShapeBorder(points: points),
            ),
            child: child,
          ),
        );
      },
      child: Center(child: widget.child),
    );
  }
}
