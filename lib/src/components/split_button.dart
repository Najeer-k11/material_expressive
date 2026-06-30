import 'package:flutter/material.dart';

/// A split button — primary action + dropdown trigger (M3 Expressive).
///
/// Renders as two connected sections: main action and a trailing
/// icon button for secondary options.
class ExpressiveSplitButton extends StatelessWidget {
  const ExpressiveSplitButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.onDropdown,
    this.icon,
    this.dropdownIcon = Icons.arrow_drop_down,
    this.borderRadius = 28,
  });

  final String label;
  final VoidCallback onPressed;
  final VoidCallback onDropdown;
  final IconData? icon;
  final IconData dropdownIcon;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.labelLarge;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Primary action
        Material(
          color: scheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              bottomLeft: Radius.circular(borderRadius),
              topRight: const Radius.circular(4),
              bottomRight: const Radius.circular(4),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18, color: scheme.onPrimary),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: textStyle?.copyWith(color: scheme.onPrimary),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 1),
        // Dropdown trigger
        Material(
          color: scheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(4),
              bottomLeft: const Radius.circular(4),
              topRight: Radius.circular(borderRadius),
              bottomRight: Radius.circular(borderRadius),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onDropdown,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Icon(dropdownIcon, color: scheme.onPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
