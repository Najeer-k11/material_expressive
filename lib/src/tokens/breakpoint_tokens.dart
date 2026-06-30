/// Breakpoint tokens.
class ExpressiveBreakpointTokens {
  const ExpressiveBreakpointTokens({
    required this.compact,
    required this.medium,
    required this.expanded,
    required this.large,
    required this.extraLarge,
  });

  static const standard = ExpressiveBreakpointTokens(
    compact: 0,
    medium: 600,
    expanded: 840,
    large: 1200,
    extraLarge: 1600,
  );

  final double compact;
  final double medium;
  final double expanded;
  final double large;
  final double extraLarge;
}

/// Window size class.
enum WindowSizeClass {
  compact,
  medium,
  expanded,
  large,
  extraLarge;

  static WindowSizeClass fromWidth(double width) {
    const bp = ExpressiveBreakpointTokens.standard;
    if (width >= bp.extraLarge) return WindowSizeClass.extraLarge;
    if (width >= bp.large) return WindowSizeClass.large;
    if (width >= bp.expanded) return WindowSizeClass.expanded;
    if (width >= bp.medium) return WindowSizeClass.medium;
    return WindowSizeClass.compact;
  }
}
