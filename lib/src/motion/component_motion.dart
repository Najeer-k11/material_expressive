import 'motion_scheme.dart';

/// Per-component spring assignment. Components use these as their default
/// springs, so changing an entry here is the one place to retune them.
///
/// Different components use different spring configurations
/// based on their visual prominence and interaction type.
class ExpressiveComponentMotion {
  ExpressiveComponentMotion._();

  // -- Standard scheme assignments --

  /// Navigation transitions (tabs, rail, bottom nav).
  static const navigation = ExpressiveMotionScheme.standard;

  /// FAB and hero elements.
  static const hero = ExpressiveMotionScheme.expressive;

  /// Buttons and interactive controls.
  static ExpressiveSpring get button =>
      ExpressiveMotionScheme.standard.fastSpatial;

  /// Cards and containers.
  static ExpressiveSpring get card =>
      ExpressiveMotionScheme.standard.defaultSpatial;

  /// Dialogs and overlays.
  static ExpressiveSpring get dialog =>
      ExpressiveMotionScheme.expressive.fastSpatial;

  /// Bottom sheets.
  static ExpressiveSpring get bottomSheet =>
      ExpressiveMotionScheme.expressive.defaultSpatial;

  /// Snackbars and toasts.
  static ExpressiveSpring get snackbar =>
      ExpressiveMotionScheme.standard.fastSpatial;

  /// Search bar expand/collapse.
  static ExpressiveSpring get searchBar =>
      ExpressiveMotionScheme.expressive.defaultSpatial;

  /// Carousel page transitions.
  static ExpressiveSpring get carousel =>
      ExpressiveMotionScheme.standard.slowSpatial;

  /// Icon animations.
  static ExpressiveSpring get icon =>
      ExpressiveMotionScheme.expressive.fastEffects;

  /// Shape morphing transitions.
  static ExpressiveSpring get shapeMorph =>
      ExpressiveMotionScheme.expressive.defaultSpatial;

  /// State layer (press/hover) effects.
  static ExpressiveSpring get stateLayer =>
      ExpressiveMotionScheme.standard.fastEffects;

  /// Loading indicator effects.
  static ExpressiveSpring get loading =>
      ExpressiveMotionScheme.standard.slowEffects;
}

// ---- Deprecated aliases (removed in 1.0.0) ----

@Deprecated('Use ExpressiveComponentMotion instead. Will be removed in 1.0.0.')
typedef ComponentMotion = ExpressiveComponentMotion;
