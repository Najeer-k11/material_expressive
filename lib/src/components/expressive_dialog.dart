import 'package:material_ui/material_ui.dart';

import '../theme/expressive_theme.dart';

/// Shows an expressive dialog with scale+fade entry animation.
Future<T?> showExpressiveDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? barrierColor,
  Duration transitionDuration = const Duration(milliseconds: 350),
  Curve curve = Curves.easeOut,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor ?? Colors.black54,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    transitionDuration: transitionDuration,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnim = CurvedAnimation(parent: animation, curve: curve);
      return ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnim),
        child: FadeTransition(opacity: curvedAnim, child: child),
      );
    },
  );
}

/// An expressive AlertDialog with shaped container.
class ExpressiveAlertDialog extends StatelessWidget {
  const ExpressiveAlertDialog({
    super.key,
    this.icon,
    this.title,
    this.content,
    this.actions = const [],
    this.borderRadius,
  });

  final Widget? icon;
  final Widget? title;
  final Widget? content;
  final List<Widget> actions;

  /// Corner radius. Defaults to the theme's `radius.xxl`.
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tokens = ExpressiveTheme.of(context);
    final spacing = tokens.spacing;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? tokens.radius.xxl),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          spacing.xl,
          spacing.xl,
          spacing.xl,
          spacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              IconTheme(
                data: IconThemeData(color: scheme.secondary, size: 24),
                child: icon!,
              ),
              SizedBox(height: spacing.lg),
            ],
            if (title != null) ...[
              DefaultTextStyle(
                style: textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                child: title!,
              ),
              SizedBox(height: spacing.lg),
            ],
            if (content != null) ...[
              DefaultTextStyle(
                style: textTheme.bodyMedium!.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
                child: content!,
              ),
              SizedBox(height: spacing.xl),
            ],
            if (actions.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:
                    actions
                        .expand((a) => [a, SizedBox(width: spacing.sm)])
                        .toList()
                      ..removeLast(),
              ),
          ],
        ),
      ),
    );
  }
}
