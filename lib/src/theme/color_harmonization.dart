import 'package:flutter/material.dart';
import 'vibrant_colors.dart';

/// Harmonizes custom colors with a theme's seed color.
///
/// Useful for brand colors, status colors, or semantic colors that should
/// feel cohesive with the dynamic theme.
class ColorHarmonization {
  ColorHarmonization._();

  /// Harmonize a single color toward the seed.
  static Color harmonize(Color color, Color seed, {double amount = 0.25}) {
    return VibrantColorScheme.harmonize(color, seed, amount: amount);
  }

  /// Harmonize a set of semantic colors with the theme.
  static HarmonizedColors harmonizeAll({
    required Color seed,
    Color success = const Color(0xFF4CAF50),
    Color warning = const Color(0xFFFF9800),
    Color info = const Color(0xFF2196F3),
    Color error = const Color(0xFFF44336),
    double amount = 0.2,
  }) {
    return HarmonizedColors(
      success: VibrantColorScheme.harmonize(success, seed, amount: amount),
      warning: VibrantColorScheme.harmonize(warning, seed, amount: amount),
      info: VibrantColorScheme.harmonize(info, seed, amount: amount),
      error: VibrantColorScheme.harmonize(error, seed, amount: amount),
    );
  }

  /// Generate harmonized container/on-container pairs.
  static HarmonizedColorPair harmonizePair(
    Color color,
    Color seed, {
    double amount = 0.2,
    Brightness brightness = Brightness.light,
  }) {
    final harmonized = VibrantColorScheme.harmonize(
      color,
      seed,
      amount: amount,
    );
    final hsl = HSLColor.fromColor(harmonized);

    final container = brightness == Brightness.light
        ? hsl.withLightness(0.9).toColor()
        : hsl.withLightness(0.2).toColor();
    final onContainer = brightness == Brightness.light
        ? hsl.withLightness(0.1).toColor()
        : hsl.withLightness(0.9).toColor();

    return HarmonizedColorPair(
      color: harmonized,
      container: container,
      onContainer: onContainer,
    );
  }
}

/// A set of harmonized semantic colors.
class HarmonizedColors {
  const HarmonizedColors({
    required this.success,
    required this.warning,
    required this.info,
    required this.error,
  });

  final Color success;
  final Color warning;
  final Color info;
  final Color error;
}

/// A color with its container and on-container variants.
class HarmonizedColorPair {
  const HarmonizedColorPair({
    required this.color,
    required this.container,
    required this.onContainer,
  });

  final Color color;
  final Color container;
  final Color onContainer;
}
