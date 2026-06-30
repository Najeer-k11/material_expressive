import 'package:flutter/material.dart';

/// An expressive horizontal carousel with peek/snap behavior.
///
/// Cards peek from edges and snap to center on scroll.
class ExpressiveCarousel extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final controller = PageController(viewportFraction: viewportFraction);

    return SizedBox(
      height: height,
      child: PageView.builder(
        controller: controller,
        itemCount: items.length,
        onPageChanged: onPageChanged,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              double scale = 1.0;
              if (controller.position.haveDimensions) {
                final page =
                    controller.page ?? controller.initialPage.toDouble();
                final diff = (page - index).abs();
                scale = (1 - diff * 0.1).clamp(0.85, 1.0);
              }
              return Transform.scale(scale: scale, child: child);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing / 2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: items[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
