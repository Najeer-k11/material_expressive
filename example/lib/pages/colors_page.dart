import 'package:flutter/material.dart';
import 'package:material_expressive/material_expressive.dart';

class ColorsPage extends StatelessWidget {
  const ColorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Colors & Theme')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section('Color Roles', [
            _ColorGrid([
              ('Primary', tokens.colors.primary, tokens.colors.onPrimary),
              ('Secondary', tokens.colors.secondary, tokens.colors.onSecondary),
              ('Tertiary', tokens.colors.tertiary, tokens.colors.onTertiary),
              ('Error', tokens.colors.error, tokens.colors.onError),
            ]),
          ]),
          _Section('Containers', [
            _ColorGrid([
              (
                'PrimaryC',
                tokens.colors.primaryContainer,
                tokens.colors.onPrimaryContainer,
              ),
              (
                'SecondaryC',
                tokens.colors.secondaryContainer,
                tokens.colors.onSecondaryContainer,
              ),
              (
                'TertiaryC',
                tokens.colors.tertiaryContainer,
                tokens.colors.onTertiaryContainer,
              ),
              (
                'ErrorC',
                tokens.colors.errorContainer,
                tokens.colors.onErrorContainer,
              ),
            ]),
          ]),
          _Section('Surfaces', [
            _ColorGrid([
              ('Surface', tokens.colors.surface, tokens.colors.onSurface),
              (
                'ContLow',
                tokens.colors.surfaceContainerLow,
                tokens.colors.onSurface,
              ),
              ('Cont', tokens.colors.surfaceContainer, tokens.colors.onSurface),
              (
                'ContHigh',
                tokens.colors.surfaceContainerHigh,
                tokens.colors.onSurface,
              ),
            ]),
          ]),
          _Section('Semantic Surfaces', [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ExpressiveSurfaceType.values.map((t) {
                return ExpressiveSurface(
                  type: t,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  child: Text(
                    t.name,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                );
              }).toList(),
            ),
          ]),
          _Section('Harmonized Colors', [
            Builder(
              builder: (context) {
                final seed = scheme.primary;
                final harmonized = ColorHarmonization.harmonizeAll(seed: seed);
                return _ColorGrid([
                  ('Success', harmonized.success, Colors.white),
                  ('Warning', harmonized.warning, Colors.white),
                  ('Info', harmonized.info, Colors.white),
                  ('Error', harmonized.error, Colors.white),
                ]);
              },
            ),
          ]),
          _Section('Vibrancy Comparison', [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: ColorScheme.fromSeed(
                            seedColor: scheme.primary,
                          ).primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Standard',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text('Standard', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Expressive',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text('Expressive', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ]),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title, this.children);
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _ColorGrid extends StatelessWidget {
  const _ColorGrid(this.items);
  final List<(String, Color, Color)> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        return Container(
          width: 78,
          height: 72,
          decoration: BoxDecoration(
            color: item.$2,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.$1,
                style: TextStyle(
                  color: item.$3,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
