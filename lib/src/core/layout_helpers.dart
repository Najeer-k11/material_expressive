import 'package:material_ui/material_ui.dart';

import 'adaptive.dart';

/// Maximum content width for readability.
class ExpressiveContentWidth extends StatelessWidget {
  const ExpressiveContentWidth({
    super.key,
    required this.child,
    this.maxWidth = 840,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;
  final double maxWidth;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

/// Responsive gap that adapts to device size.
class ExpressiveAdaptiveGap extends StatelessWidget {
  const ExpressiveAdaptiveGap({
    super.key,
    this.phone = 16,
    this.tablet,
    this.desktop,
  });

  /// Spacing `sm` (8 / 12 / 16).
  const ExpressiveAdaptiveGap.sm({super.key})
    : phone = 8,
      tablet = 12,
      desktop = 16;

  /// Spacing `lg` (16 / 24 / 32).
  const ExpressiveAdaptiveGap.md({super.key})
    : phone = 16,
      tablet = 24,
      desktop = 32;

  /// Spacing `xl` (24 / 32 / 40).
  const ExpressiveAdaptiveGap.lg({super.key})
    : phone = 24,
      tablet = 32,
      desktop = 40;

  final double phone;
  final double? tablet;
  final double? desktop;

  @override
  Widget build(BuildContext context) {
    final size = ExpressiveAdaptive.value(
      context,
      phone: phone,
      tablet: tablet,
      desktop: desktop,
    );
    return SizedBox(width: size, height: size);
  }
}

/// Adaptive page margins.
class ExpressivePageMargins extends StatelessWidget {
  const ExpressivePageMargins({
    super.key,
    required this.child,
    this.phoneMargin = 16,
    this.tabletMargin = 24,
    this.desktopMargin = 40,
  });

  final Widget child;
  final double phoneMargin;
  final double tabletMargin;
  final double desktopMargin;

  @override
  Widget build(BuildContext context) {
    final margin = ExpressiveAdaptive.value(
      context,
      phone: phoneMargin,
      tablet: tabletMargin,
      desktop: desktopMargin,
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: margin),
      child: child,
    );
  }
}

// ---- Deprecated aliases (removed in 1.0.0) ----

@Deprecated('Use ExpressiveContentWidth instead. Will be removed in 1.0.0.')
typedef ContentWidth = ExpressiveContentWidth;

@Deprecated('Use ExpressiveAdaptiveGap instead. Will be removed in 1.0.0.')
typedef AdaptiveGap = ExpressiveAdaptiveGap;

@Deprecated('Use ExpressivePageMargins instead. Will be removed in 1.0.0.')
typedef PageMargins = ExpressivePageMargins;
