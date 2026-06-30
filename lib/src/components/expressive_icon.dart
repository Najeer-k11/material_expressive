import 'package:flutter/material.dart';
import '../tokens/shape_tokens.dart';
import '../shapes/shape_morph.dart';

/// Size variants for expressive icons.
enum ExpressiveIconSize {
  /// 20px icon, 32px container.
  small,

  /// 24px icon, 40px container.
  medium,

  /// 28px icon, 48px container.
  large,

  /// 36px icon, 64px container.
  extraLarge,
}

/// An icon wrapped in a shaped, colored container (M3 Expressive style).
///
/// This doesn't replace `Icon` — it presents any icon in the expressive
/// container style used across M3 Expressive (nav indicators, FABs, etc.)
class ExpressiveIcon extends StatelessWidget {
  const ExpressiveIcon(
    this.icon, {
    super.key,
    this.size = ExpressiveIconSize.medium,
    this.containerColor,
    this.iconColor,
    this.shape,
    this.shapeType = ExpressiveShapeType.rounded,
    this.filled = true,
    this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final ExpressiveIconSize size;
  final Color? containerColor;
  final Color? iconColor;

  /// Custom shape points. Overrides [shapeType] if provided.
  final List<Offset>? shape;
  final ExpressiveShapeType shapeType;
  final bool filled;
  final VoidCallback? onPressed;
  final String? tooltip;

  double get _iconSize {
    switch (size) {
      case ExpressiveIconSize.small:
        return 20;
      case ExpressiveIconSize.medium:
        return 24;
      case ExpressiveIconSize.large:
        return 28;
      case ExpressiveIconSize.extraLarge:
        return 36;
    }
  }

  double get _containerSize {
    switch (size) {
      case ExpressiveIconSize.small:
        return 32;
      case ExpressiveIconSize.medium:
        return 40;
      case ExpressiveIconSize.large:
        return 48;
      case ExpressiveIconSize.extraLarge:
        return 64;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bgColor = containerColor ?? scheme.primaryContainer;
    final fgColor = iconColor ?? scheme.onPrimaryContainer;

    final ShapeBorder shapeBorder;
    if (shape != null) {
      shapeBorder = MorphableShapeBorder(points: shape!);
    } else {
      final tokens = ExpressiveShapeTokens(type: shapeType);
      shapeBorder = tokens.shape(_containerSize * 0.45);
    }

    Widget child = Icon(icon, size: _iconSize, color: fgColor);

    if (filled) {
      child = Material(
        color: bgColor,
        shape: shapeBorder,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: _containerSize,
          height: _containerSize,
          child: Center(child: child),
        ),
      );
    }

    if (onPressed != null) {
      child = InkWell(
        onTap: onPressed,
        customBorder: shapeBorder,
        child: child,
      );
    }

    if (tooltip != null) {
      child = Tooltip(message: tooltip!, child: child);
    }

    return child;
  }
}

/// Applies expressive icon theme globally.
///
/// Use with [IconTheme] or set on [ThemeData.iconTheme].
class ExpressiveIconTheme {
  ExpressiveIconTheme._();

  /// Icon theme with M3 Expressive defaults.
  static IconThemeData expressive({
    required ColorScheme scheme,
    double size = 24,
    double? opticalSize,
  }) {
    return IconThemeData(
      color: scheme.onSurface,
      size: size,
      opticalSize: opticalSize ?? size,
      grade: 0,
      weight: 400,
      fill: 0,
    );
  }

  /// Filled icon variant (for selected states).
  static IconThemeData expressiveFilled({
    required ColorScheme scheme,
    double size = 24,
  }) {
    return IconThemeData(
      color: scheme.onPrimaryContainer,
      size: size,
      opticalSize: size,
      grade: 200,
      weight: 700,
      fill: 1,
    );
  }
}
