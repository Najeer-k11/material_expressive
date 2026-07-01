import 'package:flutter/material.dart';
import '../tokens/color_tokens.dart';
import '../tokens/typography_tokens.dart';
import '../tokens/spacing_tokens.dart';
import '../tokens/radius_tokens.dart';
import '../tokens/elevation_tokens.dart';
import '../tokens/motion_tokens.dart';
import '../tokens/opacity_tokens.dart';
import '../tokens/state_tokens.dart';
import '../tokens/shape_tokens.dart';
import '../motion/page_transitions.dart';
import 'vibrant_colors.dart';
import 'expressive_theme_data.dart';

/// Generates expressive themes from a seed color.
class ExpressiveTheme {
  ExpressiveTheme._();

  static ExpressiveThemeData fromSeed({
    required Color seedColor,
    ExpressiveShapeType shapeType = ExpressiveShapeType.organic,
    ExpressiveSpacingTokens? spacing,
    ExpressiveRadiusTokens? radius,
    ExpressiveMotionTokens? motion,
    String? fontFamily,

    /// How much to boost saturation (0.0 = standard M3, 0.3 = very vibrant).
    double vibrancy = 0.2,

    /// Whether to keep dark mode colors vibrant (true = M3 Expressive style).
    bool vibrantDarkMode = true,

    /// Pass an existing light ColorScheme (e.g. from dynamic_color).
    /// If provided, seedColor/vibrancy are ignored for light theme.
    ColorScheme? lightColorScheme,

    /// Pass an existing dark ColorScheme.
    ColorScheme? darkColorScheme,
  }) {
    // Use provided schemes or generate vibrant ones
    final lightScheme =
        lightColorScheme ??
        VibrantColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
          saturationBoost: vibrancy,
        );
    final darkScheme =
        darkColorScheme ??
        VibrantColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
          saturationBoost: vibrantDarkMode ? vibrancy * 0.8 : vibrancy * 0.3,
        );

    final resolvedRadius = radius ?? ExpressiveRadiusTokens.standard;
    final resolvedMotion = motion ?? ExpressiveMotionTokens.standard;
    final resolvedSpacing = spacing ?? ExpressiveSpacingTokens.phone;
    final shapeTokens = ExpressiveShapeTokens(type: shapeType);

    final lightTheme = _buildTheme(
      scheme: lightScheme,
      radius: resolvedRadius,
      shapeTokens: shapeTokens,
      fontFamily: fontFamily,
    );
    final darkTheme = _buildTheme(
      scheme: darkScheme,
      radius: resolvedRadius,
      shapeTokens: shapeTokens,
      fontFamily: fontFamily,
    );

    return ExpressiveThemeData(
      colors: ExpressiveColorTokens.fromScheme(lightScheme),
      typography: ExpressiveTypographyTokens.fromTextTheme(
        lightTheme.textTheme,
      ),
      spacing: resolvedSpacing,
      radius: resolvedRadius,
      elevation: ExpressiveElevationTokens.standard,
      motion: resolvedMotion,
      opacity: ExpressiveOpacityTokens.standard,
      state: ExpressiveStateTokens.standard,
      shape: shapeTokens,
      materialTheme: lightTheme,
      materialDarkTheme: darkTheme,
    );
  }

  static ThemeData _buildTheme({
    required ColorScheme scheme,
    required ExpressiveRadiusTokens radius,
    required ExpressiveShapeTokens shapeTokens,
    String? fontFamily,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: fontFamily,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: shapeTokens.shape(radius.lg),
        color: scheme.surfaceContainerLow,
      ),
      dialogTheme: DialogThemeData(shape: shapeTokens.shape(radius.xxl)),
      bottomSheetTheme: BottomSheetThemeData(
        shape: shapeTokens.shape(radius.xxl),
        showDragHandle: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: shapeTokens.shape(radius.xl),
        elevation: 3,
      ),
      chipTheme: ChipThemeData(
        shape: shapeTokens.shape(radius.sm) as OutlinedBorder?,
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorShape: shapeTokens.shape(radius.xl) as ShapeBorder?,
        elevation: 0,
        height: 80,
      ),
      navigationRailTheme: NavigationRailThemeData(
        indicatorShape: shapeTokens.shape(radius.xl) as ShapeBorder?,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.md),
          borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.md),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.full),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.full),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.full),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ExpressivePageTransitionsBuilder(),
          TargetPlatform.iOS: ExpressivePageTransitionsBuilder(),
          TargetPlatform.windows: ExpressivePageTransitionsBuilder(),
          TargetPlatform.macOS: ExpressivePageTransitionsBuilder(),
          TargetPlatform.linux: ExpressivePageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.md),
        ),
      ),
    );
  }
}
