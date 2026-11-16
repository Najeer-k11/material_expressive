import 'package:material_ui/material_ui.dart';

import '../theme/expressive_theme.dart';

/// M3 Expressive connected button group.
///
/// Rules:
/// - Outer container is a pill (stadium)
/// - Left button: rounded left corners only (28px), square right
/// - Middle buttons: square on both sides
/// - Right button: square left corners, rounded right corners (28px)
/// - Active button overrides to FULLY rounded (all 4 corners = 28px)
///   and fills with selectedColor
class ExpressiveButtonGroup extends StatelessWidget {
  const ExpressiveButtonGroup({
    super.key,
    required this.buttons,
    this.selectedIndex,
    this.onSelected,
    this.height = 48,
    this.borderRadius,
    @Deprecated('Use borderRadius instead. Will be removed in 1.0.0.')
    this._cornerRadius,
    this.backgroundColor,
    this.selectedColor,
    this.duration,
    @Deprecated('Use duration instead. Will be removed in 1.0.0.')
    this._animationDuration,
  });

  final List<ExpressiveButtonGroupItem> buttons;
  final int? selectedIndex;
  final ValueChanged<int>? onSelected;
  final double height;

  /// Corner radius of the group ends. Defaults to the theme's `radius.xxl`.
  final double? borderRadius;

  final double? _cornerRadius;

  @Deprecated('Use borderRadius instead. Will be removed in 1.0.0.')
  double? get cornerRadius => borderRadius ?? _cornerRadius;

  final Color? backgroundColor;
  final Color? selectedColor;

  /// Selection animation duration. Defaults to the theme's
  /// `motion.durationShort`.
  final Duration? duration;

  final Duration? _animationDuration;

  @Deprecated('Use duration instead. Will be removed in 1.0.0.')
  Duration? get animationDuration => duration ?? _animationDuration;

  BorderRadius _radius(int i, bool isSelected, double cornerRadius) {
    if (isSelected) {
      return BorderRadius.circular(cornerRadius);
    }
    final n = buttons.length;
    if (n == 1) return BorderRadius.circular(cornerRadius);
    if (i == 0) {
      return BorderRadius.horizontal(left: Radius.circular(cornerRadius));
    }
    if (i == n - 1) {
      return BorderRadius.horizontal(right: Radius.circular(cornerRadius));
    }
    return BorderRadius.zero;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bgColor = backgroundColor ?? scheme.surfaceContainerHigh;
    final selColor = selectedColor ?? scheme.primaryContainer;
    final tokens = ExpressiveTheme.of(context);
    final cornerRadius = borderRadius ?? _cornerRadius ?? tokens.radius.xxl;
    final animDuration =
        duration ?? _animationDuration ?? tokens.motion.durationShort;

    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cornerRadius),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(buttons.length, (i) {
            final isSelected = selectedIndex == i;
            final item = buttons[i];
            final br = _radius(i, isSelected, cornerRadius);

            return GestureDetector(
              onTap: () => onSelected?.call(i),
              child: AnimatedContainer(
                duration: animDuration,
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  color: isSelected ? selColor : bgColor,
                  borderRadius: br,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 20 : tokens.spacing.lg,
                  vertical: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.icon != null) ...[
                      Icon(
                        item.icon,
                        size: 17,
                        color: isSelected
                            ? scheme.onPrimaryContainer
                            : scheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      item.label,
                      style: TextStyle(
                        color: isSelected
                            ? scheme.onPrimaryContainer
                            : scheme.onSurfaceVariant,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class ExpressiveButtonGroupItem {
  const ExpressiveButtonGroupItem({required this.label, this.icon});

  final String label;
  final IconData? icon;
}
