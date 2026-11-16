import 'package:material_ui/material_ui.dart';

import '../tokens/motion_tokens.dart';
import '../tokens/radius_tokens.dart';
import '../tokens/shape_tokens.dart';
import '../tokens/spacing_tokens.dart';
import 'expressive_theme_data.dart';

/// Provides [ExpressiveThemeData] to its descendants.
///
/// Mirrors Flutter's `Theme`/`ThemeData` pair:
///
/// ```dart
/// final data = ExpressiveThemeData.fromSeed(seedColor: Colors.indigo);
/// MaterialApp(
///   theme: data.materialTheme,
///   darkTheme: data.materialDarkTheme,
///   builder: (context, child) => ExpressiveTheme(data: data, child: child!),
/// );
/// ```
class ExpressiveTheme extends InheritedWidget {
  const ExpressiveTheme({super.key, required this.data, required super.child});

  /// The tokens provided to descendants.
  final ExpressiveThemeData data;

  /// The nearest [ExpressiveThemeData].
  ///
  /// If there is no [ExpressiveTheme] ancestor, returns
  /// [ExpressiveThemeData.fallback] built from the ambient [Theme], so
  /// components always have tokens to read.
  static ExpressiveThemeData of(BuildContext context) {
    return maybeOf(context) ?? ExpressiveThemeData.fallback(Theme.of(context));
  }

  /// The nearest [ExpressiveThemeData], or null if there is no
  /// [ExpressiveTheme] ancestor.
  static ExpressiveThemeData? maybeOf(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ExpressiveTheme>() ??
            // ignore: deprecated_member_use_from_same_package
            context
                .dependOnInheritedWidgetOfExactType<ExpressiveThemeProvider>())
        ?.data;
  }

  @override
  bool updateShouldNotify(ExpressiveTheme oldWidget) => data != oldWidget.data;

  /// Deprecated: use [data].
  @Deprecated('Use data instead. Will be removed in 1.0.0.')
  ExpressiveThemeData get themeData => data;

  /// Deprecated: use [ExpressiveThemeData.fromSeed].
  @Deprecated(
    'Use ExpressiveThemeData.fromSeed instead. Will be removed in 1.0.0.',
  )
  static ExpressiveThemeData fromSeed({
    required Color seedColor,
    ExpressiveShapeType shapeType = ExpressiveShapeType.organic,
    ExpressiveSpacingTokens? spacing,
    ExpressiveRadiusTokens? radius,
    ExpressiveMotionTokens? motion,
    String? fontFamily,
    double vibrancy = 0.2,
    bool vibrantDarkMode = true,
    ColorScheme? lightColorScheme,
    ColorScheme? darkColorScheme,
  }) {
    return ExpressiveThemeData.fromSeed(
      seedColor: seedColor,
      shapeType: shapeType,
      spacing: spacing,
      radius: radius,
      motion: motion,
      fontFamily: fontFamily,
      vibrancy: vibrancy,
      vibrantDarkMode: vibrantDarkMode,
      lightColorScheme: lightColorScheme,
      darkColorScheme: darkColorScheme,
    );
  }
}

/// Deprecated: use [ExpressiveTheme].
@Deprecated('Use ExpressiveTheme instead. Will be removed in 1.0.0.')
class ExpressiveThemeProvider extends ExpressiveTheme {
  @Deprecated('Use ExpressiveTheme instead. Will be removed in 1.0.0.')
  const ExpressiveThemeProvider({
    super.key,
    required ExpressiveThemeData themeData,
    required super.child,
  }) : super(data: themeData);

  @Deprecated('Use ExpressiveTheme.of instead. Will be removed in 1.0.0.')
  static ExpressiveThemeData of(BuildContext context) =>
      ExpressiveTheme.of(context);

  @Deprecated('Use ExpressiveTheme.maybeOf instead. Will be removed in 1.0.0.')
  static ExpressiveThemeData? maybeOf(BuildContext context) =>
      ExpressiveTheme.maybeOf(context);
}
