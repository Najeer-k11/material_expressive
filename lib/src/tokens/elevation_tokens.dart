/// Elevation tokens.
class ExpressiveElevationTokens {
  const ExpressiveElevationTokens({
    required this.level0,
    required this.level1,
    required this.level2,
    required this.level3,
    required this.level4,
    required this.level5,
  });

  static const standard = ExpressiveElevationTokens(
    level0: 0,
    level1: 1,
    level2: 3,
    level3: 6,
    level4: 8,
    level5: 12,
  );

  final double level0;
  final double level1;
  final double level2;
  final double level3;
  final double level4;
  final double level5;
}
