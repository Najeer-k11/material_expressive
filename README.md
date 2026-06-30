# Material Expressive

A complete **Material 3 Expressive** design system for Flutter.

This is not a widget library. It's a design system that enhances Flutter's existing Material widgets through tokens, spring physics, 35 morphable shapes, vibrant colors, emphasized typography, and expressive component behaviors.

Inspired by Google's M3 Expressive redesign announced at I/O 2025.

---

## Installation

```yaml
dependencies:
  material_expressive: ^0.3.0
```

```dart
import 'package:material_expressive/material_expressive.dart';
```

---

## Getting Started

### 1. Generate a theme

```dart
final theme = ExpressiveTheme.fromSeed(
  seedColor: Colors.deepOrange,
  shapeType: ExpressiveShapeType.organic,
);
```

### 2. Apply to your app

```dart
MaterialApp(
  theme: ExpressiveComponentThemes.applyExpressive(theme.materialTheme),
  darkTheme: ExpressiveComponentThemes.applyExpressive(theme.materialDarkTheme),
  builder: (context, child) => ExpressiveThemeProvider(
    themeData: theme,
    child: child!,
  ),
);
```

### 3. Access tokens anywhere

```dart
context.tokens.spacing.lg      // adaptive spacing
context.tokens.colors.primary  // semantic color
context.tokens.radius.md       // corner radius
context.tokens.shape.lg        // ShapeBorder
context.adaptiveSpacing.xl     // auto phone/tablet/desktop
```

---

## Sub-libraries

Import only what you need:

| Import                     | Contents                                                                 |
| -------------------------- | ------------------------------------------------------------------------ |
| `material_expressive.dart` | Everything                                                               |
| `tokens.dart`              | Design tokens (colors, spacing, radius, elevation, motion, typography)   |
| `shapes.dart`              | 35 MaterialShapes + morphing + RTL                                       |
| `motion.dart`              | Spring physics, MotionScheme, transitions, gesture spring, accessibility |
| `theme.dart`               | Theme generation, vibrant colors, color harmonization                    |
| `components.dart`          | Surfaces, icons, buttons, carousel, dialog, sheet, snackbar, search      |
| `templates.dart`           | Ready-made screen templates                                              |
| `core.dart`                | Context extensions, adaptive utilities, layout helpers                   |
| `devtools.dart`            | Spacing overlay, token inspector                                         |

---

## Shapes (35 total)

All official M3 Expressive shapes, each defined as interpolatable points:

```dart
// Use as static decoration
Container(
  decoration: ShapeDecoration(
    shape: MorphableShapeBorder(points: MaterialShapes.heart),
    color: Colors.pink,
  ),
)

// Animate between shapes
ShapeMorph(
  shape: MaterialShapes.flower,  // change this → smooth morph
  size: 80,
  color: scheme.primary,
  duration: Duration(milliseconds: 500),
)

// RTL-aware
RtlShapes.directional(context, MaterialShapes.arrow)
```

**All shapes:** circle, square, pill, diamond, triangle, pentagon, arch, arrow, heart, flower, clover4Leaf, clover8Leaf, cookie4/6/7/9/12Sided, boom, softBoom, burst, softBurst, sunny, verySunny, fan, gem, ghostish, bun, oval, puffy, puffyDiamond, semiCircle, slanted, pixelCircle, pixelTriangle, clamShell.

---

## Spring Physics (MotionScheme)

Two predefined schemes matching M3 Expressive motion tokens:

```dart
// Standard — subtle, functional transitions
MotionScheme.standard.defaultSpatial
MotionScheme.standard.fastEffects

// Expressive — bouncy, engaging hero interactions
MotionScheme.expressive.defaultSpatial  // stiffness: 380, damping: 0.73
MotionScheme.expressive.fastSpatial

// Use on any AnimationController
controller.animateWithSpring(
  MotionScheme.expressive.defaultSpatial,
  target: 1.0,
);

// Per-component assignments
ComponentMotion.hero       // expressive scheme
ComponentMotion.navigation // standard scheme
ComponentMotion.dialog     // expressive.fastSpatial
ComponentMotion.button     // standard.fastSpatial
```

### SpringTransition widget

```dart
SpringTransition(
  isActive: _expanded,
  spring: MotionScheme.expressive.defaultSpatial,
  scaleActive: 1.3,
  scaleInactive: 1.0,
  child: myWidget,
)
```

### Gesture-driven spring

```dart
GestureSpringBox(
  spring: MotionScheme.expressive.defaultSpatial,
  axis: Axis.vertical,
  maxOffset: 100,
  snapBack: true,
  child: Card(...),
)
```

### Accessibility

```dart
// Respects system "reduce motion" setting
final spring = MotionAccessibility.adaptiveSpring(
  context, MotionScheme.expressive.defaultSpatial);
final dur = MotionAccessibility.adaptiveDuration(
  context, Duration(milliseconds: 400));
```

---

## Vibrant Colors

M3 Expressive uses more saturated palettes than standard Material You:

```dart
// Vibrant scheme (boosted saturation)
final scheme = VibrantColorScheme.fromSeed(
  seedColor: Colors.blue,
  saturationBoost: 0.2,
);

// Harmonize brand colors with your theme
final brandRed = ColorHarmonization.harmonize(
  myBrandRed, seedColor, amount: 0.25);

// Generate all semantic colors at once
final semantic = ColorHarmonization.harmonizeAll(
  seed: seedColor,
  success: Colors.green,
  warning: Colors.orange,
  info: Colors.blue,
  error: Colors.red,
);
```

---

## Expressive Typography

```dart
// Apply emphasis (bolder, larger headlines)
final textTheme = ExpressiveTypography.emphasized(
  base.textTheme,
  emphasisLevel: 0.6, // 0.0 = standard, 1.0 = max
);

// Variable font axes (if font supports it)
Text('Hello', style: ExpressiveTypography.withVariableAxes(
  baseStyle,
  weight: 700,
  opticalSize: 48,
));
```

---

## Components

### Button Group

```dart
ExpressiveButtonGroup(
  buttons: [
    ExpressiveButtonGroupItem(label: 'Day', icon: Icons.today),
    ExpressiveButtonGroupItem(label: 'Week'),
    ExpressiveButtonGroupItem(label: 'Month'),
  ],
  selectedIndex: _selected,
  onSelected: (i) => setState(() => _selected = i),
)
```

### Split Button

```dart
ExpressiveSplitButton(
  label: 'Save',
  icon: Icons.save,
  onPressed: _save,
  onDropdown: _showOptions,
)
```

### Floating Toolbar

```dart
ExpressiveFloatingToolbar(items: [
  FloatingToolbarItem(icon: Icons.format_bold, isSelected: true, onPressed: () {}),
  FloatingToolbarItem(icon: Icons.format_italic, onPressed: () {}),
  const FloatingToolbarItem.divider(),
  FloatingToolbarItem(icon: Icons.link, onPressed: () {}),
])
```

### Carousel

```dart
ExpressiveCarousel(
  height: 200,
  viewportFraction: 0.85,
  items: [Card(...), Card(...), Card(...)],
)
```

### Search Bar (morph expand)

```dart
ExpressiveSearchBar(
  controller: _searchCtrl,
  hintText: 'Search...',
  onChanged: (q) {},
)
```

### Bottom Sheet

```dart
showExpressiveBottomSheet(
  context: context,
  snap: true,
  snapSizes: [0.25, 0.5, 0.9],
  builder: (_) => MyContent(),
);
```

### Dialog

```dart
showExpressiveDialog(
  context: context,
  builder: (_) => ExpressiveAlertDialog(
    icon: Icon(Icons.warning),
    title: Text('Discard changes?'),
    content: Text('Your edits will be lost.'),
    actions: [
      TextButton(onPressed: () {}, child: Text('Cancel')),
      FilledButton(onPressed: () {}, child: Text('Discard')),
    ],
  ),
);
```

### Snackbar

```dart
showExpressiveSnackBar(context,
  message: 'File saved',
  icon: Icons.check_circle,
  actionLabel: 'Undo',
  onAction: _undo,
);
```

### State Morph Container

```dart
StateMorphContainer(
  isActive: _selected,
  activeShape: MaterialShapes.circle,
  inactiveShape: MaterialShapes.square,
  spring: MotionScheme.expressive.defaultSpatial,
  child: Icon(Icons.star),
)
```

### Shape Container Transform

```dart
ShapeContainerTransform(
  closedShape: MaterialShapes.circle,
  closedSize: 56,
  closedBuilder: (ctx, open) => IconButton(icon: Icon(Icons.add), onPressed: open),
  openBuilder: (ctx, close) => DetailScreen(onBack: close),
)
```

---

## Loading Indicators

```dart
ContainedLoadingIndicator(segments: 4)   // M3 Expressive segmented arc
OrganicLoadingIndicator()                 // blob animation
PulsingDotsIndicator()                    // pulsing dots
MorphingShapeIndicator()                  // morphing shape
```

---

## Surfaces

```dart
ExpressiveSurface(
  type: ExpressiveSurfaceType.primaryTinted,
  padding: EdgeInsets.all(16),
  child: Text('Tinted surface'),
)
```

Types: `surface`, `containerLow`, `container`, `containerHigh`, `primaryTinted`, `secondaryTinted`, `tertiaryTinted`.

---

## Templates

Ready-made screens: `LoginTemplate`, `ProfileTemplate`, `DashboardTemplate`, `ChatTemplate`, `SettingsTemplate`, `SearchTemplate`, `ListTemplate`, `MediaTemplate`, `ProductDetailTemplate`.

---

## Theme Extensions

Apply expressive styling to all standard Material widgets at once:

```dart
final expressiveTheme = ExpressiveComponentThemes.applyExpressive(
  theme.materialTheme,
  coloredAppBar: true,
);
```

Or apply individually:

- `expressiveFab(scheme:)` — organic-shaped FAB
- `expressiveNavBar(scheme:)` — taller nav with bold labels
- `expressiveAppBar(scheme:, colored:)` — bolder title
- `expressiveIconButton(scheme:)` — larger touch targets
- `expressiveCarouselCard(scheme:)` — shaped carousel cards

---

## Dev Tools

```dart
// Spacing grid overlay
SpacingOverlay(enabled: kDebugMode, child: MyApp())

// Token inspector drawer
Scaffold(endDrawer: TokenInspector())
```

---

## License

MIT
