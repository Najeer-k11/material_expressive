import 'package:flutter/material.dart';

/// Maximum content width for readability.
class ContentWidth extends StatelessWidget {
  const ContentWidth({
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
class AdaptiveGap extends StatelessWidget {
  const AdaptiveGap({super.key, this.phone = 16, this.tablet, this.desktop});

  const AdaptiveGap.sm({super.key}) : phone = 8, tablet = 12, desktop = 16;

  const AdaptiveGap.md({super.key}) : phone = 16, tablet = 24, desktop = 32;

  const AdaptiveGap.lg({super.key}) : phone = 24, tablet = 32, desktop = 40;

  final double phone;
  final double? tablet;
  final double? desktop;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double size;
    if (width >= 1200) {
      size = desktop ?? tablet ?? phone;
    } else if (width >= 600) {
      size = tablet ?? phone;
    } else {
      size = phone;
    }
    return SizedBox(width: size, height: size);
  }
}

/// Adaptive page margins.
class PageMargins extends StatelessWidget {
  const PageMargins({
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
    final width = MediaQuery.of(context).size.width;
    double margin;
    if (width >= 1200) {
      margin = desktopMargin;
    } else if (width >= 600) {
      margin = tabletMargin;
    } else {
      margin = phoneMargin;
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: margin),
      child: child,
    );
  }
}
