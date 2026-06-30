# Material Expressive

A complete Material 3 Expressive design system for Flutter — not a widget library.

Brings Google's M3 Expressive design language to Flutter through tokens, spring physics, 35 morphable shapes, adaptive layouts, and theme extensions that enhance existing Material widgets.

## Installation

```yaml
dependencies:
  material_expressive: ^0.2.0
```

## Quick Start

```dart
import 'package:material_expressive/material_expressive.dart';

final theme = ExpressiveTheme.fromSeed(
  seedColor: Colors.deepOrange,
  shapeType: ExpressiveShapeType.organic,
);

MaterialApp(
  theme: ExpressiveComponentThemes.applyExpressive(theme.materialTheme),
  darkTheme: ExpressiveComponentThemes.applyExpressive(theme.materialDarkTheme),
  builder: (context, child) => ExpressiveThemeProvider(
    themeData: theme,
    child: child!,
  ),
);
```

## Sub-libraries

```dart
import 'package:material_expressive/material_expressive.dart'; // everything
import 'package:material_expressive/tokens.dart';     // design tokens
import 'package:material_expressive/shapes.dart';     // 35 shapes + morphing
import 'package:material_expressive/motion.dart';     // spring physics + transitions
import 'package:material_expressive/theme.dart';      // theme generation
import 'package:material_expressive/components.dart'; // surfaces, icons, buttons
import 'package:material_expressive/templates.dart';  // screen templates
import 'package:material_expressive/devtools.dart';   // debugging tools
```

## 35 Material Shapes

```dart
// Static shape
Container(
  decoration: ShapeDecoration(
    shape: MorphableShapeBorder(points: MaterialShapes.heart),
    color: Colors.pink,
  ),
)

// Animated morph between shapes
ShapeMorph(
  shape: MaterialShapes.flower, // change to morph
  size: 80,
  duration: Duration(milliseconds: 500),
)
```

Available: circle, square, pill, diamond, triangle, pentagon, arch, arrow, heart, flower, clover4Leaf, clover8Leaf, cookie4/6/7/9/12Sided, boom, softBoom, burst, softBurst, sunny, verySunny, fan, gem, ghostish, bun, oval, puffy, puffyDiamond, semiCircle, slanted, pixelCircle, pixelTriangle, clamShell.

## Spring Physics (MotionScheme)

```dart
// Two schemes: standard (subtle) and expressive (bouncy)
controller.animateWithSpring(
  MotionScheme.expressive.defaultSpatial,
  target: 1.0,
);

// SpringTransition widget
SpringTransition(
  isActive: _expanded,
  spring: MotionScheme.expressive.defaultSpatial,
  scaleActive: 1.2,
  child: myWidget,
)
```

## Components

```dart
// Button group
ExpressiveButtonGroup(
  buttons: [
    ExpressiveButtonGroupItem(label: 'Day', icon: Icons.today),
    ExpressiveButtonGroupItem(label: 'Week'),
    ExpressiveButtonGroupItem(label: 'Month'),
  ],
  selectedIndex: 0,
  onSelected: (i) {},
)

// Split button
ExpressiveSplitButton(
  label: 'Save',
  icon: Icons.save,
  onPressed: _save,
  onDropdown: _showOptions,
)

// Floating toolbar
ExpressiveFloatingToolbar(items: [
  FloatingToolbarItem(icon: Icons.format_bold, isSelected: true),
  FloatingToolbarItem(icon: Icons.format_italic),
  const FloatingToolbarItem.divider(),
  FloatingToolbarItem(icon: Icons.link),
])

// Contained loading indicator
ContainedLoadingIndicator(segments: 4, size: 48)
```

## Theme Extensions

```dart
// Apply expressive styling to all components at once
final expressiveTheme = ExpressiveComponentThemes.applyExpressive(
  theme.materialTheme,
  coloredAppBar: true,
);

// Or apply individually
theme.copyWith(
  floatingActionButtonTheme: ExpressiveComponentThemes.expressiveFab(scheme: scheme),
  navigationBarTheme: ExpressiveComponentThemes.expressiveNavBar(scheme: scheme),
);
```

## Token Access

```dart
context.tokens.spacing.lg
context.tokens.colors.primary
context.tokens.radius.md
context.tokens.shape.lg
context.adaptiveSpacing.xl
```

## License

MIT
