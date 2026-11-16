# Changelog

## 0.10.0

### API consistency pass

Every rename below keeps the old name as a `@Deprecated` alias or forwarder,
so 0.9.x code still compiles (with deprecation hints). The aliases will be
removed in **1.0.0**.

#### Naming — every public type now starts with `Expressive`

| Old | New |
| --- | --- |
| `RotatingIcon`, `BouncingIcon`, `MorphingIcon`, `HoverIcon`, `SelectionIcon` | `Expressive…` (same suffix) |
| `ContainedLoadingIndicator`, `OrganicLoadingIndicator`, `PulsingDotsIndicator`, `MorphingShapeIndicator` | `Expressive…` |
| `WavyLinearProgressIndicator`, `WavyCircularProgressIndicator` | `Expressive…` |
| `StateMorphContainer`, `FloatingToolbarItem` | `Expressive…` |
| `ContentWidth`, `AdaptiveGap`, `PageMargins`, `Adaptive`, `DeviceType`, `WindowSizeClass` | `Expressive…` |
| `MotionScheme`, `MotionSpec`, `ComponentMotion`, `MotionAccessibility`, `SpringTransition`, `GestureSpringBox`, `ShapeContainerTransform` | `Expressive…` |
| `ShapeMorph`, `MorphableShapeBorder`, `SquircleBorder`, `OrganicBorder`, `RtlShapes` | `Expressive…` |
| `ColorFromImage`, `ColorHarmonization`, `HarmonizedColors`, `HarmonizedColorPair`, `VibrantColorScheme` | `Expressive…` |
| `SpacingOverlay`, `TokenInspector` | `Expressive…` |
| `SpringAnimationExt` (extension) | `ExpressiveSpringAnimation` (no alias; only matters for explicit extension calls) |

#### Theme — now mirrors Flutter's `Theme` / `ThemeData`

| Old | New |
| --- | --- |
| `ExpressiveTheme.fromSeed(...)` | `ExpressiveThemeData.fromSeed(...)` |
| `ExpressiveThemeProvider(themeData: d, child: c)` | `ExpressiveTheme(data: d, child: c)` |
| `ExpressiveThemeProvider.of(context)` | `ExpressiveTheme.of(context)` |

`ExpressiveTheme.of` no longer asserts when there is no ancestor; it falls
back to `ExpressiveThemeData.fallback(Theme.of(context))` (standard tokens on
the ambient Material theme). `maybeOf` still returns null.

#### Duplicate APIs merged

| Old | New |
| --- | --- |
| `ExpressiveInputThemes.expressiveSlider()` etc. | `ExpressiveComponentThemes.sliderTheme()` etc. |
| `ExpressiveComponentThemes.expressiveFab/NavBar/AppBar/IconButton/CarouselCard()` | `floatingActionButtonTheme` / `navigationBarTheme` / `appBarTheme` / `iconButtonTheme` / `cardTheme` |
| `ExpressiveComponentThemes.applyExpressive()` | `ExpressiveComponentThemes.apply()` |
| `ExpressiveInputThemes.applyAll()` | `ExpressiveComponentThemes.apply()` (applies inputs too) |
| `ExpressiveIconTheme.expressive()` / `.expressiveFilled()` | `ExpressiveComponentThemes.iconTheme(filled: …)` |
| `ExpressiveNavBarTheme.morphing()` | `ExpressiveComponentThemes.navigationBarTheme()` |
| `VibrantColorScheme.harmonize()` | `ExpressiveColorHarmonization.harmonize()` |
| `ExpressiveMotion.quick` etc. | `ExpressiveMotionSpec.quick` etc. |
| `MotionAccessibility.duration(context, normal:, reduced:)` | `ExpressiveMotionAccessibility.adaptiveDuration(context, normal, reduced:)` |
| `smoothPathFromScaled()`, `lerpShapePoints()` | `ExpressiveShapes.smoothPath()`, `ExpressiveShapes.lerp()` |
| `ExpressiveBuildContext` + `ExpressiveTokenContext` extensions | one `ExpressiveContext` extension (also exported from `theme.dart`) |
| `context.brightness` | `context.platformBrightness` |
| `ExpressiveStateTokens.disabledOpacity` | `ExpressiveOpacityTokens.disabled` |

`ExpressiveAdaptive` (formerly `Adaptive`) and the layout helpers now derive
breakpoints from `ExpressiveBreakpointTokens` instead of hardcoded 600/1200
(same values). New: `context.windowSizeClass`, `context.deviceType`,
`context.reduceMotion`, `ExpressiveAdaptive.windowSizeClass()`,
`ExpressiveSpacingTokens.standard`.

#### Parameter names

| Widget | Old | New |
| --- | --- | --- |
| `ExpressiveButtonGroup`, `ExpressiveSplitButton` | `cornerRadius` | `borderRadius` |
| `ExpressiveButtonGroup`, `ExpressiveWavy*ProgressIndicator` | `animationDuration` | `duration` |
| `ExpressiveIcon` | `containerColor`, `iconColor` | `backgroundColor`, `foregroundColor` |

#### Components read tokens

Defaults that matched a token are now nullable and resolve from
`ExpressiveTheme.of(context)`, so a custom `ExpressiveThemeData` restyles the
package's own components: dialog, bottom sheet, snackbar, search bar, surface,
carousel, button group, split button, floating toolbar and FAB radii /
spacing / elevation / durations. `ExpressiveShapeTokens` sizes (`xs`…`xxl`) now
come from `ExpressiveRadiusTokens` (new `radius` field). With standard tokens
every value is the same as before.

Spring defaults now come from the motion scheme:
`ExpressiveCarousel.spring` → `ExpressiveComponentMotion.carousel`, and
`ExpressiveGestureSpringBox` / `ExpressiveSpringTransition` →
`ExpressiveMotionScheme.expressive.defaultSpatial` (same values as before).
`ExpressiveComponentMotion.carousel` was corrected to `standard.slowSpatial`
to match what the carousel actually uses.

#### Visual changes

- `ExpressiveNavBarTheme.morphing()` (deprecated) now also sets the rounded
  indicator shape, as `navigationBarTheme()` always did.

#### Docs

- Removed references to screen templates and `templates.dart` (removed in 0.8.0).
- Removed a duplicated "What this does NOT do" section from the guide.
- Library docs list every sub-library and describe the motion layers.

## 0.9.0

### Migrated to the decoupled Material library (`material_ui`)

Flutter 3.47+ deprecates `package:flutter/material.dart` in favor of the standalone
[`material_ui`](https://pub.dev/packages/material_ui) package. This release moves to it.

- **Breaking:** requires Flutter `>=3.47.0` and Dart `^3.13.0`.
- Depends on `material_ui: ^1.11.0`; all internal imports now use `package:material_ui/material_ui.dart`.
- Bumped `animations` to `^3.0.0` (also built on `material_ui`, so its types match).
- **Breaking:** `MaterialShapes` renamed to **`ExpressiveShapes`**. `material_ui` now exports its own
  `MaterialShapes` (`RoundedPolygon`-based), so keeping the old name would cause `ambiguous_import`
  errors for anyone importing both packages.

#### Migrating

```dart
// before
import 'package:flutter/material.dart';
final pts = MaterialShapes.cookie9Sided;

// after
import 'package:material_ui/material_ui.dart';
final pts = ExpressiveShapes.cookie9Sided;
```

Add `material_ui` to your app's `pubspec.yaml` dependencies. Running `dart fix --apply` also migrates
the old Material import in your own code.

## 0.8.0

### Demo App Enhancements

- **Floating Action Button (FAB) Demo**
  - Tap the floating button to cycle through 5 different cards
  - Each card has a unique expressive design with varying colors and content
  - Built using `GestureSpringBox` for smooth interactive animations
  - Fully responsive and adapts to different screen sizes

- **Card Carousel Improvements**
  - Enhanced card animations and transitions
  - Better peek/snap behavior with more natural easing
  - Improved indicator dot scaling and responsiveness

### Bug Fixes

- Fixed carousel indicator dots to properly handle infinite looping wrap-around
- Improved carousel page switching with better edge case handling
- Resolved minor layout glitches in demo app

## 0.7.0

### New Components

- `NavigationBar` → pill-shaped selection indicator with morphing (morphs between destinations on tap)
- `ExpressiveBottomNavigationBar` — fully custom bottom nav with pill container for selection
- Scroll-aware `ExpressiveNavigationBar` — shrinks when scrolling down, expands when scrolling up
- Pill-shaped selection indicator now morphs smoothly between destinations
- Added `_expressive.navBar.indicator.container.cornerFamily` token for pill curvature control

### Demo App Enhancements

- Main navigation uses new morphing bottom navigation bar
- Light and dark mode GIFs now show the new morphing navigation bar
- All pages fully accessible via navigation bar
- Minor theme tune-ups for better visual balance

### API Additions

- Added `ExpressiveTheme.of(context).navBar` extension for convenient access to nav bar tokens
- Added `ExpressiveNavBarTokens` class

### Bug Fixes

- Fixed navigation bar pill to correctly morph between all destinations
- Scroll-aware animation now works smoothly with the morphing indicator
- Eliminated visual glitches on navigation bar when scrolling
- Removed `indicatorShape` from `NavigationBar` (now handled by `_expressive.navBar.indicator.container.shape`)

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
