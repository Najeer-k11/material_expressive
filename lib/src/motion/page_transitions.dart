import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

/// Types of page transitions available.
enum ExpressivePageTransitionType { fadeThrough, sharedAxis, fade }

/// Expressive page route transitions.
class ExpressivePageRoute<T> extends PageRouteBuilder<T> {
  ExpressivePageRoute({
    required WidgetBuilder builder,
    super.settings,
    ExpressivePageTransitionType type = ExpressivePageTransitionType.sharedAxis,
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) =>
             builder(context),
         transitionsBuilder: _transitionBuilder(type),
         transitionDuration: _duration(type),
         reverseTransitionDuration: _reverseDuration(type),
       );

  static Duration _duration(ExpressivePageTransitionType type) {
    switch (type) {
      case ExpressivePageTransitionType.fadeThrough:
        return const Duration(milliseconds: 400);
      case ExpressivePageTransitionType.sharedAxis:
        return const Duration(milliseconds: 400);
      case ExpressivePageTransitionType.fade:
        return const Duration(milliseconds: 300);
    }
  }

  static Duration _reverseDuration(ExpressivePageTransitionType type) {
    switch (type) {
      case ExpressivePageTransitionType.fadeThrough:
        return const Duration(milliseconds: 300);
      case ExpressivePageTransitionType.sharedAxis:
        return const Duration(milliseconds: 300);
      case ExpressivePageTransitionType.fade:
        return const Duration(milliseconds: 200);
    }
  }

  static RouteTransitionsBuilder _transitionBuilder(
    ExpressivePageTransitionType type,
  ) {
    switch (type) {
      case ExpressivePageTransitionType.fadeThrough:
        return (context, animation, secondaryAnimation, child) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        };
      case ExpressivePageTransitionType.sharedAxis:
        return (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        };
      case ExpressivePageTransitionType.fade:
        return (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        };
    }
  }
}

/// A [PageTransitionsBuilder] using expressive transitions globally.
class ExpressivePageTransitionsBuilder extends PageTransitionsBuilder {
  const ExpressivePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SharedAxisTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      transitionType: SharedAxisTransitionType.horizontal,
      child: child,
    );
  }
}
