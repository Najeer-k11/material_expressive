import 'package:flutter/material.dart';
import 'motion_scheme.dart';

/// A widget that responds to drag gestures with spring physics.
///
/// Fling velocity feeds into the spring simulation for natural
/// release behavior.
class GestureSpringBox extends StatefulWidget {
  const GestureSpringBox({
    super.key,
    required this.child,
    this.spring = const ExpressiveSpring(stiffness: 380, dampingRatio: 0.73),
    this.axis = Axis.vertical,
    this.maxOffset = 100,
    this.onFling,
    this.snapBack = true,
  });

  final Widget child;
  final ExpressiveSpring spring;
  final Axis axis;
  final double maxOffset;
  final ValueChanged<double>? onFling;
  final bool snapBack;

  @override
  State<GestureSpringBox> createState() => _GestureSpringBoxState();
}

class _GestureSpringBoxState extends State<GestureSpringBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  double _dragOffset = 0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController.unbounded(vsync: this);
    _ctrl.addListener(() {
      if (!_isDragging) {
        setState(() => _dragOffset = _ctrl.value);
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      final delta = widget.axis == Axis.vertical
          ? details.delta.dy
          : details.delta.dx;
      _dragOffset = (_dragOffset + delta).clamp(
        -widget.maxOffset,
        widget.maxOffset,
      );
    });
  }

  void _onDragEnd(DragEndDetails details) {
    _isDragging = false;
    final velocity = widget.axis == Axis.vertical
        ? details.velocity.pixelsPerSecond.dy
        : details.velocity.pixelsPerSecond.dx;

    widget.onFling?.call(velocity);

    if (widget.snapBack) {
      final simulation = widget.spring.simulate(
        start: _dragOffset,
        target: 0,
        velocity: velocity,
      );
      _ctrl.animateWith(simulation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final offset = widget.axis == Axis.vertical
        ? Offset(0, _dragOffset)
        : Offset(_dragOffset, 0);

    return GestureDetector(
      onVerticalDragStart: widget.axis == Axis.vertical
          ? (_) => _isDragging = true
          : null,
      onVerticalDragUpdate: widget.axis == Axis.vertical ? _onDragUpdate : null,
      onVerticalDragEnd: widget.axis == Axis.vertical ? _onDragEnd : null,
      onHorizontalDragStart: widget.axis == Axis.horizontal
          ? (_) => _isDragging = true
          : null,
      onHorizontalDragUpdate: widget.axis == Axis.horizontal
          ? _onDragUpdate
          : null,
      onHorizontalDragEnd: widget.axis == Axis.horizontal ? _onDragEnd : null,
      child: Transform.translate(offset: offset, child: widget.child),
    );
  }
}
