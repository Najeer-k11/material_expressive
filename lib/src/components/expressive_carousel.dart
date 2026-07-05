import 'package:flutter/material.dart';

/// An expressive horizontal carousel with peek/snap behavior.
///
/// Cards peek from edges and snap to center on scroll.
class ExpressiveCarousel extends StatefulWidget {
  const ExpressiveCarousel({
    super.key,
    required this.items,
    this.height = 200,
    this.viewportFraction = 0.85,
    this.borderRadius = 24,
    this.spacing = 12,
    this.onPageChanged,
  });

  final List<Widget> items;
  final double height;
  final double viewportFraction;
  final double borderRadius;
  final double spacing;
  final ValueChanged<int>? onPageChanged;

  @override
  State<ExpressiveCarousel> createState() => _ExpressiveCarouselState();
}

class _ExpressiveCarouselState extends State<ExpressiveCarousel> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: widget.viewportFraction);
  }

  @override
  void didUpdateWidget(ExpressiveCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.viewportFraction != oldWidget.viewportFraction) {
      _controller.dispose();
      _controller = PageController(viewportFraction: widget.viewportFraction);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.items.length,
        onPageChanged: widget.onPageChanged,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double scale = 1.0;
              if (_controller.position.haveDimensions) {
                final page =
                    _controller.page ?? _controller.initialPage.toDouble();
                final diff = (page - index).abs();
                scale = (1 - diff * 0.1).clamp(0.85, 1.0);
              }
              return Transform.scale(scale: scale, child: child);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: widget.items[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
