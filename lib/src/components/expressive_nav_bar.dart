import 'package:material_ui/material_ui.dart';

import 'expressive_component_themes.dart';

/// Deprecated: use [ExpressiveComponentThemes.navigationBarTheme].
@Deprecated(
  'Use ExpressiveComponentThemes.navigationBarTheme instead. '
  'Will be removed in 1.0.0.',
)
class ExpressiveNavBarTheme {
  ExpressiveNavBarTheme._();

  /// [selectedShape] and [unselectedShape] were never applied and are ignored.
  static NavigationBarThemeData morphing({
    required ColorScheme scheme,
    List<Offset> selectedShape = const [],
    List<Offset> unselectedShape = const [],
    double height = 88,
  }) => ExpressiveComponentThemes.navigationBarTheme(
    scheme: scheme,
    height: height,
  );
}
