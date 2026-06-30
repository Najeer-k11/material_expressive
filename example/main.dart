import 'package:flutter/material.dart';
import 'package:material_expressive/material_expressive.dart';

void main() {
  runApp(const ExpressiveExampleApp());
}

class ExpressiveExampleApp extends StatefulWidget {
  const ExpressiveExampleApp({super.key});

  @override
  State<ExpressiveExampleApp> createState() => _ExpressiveExampleAppState();
}

class _ExpressiveExampleAppState extends State<ExpressiveExampleApp> {
  Color _seedColor = Colors.deepOrange;
  var _shapeType = ExpressiveShapeType.organic;
  var _isDark = false;

  @override
  Widget build(BuildContext context) {
    final theme = ExpressiveTheme.fromSeed(
      seedColor: _seedColor,
      shapeType: _shapeType,
      vibrancy: 0.3,
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
        themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
        home: _HomePage(
          seedColor: _seedColor,
          shapeType: _shapeType,
          onSeedChanged: (c) => setState(() => _seedColor = c),
          onShapeChanged: (s) => setState(() => _shapeType = s),
          onToggleDark: () => setState(() => _isDark = !_isDark),
        ),
      ),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage({
    required this.seedColor,
    required this.shapeType,
    required this.onSeedChanged,
    required this.onShapeChanged,
    required this.onToggleDark,
  });

  final Color seedColor;
  final ExpressiveShapeType shapeType;
  final ValueChanged<Color> onSeedChanged;
  final ValueChanged<ExpressiveShapeType> onShapeChanged;
  final VoidCallback onToggleDark;

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  var _isMenuOpen = false;
  var _isLiked = false;
  var _isPlaying = false;
  var _selectedButton = 0;
  var _currentShapeIndex = 0;
  var _springActive = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Expressive'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: widget.onToggleDark,
          ),
        ],
      ),
      endDrawer: const TokenInspector(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // -- Seed color --
          Text('Seed Color', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                [
                      Colors.deepOrange,
                      Colors.blue,
                      Colors.teal,
                      Colors.purple,
                      Colors.green,
                      Colors.pink,
                    ]
                    .map(
                      (c) => GestureDetector(
                        onTap: () => widget.onSeedChanged(c),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: c,
                          child: widget.seedColor == c
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                )
                              : null,
                        ),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 24),

          // -- Shape type --
          Text('Shape Type', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<ExpressiveShapeType>(
            segments: const [
              ButtonSegment(
                value: ExpressiveShapeType.rounded,
                label: Text('Rounded'),
              ),
              ButtonSegment(
                value: ExpressiveShapeType.squircle,
                label: Text('Squircle'),
              ),
              ButtonSegment(
                value: ExpressiveShapeType.organic,
                label: Text('Organic'),
              ),
            ],
            selected: {widget.shapeType},
            onSelectionChanged: (s) => widget.onShapeChanged(s.first),
          ),
          const SizedBox(height: 32),

          // -- Shape Morphing --
          Text('Shape Morphing', style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text('Tap to morph between shapes', style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          Center(
            child: GestureDetector(
              onTap: () => setState(() {
                _currentShapeIndex =
                    (_currentShapeIndex + 1) % MaterialShapes.allNames.length;
              }),
              child: Column(
                children: [
                  ShapeMorph(
                    shape: MaterialShapes.byName(
                      MaterialShapes.allNames[_currentShapeIndex],
                    ),
                    size: 120,
                    color: scheme.primary,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    MaterialShapes.allNames[_currentShapeIndex],
                    style: theme.textTheme.labelLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Static shape grid
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                [
                      'heart',
                      'flower',
                      'clover4Leaf',
                      'boom',
                      'sunny',
                      'gem',
                      'cookie6Sided',
                      'diamond',
                    ]
                    .map(
                      (name) => Container(
                        width: 48,
                        height: 48,
                        decoration: ShapeDecoration(
                          color: scheme.tertiaryContainer,
                          shape: MorphableShapeBorder(
                            points: MaterialShapes.byName(name),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 32),

          // -- Spring Physics --
          Text('Spring Physics', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          Center(
            child: GestureDetector(
              onTap: () => setState(() => _springActive = !_springActive),
              child: SpringTransition(
                isActive: _springActive,
                spring: MotionScheme.expressive.defaultSpatial,
                scaleActive: 1.3,
                scaleInactive: 1.0,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: scheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      _springActive ? '🎉' : '👆',
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Tap for spring bounce',
              style: theme.textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 32),

          // -- Button Group --
          Text('Button Group', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          ExpressiveButtonGroup(
            buttons: const [
              ExpressiveButtonGroupItem(label: 'Day', icon: Icons.today),
              ExpressiveButtonGroupItem(label: 'Week', icon: Icons.view_week),
              ExpressiveButtonGroupItem(
                label: 'Month',
                icon: Icons.calendar_month,
              ),
            ],
            selectedIndex: _selectedButton,
            onSelected: (i) => setState(() => _selectedButton = i),
          ),
          const SizedBox(height: 32),

          // -- Split Button --
          Text('Split Button', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          ExpressiveSplitButton(
            label: 'Save',
            icon: Icons.save,
            onPressed: () {},
            onDropdown: () {},
          ),
          const SizedBox(height: 32),

          // -- Floating Toolbar --
          Text('Floating Toolbar', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          Center(
            child: ExpressiveFloatingToolbar(
              items: [
                FloatingToolbarItem(
                  icon: Icons.format_bold,
                  isSelected: true,
                  onPressed: () {},
                ),
                FloatingToolbarItem(
                  icon: Icons.format_italic,
                  onPressed: () {},
                ),
                FloatingToolbarItem(
                  icon: Icons.format_underline,
                  onPressed: () {},
                ),
                const FloatingToolbarItem.divider(),
                FloatingToolbarItem(icon: Icons.link, onPressed: () {}),
                FloatingToolbarItem(icon: Icons.image, onPressed: () {}),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // -- Loading Indicators --
          Text('Loading Indicators', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  ContainedLoadingIndicator(segments: 4),
                  SizedBox(height: 8),
                  Text('Contained'),
                ],
              ),
              Column(
                children: [
                  OrganicLoadingIndicator(),
                  SizedBox(height: 8),
                  Text('Organic'),
                ],
              ),
              Column(
                children: [
                  PulsingDotsIndicator(),
                  SizedBox(height: 8),
                  Text('Pulsing'),
                ],
              ),
              Column(
                children: [
                  MorphingShapeIndicator(),
                  SizedBox(height: 8),
                  Text('Morphing'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),

          // -- Animated Icons --
          Text('Animated Icons', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      ExpressiveAnimatedIcon(
                        icon: AnimatedIcons.menu_close,
                        isActive: _isMenuOpen,
                        onPressed: () =>
                            setState(() => _isMenuOpen = !_isMenuOpen),
                      ),
                      const Text('Menu'),
                    ],
                  ),
                  Column(
                    children: [
                      BouncingIcon(
                        icon: Icons.favorite_border,
                        activeIcon: Icons.favorite,
                        isActive: _isLiked,
                        activeColor: Colors.red,
                        onPressed: () => setState(() => _isLiked = !_isLiked),
                      ),
                      const Text('Like'),
                    ],
                  ),
                  Column(
                    children: [
                      MorphingIcon(
                        icon: Icons.play_arrow,
                        activeIcon: Icons.pause,
                        isActive: _isPlaying,
                        onPressed: () =>
                            setState(() => _isPlaying = !_isPlaying),
                      ),
                      const Text('Play'),
                    ],
                  ),
                  Column(
                    children: [
                      HoverIcon(
                        icon: Icons.settings,
                        tooltip: 'Settings',
                        onPressed: () {},
                      ),
                      const Text('Hover'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // -- Surfaces --
          Text('Surfaces', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _SurfaceChip('Primary', ExpressiveSurfaceType.primaryTinted),
              _SurfaceChip('Secondary', ExpressiveSurfaceType.secondaryTinted),
              _SurfaceChip('Tertiary', ExpressiveSurfaceType.tertiaryTinted),
              _SurfaceChip('Container', ExpressiveSurfaceType.container),
              _SurfaceChip('High', ExpressiveSurfaceType.containerHigh),
            ],
          ),
          const SizedBox(height: 32),

          // -- State Layer --
          Text('State Layer', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          ExpressiveStateLayer(
            onTap: () {},
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'Press for scale animation',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _SurfaceChip extends StatelessWidget {
  const _SurfaceChip(this.label, this.type);
  final String label;
  final ExpressiveSurfaceType type;

  @override
  Widget build(BuildContext context) {
    return ExpressiveSurface(
      type: type,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: BorderRadius.circular(12),
      child: Text(label, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}
