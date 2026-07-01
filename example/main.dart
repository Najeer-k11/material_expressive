import 'package:flutter/material.dart';
import 'package:material_expressive/material_expressive.dart';
import 'pages/colors_page.dart';
import 'pages/shapes_page.dart';
import 'pages/motion_page.dart';
import 'pages/components_page.dart';
import 'pages/inputs_page.dart';
import 'pages/typography_page.dart';

void main() {
  runApp(const MaterialExpressiveDemoApp());
}

class MaterialExpressiveDemoApp extends StatefulWidget {
  const MaterialExpressiveDemoApp({super.key});

  @override
  State<MaterialExpressiveDemoApp> createState() =>
      _MaterialExpressiveDemoAppState();
}

class _MaterialExpressiveDemoAppState extends State<MaterialExpressiveDemoApp> {
  Color _seed = Colors.deepPurple;
  var _shape = ExpressiveShapeType.organic;
  var _dark = false;
  var _vibrancy = 0.2;

  @override
  Widget build(BuildContext context) {
    final theme = ExpressiveTheme.fromSeed(
      seedColor: _seed,
      shapeType: _shape,
      vibrancy: _vibrancy,
      vibrantDarkMode: true,
    );

    return ExpressiveThemeProvider(
      themeData: theme,
      child: MaterialApp(
        title: 'Material Expressive Demo',
        debugShowCheckedModeBanner: false,
        theme: ExpressiveComponentThemes.applyExpressive(theme.materialTheme),
        darkTheme: ExpressiveComponentThemes.applyExpressive(
          theme.materialDarkTheme,
        ),
        themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
        home: DemoHome(
          seed: _seed,
          shape: _shape,
          dark: _dark,
          vibrancy: _vibrancy,
          onSeed: (c) => setState(() => _seed = c),
          onShape: (s) => setState(() => _shape = s),
          onDark: () => setState(() => _dark = !_dark),
          onVibrancy: (v) => setState(() => _vibrancy = v),
        ),
      ),
    );
  }
}

class DemoHome extends StatelessWidget {
  const DemoHome({
    super.key,
    required this.seed,
    required this.shape,
    required this.dark,
    required this.vibrancy,
    required this.onSeed,
    required this.onShape,
    required this.onDark,
    required this.onVibrancy,
  });

  final Color seed;
  final ExpressiveShapeType shape;
  final bool dark;
  final double vibrancy;
  final ValueChanged<Color> onSeed;
  final ValueChanged<ExpressiveShapeType> onShape;
  final VoidCallback onDark;
  final ValueChanged<double> onVibrancy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Expressive'),
        actions: [
          IconButton(
            icon: Icon(dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: onDark,
            tooltip: 'Toggle dark mode',
          ),
          const SizedBox(width: 4),
        ],
      ),
      endDrawer: const TokenInspector(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          // Seed color
          Text('Seed Color', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Colors.deepPurple,
              Colors.deepOrange,
              Colors.teal,
              Colors.pink,
              Colors.indigo,
              Colors.green,
            ].map((c) => _ColorDot(c, seed == c, () => onSeed(c))).toList(),
          ),
          const SizedBox(height: 20),

          // Vibrancy
          Text('Vibrancy', style: theme.textTheme.titleSmall),
          Slider(
            value: vibrancy,
            min: 0,
            max: 0.4,
            divisions: 8,
            label: vibrancy.toStringAsFixed(2),
            onChanged: onVibrancy,
          ),
          const SizedBox(height: 12),

          // Shape
          Text('Shape System', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          ExpressiveButtonGroup(
            selectedIndex: ExpressiveShapeType.values.indexOf(shape),
            onSelected: (i) => onShape(ExpressiveShapeType.values[i]),
            buttons: const [
              ExpressiveButtonGroupItem(label: 'Rounded'),
              ExpressiveButtonGroupItem(label: 'Squircle'),
              ExpressiveButtonGroupItem(label: 'Organic'),
              ExpressiveButtonGroupItem(label: 'Full'),
            ],
          ),
          const SizedBox(height: 28),

          // Feature pages
          Text('Explore', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          ..._pages(context, scheme),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<Widget> _pages(BuildContext ctx, ColorScheme s) {
    final pages = [
      (Icons.palette, 'Colors & Theme', const ColorsPage()),
      (Icons.category, 'Shapes & Morphing', const ShapesPage()),
      (Icons.animation, 'Motion & Springs', const MotionPage()),
      (Icons.widgets, 'Components', const ComponentsPage()),
      (Icons.input, 'Inputs', const InputsPage()),
      (Icons.text_fields, 'Typography', const TypographyPage()),
    ];

    return pages.map((p) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Card(
          child: ListTile(
            leading: Icon(p.$1, color: s.primary),
            title: Text(p.$2),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              ctx,
              ExpressivePageRoute(
                builder: (_) => p.$3,
                type: ExpressivePageTransitionType.sharedAxis,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot(this.color, this.selected, this.onTap);
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: selected
              ? Border.all(
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 3,
                )
              : null,
        ),
        child: selected
            ? const Icon(Icons.check, color: Colors.white, size: 18)
            : null,
      ),
    );
  }
}
