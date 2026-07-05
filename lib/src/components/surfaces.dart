import 'package:flutter/material.dart';

/// Semantic surface types.
enum ExpressiveSurfaceType {
  surface,
  containerLow,
  container,
  containerHigh,
  primaryTinted,
  secondaryTinted,
  tertiaryTinted,
}

/// A semantic surface widget.
class ExpressiveSurface extends StatelessWidget {
  const ExpressiveSurface({
    super.key,
    required this.child,
    this.type = ExpressiveSurfaceType.container,
    this.borderRadius,
    this.padding,
    this.elevation = 0,
  });

  final Widget child;
  final ExpressiveSurfaceType type;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double elevation;

  Color _resolveColor(ColorScheme scheme) {
    switch (type) {
      case ExpressiveSurfaceType.surface:
        return scheme.surface;
      case ExpressiveSurfaceType.containerLow:
        return scheme.surfaceContainerLow;
      case ExpressiveSurfaceType.container:
        return scheme.surfaceContainer;
      case ExpressiveSurfaceType.containerHigh:
        return scheme.surfaceContainerHigh;
      case ExpressiveSurfaceType.primaryTinted:
        return Color.lerp(scheme.surface, scheme.primaryContainer, 0.15)!;
      case ExpressiveSurfaceType.secondaryTinted:
        return Color.lerp(scheme.surface, scheme.secondaryContainer, 0.15)!;
      case ExpressiveSurfaceType.tertiaryTinted:
        return Color.lerp(scheme.surface, scheme.tertiaryContainer, 0.15)!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final resolvedRadius = borderRadius ?? BorderRadius.circular(16);
    final textDirection = Directionality.maybeOf(context);
    final resolvedBorderRadius = resolvedRadius.resolve(textDirection);
    return Material(
      color: _resolveColor(scheme),
      elevation: elevation,
      borderRadius: resolvedBorderRadius,
      clipBehavior: Clip.antiAlias,
      child: padding != null ? Padding(padding: padding!, child: child) : child,
    );
  }
}
