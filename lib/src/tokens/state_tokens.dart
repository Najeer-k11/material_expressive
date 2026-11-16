import 'opacity_tokens.dart';

/// State layer tokens.
class ExpressiveStateTokens {
  const ExpressiveStateTokens({
    required this.hoverElevation,
    required this.pressedScale,
    required this.focusOutlineWidth,
    required this.draggedElevation,
    @Deprecated(
      'Use ExpressiveOpacityTokens.disabled instead. Will be removed in 1.0.0.',
    )
    this.disabledOpacity = 0.38,
  });

  static const standard = ExpressiveStateTokens(
    hoverElevation: 1.0,
    pressedScale: 0.96,
    focusOutlineWidth: 2.0,
    draggedElevation: 8.0,
  );

  final double hoverElevation;
  final double pressedScale;
  final double focusOutlineWidth;
  final double draggedElevation;

  /// Deprecated: duplicate of [ExpressiveOpacityTokens.disabled].
  @Deprecated(
    'Use ExpressiveOpacityTokens.disabled instead. Will be removed in 1.0.0.',
  )
  final double disabledOpacity;
}
