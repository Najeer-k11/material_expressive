import 'package:flutter/material.dart';

/// Typography tokens with expressive weight adjustments.
class ExpressiveTypographyTokens {
  const ExpressiveTypographyTokens({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
  });

  factory ExpressiveTypographyTokens.fromTextTheme(TextTheme t) {
    return ExpressiveTypographyTokens(
      displayLarge: t.displayLarge!.copyWith(
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
      ),
      displayMedium: t.displayMedium!.copyWith(fontWeight: FontWeight.w400),
      displaySmall: t.displaySmall!.copyWith(fontWeight: FontWeight.w400),
      headlineLarge: t.headlineLarge!.copyWith(fontWeight: FontWeight.w500),
      headlineMedium: t.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
      headlineSmall: t.headlineSmall!.copyWith(fontWeight: FontWeight.w500),
      titleLarge: t.titleLarge!.copyWith(fontWeight: FontWeight.w600),
      titleMedium: t.titleMedium!.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      titleSmall: t.titleSmall!.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      bodyLarge: t.bodyLarge!,
      bodyMedium: t.bodyMedium!,
      bodySmall: t.bodySmall!,
      labelLarge: t.labelLarge!.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      labelMedium: t.labelMedium!.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      labelSmall: t.labelSmall!.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle displaySmall;
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;

  TextTheme toTextTheme() {
    return TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    );
  }
}
