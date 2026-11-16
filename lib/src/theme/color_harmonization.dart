import 'package:material_ui/material_ui.dart';

/// Harmonizes custom colors with a theme's seed color.
///
/// Useful for brand colors, status colors, or semantic colors that should
/// feel cohesive with the dynamic theme.
class ExpressiveColorHarmonization {
  ExpressiveColorHarmonization._();

  /// Harmonize a single color toward the seed.
  ///
  /// Shifts the hue of [color] toward [seed] by [amount] (0..1) along the
  /// shortest path around the color wheel.
  static Color harmonize(Color color, Color seed, {double amount = 0.25}) {
    final hsl = HSLColor.fromColor(color);
    final seedHsl = HSLColor.fromColor(seed);
    final hueDiff = _shortestHueDiff(hsl.hue, seedHsl.hue);
    final newHue = (hsl.hue + hueDiff * amount) % 360;
    return hsl.withHue(newHue < 0 ? newHue + 360 : newHue).toColor();
  }

  static double _shortestHueDiff(double from, double to) {
    final diff = to - from;
    if (diff > 180) return diff - 360;
    if (diff < -180) return diff + 360;
    return diff;
  }

  /// Harmonize a set of semantic colors with the theme.
  static ExpressiveHarmonizedColors harmonizeAll({
    required Color seed,
    Color success = const Color(0xFF4CAF50),
    Color warning = const Color(0xFFFF9800),
    Color info = const Color(0xFF2196F3),
    Color error = const Color(0xFFF44336),
    double amount = 0.2,
  }) {
    return ExpressiveHarmonizedColors(
      success: harmonize(success, seed, amount: amount),
      warning: harmonize(warning, seed, amount: amount),
      info: harmonize(info, seed, amount: amount),
      error: harmonize(error, seed, amount: amount),
    );
  }

  /// Generate harmonized container/on-container pairs.
  static ExpressiveHarmonizedColorPair harmonizePair(
    Color color,
    Color seed, {
    double amount = 0.2,
    Brightness brightness = Brightness.light,
  }) {
    final harmonized = harmonize(color, seed, amount: amount);
    final hsl = HSLColor.fromColor(harmonized);

    final container = brightness == Brightness.light
        ? hsl.withLightness(0.9).toColor()
        : hsl.withLightness(0.2).toColor();
    final onContainer = brightness == Brightness.light
        ? hsl.withLightness(0.1).toColor()
        : hsl.withLightness(0.9).toColor();

    return ExpressiveHarmonizedColorPair(
      color: harmonized,
      container: container,
      onContainer: onContainer,
    );
  }
}

/// A set of harmonized semantic colors.
class ExpressiveHarmonizedColors {
  const ExpressiveHarmonizedColors({
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
class ExpressiveHarmonizedColorPair {
  const ExpressiveHarmonizedColorPair({
    required this.color,
    required this.container,
    required this.onContainer,
  });

  final Color color;
  final Color container;
  final Color onContainer;
}

// ---- Deprecated aliases (removed in 1.0.0) ----

@Deprecated(
  'Use ExpressiveColorHarmonization instead. Will be removed in 1.0.0.',
)
typedef ColorHarmonization = ExpressiveColorHarmonization;

@Deprecated('Use ExpressiveHarmonizedColors instead. Will be removed in 1.0.0.')
typedef HarmonizedColors = ExpressiveHarmonizedColors;

@Deprecated(
  'Use ExpressiveHarmonizedColorPair instead. Will be removed in 1.0.0.',
)
typedef HarmonizedColorPair = ExpressiveHarmonizedColorPair;
