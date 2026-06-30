import 'package:flutter/material.dart';

/// An expressive action chip — pill/stadium shaped with icon + label.
///
/// Matches the M3 Expressive "Select", "Add photos", "Share album" style.
/// Full stadium border, tonal container, icon on the left.
class ExpressiveActionChip extends StatelessWidget {
  const ExpressiveActionChip({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bgColor = backgroundColor ?? scheme.secondaryContainer;
    final fgColor = foregroundColor ?? scheme.onSecondaryContainer;

    return Material(
      color: bgColor,
      elevation: elevation,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: fgColor),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  color: fgColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A vertical list of action chips (like the reference "Select / Add photos / Share album / Search" layout).
class ExpressiveActionChipList extends StatelessWidget {
  const ExpressiveActionChipList({
    super.key,
    required this.chips,
    this.spacing = 8,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.dismissible = false,
    this.onDismiss,
  });

  final List<ExpressiveActionChip> chips;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;
  final bool dismissible;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        ...chips.map(
          (chip) => Padding(
            padding: EdgeInsets.only(bottom: spacing),
            child: chip,
          ),
        ),
        if (dismissible)
          Material(
            color: scheme.surfaceContainerHighest,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onDismiss,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
