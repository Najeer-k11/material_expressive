import 'package:material_ui/material_ui.dart';

import '../theme/expressive_theme.dart';

/// Shows an expressive snackbar with icon, shape, and spring dismiss.
void showExpressiveSnackBar(
  BuildContext context, {
  required String message,
  IconData? icon,
  String? actionLabel,
  VoidCallback? onAction,
  Duration duration = const Duration(seconds: 4),
  double? borderRadius,
  Color? backgroundColor,
  Color? textColor,
}) {
  final scheme = Theme.of(context).colorScheme;
  final tokens = ExpressiveTheme.of(context);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: duration,
      backgroundColor: backgroundColor ?? scheme.inverseSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? tokens.radius.lg),
      ),
      margin: EdgeInsets.all(tokens.spacing.lg),
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor ?? scheme.onInverseSurface, size: 20),
            SizedBox(width: tokens.spacing.md),
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
