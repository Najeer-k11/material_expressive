import 'package:flutter/material.dart';
import '../tokens/spacing_tokens.dart';
import '../core/adaptive.dart';
import 'expressive_theme_data.dart';

/// InheritedWidget that provides [ExpressiveThemeData].
class ExpressiveThemeProvider extends InheritedWidget {
  const ExpressiveThemeProvider({
    super.key,
    required this.themeData,
    required super.child,
  });

  final ExpressiveThemeData themeData;

  static ExpressiveThemeData of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<ExpressiveThemeProvider>();
    assert(provider != null, 'No ExpressiveThemeProvider found in context');
    return provider!.themeData;
  }

  static ExpressiveThemeData? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ExpressiveThemeProvider>()
        ?.themeData;
  }

  @override
  bool updateShouldNotify(ExpressiveThemeProvider oldWidget) {
    return themeData != oldWidget.themeData;
  }
}

/// Context extensions for token access.
extension ExpressiveTokenContext on BuildContext {
  ExpressiveThemeData get tokens => ExpressiveThemeProvider.of(this);

  ExpressiveSpacingTokens get adaptiveSpacing {
    switch (Adaptive.deviceType(this)) {
      case DeviceType.phone:
        return ExpressiveSpacingTokens.phone;
      case DeviceType.tablet:
        return ExpressiveSpacingTokens.tablet;
      case DeviceType.desktop:
        return ExpressiveSpacingTokens.desktop;
    }
  }
}
