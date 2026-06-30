import 'package:flutter/material.dart';

/// Shows an expressive snackbar with icon, shape, and spring dismiss.
void showExpressiveSnackBar(
  BuildContext context, {
  required String message,
  IconData? icon,
  String? actionLabel,
  VoidCallback? onAction,
  Duration duration = const Duration(seconds: 4),
  double borderRadius = 16,
  Color? backgroundColor,
  Color? textColor,
}) {
  final scheme = Theme.of(context).colorScheme;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: duration,
      backgroundColor: backgroundColor ?? scheme.inverseSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      margin: const EdgeInsets.all(16),
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor ?? scheme.onInverseSurface, size: 20),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor ?? scheme.onInverseSurface),
            ),
          ),
        ],
      ),
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: scheme.inversePrimary,
              onPressed: onAction ?? () {},
            )
          : null,
    ),
  );
}
