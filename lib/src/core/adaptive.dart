import 'package:material_ui/material_ui.dart';

import '../tokens/breakpoint_tokens.dart';

/// Device form factor for adaptive layouts.
///
/// A coarse grouping of [ExpressiveWindowSizeClass]:
/// compact → [phone], medium/expanded → [tablet], large/extraLarge → [desktop].
enum ExpressiveDeviceType {
  phone,
  tablet,
  desktop;

  /// The device type for a window size class.
  static ExpressiveDeviceType fromWindowSizeClass(
    ExpressiveWindowSizeClass sizeClass,
  ) {
    switch (sizeClass) {
      case ExpressiveWindowSizeClass.compact:
        return ExpressiveDeviceType.phone;
      case ExpressiveWindowSizeClass.medium:
      case ExpressiveWindowSizeClass.expanded:
        return ExpressiveDeviceType.tablet;
      case ExpressiveWindowSizeClass.large:
      case ExpressiveWindowSizeClass.extraLarge:
        return ExpressiveDeviceType.desktop;
    }
  }
}

/// Adaptive layout helpers.
///
/// All breakpoints come from [ExpressiveBreakpointTokens.standard].
class ExpressiveAdaptive {
  ExpressiveAdaptive._();

  /// The window size class for the current screen width.
  static ExpressiveWindowSizeClass windowSizeClass(BuildContext context) {
    return ExpressiveWindowSizeClass.fromWidth(
      MediaQuery.sizeOf(context).width,
    );
  }

  /// The device type for the current screen width.
  static ExpressiveDeviceType deviceType(BuildContext context) {
    return ExpressiveDeviceType.fromWindowSizeClass(windowSizeClass(context));
  }

  /// Picks a value for the current device type, falling back to the next
  /// smaller form factor when a value isn't given.
  static T value<T>(
    BuildContext context, {
    required T phone,
    T? tablet,
    T? desktop,
  }) {
    switch (deviceType(context)) {
      case ExpressiveDeviceType.desktop:
        return desktop ?? tablet ?? phone;
      case ExpressiveDeviceType.tablet:
        return tablet ?? phone;
      case ExpressiveDeviceType.phone:
        return phone;
    }
  }
}

// ---- Deprecated aliases (removed in 1.0.0) ----

@Deprecated('Use ExpressiveAdaptive instead. Will be removed in 1.0.0.')
typedef Adaptive = ExpressiveAdaptive;

@Deprecated('Use ExpressiveDeviceType instead. Will be removed in 1.0.0.')
typedef DeviceType = ExpressiveDeviceType;
