import 'package:flutter/material.dart';

/// A floating toolbar (M3 Expressive).
///
/// Appears as a pill-shaped floating bar with action icons,
/// typically anchored at the bottom of the screen.
class ExpressiveFloatingToolbar extends StatelessWidget {
  const ExpressiveFloatingToolbar({
    super.key,
    required this.items,
    this.elevation = 6,
    this.backgroundColor,
    this.borderRadius = 28,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  final List<FloatingToolbarItem> items;
  final double elevation;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bgColor = backgroundColor ?? scheme.surfaceContainerHigh;

    return Material(
      elevation: elevation,
      color: bgColor,
      borderRadius: BorderRadius.circular(borderRadius),
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
            return IconButton(
              onPressed: item.onPressed,
              icon: Icon(item.icon),
              tooltip: item.tooltip,
              color: item.isSelected ? scheme.primary : scheme.onSurfaceVariant,
              style: item.isSelected
                  ? IconButton.styleFrom(
                      backgroundColor: scheme.primaryContainer,
                    )
                  : null,
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
  });

  /// Creates a divider between toolbar items.
  const FloatingToolbarItem.divider()
    : icon = Icons.remove,
      onPressed = null,
      tooltip = null,
      isSelected = false;

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool isSelected;

  bool get isDivider => onPressed == null && tooltip == null && !isSelected;
}
