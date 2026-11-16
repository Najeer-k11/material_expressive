import 'dart:math' as math;

import 'package:flutter/physics.dart';
import 'package:material_ui/material_ui.dart';

/// A spring specification for physics-based animation.
class ExpressiveSpring {
  const ExpressiveSpring({
    required this.stiffness,
    required this.dampingRatio,
    this.mass = 1.0,
  });

  final double stiffness;
  final double dampingRatio;
  final double mass;

  /// Convert to Flutter's [SpringDescription].
  SpringDescription toSpringDescription() {
    final damping = dampingRatio * 2 * math.sqrt(stiffness * mass);
    return SpringDescription(
      mass: mass,
      stiffness: stiffness,
      damping: damping,
    );
  }

  /// Create a [SpringSimulation] targeting [target] from [start].
  SpringSimulation simulate({
    double start = 0,
    double target = 1,
    double velocity = 0,
  }) {
    return SpringSimulation(toSpringDescription(), start, target, velocity);
  }
}

/// Material 3 Expressive motion schemes.
///
/// Two predefined schemes:
/// - `standard` — for subtle transitions (nav, state changes)
/// - `expressive` — for hero interactions and prominent UI
class ExpressiveMotionScheme {
  const ExpressiveMotionScheme({
    required this.defaultSpatial,
    required this.fastSpatial,
    required this.slowSpatial,
    required this.defaultEffects,
    required this.fastEffects,
    required this.slowEffects,
  });

  /// Spring for spatial animations (position, size).
  final ExpressiveSpring defaultSpatial;
  final ExpressiveSpring fastSpatial;
  final ExpressiveSpring slowSpatial;

  /// Spring for effects (opacity, color, scale).
  final ExpressiveSpring defaultEffects;
  final ExpressiveSpring fastEffects;
  final ExpressiveSpring slowEffects;

  /// Standard motion scheme — subtle, functional.
  static const standard = ExpressiveMotionScheme(
    defaultSpatial: ExpressiveSpring(stiffness: 700, dampingRatio: 0.9),
    fastSpatial: ExpressiveSpring(stiffness: 1400, dampingRatio: 1.0),
    slowSpatial: ExpressiveSpring(stiffness: 300, dampingRatio: 0.9),
    defaultEffects: ExpressiveSpring(stiffness: 1600, dampingRatio: 1.0),
    fastEffects: ExpressiveSpring(stiffness: 3000, dampingRatio: 1.0),
    slowEffects: ExpressiveSpring(stiffness: 800, dampingRatio: 1.0),
  );

  /// Expressive motion scheme — bouncy, engaging, hero transitions.
  static const expressive = ExpressiveMotionScheme(
    defaultSpatial: ExpressiveSpring(stiffness: 380, dampingRatio: 0.73),
    fastSpatial: ExpressiveSpring(stiffness: 800, dampingRatio: 0.78),
    slowSpatial: ExpressiveSpring(stiffness: 200, dampingRatio: 0.7),
    defaultEffects: ExpressiveSpring(stiffness: 1200, dampingRatio: 0.8),
    fastEffects: ExpressiveSpring(stiffness: 2400, dampingRatio: 0.9),
    slowEffects: ExpressiveSpring(stiffness: 600, dampingRatio: 0.75),
  );
}

/// Extension to easily run spring animations on controllers.
extension ExpressiveSpringAnimation on AnimationController {
  /// Animate to [target] using spring physics.
  TickerFuture animateWithSpring(
    ExpressiveSpring spring, {
    double? from,
    double target = 1.0,
    double velocity = 0.0,
  }) {
    if (from != null) value = from;
    final simulation = spring.simulate(
      start: value,
      target: target,
      velocity: velocity,
    );
    return animateWith(simulation);
  }
}

/// A widget that applies spring-based animation to its child's properties.
class ExpressiveSpringTransition extends StatefulWidget {
  const ExpressiveSpringTransition({
    super.key,
    required this.child,
    this.isActive = false,
    this.spring,
    this.scaleActive = 1.0,
    this.scaleInactive = 1.0,
    this.offsetActive = Offset.zero,
    this.offsetInactive = Offset.zero,
  });

  final Widget child;
  final bool isActive;

  /// Defaults to [ExpressiveMotionScheme.expressive]'s `defaultSpatial`.
  final ExpressiveSpring? spring;

  ExpressiveSpring get _spring =>
      spring ?? ExpressiveMotionScheme.expressive.defaultSpatial;
  final double scaleActive;
  final double scaleInactive;
  final Offset offsetActive;
  final Offset offsetInactive;

  @override
  State<ExpressiveSpringTransition> createState() => _SpringTransitionState();
}

class _SpringTransitionState extends State<ExpressiveSpringTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      value: widget.isActive ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(ExpressiveSpringTransition old) {
    super.didUpdateWidget(old);
    if (widget.isActive != old.isActive) {
      _ctrl.animateWithSpring(
        widget._spring,
        target: widget.isActive ? 1.0 : 0.0,
      );
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final t = _ctrl.value;
        final scale =
            widget.scaleInactive +
            (widget.scaleActive - widget.scaleInactive) * t;
        final dx =
            widget.offsetInactive.dx +
            (widget.offsetActive.dx - widget.offsetInactive.dx) * t;
        final dy =
            widget.offsetInactive.dy +
            (widget.offsetActive.dy - widget.offsetInactive.dy) * t;
        return Transform.translate(
          offset: Offset(dx, dy),
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: widget.child,
    );
  }
}

// ---- Deprecated aliases (removed in 1.0.0) ----

@Deprecated('Use ExpressiveMotionScheme instead. Will be removed in 1.0.0.')
typedef MotionScheme = ExpressiveMotionScheme;

@Deprecated('Use ExpressiveSpringTransition instead. Will be removed in 1.0.0.')
typedef SpringTransition = ExpressiveSpringTransition;
