import 'package:material_ui/material_ui.dart';

import '../theme/expressive_theme.dart';

/// Shows an expressive bottom sheet with spring-based drag physics.
Future<T?> showExpressiveBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isDismissible = true,
  bool enableDrag = true,
  Color? backgroundColor,
  double? elevation,
  ShapeBorder? shape,
  double initialChildSize = 0.5,
  double maxChildSize = 0.9,
  double minChildSize = 0.25,
  bool snap = true,
  List<double>? snapSizes,
}) {
  final scheme = Theme.of(context).colorScheme;
  final tokens = ExpressiveTheme.of(context);

  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: backgroundColor ?? scheme.surfaceContainerLow,
    elevation: elevation ?? 2,
    shape:
        shape ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(tokens.radius.xxl),
          ),
        ),
    isScrollControlled: true,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        maxChildSize: maxChildSize,
        minChildSize: minChildSize,
        snap: snap,
        snapSizes: snapSizes,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Padding(
                padding: EdgeInsets.symmetric(vertical: tokens.spacing.md),
                child: Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: scheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: builder(context),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
