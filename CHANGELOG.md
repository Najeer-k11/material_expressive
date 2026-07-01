# Changelog

## 0.6.0

### Color System

- `VibrantColorScheme.fromSeed()` now used as default in `ExpressiveTheme.fromSeed()` — no more muted palettes
- Dark mode colors stay **vibrant** (1.5× saturation boost, minimum 0.3 saturation floor, seed-tinted surfaces)
- `vibrancy` parameter on `fromSeed()` — control how saturated the palette is (0.0 = standard M3, 0.3 = expressive)
- `vibrantDarkMode` parameter — toggle vibrant dark mode (default: true)
- `lightColorScheme` / `darkColorScheme` parameters — plug in external schemes (e.g. from `dynamic_color`)
- `ColorFromImage.extract()` — extract a dominant seed color from any `ImageProvider` (pure Dart, no platform deps)

### Button Group Fix

- Redesigned to match M3 Expressive spec: shared stadium container, **active button morphs to pill** inside the container
- Inactive buttons remain flat segments within the shared outer pill
- Animated size/padding transition on selection change

### Slider Fix

- Custom `_ExpressiveSliderThumbShape` — tall capsule/rounded-rect thumb (not a circle)
- Custom `_ExpressiveSliderTrackShape` — active track is thick stadium, inactive track is thinner
- Matches M3 Expressive reference: chunky pill active portion with capsule thumb

### Smooth Shapes Fix

- `MorphableShapeBorder` and `ShapeMorph` now use **Catmull-Rom spline → cubic Bezier** rendering
- Eliminates jagged/rough edges at all sizes
- Both static `ShapeDecoration` and animated `ShapeMorph` benefit

### New Components

- `ExpressiveActionChip` — pill/stadium chip with icon + label (matches M3 Expressive action chips)
- `ExpressiveActionChipList` — vertical list of action chips with optional dismiss button
- `ExpressiveFab` — full expressive FAB: size variants (small/medium/large), spring press, scroll-aware shrinking, extended mode
- Floating toolbar redesigned: circular icon buttons inside pill, primary item gets accent circle

### Input Themes

- `ExpressiveInputThemes.applyAll()` — wires all input themes automatically via `applyExpressive()`
- Slider, Switch, Checkbox, Radio, DatePicker, TimePicker, Tooltip, PopupMenu, ProgressIndicator

## 0.3.0

### Expressive Icons

- `ExpressiveIcon` — any icon in a shaped, colored container (small/medium/large/extraLarge)
- `ExpressiveIconTheme.expressive()` — optical sizing, weight, grade for variable font icons
- `ExpressiveIconTheme.expressiveFilled()` — filled/selected variant

### Wavy Progress Indicators

- `WavyLinearProgressIndicator` — sine wave track (determinate + indeterminate)
- `WavyCircularProgressIndicator` — undulating circular track (determinate + indeterminate)

### Vibrant Colors

- `VibrantColorScheme.fromSeed()` — boosted saturation color scheme
- `ColorHarmonization` — harmonize brand/semantic colors toward seed hue
- `HarmonizedColors`, `HarmonizedColorPair`

### Expressive Typography

- `ExpressiveTypography.emphasized()` — bolder, larger headlines
- `ExpressiveTypography.withVariableAxes()` — `wght`, `opsz`, `wdth` font variation axes

### Motion Upgrades

- `ComponentMotion` — per-component spring token assignments
- `GestureSpringBox` — drag with fling velocity → spring physics
- `ShapeContainerTransform` — container expand with shape morphing
- `MotionAccessibility` — respects `disableAnimations`

### RTL Shapes

- `RtlShapes.directional()` — auto-flip for RTL
- `RtlShapes.flipHorizontal()` / `flipVertical()` / `rotate()` / `scale()`

### Components

- `StateMorphContainer` — widget morphs shape on active/inactive state
- `ExpressiveCarousel` — horizontal carousel with peek/snap
- `showExpressiveBottomSheet()` — spring drag with snap points
- `showExpressiveDialog()` + `ExpressiveAlertDialog`
- `showExpressiveSnackBar()` — icon + shaped + floating
- `ExpressiveSearchBar` — collapses to icon, expands with spring

## 0.2.0

### 35 Material Shapes

- All official M3 Expressive shapes via `MaterialShapes.*`
- `ShapeMorph` widget, `MorphableShapeBorder`, `lerpShapePoints()`

### Spring Physics

- `MotionScheme.standard` and `MotionScheme.expressive`
- `ExpressiveSpring`, `.animateWithSpring()`, `SpringTransition`

### Components

- `ExpressiveButtonGroup`, `ExpressiveSplitButton`
- `ExpressiveFloatingToolbar`, `ContainedLoadingIndicator`
- `ExpressiveComponentThemes.applyExpressive()`

## 0.1.0

- Initial release: design tokens, organic shape system, motion, theme generation,
  adaptive spacing, surfaces, state layer, loading indicators, animated icons,
  screen templates, dev tools
