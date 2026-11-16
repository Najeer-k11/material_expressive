import 'package:material_ui/material_ui.dart';

import '../theme/expressive_theme.dart';

/// M3 Expressive split button.
///
/// A single pill-shaped container with two sections:
/// - Left: main action with icon + label (rounded left)
/// - Right: dropdown trigger with chevron (rounded right)
/// - A 1px divider separates them inside the shared container
/// - Both share the same background color for a unified look
class ExpressiveSplitButton extends StatelessWidget {
  const ExpressiveSplitButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.onDropdown,
    this.icon,
    this.dropdownIcon = Icons.arrow_drop_down,
    this.borderRadius,
    @Deprecated('Use borderRadius instead. Will be removed in 1.0.0.')
    this._cornerRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 48,
  });

  final String label;
  final VoidCallback onPressed;
  final VoidCallback onDropdown;
  final IconData? icon;
  final IconData dropdownIcon;

  /// Corner radius of the outer ends. Defaults to the theme's `radius.xxl`.
  final double? borderRadius;

  final double? _cornerRadius;

  @Deprecated('Use borderRadius instead. Will be removed in 1.0.0.')
  double? get cornerRadius => borderRadius ?? _cornerRadius;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = backgroundColor ?? scheme.primaryContainer;
    final fg = foregroundColor ?? scheme.onPrimaryContainer;
    final tokens = ExpressiveTheme.of(context);
    final cornerRadius = borderRadius ?? _cornerRadius ?? tokens.radius.xxl;

    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cornerRadius),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main action — left side
            Material(
              color: bg,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(cornerRadius),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onPressed,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 20, color: fg),
                        SizedBox(width: tokens.spacing.sm),
                      ],
                      Text(
                        label,
                        style: TextStyle(
                          color: fg,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 1px divider
            Container(
              width: 1,
              height: height * 0.55,
              color: fg.withValues(alpha: 0.25),
            ),
            // Dropdown — right side
            Material(
              color: bg,
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(cornerRadius),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onDropdown,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Icon(dropdownIcon, size: 22, color: fg),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
