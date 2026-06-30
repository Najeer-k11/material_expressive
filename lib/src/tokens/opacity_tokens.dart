/// Opacity tokens.
class ExpressiveOpacityTokens {
  const ExpressiveOpacityTokens({
    required this.disabled,
    required this.hover,
    required this.focus,
    required this.pressed,
    required this.dragged,
  });

  static const standard = ExpressiveOpacityTokens(
    disabled: 0.38,
    hover: 0.08,
    focus: 0.10,
    pressed: 0.10,
    dragged: 0.16,
  );

  final double disabled;
  final double hover;
  final double focus;
  final double pressed;
  final double dragged;
}
