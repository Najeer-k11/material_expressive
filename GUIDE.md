# Material Expressive — Developer Guide

A comprehensive guide to understanding and using the Material Expressive design system.

---

## What is this?

Material Expressive brings Google's M3 Expressive design language (announced at I/O 2025, shipped with Android 16) to Flutter as a composable design system.

**Key principle:** This is NOT a widget library. It does not replace Flutter's built-in widgets with custom ones. Instead, it:

- Defines **design tokens** (spacing, radius, colors, motion, shapes)
- Provides **spring-based motion** that replaces manual duration/curve configuration
- Offers **35 morphable shapes** matching the official M3 Expressive spec
- Generates **complete themes** from a single seed color
- Enhances **existing Material widgets** through `ThemeData` extensions

---

## Architecture

```
lib/
├── material_expressive.dart   ← barrel (imports everything)
├── tokens.dart                ← design tokens only
├── shapes.dart                ← 35 shapes + morphing + RTL
├── motion.dart                ← springs, schemes, gestures, accessibility
├── theme.dart                 ← ExpressiveTheme(Data), vibrant colors, harmonization
├── components.dart            ← widgets + ExpressiveComponentThemes
├── core.dart                  ← extensions, adaptive, layout
└── devtools.dart              ← debugging tools
```

**Naming:** every public type starts with `Expressive`. Static helpers live on
classes (`ExpressiveShapes.lerp`, `ExpressiveAdaptive.value`, …), and
`ExpressiveTheme` / `ExpressiveThemeData` mirror Flutter's `Theme` / `ThemeData`.

Each sub-library can be imported independently. You don't pay for what you don't use (tree-shaking handles the rest).

---

## Design Tokens

Tokens are the foundation. Package components take their default radii, spacing, elevation and durations from the active `ExpressiveTheme` (or standard tokens when there is none), so a custom `ExpressiveThemeData` restyles them. Component-specific sizes that have no matching token (e.g. a 56dp search bar height) stay as documented constructor defaults.

### Spacing

Three scales that auto-select based on device:

| Token | Phone | Tablet | Desktop |
| ----- | ----- | ------ | ------- |
| xxs   | 2     | 4      | 4       |
| xs    | 4     | 8      | 8       |
| sm    | 8     | 12     | 16      |
| md    | 12    | 16     | 24      |
| lg    | 16    | 24     | 32      |
| xl    | 24    | 32     | 40      |
| xxl   | 32    | 40     | 48      |
| xxxl  | 48    | 56     | 64      |

Access via `context.adaptiveSpacing.lg` — auto-picks the right scale.

### Radius

| Token | Value |
| ----- | ----- |
| none  | 0     |
| xs    | 4     |
| sm    | 8     |
| md    | 12    |
| lg    | 16    |
| xl    | 24    |
| xxl   | 28    |
| full  | 9999  |

### Elevation

Standard Material 3 levels: 0, 1, 3, 6, 8, 12.

### Motion

| Token      | Duration |
| ---------- | -------- |
| extraShort | 100ms    |
| short      | 200ms    |
| medium     | 300ms    |
| long       | 450ms    |
| extraLong  | 700ms    |

Plus curves: standard, decelerate, accelerate, emphasized, spring.

---

## Motion System

The motion system is the biggest difference from standard Material. Interactive motion uses **spring physics** rather than fixed durations.

It is layered:

1. `ExpressiveMotionTokens` — raw durations and curves
2. `ExpressiveMotionSpec` — tween presets (`quick`, `standard`, `enter`, `exit`, …)
3. `ExpressiveMotionScheme` — spring presets (`standard`, `expressive`)
4. `ExpressiveComponentMotion` — which spring each component uses by default

### ExpressiveMotionScheme

Two presets:

**Standard** — for functional transitions (navigation, state changes):

- `defaultSpatial`: stiffness 700, damping 0.9
- `fastSpatial`: stiffness 1400, damping 1.0 (no bounce)
- `slowSpatial`: stiffness 300, damping 0.9

**Expressive** — for hero interactions (FAB, dialogs, shape morphs):

- `defaultSpatial`: stiffness 380, damping 0.73 (bouncy)
- `fastSpatial`: stiffness 800, damping 0.78
- `slowSpatial`: stiffness 200, damping 0.7 (very bouncy)

### Using springs

```dart
// On an AnimationController
controller.animateWithSpring(
  ExpressiveMotionScheme.expressive.defaultSpatial,
  target: 1.0,
  velocity: dragVelocity,  // optional: feed gesture velocity
);
```

### Component motion tokens

Each component type has a pre-assigned spring:

```dart
ExpressiveComponentMotion.button      // standard.fastSpatial
ExpressiveComponentMotion.card        // standard.defaultSpatial
ExpressiveComponentMotion.dialog      // expressive.fastSpatial
ExpressiveComponentMotion.bottomSheet // expressive.defaultSpatial
ExpressiveComponentMotion.hero        // expressive (full scheme)
ExpressiveComponentMotion.navigation  // standard (full scheme)
ExpressiveComponentMotion.shapeMorph  // expressive.defaultSpatial
ExpressiveComponentMotion.carousel    // standard.slowSpatial (ExpressiveCarousel's default)
```

### Accessibility

The system respects `MediaQuery.disableAnimations`:

```dart
// Returns Duration.zero if motion is disabled
ExpressiveMotionAccessibility.adaptiveDuration(context, Duration(milliseconds: 400))

// Returns critically-damped (no bounce) if motion should be reduced
ExpressiveMotionAccessibility.adaptiveSpring(context, ExpressiveMotionScheme.expressive.defaultSpatial)
```

---

## Shape System

35 shapes matching the official Compose `ExpressiveShapes` API.

### How shapes work

Each shape is a `List<Offset>` of 32 normalized points (x/y in 0..1 range). This allows:

1. **Rendering** — draw as a filled path in any size
2. **Morphing** — interpolate between any two shapes
3. **Borders** — use as `ShapeBorder` on Material widgets
4. **Clipping** — clip widgets to any shape

### Shape morphing

```dart
// The ExpressiveShapeMorph widget handles animation automatically
ExpressiveShapeMorph(
  shape: ExpressiveShapes.heart,  // change this reference → animates
  size: 100,
  color: Colors.red,
  duration: Duration(milliseconds: 600),
)
```

Under the hood: `ExpressiveShapes.lerp(shapeA, shapeB, t)` interpolates point-by-point.

### State-driven morphing

```dart
ExpressiveStateMorphContainer(
  isActive: _isSelected,
  activeShape: ExpressiveShapes.circle,
  inactiveShape: ExpressiveShapes.square,
  spring: ExpressiveMotionScheme.expressive.defaultSpatial,
  child: Icon(Icons.check),
)
```

The container morphs shape + color when `isActive` changes, using spring physics.

---

## Vibrant Colors

Standard `ColorScheme.fromSeed` produces muted palettes. M3 Expressive uses more saturated tones.

```dart
// Standard (muted)
ColorScheme.fromSeed(seedColor: Colors.blue)

// Vibrant (M3 Expressive)
ExpressiveVibrantColorScheme.fromSeed(seedColor: Colors.blue, saturationBoost: 0.2)
```

### Color harmonization

Makes custom colors feel cohesive with the theme:

```dart
// Your brand red, shifted toward the seed hue
final harmonizedRed = ExpressiveColorHarmonization.harmonize(
  Color(0xFFFF0000), seedColor, amount: 0.2);

// Full pair with container/onContainer
final pair = ExpressiveColorHarmonization.harmonizePair(
  myBrandColor, seedColor, brightness: Brightness.light);
// pair.color, pair.container, pair.onContainer
```

---

## Expressive Typography

```dart
// Standard M3 text theme
final base = ThemeData().textTheme;

// Expressive (bolder headlines, larger display, more weight contrast)
final expressive = ExpressiveTypography.emphasized(base, emphasisLevel: 0.6);
```

For variable fonts (Inter, Roboto Flex, etc.):

```dart
Text('Title',
  style: ExpressiveTypography.withVariableAxes(
    style,
    weight: 700,       // wght axis
    opticalSize: 32,   // opsz axis
    width: 100,        // wdth axis
  ),
)
```

---

## RTL Support

Directional shapes (arrows, fans) auto-flip in RTL contexts:

```dart
// Automatically mirrors for RTL
final shape = ExpressiveRtlShapes.directional(context, ExpressiveShapes.arrow);

// Manual transforms
ExpressiveRtlShapes.flipHorizontal(shape)
ExpressiveRtlShapes.rotate(shape, 0.25)  // 90 degrees
ExpressiveRtlShapes.scale(shape, 0.8)
```

---

## Theme Generation

One call generates everything:

```dart
final theme = ExpressiveThemeData.fromSeed(
  seedColor: Colors.deepOrange,
  shapeType: ExpressiveShapeType.organic,  // rounded, squircle, organic, full
  spacing: ExpressiveSpacingTokens.tablet,
  fontFamily: 'Inter',
);
```

This produces:

- `theme.materialTheme` — light ThemeData
- `theme.materialDarkTheme` — dark ThemeData
- `theme.colors` — ExpressiveColorTokens
- `theme.typography` — ExpressiveTypographyTokens
- `theme.spacing` — ExpressiveSpacingTokens
- `theme.radius` — ExpressiveRadiusTokens
- `theme.motion` — ExpressiveMotionTokens
- `theme.shape` — ExpressiveShapeTokens

The generated ThemeData auto-configures: cards, dialogs, sheets, FABs, chips, nav bars, inputs, buttons, snackbars, page transitions, and app bars.

---

## Component Behaviors

These enhance existing widgets, not replace them.

### ExpressiveComponentThemes

Apply all expressive styles at once:

```dart
final themed = ExpressiveComponentThemes.apply(
  theme.materialTheme,
  coloredAppBar: true,
);
```

After this, standard Flutter widgets (FAB, NavigationBar, AppBar, Cards, IconButtons, sliders, switches, pickers, …) automatically use expressive styling.

### New component types

| Component                   | What it does                           |
| --------------------------- | -------------------------------------- |
| `ExpressiveButtonGroup`     | Connected button row with shared radii |
| `ExpressiveSplitButton`     | Primary action + dropdown in one unit  |
| `ExpressiveFloatingToolbar` | Pill-shaped floating action bar        |
| `ExpressiveCarousel`        | Horizontal cards with peek and snap    |
| `ExpressiveSearchBar`       | Collapses to icon, expands with spring |
| `ExpressiveContainedLoadingIndicator` | Segmented arc progress                 |
| `ExpressiveStateMorphContainer`       | Shape-morphs on state change           |
| `ExpressiveShapeContainerTransform`   | Container expand with shape morph      |

### Expressive dialogs, sheets, snackbars

These are functions that enhance standard Material behaviors:

```dart
showExpressiveDialog(...)      // scale+fade entry
showExpressiveBottomSheet(...) // spring drag with snap points
showExpressiveSnackBar(...)    // icon + shaped + floating
```

---

## Dev Tools

### ExpressiveSpacingOverlay

Renders an 8dp grid over your UI during development:

```dart
ExpressiveSpacingOverlay(
  enabled: kDebugMode,
  gridSize: 8,
  child: MyApp(),
)
```

### ExpressiveTokenInspector

A drawer that visualizes current token values (colors, spacing, radius):

```dart
Scaffold(endDrawer: const ExpressiveTokenInspector())
```

---

## Expressive Icons

M3 Expressive doesn't change icon glyphs — it changes how icons are **presented**. Icons sit inside shaped, colored containers with proper optical sizing.

### The problem

Standard Flutter icons are flat — just a glyph on a background. In M3 Expressive, icons appear inside containers (circles, squircles, organic shapes) with tonal colors, and respond to state changes.

### ExpressiveIcon

Wraps any `IconData` in a shaped container:

```dart
ExpressiveIcon(Icons.favorite,
  size: ExpressiveIconSize.large,        // small, medium, large, extraLarge
  shapeType: ExpressiveShapeType.organic, // rounded, squircle, organic, full
  backgroundColor: scheme.primaryContainer,
  foregroundColor: scheme.onPrimaryContainer,
)
```

Size mapping:

| Size       | Icon | Container |
| ---------- | ---- | --------- |
| small      | 20px | 32px      |
| medium     | 24px | 40px      |
| large      | 28px | 48px      |
| extraLarge | 36px | 64px      |

### Custom shapes on icons

```dart
// Use any of the 35 ExpressiveShapes as the icon container
ExpressiveIcon(Icons.star,
  shape: ExpressiveShapes.heart,  // custom shape points
)
```

### Interactive icons

```dart
ExpressiveIcon(Icons.add,
  onPressed: _handleAdd,
  tooltip: 'Add item',
)
```

### Icon theme

Apply expressive icon styling globally through `IconTheme`:

```dart
// Standard (outlined)
IconTheme(
  data: ExpressiveComponentThemes.iconTheme(scheme: scheme, size: 24),
  child: myWidget,
)

// Filled (for selected states) — sets fill=1, weight=700, grade=200
IconTheme(
  data: ExpressiveComponentThemes.iconTheme(scheme: scheme, filled: true),
  child: myWidget,
)
```

The theme sets `opticalSize`, `weight`, `grade`, and `fill` — which variable icon fonts (like Material Symbols) respond to automatically.

### Pairing with Material Symbols

For the best experience, use the `material_symbols_icons` package:

```yaml
dependencies:
  material_expressive: ^0.10.0
  material_symbols_icons: ^4.0.0
```

```dart
import 'package:material_symbols_icons/symbols.dart';

ExpressiveIcon(Symbols.rocket_launch,
  size: ExpressiveIconSize.large,
  shapeType: ExpressiveShapeType.organic,
)
```

`ExpressiveComponentThemes.iconTheme` sets the variable font axes (`opsz`, `wght`, `FILL`, `GRAD`) that Material Symbols responds to — so icons automatically look heavier when selected, lighter when inactive.

---

## Loading & Progress Indicators

M3 Expressive introduces distinctive loading animations — wavy tracks, segmented arcs, organic blobs, and morphing shapes.

### When to use which

| Indicator                       | Best for                                           |
| ------------------------------- | -------------------------------------------------- |
| `ExpressiveWavyLinearProgressIndicator`   | File uploads, downloads, long operations (playful) |
| `ExpressiveWavyCircularProgressIndicator` | Page loads, refresh actions (playful)              |
| `ExpressiveContainedLoadingIndicator`     | Partitioned/step progress, Chrome-style loading    |
| `ExpressiveOrganicLoadingIndicator`       | Ambient loading, splash screens (organic feel)     |
| `ExpressivePulsingDotsIndicator`          | Chat typing indicators, waiting states             |
| `ExpressiveMorphingShapeIndicator`        | Brand-forward loading, onboarding                  |

### Wavy Linear Progress

A sine wave replaces the flat progress track:

```dart
// Determinate (shows progress)
ExpressiveWavyLinearProgressIndicator(value: 0.65)

// Indeterminate (unknown duration)
ExpressiveWavyLinearProgressIndicator()

// Customized
ExpressiveWavyLinearProgressIndicator(
  value: _progress,
  height: 8,
  waveAmplitude: 4,     // how tall the wave peaks are
  waveLength: 32,       // distance between wave peaks
  color: scheme.tertiary,
  backgroundColor: scheme.surfaceContainerHighest,
)
```

### Wavy Circular Progress

The circular track undulates — the radius oscillates along the circumference:

```dart
// Determinate
ExpressiveWavyCircularProgressIndicator(value: 0.4)

// Indeterminate (rotating wave segment)
ExpressiveWavyCircularProgressIndicator()

// Customized
ExpressiveWavyCircularProgressIndicator(
  size: 64,
  strokeWidth: 5,
  waveAmplitude: 3,    // how much the radius varies
  waveCycles: 8,       // number of bumps around the circle
)
```

### Contained/Segmented Loading

Segmented arcs that fill progressively (like Chrome's new tab loading):

```dart
ExpressiveContainedLoadingIndicator(
  segments: 4,          // number of arc segments
  gapDegrees: 12,      // gap between segments
  size: 48,
  strokeWidth: 4,
)
```

### Organic Blob

A cluster of soft circles orbiting each other:

```dart
ExpressiveOrganicLoadingIndicator(
  size: 48,
  blobCount: 3,
  color: scheme.primary,
)
```

### Pulsing Dots

Classic typing/waiting indicator:

```dart
ExpressivePulsingDotsIndicator(
  size: 48,
  dotCount: 3,
  color: scheme.primary,
)
```

### Morphing Shape

A shape that continuously morphs between circle, square, and diamond:

```dart
ExpressiveMorphingShapeIndicator(size: 48)
```

### Theming

All indicators use `Theme.of(context).colorScheme.primary` by default — so they automatically match your seed color. Override with the `color` parameter when needed.

---

## What this does NOT do

- Does not replace `ElevatedButton` with `ExpressiveButton`
- Does not require you to use custom widgets
- Does not break if you use standard Material alongside it
- Does not add runtime overhead beyond what your animations need
- Does not require specific fonts (but works better with variable fonts)

Everything is opt-in and composable. Use the tokens, ignore the components. Use the shapes, ignore the motion. Mix and match.
