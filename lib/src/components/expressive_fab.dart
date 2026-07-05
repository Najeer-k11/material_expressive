import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../tokens/shape_tokens.dart';

/// Size variants for the M3 Expressive FAB.
enum ExpressiveFabSize {
  /// 40x40, icon 20px.
  small,

  /// 56x56, icon 24px (default).
  medium,

  /// 96x96, icon 36px.
  large,
}

/// An expressive floating action button with:
/// - Size variants (small, medium, large)
/// - Organic/squircle shapes via theme tokens
/// - Spring animation on press
/// - Optional scroll-aware shrinking
///
/// This is not wrapping FAB — it IS a FAB that uses expressive styling.
/// Use it directly as `Scaffold.floatingActionButton`.
class ExpressiveFab extends StatefulWidget {
  const ExpressiveFab({
    super.key,
    required this.onPressed,
    this.icon,
    this.label,
    this.size = ExpressiveFabSize.medium,
    this.shapeType = ExpressiveShapeType.organic,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 4,
    this.tooltip,
    this.heroTag,
    this.scrollController,
    this.shrinkOnScroll = false,
  });

  final VoidCallback? onPressed;
  final IconData? icon;
  final String? label;
  final ExpressiveFabSize size;
  final ExpressiveShapeType shapeType;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final String? tooltip;
  final Object? heroTag;

  /// If provided with [shrinkOnScroll], the FAB morphs smaller on scroll down.
  final ScrollController? scrollController;
  final bool shrinkOnScroll;

  @override
  State<ExpressiveFab> createState() => _ExpressiveFabState();
}

class _ExpressiveFabState extends State<ExpressiveFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _pressScale;
  var _isScrolledDown = false;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 250),
    );
    _pressScale = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOut));
    if (widget.shrinkOnScroll && widget.scrollController != null) {
      widget.scrollController!.addListener(_onScroll);
    }
  }

  void _onScroll() {
    if (widget.scrollController == null) return;
    final direction = widget.scrollController!.position.userScrollDirection;
    final scrolledDown = direction == ScrollDirection.reverse;
    if (scrolledDown != _isScrolledDown) {
      setState(() => _isScrolledDown = scrolledDown);
    }
  }

  @override
  void didUpdateWidget(ExpressiveFab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shrinkOnScroll != oldWidget.shrinkOnScroll ||
        widget.scrollController != oldWidget.scrollController) {
      oldWidget.scrollController?.removeListener(_onScroll);
      if (widget.shrinkOnScroll && widget.scrollController != null) {
        widget.scrollController!.addListener(_onScroll);
      }
    }
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    _pressCtrl.dispose();
    super.dispose();
  }

  double get _containerSize {
    if (_isScrolledDown && widget.shrinkOnScroll) {
      return 40; // shrink to small
    }
    switch (widget.size) {
      case ExpressiveFabSize.small:
        return 40;
      case ExpressiveFabSize.medium:
        return 56;
      case ExpressiveFabSize.large:
        return 96;
    }
  }

  double get _iconSize {
    if (_isScrolledDown && widget.shrinkOnScroll) return 20;
    switch (widget.size) {
      case ExpressiveFabSize.small:
        return 20;
      case ExpressiveFabSize.medium:
        return 24;
      case ExpressiveFabSize.large:
        return 36;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bgColor = widget.backgroundColor ?? scheme.primaryContainer;
    final fgColor = widget.foregroundColor ?? scheme.onPrimaryContainer;
    final shapeTokens = ExpressiveShapeTokens(type: widget.shapeType);
    final shapeBorder = shapeTokens.shape(_containerSize * 0.4);
    final isExtended = widget.label != null && !_isScrolledDown;

    Widget child;
    if (isExtended) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null)
            Icon(widget.icon, size: _iconSize, color: fgColor),
          if (widget.icon != null && widget.label != null)
            const SizedBox(width: 12),
          if (widget.label != null)
            Text(
              widget.label!,
              style: TextStyle(
                color: fgColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.1,
              ),
            ),
        ],
      );
    } else {
      child = Icon(widget.icon ?? Icons.add, size: _iconSize, color: fgColor);
    }

    Widget fab = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      width: isExtended ? null : _containerSize,
      height: _containerSize,
      constraints: isExtended ? BoxConstraints(minWidth: _containerSize) : null,
      child: Material(
        color: bgColor,
        elevation: widget.elevation,
        shape: shapeBorder,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onPressed,
          onTapDown: (_) => _pressCtrl.forward(),
          onTapUp: (_) => _pressCtrl.reverse(),
          onTapCancel: () => _pressCtrl.reverse(),
          customBorder: shapeBorder,
          child: Padding(
            padding: isExtended
                ? const EdgeInsets.symmetric(horizontal: 20)
                : EdgeInsets.zero,
            child: Center(child: child),
          ),
        ),
      ),
    );

    // Spring press scale
    fab = AnimatedBuilder(
      animation: _pressScale,
      builder: (context, child) =>
          Transform.scale(scale: _pressScale.value, child: child),
      child: fab,
    );

    if (widget.tooltip != null) {
      fab = Tooltip(message: widget.tooltip!, child: fab);
    }

    if (widget.heroTag != null) {
      fab = Hero(tag: widget.heroTag!, child: fab);
    }

    return fab;
  }
}
