import 'package:flutter/material.dart';

/// A connected button group where the active button morphs to pill shape.
///
/// M3 Expressive style: buttons share a container, the selected one
/// "pops out" as a pill/stadium while others remain flat segments.
class ExpressiveButtonGroup extends StatelessWidget {
  const ExpressiveButtonGroup({
    super.key,
    required this.buttons,
    this.direction = Axis.horizontal,
    this.selectedIndex,
    this.onSelected,
    this.height = 44,
    this.backgroundColor,
    this.selectedColor,
    this.animationDuration = const Duration(milliseconds: 250),
  });

  final List<ExpressiveButtonGroupItem> buttons;
  final Axis direction;
  final int? selectedIndex;
  final ValueChanged<int>? onSelected;
  final double height;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bgColor = backgroundColor ?? scheme.surfaceContainerHigh;
    final selColor = selectedColor ?? scheme.primaryContainer;

    return Container(
      height: height,
      decoration: ShapeDecoration(color: bgColor, shape: const StadiumBorder()),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(buttons.length, (i) {
          final isSelected = selectedIndex == i;
          final item = buttons[i];

          return GestureDetector(
            onTap: () => onSelected?.call(i),
            child: AnimatedContainer(
              duration: animationDuration,
              curve: Curves.easeOut,
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 20 : 16,
                vertical: 4,
              ),
              decoration: isSelected
                  ? ShapeDecoration(
                      color: selColor,
                      shape: const StadiumBorder(),
                    )
                  : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.icon != null) ...[
                    Icon(
                      item.icon,
                      size: 18,
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
    );
  }
}

/// An item in an [ExpressiveButtonGroup].
class ExpressiveButtonGroupItem {
  const ExpressiveButtonGroupItem({required this.label, this.icon});

  final String label;
  final IconData? icon;
}
