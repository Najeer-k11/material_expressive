import 'motion_scheme.dart';

/// Per-component motion token assignment.
///
/// Different components use different spring configurations
/// based on their visual prominence and interaction type.
class ComponentMotion {
  ComponentMotion._();

  // -- Standard scheme assignments --

  /// Navigation transitions (tabs, rail, bottom nav).
  static const navigation = MotionScheme.standard;

  /// FAB and hero elements.
  static const hero = MotionScheme.expressive;

  /// Buttons and interactive controls.
  static ExpressiveSpring get button => MotionScheme.standard.fastSpatial;

  /// Cards and containers.
  static ExpressiveSpring get card => MotionScheme.standard.defaultSpatial;

  /// Dialogs and overlays.
  static ExpressiveSpring get dialog => MotionScheme.expressive.fastSpatial;

  /// Bottom sheets.
  static ExpressiveSpring get bottomSheet =>
      MotionScheme.expressive.defaultSpatial;

  /// Snackbars and toasts.
  static ExpressiveSpring get snackbar => MotionScheme.standard.fastSpatial;

  /// Search bar expand/collapse.
  static ExpressiveSpring get searchBar =>
      MotionScheme.expressive.defaultSpatial;

  /// Carousel page transitions.
  static ExpressiveSpring get carousel => MotionScheme.expressive.slowSpatial;

  /// Icon animations.
  static ExpressiveSpring get icon => MotionScheme.expressive.fastEffects;

  /// Shape morphing transitions.
  static ExpressiveSpring get shapeMorph =>
      MotionScheme.expressive.defaultSpatial;

  /// State layer (press/hover) effects.
  static ExpressiveSpring get stateLayer => MotionScheme.standard.fastEffects;

  /// Loading indicator effects.
  static ExpressiveSpring get loading => MotionScheme.standard.slowEffects;
}
