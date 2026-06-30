import 'package:flutter/material.dart';
import '../tokens/state_tokens.dart';

/// Adds expressive press-to-scale behavior to any widget.
class ExpressiveStateLayer extends StatefulWidget {
  const ExpressiveStateLayer({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.enableScale = true,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enableScale;
  final BorderRadius borderRadius;

  @override
  State<ExpressiveStateLayer> createState() => _ExpressiveStateLayerState();
}

class _ExpressiveStateLayerState extends State<ExpressiveStateLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  static const _tokens = ExpressiveStateTokens.standard;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: _tokens.pressedScale)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;
    if (widget.enableScale) {
      child = AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: child,
      );
    }
    return GestureDetector(
      onTapDown: (_) {
        if (widget.enableScale) _controller.forward();
      },
      onTapUp: (_) {
        if (widget.enableScale) _controller.reverse();
      },
      onTapCancel: () {
        if (widget.enableScale) _controller.reverse();
      },
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: child,
    );
  }
}
