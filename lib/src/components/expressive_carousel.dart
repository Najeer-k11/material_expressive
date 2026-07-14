import 'dart:async';
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import '../motion/motion_scheme.dart';

/// An expressive page scroll physics that overrides snapping spring physics.
class ExpressivePageScrollPhysics extends PageScrollPhysics {
  const ExpressivePageScrollPhysics({
    super.parent,
    required this.expressiveSpring,
  });

  final ExpressiveSpring expressiveSpring;

  @override
  ExpressivePageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ExpressivePageScrollPhysics(
      parent: buildParent(ancestor),
      expressiveSpring: expressiveSpring,
    );
  }

  @override
  SpringDescription get spring => expressiveSpring.toSpringDescription();
}

/// An expressive horizontal carousel with a weighted Material 3 layout,
/// custom spring-based snap physics, auto-play, infinite looping,
/// interactive indicators, and tap-to-focus on peek cards.
class ExpressiveCarousel extends StatefulWidget {
  const ExpressiveCarousel({
    super.key,
    required this.items,
    this.height = 200,
    this.viewportFraction = 0.85,
    this.borderRadius = 24,
    this.spacing = 12,
    this.onPageChanged,
    this.initialPage = 0,
    this.showIndicator = true,
    this.spring = const ExpressiveSpring(stiffness: 300, dampingRatio: 0.9),
    this.controller,
    this.loop = true,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.autoPlayDuration = const Duration(milliseconds: 600),
    this.autoPlayCurve = Curves.easeInOut,
  });

  final List<Widget> items;
  final double height;
  final double viewportFraction;
  final double borderRadius;
  final double spacing;
  final ValueChanged<int>? onPageChanged;

  /// The initial page index of the carousel.
  final int initialPage;

  /// Whether to show a beautiful interactive page indicator below the carousel.
  final bool showIndicator;

  /// The spring physics configuration used for page snapping.
  final ExpressiveSpring spring;

  /// An optional external [PageController] to programmatically control the carousel.
  final PageController? controller;

  /// Whether the carousel should loop infinitely.
  final bool loop;

  /// Whether the carousel should automatically scroll.
  final bool autoPlay;

  /// The duration between automatic scroll transitions.
  final Duration autoPlayInterval;

  /// The animation duration of the auto-play transition.
  final Duration autoPlayDuration;

  /// The animation curve of the auto-play transition.
  final Curve autoPlayCurve;

  @override
  State<ExpressiveCarousel> createState() => _ExpressiveCarouselState();
}

class _ExpressiveCarouselState extends State<ExpressiveCarousel> {
  PageController? _internalController;
  Timer? _autoPlayTimer;
  static const int _loopFactor = 10000;

  PageController get _controller => widget.controller ?? _internalController!;

  int get _itemCount => widget.loop && widget.items.isNotEmpty
      ? widget.items.length * _loopFactor
      : widget.items.length;

  int get _initialPageIndex {
    if (widget.items.isEmpty) return 0;
    if (widget.loop) {
      return (widget.items.length * _loopFactor) ~/ 2 + widget.initialPage;
    }
    return widget.initialPage;
  }

  @override
  void initState() {
    super.initState();
    _initController();
    _startAutoPlay();
  }

  void _initController() {
    if (widget.controller == null) {
      _internalController = PageController(
        initialPage: _initialPageIndex,
        viewportFraction: widget.viewportFraction,
      );
    }
  }

  @override
  void didUpdateWidget(ExpressiveCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    final controllerChanged = widget.controller != oldWidget.controller;
    final loopChanged = widget.loop != oldWidget.loop;
    final initialPageChanged = widget.initialPage != oldWidget.initialPage;
    final viewportFractionChanged = widget.viewportFraction != oldWidget.viewportFraction;

    if (controllerChanged || loopChanged || initialPageChanged || viewportFractionChanged) {
      _stopAutoPlay();
      if (oldWidget.controller == null) {
        _internalController?.dispose();
        _internalController = null;
      }
      _initController();
      _startAutoPlay();
    } else if (widget.autoPlay != oldWidget.autoPlay ||
        widget.autoPlayInterval != oldWidget.autoPlayInterval) {
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _internalController?.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _stopAutoPlay();
    if (!widget.autoPlay || widget.items.length <= 1) return;
    _autoPlayTimer = Timer.periodic(widget.autoPlayInterval, (timer) {
      if (!mounted || !_controller.hasClients) return;
      final page = _controller.page ?? _controller.initialPage.toDouble();
      final nextPage = page.round() + 1;
      
      if (!widget.loop && nextPage >= widget.items.length) {
        _controller.animateToPage(
          0,
          duration: widget.autoPlayDuration,
          curve: widget.autoPlayCurve,
        );
      } else {
        _controller.animateToPage(
          nextPage,
          duration: widget.autoPlayDuration,
          curve: widget.autoPlayCurve,
        );
      }
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
  }

  void _onIndicatorTapped(int targetIndex) {
    if (!_controller.hasClients || widget.items.isEmpty) return;
    
    _stopAutoPlay();
    
    if (widget.loop) {
      final double currentPage = _controller.page ?? _controller.initialPage.toDouble();
      final int currentIntPage = currentPage.round();
      final int currentRealIndex = currentIntPage % widget.items.length;
      
      // Calculate index difference and target page index closest to the current page index
      final int diff = targetIndex - currentRealIndex;
      final int targetPage = currentIntPage + diff;
      
      _controller.animateToPage(
        targetPage,
        duration: widget.autoPlayDuration,
        curve: widget.autoPlayCurve,
      );
    } else {
      _controller.animateToPage(
        targetIndex,
        duration: widget.autoPlayDuration,
        curve: widget.autoPlayCurve,
      );
    }
    _startAutoPlay();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return SizedBox(height: widget.height);
    }

    final Widget pageView = PageView.builder(
      controller: _controller,
      physics: ExpressivePageScrollPhysics(
        expressiveSpring: widget.spring,
        parent: const BouncingScrollPhysics(),
      ),
      itemCount: _itemCount,
      onPageChanged: (index) {
        if (widget.onPageChanged != null) {
          final actualIndex = widget.loop ? index % widget.items.length : index;
          widget.onPageChanged!(actualIndex);
        }
      },
      itemBuilder: (context, index) {
        final actualIndex = widget.loop ? index % widget.items.length : index;

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double diff = 0.0;
            if (_controller.position.haveDimensions) {
              final page = _controller.page ?? _controller.initialPage.toDouble();
              diff = page - index;
            } else {
              diff = (_initialPageIndex - index).toDouble();
            }

            final t = diff.abs().clamp(0.0, 1.0);

            // Interpolate standard BorderRadius
            final double currentRadius = lerpDouble(
              widget.borderRadius,
              widget.borderRadius * 0.7,
              t,
            )!;

            final Widget itemChild = ClipRRect(
              borderRadius: BorderRadius.circular(currentRadius),
              child: child,
            );

            // Apply dynamic padding/shrinking (height and width)
            final double vertPadding = lerpDouble(0, widget.height * 0.08, t)!;
            final double horizPadding = lerpDouble(
              widget.spacing / 2,
              widget.spacing / 2 + 8,
              t,
            )!;

            return GestureDetector(
              onTap: () {
                if (_controller.hasClients) {
                  final currentPage = _controller.page ?? _controller.initialPage.toDouble();
                  final currentIntPage = currentPage.round();
                  if (index != currentIntPage) {
                    _stopAutoPlay();
                    _controller.animateToPage(
                      index,
                      duration: widget.autoPlayDuration,
                      curve: widget.autoPlayCurve,
                    );
                    _startAutoPlay();
                  }
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: vertPadding,
                  horizontal: horizPadding,
                ),
                child: itemChild,
              ),
            );
          },
          child: widget.items[actualIndex],
        );
      },
    );

    final Widget carousel = NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          if (notification.dragDetails != null) {
            _stopAutoPlay();
          }
        } else if (notification is ScrollEndNotification) {
          _startAutoPlay();
        }
        return false;
      },
      child: pageView,
    );

    if (widget.showIndicator && widget.items.length > 1) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: widget.height, child: carousel),
          const SizedBox(height: 12),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              double page = 0.0;
              if (_controller.position.haveDimensions) {
                page = _controller.page ?? _controller.initialPage.toDouble();
              } else {
                page = _initialPageIndex.toDouble();
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.items.length, (index) {
                  // Distance from current page (interpolated)
                  double diff = 0.0;
                  if (widget.loop) {
                    final double currentPageMod = page % widget.items.length;
                    
                    // Handle wrap-around distance for correct indicator dot scaling
                    final d1 = (currentPageMod - index).abs();
                    final d2 = (currentPageMod - (index + widget.items.length)).abs();
                    final d3 = ((currentPageMod + widget.items.length) - index).abs();
                    diff = [d1, d2, d3].reduce((value, element) => value < element ? value : element);
                  } else {
                    diff = (page - index).abs();
                  }

                  final activeFactor = (1.0 - diff).clamp(0.0, 1.0);
                  
                  final width = lerpDouble(8, 24, activeFactor)!;
                  const height = 8.0;
                  final opacity = lerpDouble(0.4, 1.0, activeFactor)!;
                  final color = Theme.of(context).colorScheme.primary.withValues(alpha: opacity);

                  return GestureDetector(
                    onTap: () => _onIndicatorTapped(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeOut,
                      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      );
    }

    return SizedBox(height: widget.height, child: carousel);
  }
}
