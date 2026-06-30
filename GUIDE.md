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
- Provides **screen templates** as layout guidance (not locked-in widgets)

---

## Architecture

```
lib/
├── material_expressive.dart   ← barrel (imports everything)
├── tokens.dart                ← design tokens only
├── shapes.dart                ← 35 shapes + morphing + RTL
├── motion.dart                ← springs, schemes, gestures, accessibility
├── theme.dart                 ← theme gen, vibrant colors, harmonization
├── components.dart            ← surfaces, buttons, indicators, behaviors
├── templates.dart             ← screen templates
├── core.dart                  ← extensions, adaptive, layout
└── devtools.dart              ← debugging tools
```

Each sub-library can be imported independently. You don't pay for what you don't use (tree-shaking handles the rest).

---

## Design Tokens

Tokens are the foundation. Nothing in the system uses hardcoded values.

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

The motion system is the biggest difference from standard Material. Everything uses **spring physics**, not fixed durations.

### MotionScheme

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
  MotionScheme.expressive.defaultSpatial,
  target: 1.0,
  velocity: dragVelocity,  // optional: feed gesture velocity
);
```

### Component motion tokens

Each component type has a pre-assigned spring:

```dart
ComponentMotion.button      // standard.fastSpatial
ComponentMotion.card        // standard.defaultSpatial
ComponentMotion.dialog      // expressive.fastSpatial
ComponentMotion.bottomSheet // expressive.defaultSpatial
ComponentMotion.hero        // expressive (full scheme)
ComponentMotion.navigation  // standard (full scheme)
ComponentMotion.shapeMorph  // expressive.defaultSpatial
```

### Accessibility

The system respects `MediaQuery.disableAnimations`:

```dart
// Returns Duration.zero if motion is disabled
MotionAccessibility.adaptiveDuration(context, Duration(milliseconds: 400))

// Returns critically-damped (no bounce) if motion should be reduced
MotionAccessibility.adaptiveSpring(context, MotionScheme.expressive.defaultSpatial)
```

---

## Shape System

35 shapes matching the official Compose `MaterialShapes` API.

### How shapes work

Each shape is a `List<Offset>` of 32 normalized points (x/y in 0..1 range). This allows:

1. **Rendering** — draw as a filled path in any size
2. **Morphing** — interpolate between any two shapes
3. **Borders** — use as `ShapeBorder` on Material widgets
4. **Clipping** — clip widgets to any shape

### Shape morphing

```dart
// The ShapeMorph widget handles animation automatically
ShapeMorph(
  shape: MaterialShapes.heart,  // change this reference → animates
  size: 100,
  color: Colors.red,
  duration: Duration(milliseconds: 600),
)
```

Under the hood: `lerpShapePoints(shapeA, shapeB, t)` interpolates point-by-point.

### State-driven morphing

```dart
StateMorphContainer(
  isActive: _isSelected,
  activeShape: MaterialShapes.circle,
  inactiveShape: MaterialShapes.square,
  spring: MotionScheme.expressive.defaultSpatial,
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
VibrantColorScheme.fromSeed(seedColor: Colors.blue, saturationBoost: 0.2)
```

### Color harmonization

Makes custom colors feel cohesive with the theme:

```dart
// Your brand red, shifted toward the seed hue
final harmonizedRed = ColorHarmonization.harmonize(
  Color(0xFFFF0000), seedColor, amount: 0.2);

// Full pair with container/onContainer
final pair = ColorHarmonization.harmonizePair(
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
final shape = RtlShapes.directional(context, MaterialShapes.arrow);

// Manual transforms
RtlShapes.flipHorizontal(shape)
RtlShapes.rotate(shape, 0.25)  // 90 degrees
RtlShapes.scale(shape, 0.8)
```

---

## Theme Generation

One call generates everything:

```dart
final theme = ExpressiveTheme.fromSeed(
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
final themed = ExpressiveComponentThemes.applyExpressive(
  theme.materialTheme,
  coloredAppBar: true,
);
```

After this, standard Flutter widgets (FAB, NavigationBar, AppBar, Cards, IconButtons) automatically use expressive styling.

### New component types

| Component                   | What it does                           |
| --------------------------- | -------------------------------------- |
| `ExpressiveButtonGroup`     | Connected button row with shared radii |
| `ExpressiveSplitButton`     | Primary action + dropdown in one unit  |
| `ExpressiveFloatingToolbar` | Pill-shaped floating action bar        |
| `ExpressiveCarousel`        | Horizontal cards with peek and snap    |
| `ExpressiveSearchBar`       | Collapses to icon, expands with spring |
| `ContainedLoadingIndicator` | Segmented arc progress                 |
| `StateMorphContainer`       | Shape-morphs on state change           |
| `ShapeContainerTransform`   | Container expand with shape morph      |

### Expressive dialogs, sheets, snackbars

These are functions that enhance standard Material behaviors:

```dart
showExpressiveDialog(...)      // scale+fade entry
showExpressiveBottomSheet(...) // spring drag with snap points
showExpressiveSnackBar(...)    // icon + shaped + floating
```

---

## Templates

Layout guidance for common screens. They compose standard Material widgets with proper spacing and structure:

- `LoginTemplate` — auth screen with adaptive spacing
- `ProfileTemplate` — avatar + stats + cover image
- `DashboardTemplate` — adaptive metric grid
- `ChatTemplate` + `ChatBubble` — messaging UI
- `SettingsTemplate` — grouped settings sections
- `SearchTemplate` — search with suggestions
- `ListTemplate` — sectioned list with refresh
- `MediaTemplate` — hero detail with related items
- `ProductDetailTemplate` — commerce product page

---

## Dev Tools

### SpacingOverlay

Renders an 8dp grid over your UI during development:

```dart
SpacingOverlay(
  enabled: kDebugMode,
  gridSize: 8,
  child: MyApp(),
)
```

### TokenInspector

A drawer that visualizes current token values (colors, spacing, radius):

```dart
Scaffold(endDrawer: const TokenInspector())
```

---

## What this does NOT do

- Does not replace `ElevatedButton` with `ExpressiveButton`
- Does not require you to use custom widgets
- Does not break if you use standard Material alongside it
- Does not add runtime overhead beyond what your animations need
- Does not require specific fonts (but works better with variable fonts)

Everything is opt-in and composable. Use the tokens, ignore the templates. Use the shapes, ignore the motion. Mix and match.
