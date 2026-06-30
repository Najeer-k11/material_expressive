/// State layer tokens.
class ExpressiveStateTokens {
  const ExpressiveStateTokens({
    required this.hoverElevation,
    required this.pressedScale,
    required this.focusOutlineWidth,
    required this.draggedElevation,
    required this.disabledOpacity,
  });

  static const standard = ExpressiveStateTokens(
    hoverElevation: 1.0,
    pressedScale: 0.96,
    focusOutlineWidth: 2.0,
    draggedElevation: 8.0,
    disabledOpacity: 0.38,
  );

  final double hoverElevation;
  final double pressedScale;
  final double focusOutlineWidth;
  final double draggedElevation;
  final double disabledOpacity;
}
