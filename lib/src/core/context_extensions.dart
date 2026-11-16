import 'package:material_ui/material_ui.dart';

import '../theme/expressive_theme.dart';
import '../theme/expressive_theme_data.dart';
import '../tokens/breakpoint_tokens.dart';
import '../tokens/spacing_tokens.dart';
import 'adaptive.dart';

/// Shortcuts for theme, token, media and adaptive lookups.
extension ExpressiveContext on BuildContext {
  // -- Material theme --
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  /// Whether the active [Theme] is dark.
  bool get isDark => theme.brightness == Brightness.dark;

  // -- Expressive tokens --

  /// The nearest [ExpressiveThemeData] (see [ExpressiveTheme.of]).
  ExpressiveThemeData get tokens => ExpressiveTheme.of(this);

  /// Spacing scale for the current device type
  /// (phone / tablet / desktop).
  ExpressiveSpacingTokens get adaptiveSpacing {
    switch (deviceType) {
      case ExpressiveDeviceType.phone:
        return ExpressiveSpacingTokens.phone;
      case ExpressiveDeviceType.tablet:
        return ExpressiveSpacingTokens.tablet;
      case ExpressiveDeviceType.desktop:
        return ExpressiveSpacingTokens.desktop;
    }
  }

  // -- Adaptive --
  ExpressiveWindowSizeClass get windowSizeClass =>
      ExpressiveAdaptive.windowSizeClass(this);
  ExpressiveDeviceType get deviceType => ExpressiveAdaptive.deviceType(this);

  // -- Media --
  MediaQueryData get media => MediaQuery.of(this);
  double get screenWidth => media.size.width;
  double get screenHeight => media.size.height;
  bool get isLandscape => media.orientation == Orientation.landscape;
  double get pixelRatio => media.devicePixelRatio;
  EdgeInsets get safeArea => media.padding;
  EdgeInsets get viewInsets => media.viewInsets;

  /// The platform (system) brightness. May differ from [isDark], which
  /// reflects the active [Theme].
  Brightness get platformBrightness => media.platformBrightness;

  /// Whether the user asked the platform to reduce motion.
  bool get reduceMotion => media.disableAnimations;

  @Deprecated('Use platformBrightness instead. Will be removed in 1.0.0.')
  Brightness get brightness => platformBrightness;
}
