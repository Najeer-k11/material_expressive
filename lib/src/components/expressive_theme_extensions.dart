import 'package:flutter/material.dart';
import '../tokens/shape_tokens.dart';
import 'expressive_input_themes.dart';

/// Expressive ThemeData extensions for M3 Expressive component styles.
///
/// These extend standard Material widgets through theming, not wrapping.
class ExpressiveComponentThemes {
  ExpressiveComponentThemes._();

  /// Expressive FAB theme — larger, bolder, with expressive shape.
  static FloatingActionButtonThemeData expressiveFab({
    required ColorScheme scheme,
    ExpressiveShapeTokens? shape,
    double radius = 24,
  }) {
    final shapeTokens =
        shape ?? const ExpressiveShapeTokens(type: ExpressiveShapeType.organic);
    return FloatingActionButtonThemeData(
      shape: shapeTokens.shape(radius),
      elevation: 4,
      highlightElevation: 8,
      backgroundColor: scheme.primaryContainer,
      foregroundColor: scheme.onPrimaryContainer,
      extendedPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      extendedTextStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    );
  }

  /// Expressive navigation bar — taller, pill indicators, bolder labels.
  static NavigationBarThemeData expressiveNavBar({
    required ColorScheme scheme,
    double indicatorRadius = 28,
  }) {
    return NavigationBarThemeData(
      height: 88,
      elevation: 0,
      backgroundColor: scheme.surfaceContainer,
      indicatorColor: scheme.secondaryContainer,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(indicatorRadius),
      ),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: scheme.onSecondaryContainer, size: 24);
        }
        return IconThemeData(color: scheme.onSurfaceVariant, size: 24);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          );
        }
        return TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: scheme.onSurfaceVariant,
        );
      }),
    );
  }

  /// Expressive app bar — bolder title, colored background options.
  static AppBarTheme expressiveAppBar({
    required ColorScheme scheme,
    bool colored = false,
  }) {
    return AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 3,
      backgroundColor: colored ? scheme.primaryContainer : scheme.surface,
      foregroundColor: colored ? scheme.onPrimaryContainer : scheme.onSurface,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: colored ? scheme.onPrimaryContainer : scheme.onSurface,
      ),
    );
  }

  /// Expressive icon button — larger touch target, container on select.
  static IconButtonThemeData expressiveIconButton({
    required ColorScheme scheme,
  }) {
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        minimumSize: const Size(48, 48),
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  /// Expressive carousel card theme.
  static CardThemeData expressiveCarouselCard({
    required ColorScheme scheme,
    double radius = 20,
  }) {
    return CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      color: scheme.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
    );
  }

  /// Apply all expressive component themes to a base ThemeData.
  static ThemeData applyExpressive(
    ThemeData base, {
    bool coloredAppBar = false,
  }) {
    final scheme = base.colorScheme;
    var themed = base.copyWith(
      floatingActionButtonTheme: expressiveFab(scheme: scheme),
      navigationBarTheme: expressiveNavBar(scheme: scheme),
      appBarTheme: expressiveAppBar(scheme: scheme, colored: coloredAppBar),
      iconButtonTheme: expressiveIconButton(scheme: scheme),
      cardTheme: expressiveCarouselCard(scheme: scheme),
    );
    // Also apply input themes
    themed = ExpressiveInputThemes.applyAll(themed);
    return themed;
  }
}
