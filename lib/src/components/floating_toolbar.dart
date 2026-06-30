import 'package:flutter/material.dart';

/// A floating toolbar with circular icon buttons in a pill container.
///
/// Matches the M3 Expressive toolbar pattern: icons sit in circles,
/// the selected/primary action gets an accent background.
class ExpressiveFloatingToolbar extends StatelessWidget {
  const ExpressiveFloatingToolbar({
    super.key,
    required this.items,
    this.elevation = 6,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  });

  final List<FloatingToolbarItem> items;
  final double elevation;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bgColor = backgroundColor ?? scheme.surfaceContainerHigh;

    return Material(
      elevation: elevation,
      color: bgColor,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: items.map((item) {
            if (item.isDivider) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: SizedBox(
                  height: 24,
                  child: VerticalDivider(
                    width: 1,
                    color: scheme.outlineVariant,
                  ),
                ),
              );
            }

            // Primary/accent item gets larger colored circle
            if (item.isPrimary) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Material(
                  color: scheme.primary,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: item.onPressed,
                    customBorder: const CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Icon(item.icon, size: 24, color: scheme.onPrimary),
                    ),
                  ),
                ),
              );
            }

            // Standard item — icon in subtle circle
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Material(
                color: item.isSelected
                    ? scheme.secondaryContainer
                    : Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: item.onPressed,
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      item.icon,
                      size: 22,
                      color: item.isSelected
                          ? scheme.onSecondaryContainer
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// An item in an [ExpressiveFloatingToolbar].
class FloatingToolbarItem {
  const FloatingToolbarItem({
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.isSelected = false,
    this.isPrimary = false,
  });

  /// Creates a divider between toolbar items.
  const FloatingToolbarItem.divider()
    : icon = Icons.remove,
      onPressed = null,
      tooltip = null,
      isSelected = false,
      isPrimary = false;

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool isSelected;

  /// Primary action (gets accent-colored larger circle).
  final bool isPrimary;

  bool get isDivider =>
      onPressed == null && tooltip == null && !isSelected && !isPrimary;
}
