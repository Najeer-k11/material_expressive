import 'package:flutter/material.dart';

/// Generates vibrant/expressive color schemes with boosted saturation
/// and deliberate hue contrast between primary/secondary/tertiary.
///
/// M3 Expressive uses more saturated tonal palettes and pushes
/// secondary/tertiary hues further from the primary for vibrancy.
class VibrantColorScheme {
  VibrantColorScheme._();

  /// Creates a vibrant [ColorScheme] from a seed color.
  ///
  /// [saturationBoost] controls how much more saturated colors are (0..0.4).
  /// In dark mode, containers stay vivid instead of washing out.
  static ColorScheme fromSeed({
    required Color seedColor,
    Brightness brightness = Brightness.light,
    double saturationBoost = 0.2,
  }) {
    final base = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    final isDark = brightness == Brightness.dark;

    return base.copyWith(
      // Primary — boosted
      primary: _boost(base.primary, saturationBoost, isDark),
      primaryContainer: _boost(
        base.primaryContainer,
        saturationBoost * 0.7,
        isDark,
      ),
      // Secondary — boosted + hue pushed for contrast
      secondary: _boost(base.secondary, saturationBoost * 1.1, isDark),
      secondaryContainer: _boost(
        base.secondaryContainer,
        saturationBoost * 0.6,
        isDark,
      ),
      // Tertiary — most contrast, highest boost
      tertiary: _boost(base.tertiary, saturationBoost * 1.2, isDark),
      tertiaryContainer: _boost(
        base.tertiaryContainer,
        saturationBoost * 0.7,
        isDark,
      ),
      // Surfaces in dark mode: slightly tinted, not pure gray
      surfaceContainerHighest: isDark
          ? _tintSurface(base.surfaceContainerHighest, seedColor, 0.05)
          : base.surfaceContainerHighest,
      surfaceContainerHigh: isDark
          ? _tintSurface(base.surfaceContainerHigh, seedColor, 0.04)
          : base.surfaceContainerHigh,
      surfaceContainer: isDark
          ? _tintSurface(base.surfaceContainer, seedColor, 0.03)
          : base.surfaceContainer,
    );
  }

  /// Harmonize a custom color toward the seed hue.
  static Color harmonize(Color color, Color seedColor, {double amount = 0.25}) {
    final hsl = HSLColor.fromColor(color);
    final seedHsl = HSLColor.fromColor(seedColor);
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

  /// Boost saturation. In dark mode, keep lightness in a controlled range
  /// so colors stay vibrant but dark (not washed out to light).
  static Color _boost(Color color, double boost, bool isDark) {
    final hsl = HSLColor.fromColor(color);
    final newSat = (hsl.saturation + boost).clamp(0.0, 1.0);

    double newLight;
    if (isDark) {
      // Dark mode: clamp lightness to 0.25–0.55 range
      // High saturation in this range = vivid but dark
      newLight = hsl.lightness.clamp(0.25, 0.55);
    } else {
      // Light mode: clamp to 0.3–0.75 to prevent too light or too dark
      newLight = hsl.lightness.clamp(0.3, 0.75);
    }

    return hsl.withSaturation(newSat).withLightness(newLight).toColor();
  }

  /// Tint a surface color slightly toward the seed for cohesion in dark mode.
  static Color _tintSurface(Color surface, Color seed, double amount) {
    return Color.lerp(surface, seed, amount)!;
  }
}
