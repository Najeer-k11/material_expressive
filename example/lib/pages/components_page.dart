import 'package:flutter/material.dart';
import 'package:material_expressive/material_expressive.dart';

class ComponentsPage extends StatefulWidget {
  const ComponentsPage({super.key});

  @override
  State<ComponentsPage> createState() => _ComponentsPageState();
}

class _ComponentsPageState extends State<ComponentsPage> {
  var _groupSel = 0;
  var _menuOpen = false;
  var _liked = false;
  var _playing = false;
  var _selected = false;
  var _chips = true;
  var _fabMorphIndex = 0;
  var _morphActive = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Components')),
      floatingActionButton: ExpressiveFab(
        onPressed: () =>
            setState(() => _fabMorphIndex = (_fabMorphIndex + 1) % 3),
        icon: [Icons.add, Icons.edit, Icons.check][_fabMorphIndex],
        shapeType: ExpressiveShapeType.organic,
        size: [
          ExpressiveFabSize.medium,
          ExpressiveFabSize.large,
          ExpressiveFabSize.small,
        ][_fabMorphIndex],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Button Group
          const _Title('Button Group'),
          ExpressiveButtonGroup(
            selectedIndex: _groupSel,
            onSelected: (i) => setState(() => _groupSel = i),
            buttons: const [
              ExpressiveButtonGroupItem(label: 'Day', icon: Icons.today),
              ExpressiveButtonGroupItem(label: 'Week', icon: Icons.view_week),
              ExpressiveButtonGroupItem(label: 'Month'),
            ],
          ),
          const SizedBox(height: 24),

          // Action Chips
          const _Title('Action Chips'),
          if (_chips)
            ExpressiveActionChipList(
              dismissible: true,
              onDismiss: () => setState(() => _chips = false),
              chips: [
                ExpressiveActionChip(
                  label: 'Select',
                  icon: Icons.check_circle,
                  onPressed: () {},
                ),
                ExpressiveActionChip(
                  label: 'Add photos',
                  icon: Icons.camera_alt,
                  onPressed: () {},
                ),
                ExpressiveActionChip(
                  label: 'Share album',
                  icon: Icons.share,
                  onPressed: () {},
                ),
                ExpressiveActionChip(
                  label: 'Search',
                  icon: Icons.search,
                  onPressed: () {},
                ),
              ],
            )
          else
            TextButton(
              onPressed: () => setState(() => _chips = true),
              child: const Text('Restore chips'),
            ),
          const SizedBox(height: 24),

          // Split Button
          const _Title('Split Button'),
          ExpressiveSplitButton(
            label: 'Save',
            icon: Icons.save,
            onPressed: () => showExpressiveSnackBar(
              context,
              message: 'Saved!',
              icon: Icons.check_circle,
            ),
            onDropdown: () {},
          ),
          const SizedBox(height: 24),

          // Floating Toolbar
          const _Title('Floating Toolbar'),
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
                FloatingToolbarItem(
                  icon: Icons.settings,
                  isPrimary: true,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Expressive Carousel
          const _Title('Expressive Carousel'),
          ExpressiveCarousel(
            height: 120,
            items: [
              Card(
                color: scheme.primaryContainer,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_library, size: 28, color: scheme.onPrimaryContainer),
                      const SizedBox(height: 4),
                      Text('First Page', style: TextStyle(color: scheme.onPrimaryContainer, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              Card(
                color: scheme.secondaryContainer,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.palette, size: 28, color: scheme.onSecondaryContainer),
                      const SizedBox(height: 4),
                      Text('Second Page', style: TextStyle(color: scheme.onSecondaryContainer, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              Card(
                color: scheme.tertiaryContainer,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bolt, size: 28, color: scheme.onTertiaryContainer),
                      const SizedBox(height: 4),
                      Text('Third Page', style: TextStyle(color: scheme.onTertiaryContainer, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // State Morph Container
          const _Title('State Morph Container (tap to morph shape/color)'),
          Center(
            child: GestureDetector(
              onTap: () => setState(() => _morphActive = !_morphActive),
              child: StateMorphContainer(
                isActive: _morphActive,
                activeShape: MaterialShapes.heart,
                inactiveShape: MaterialShapes.circle,
                activeColor: scheme.primary,
                inactiveColor: scheme.surfaceContainerHigh,
                size: 80,
                child: Icon(
                  _morphActive ? Icons.favorite : Icons.favorite_border,
                  color: _morphActive ? scheme.onPrimary : scheme.onSurfaceVariant,
                  size: 32,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Expressive Icons
          const _Title('Expressive Icons'),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _IconDemo(
                Icons.favorite,
                ExpressiveFabSize.small.name,
                ExpressiveIconSize.small,
                ExpressiveShapeType.organic,
                scheme,
              ),
              _IconDemo(
                Icons.star,
                ExpressiveFabSize.medium.name,
                ExpressiveIconSize.medium,
                ExpressiveShapeType.squircle,
                scheme,
              ),
              _IconDemo(
                Icons.rocket_launch,
                ExpressiveFabSize.large.name,
                ExpressiveIconSize.large,
                ExpressiveShapeType.organic,
                scheme,
              ),
              _IconDemo(
                Icons.diamond,
                'xl',
                ExpressiveIconSize.extraLarge,
                ExpressiveShapeType.rounded,
                scheme,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Animated Icons
          const _Title('Animated Icons'),
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
                        isActive: _menuOpen,
                        onPressed: () => setState(() => _menuOpen = !_menuOpen),
                      ),
                      const Text('Toggle', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                  Column(
                    children: [
                      BouncingIcon(
                        icon: Icons.favorite_border,
                        activeIcon: Icons.favorite,
                        isActive: _liked,
                        activeColor: Colors.red,
                        onPressed: () => setState(() => _liked = !_liked),
                      ),
                      const Text('Bounce', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                  Column(
                    children: [
                      MorphingIcon(
                        icon: Icons.play_arrow,
                        activeIcon: Icons.pause,
                        isActive: _playing,
                        onPressed: () => setState(() => _playing = !_playing),
                      ),
                      const Text('Morph', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                  Column(
                    children: [
                      SelectionIcon(
                        isSelected: _selected,
                        onChanged: (v) => setState(() => _selected = v),
                      ),
                      const Text('Select', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Loading
          const _Title('Loading Indicators'),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _LoaderDemo('Contained', ContainedLoadingIndicator()),
              _LoaderDemo('Organic', OrganicLoadingIndicator()),
              _LoaderDemo('Pulsing', PulsingDotsIndicator()),
              _LoaderDemo('Morphing', MorphingShapeIndicator()),
            ],
          ),
          const SizedBox(height: 16),
          WavyLinearProgressIndicator(color: scheme.primary),
          const SizedBox(height: 12),
          WavyLinearProgressIndicator(value: 0.65, color: scheme.secondary),
          const SizedBox(height: 24),

          // Surfaces
          const _Title('Surfaces'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ExpressiveSurfaceType.values.map((t) {
              return ExpressiveSurface(
                type: t,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                borderRadius: BorderRadius.circular(12),
                child: Text(t.name, style: theme.textTheme.labelSmall),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // State Layer
          const _Title('State Layer (press)'),
          ExpressiveStateLayer(
            onTap: () {},
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'Press for spring scale',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Search bar
          const _Title('Expressive Search Bar'),
          ExpressiveSearchBar(
            hintText: 'Search components...',
            onChanged: (_) {},
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _LoaderDemo extends StatelessWidget {
  const _LoaderDemo(this.label, this.widget);
  final String label;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget,
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}

class _IconDemo extends StatelessWidget {
  const _IconDemo(this.icon, this.label, this.size, this.shape, this.scheme);
  final IconData icon;
  final String label;
  final ExpressiveIconSize size;
  final ExpressiveShapeType shape;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpressiveIcon(icon, size: size, shapeType: shape),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
