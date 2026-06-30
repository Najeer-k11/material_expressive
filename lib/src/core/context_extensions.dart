import 'package:flutter/material.dart';

/// Core context extensions for quick access to theme properties.
extension ExpressiveBuildContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  MediaQueryData get media => MediaQuery.of(this);
  double get screenWidth => media.size.width;
  double get screenHeight => media.size.height;
  bool get isLandscape => media.orientation == Orientation.landscape;
  double get pixelRatio => media.devicePixelRatio;
  Brightness get brightness => media.platformBrightness;
  bool get isDark => theme.brightness == Brightness.dark;
  EdgeInsets get safeArea => media.padding;
  EdgeInsets get viewInsets => media.viewInsets;
}
