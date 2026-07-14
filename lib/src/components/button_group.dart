import 'package:flutter/material.dart';

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
    this.cornerRadius = 28,
    this.backgroundColor,
    this.selectedColor,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  final List<ExpressiveButtonGroupItem> buttons;
  final int? selectedIndex;
  final ValueChanged<int>? onSelected;
  final double height;
  final double cornerRadius;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Duration animationDuration;

  BorderRadius _radius(int i, bool isSelected) {
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
            final br = _radius(i, isSelected);
      
          return Semantics(
            selected: isSelected,
            label: item.label,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onSelected?.call(i),
                child: AnimatedContainer(
                  duration: animationDuration,
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    color: isSelected ? selColor : bgColor,
                    borderRadius: br,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 20 : 16,
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
