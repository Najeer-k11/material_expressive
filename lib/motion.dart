/// Motion system, in layers:
///
/// 1. `ExpressiveMotionTokens` (in tokens.dart) — raw durations and curves.
/// 2. [ExpressiveMotionSpec] — tween presets (duration + curve).
/// 3. [ExpressiveMotionScheme] — spring presets (`standard`, `expressive`).
/// 4. [ExpressiveComponentMotion] — which spring each component uses.
///
/// Plus transitions, page routes, gesture-driven springs, shape container
/// transforms, and reduced-motion helpers ([ExpressiveMotionAccessibility]).
library;

export 'src/motion/motion_specs.dart';
export 'src/motion/transitions.dart';
export 'src/motion/page_transitions.dart';
export 'src/motion/motion_scheme.dart';
export 'src/motion/component_motion.dart';
export 'src/motion/gesture_spring.dart';
export 'src/motion/shape_container_transform.dart';
export 'src/motion/motion_accessibility.dart';
