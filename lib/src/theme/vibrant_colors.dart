import 'package:flutter/material.dart';

/// Generates vibrant/expressive color schemes with boosted saturation.
///
/// M3 Expressive uses more saturated tonal palettes than standard Material You.
class VibrantColorScheme {
  VibrantColorScheme._();

  /// Creates a vibrant [ColorScheme] from a seed color with boosted saturation.
  static ColorScheme fromSeed({
    required Color seedColor,
    Brightness brightness = Brightness.light,
    double saturationBoost = 0.2,
  }) {
    final base = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    return base.copyWith(
      primary: _boostSaturation(base.primary, saturationBoost),
      primaryContainer: _boostSaturation(
        base.primaryContainer,
        saturationBoost * 0.6,
      ),
      secondary: _boostSaturation(base.secondary, saturationBoost),
      secondaryContainer: _boostSaturation(
        base.secondaryContainer,
        saturationBoost * 0.5,
      ),
      tertiary: _boostSaturation(base.tertiary, saturationBoost),
      tertiaryContainer: _boostSaturation(
        base.tertiaryContainer,
        saturationBoost * 0.5,
      ),
    );
  }

  /// Harmonize a custom color with the seed palette.
  ///
  /// Shifts the hue of [color] toward [seedColor] by [amount] (0..1).
  static Color harmonize(Color color, Color seedColor, {double amount = 0.25}) {
    final hsl = HSLColor.fromColor(color);
    final seedHsl = HSLColor.fromColor(seedColor);
    final hueDiff = _shortestHueDiff(hsl.hue, seedHsl.hue);
    final newHue = (hsl.hue + hueDiff * amount) % 360;
    return hsl.withHue(newHue).toColor();
  }

  static double _shortestHueDiff(double from, double to) {
    final diff = to - from;
    if (diff > 180) return diff - 360;
    if (diff < -180) return diff + 360;
    return diff;
  }

  static Color _boostSaturation(Color color, double boost) {
    final hsl = HSLColor.fromColor(color);
    final newSat = (hsl.saturation + boost).clamp(0.0, 1.0);
    return hsl.withSaturation(newSat).toColor();
  }
}
