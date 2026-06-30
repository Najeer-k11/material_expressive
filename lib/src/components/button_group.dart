import 'package:flutter/material.dart';

/// A group of connected buttons (M3 Expressive button group).
///
/// Not a wrapper — it uses standard Material buttons but arranges them
/// with connected shape theming (first/middle/last get different radii).
class ExpressiveButtonGroup extends StatelessWidget {
  const ExpressiveButtonGroup({
    super.key,
    required this.buttons,
    this.direction = Axis.horizontal,
    this.spacing = 0,
    this.borderRadius = 28,
    this.selectedIndex,
    this.onSelected,
  });

  /// List of button labels/children.
  final List<ExpressiveButtonGroupItem> buttons;
  final Axis direction;
  final double spacing;
  final double borderRadius;
  final int? selectedIndex;
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final children = <Widget>[];

    for (int i = 0; i < buttons.length; i++) {
      final isFirst = i == 0;
      final isLast = i == buttons.length - 1;
      final isSelected = selectedIndex == i;

      final radius = BorderRadius.only(
        topLeft: Radius.circular(isFirst ? borderRadius : 4),
        bottomLeft: Radius.circular(isFirst ? borderRadius : 4),
        topRight: Radius.circular(isLast ? borderRadius : 4),
        bottomRight: Radius.circular(isLast ? borderRadius : 4),
      );

      final item = buttons[i];
      children.add(
        Expanded(
          child: Material(
            color: isSelected
                ? scheme.secondaryContainer
                : scheme.surfaceContainerHigh,
            shape: RoundedRectangleBorder(borderRadius: radius),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => onSelected?.call(i),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.icon != null) ...[
                      Icon(
                        item.icon,
                        size: 18,
                        color: isSelected
                            ? scheme.onSecondaryContainer
                            : scheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      item.label,
                      style: TextStyle(
                        color: isSelected
                            ? scheme.onSecondaryContainer
                            : scheme.onSurfaceVariant,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      if (spacing > 0 && !isLast) {
        children.add(
          SizedBox(
            width: direction == Axis.horizontal ? spacing : 0,
            height: direction == Axis.vertical ? spacing : 0,
          ),
        );
      }
    }

    return direction == Axis.horizontal
        ? Row(mainAxisSize: MainAxisSize.min, children: children)
        : Column(mainAxisSize: MainAxisSize.min, children: children);
  }
}

/// An item in an [ExpressiveButtonGroup].
class ExpressiveButtonGroupItem {
  const ExpressiveButtonGroupItem({required this.label, this.icon});

  final String label;
  final IconData? icon;
}
