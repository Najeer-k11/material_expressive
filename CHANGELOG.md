# Changelog

## 0.5.0

### Color Vibrancy & Image Color getter

- Color vibrancy field added in theme applying, where you can increase the hues. so that they donot look dimmed in dark theme
- Fixed Some shapes and some components like `ExpressiveButtonGroup`
- you can pass dynamic color to this theme constructor from dynamic_color package

## 0.4.0

### Expressive Icons

- `ExpressiveIcon` — any icon in a shaped, colored container (small/medium/large/extraLarge)
- `ExpressiveIconTheme.expressive()` — icon theme with optical sizing and weight
- `ExpressiveIconTheme.expressiveFilled()` — filled variant for selected states
- Works with standard `Icons.*` and third-party icon packages (material_symbols_icons, etc.)

### Wavy Progress Indicators

- `WavyLinearProgressIndicator` — sinusoidal wave track (determinate + indeterminate)
- `WavyCircularProgressIndicator` — circular track with wave undulation (determinate + indeterminate)

## 0.3.0

### Vibrant Colors & Harmonization

- `VibrantColorScheme.fromSeed()` — generates saturated/vibrant palettes (boosted beyond standard Material You)
- `ColorHarmonization.harmonize()` — shift any custom color's hue toward the seed for cohesion
- `ColorHarmonization.harmonizeAll()` — harmonize success/warning/info/error in one call
- `HarmonizedColorPair` — generates container + onContainer from any harmonized color

### Expressive Typography

- `ExpressiveTypography.emphasized()` — apply emphasis to a TextTheme (bolder headlines, larger display)
- `ExpressiveTypography.withVariableAxes()` — set `wght`, `opsz`, `wdth` font variation axes

### State-Driven Shape Morphing

- `StateMorphContainer` — widget that morphs between shapes on active/inactive with spring physics
- `ExpressiveNavBarTheme.morphing()` — nav bar theme with morphable indicator shape

### Expressive Components

- `ExpressiveCarousel` — horizontal page carousel with peek/snap and scale-on-scroll
- `showExpressiveBottomSheet()` — spring drag bottom sheet with snap points
- `showExpressiveDialog()` — scale+fade entry dialog
- `ExpressiveAlertDialog` — shaped dialog with icon/title/content/actions
- `showExpressiveSnackBar()` — icon-bearing shaped floating snackbar
- `ExpressiveSearchBar` — collapses to icon, expands with spring animation

### Motion System Upgrades

- `ComponentMotion` — per-component spring token assignments (nav, hero, dialog, etc.)
- `GestureSpringBox` — drag gesture with fling velocity feeding spring physics
- `ShapeContainerTransform` — container expand with shape morphing (circle → rectangle)
- `MotionAccessibility` — respects `disableAnimations`, provides reduced-motion springs and durations

### RTL Support

- `RtlShapes.directional()` — auto-flip shapes for RTL layouts
- `RtlShapes.flipHorizontal()` / `flipVertical()` / `rotate()` / `scale()` — shape transforms

## 0.2.0

### 35 Material Shapes

- All official M3 Expressive shapes: circle, square, pill, diamond, triangle, pentagon, arch, arrow, heart, flower, clover4Leaf, clover8Leaf, cookie4/6/7/9/12Sided, boom, softBoom, burst, softBurst, sunny, verySunny, fan, gem, ghostish, bun, oval, puffy, puffyDiamond, semiCircle, slanted, pixelCircle, pixelTriangle, clamShell

### Shape Morphing

- `ShapeMorph` widget — animated transition between any two shapes
- `MorphableShapeBorder` — use any shape as a ShapeBorder
- `lerpShapePoints()` — interpolate between shape point lists

### Spring Physics (MotionScheme)

- `MotionScheme.standard` and `MotionScheme.expressive` presets
- `ExpressiveSpring` — configurable stiffness + damping ratio
- `.animateWithSpring()` extension on AnimationController
- `SpringTransition` widget

### New Components

- `ExpressiveButtonGroup` — connected buttons with shared radius
- `ExpressiveSplitButton` — primary action + dropdown trigger
- `ExpressiveFloatingToolbar` — pill-shaped floating action toolbar
- `ContainedLoadingIndicator` — segmented/partitioned progress arc
- `ExpressiveComponentThemes.applyExpressive()` — one-call to theme all components

## 0.1.0

- Initial release
- Design tokens (colors, typography, spacing, radius, elevation, motion, opacity, state, shapes)
- Shape system (rounded, squircle, organic, full)
- Motion system (predefined specs, page transitions, container transform)
- Theme generation from seed color with token provider
- Adaptive spacing (phone/tablet/desktop)
- Components (surfaces, state layer, loading indicators, animated icons)
- Templates (settings, login, profile, dashboard, search, chat, list, media, commerce)
- Dev tools (spacing overlay, token inspector)
