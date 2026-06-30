import 'package:flutter/material.dart';

/// Emphasized/expressive typography with dynamic weight and optical sizing.
///
/// M3 Expressive uses bolder headlines, larger display sizes, and more
/// weight contrast than standard Material 3.
class ExpressiveTypography {
  ExpressiveTypography._();

  /// Generate emphasized text theme from a base [TextTheme].
  ///
  /// [emphasisLevel] controls how much bolder/larger (0.0 = standard, 1.0 = max).
  static TextTheme emphasized(TextTheme base, {double emphasisLevel = 0.6}) {
    final e = emphasisLevel.clamp(0.0, 1.0);

    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontWeight: FontWeight.lerp(FontWeight.w400, FontWeight.w700, e),
        fontSize: (base.displayLarge?.fontSize ?? 57) + 4 * e,
        letterSpacing: -0.5 * e,
        height: 1.1,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontWeight: FontWeight.lerp(FontWeight.w400, FontWeight.w600, e),
        fontSize: (base.displayMedium?.fontSize ?? 45) + 3 * e,
        height: 1.15,
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontWeight: FontWeight.lerp(FontWeight.w400, FontWeight.w600, e),
        fontSize: (base.displaySmall?.fontSize ?? 36) + 2 * e,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontWeight: FontWeight.lerp(FontWeight.w400, FontWeight.w700, e),
        fontSize: (base.headlineLarge?.fontSize ?? 32) + 2 * e,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontWeight: FontWeight.lerp(FontWeight.w400, FontWeight.w600, e),
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontWeight: FontWeight.lerp(FontWeight.w400, FontWeight.w600, e),
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.lerp(FontWeight.w400, FontWeight.w700, e),
        letterSpacing: 0.0,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w700, e),
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, e),
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w700, e),
        letterSpacing: 0.1,
      ),
    );
  }

  /// Apply variable font features (if the font supports it).
  ///
  /// Returns a [TextStyle] with font feature settings for optical sizing
  /// and weight axis.
  static TextStyle withVariableAxes(
    TextStyle style, {
    double? weight,
    double? opticalSize,
    double? width,
  }) {
    final features = <FontFeature>[];
    final variations = <FontVariation>[];

    if (weight != null) {
      variations.add(FontVariation('wght', weight));
    }
    if (opticalSize != null) {
      variations.add(FontVariation('opsz', opticalSize));
    }
    if (width != null) {
      variations.add(FontVariation('wdth', width));
    }

    return style.copyWith(
      fontFeatures: features.isNotEmpty ? features : null,
      fontVariations: variations.isNotEmpty ? variations : null,
    );
  }
}
