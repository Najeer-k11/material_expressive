import 'package:material_ui/material_ui.dart';

import '../tokens/shape_tokens.dart';
import '../shapes/shape_morph.dart';
import 'expressive_component_themes.dart';

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
    this.backgroundColor,
    this.foregroundColor,
    @Deprecated('Use backgroundColor instead. Will be removed in 1.0.0.')
    this._containerColor,
    @Deprecated('Use foregroundColor instead. Will be removed in 1.0.0.')
    this._iconColor,
    this.shape,
    this.shapeType = ExpressiveShapeType.rounded,
    this.filled = true,
    this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final ExpressiveIconSize size;

  /// Container color. Defaults to `primaryContainer`.
  final Color? backgroundColor;

  /// Icon color. Defaults to `onPrimaryContainer`.
  final Color? foregroundColor;

  final Color? _containerColor;
  final Color? _iconColor;

  @Deprecated('Use backgroundColor instead. Will be removed in 1.0.0.')
  Color? get containerColor => backgroundColor ?? _containerColor;

  @Deprecated('Use foregroundColor instead. Will be removed in 1.0.0.')
  Color? get iconColor => foregroundColor ?? _iconColor;

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
    final bgColor =
        backgroundColor ?? _containerColor ?? scheme.primaryContainer;
    final fgColor = foregroundColor ?? _iconColor ?? scheme.onPrimaryContainer;

    final ShapeBorder shapeBorder;
    if (shape != null) {
      shapeBorder = ExpressiveMorphableShapeBorder(points: shape!);
    } else {
      final tokens = ExpressiveShapeTokens(type: shapeType);
      shapeBorder = tokens.shape(_containerSize * 0.45);
    }

    Widget child = Icon(icon, size: _iconSize, color: fgColor);

    if (onPressed != null) {
      child = Material(
        color: filled ? bgColor : Colors.transparent,
        shape: shapeBorder,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          customBorder: shapeBorder,
          child: SizedBox(
            width: _containerSize,
            height: _containerSize,
            child: Center(child: child),
          ),
        ),
      );
    } else if (filled) {
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

    if (tooltip != null) {
      child = Tooltip(message: tooltip!, child: child);
    }

    return child;
  }
}

/// Deprecated: use [ExpressiveComponentThemes.iconTheme].
@Deprecated(
  'Use ExpressiveComponentThemes.iconTheme instead. Will be removed in 1.0.0.',
)
class ExpressiveIconTheme {
  ExpressiveIconTheme._();

  static IconThemeData expressive({
    required ColorScheme scheme,
    double size = 24,
    double? opticalSize,
  }) => ExpressiveComponentThemes.iconTheme(
    scheme: scheme,
    size: size,
    opticalSize: opticalSize,
  );

  static IconThemeData expressiveFilled({
    required ColorScheme scheme,
    double size = 24,
  }) => ExpressiveComponentThemes.iconTheme(
    scheme: scheme,
    size: size,
    filled: true,
  );
}
