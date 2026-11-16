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
enum ExpressiveWindowSizeClass {
  compact,
  medium,
  expanded,
  large,
  extraLarge;

  static ExpressiveWindowSizeClass fromWidth(double width) {
    const bp = ExpressiveBreakpointTokens.standard;
    if (width >= bp.extraLarge) return ExpressiveWindowSizeClass.extraLarge;
    if (width >= bp.large) return ExpressiveWindowSizeClass.large;
    if (width >= bp.expanded) return ExpressiveWindowSizeClass.expanded;
    if (width >= bp.medium) return ExpressiveWindowSizeClass.medium;
    return ExpressiveWindowSizeClass.compact;
  }
}

// ---- Deprecated aliases (removed in 1.0.0) ----

@Deprecated('Use ExpressiveWindowSizeClass instead. Will be removed in 1.0.0.')
typedef WindowSizeClass = ExpressiveWindowSizeClass;
