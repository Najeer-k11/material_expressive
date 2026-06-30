import 'package:flutter/material.dart';
import '../tokens/color_tokens.dart';
import '../tokens/spacing_tokens.dart';
import '../tokens/radius_tokens.dart';

/// Debug panel showing current token values.
class TokenInspector extends StatelessWidget {
  const TokenInspector({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tokens = ExpressiveColorTokens.fromScheme(scheme);
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Token Inspector',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const _Header('Colors'),
            _Swatch('Primary', tokens.primary),
            _Swatch('Secondary', tokens.secondary),
            _Swatch('Tertiary', tokens.tertiary),
            _Swatch('Surface', tokens.surface),
            _Swatch('Error', tokens.error),
            const SizedBox(height: 16),
            const _Header('Spacing (Phone)'),
            ..._spacings(ExpressiveSpacingTokens.phone),
            const SizedBox(height: 16),
            const _Header('Radius'),
            ..._radii(ExpressiveRadiusTokens.standard),
          ],
        ),
      ),
    );
  }

  List<Widget> _spacings(ExpressiveSpacingTokens s) => [
    _Row('xxs', '${s.xxs}'),
    _Row('xs', '${s.xs}'),
    _Row('sm', '${s.sm}'),
    _Row('md', '${s.md}'),
    _Row('lg', '${s.lg}'),
    _Row('xl', '${s.xl}'),
    _Row('xxl', '${s.xxl}'),
    _Row('xxxl', '${s.xxxl}'),
  ];

  List<Widget> _radii(ExpressiveRadiusTokens r) => [
    _Row('xs', '${r.xs}'),
    _Row('sm', '${r.sm}'),
    _Row('md', '${r.md}'),
    _Row('lg', '${r.lg}'),
    _Row('xl', '${r.xl}'),
    _Row('xxl', '${r.xxl}'),
  ];
}

class _Header extends StatelessWidget {
  const _Header(this.title);
  final String title;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.name, this.color);
  final String name;
  final Color color;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 12),
        Text(name),
        const Spacer(),
        Text(
          '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}',
          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
        ),
      ],
    ),
  );
}

class _Row extends StatelessWidget {
  const _Row(this.name, this.value);
  final String name;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Text(name),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
        ),
      ],
    ),
  );
}
