import 'package:flutter/material.dart';
import 'package:material_expressive/material_expressive.dart';

class TypographyPage extends StatefulWidget {
  const TypographyPage({super.key});

  @override
  State<TypographyPage> createState() => _TypographyPageState();
}

class _TypographyPageState extends State<TypographyPage> {
  var _emphasis = 0.6;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).textTheme;
    final expressive = ExpressiveTypography.emphasized(
      base,
      emphasisLevel: _emphasis,
    );
    final scheme = Theme.of(context).colorScheme;
    final tokens = context.tokens;

    return Scaffold(
      appBar: AppBar(title: const Text('Typography')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Emphasis Level', style: base.titleSmall),
          Slider(
            value: _emphasis,
            min: 0,
            max: 1,
            divisions: 10,
            label: _emphasis.toStringAsFixed(1),
            onChanged: (v) => setState(() => _emphasis = v),
          ),
          const SizedBox(height: 24),

          Text(
            'Token Typography',
            style: base.titleSmall?.copyWith(color: scheme.primary),
          ),
          const SizedBox(height: 12),
          ...[
            ('displayLarge', tokens.typography.displayLarge),
            ('headlineLarge', tokens.typography.headlineLarge),
            ('headlineMedium', tokens.typography.headlineMedium),
            ('titleLarge', tokens.typography.titleLarge),
            ('titleMedium', tokens.typography.titleMedium),
            ('bodyLarge', tokens.typography.bodyLarge),
            ('bodyMedium', tokens.typography.bodyMedium),
            ('labelLarge', tokens.typography.labelLarge),
          ].map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.$2.fontSize != null
                        ? 'The quick brown fox'
                        : 'Sample text',
                    style: e.$2,
                  ),
                  Text(
                    e.$1,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  const Divider(height: 12),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'Expressive Emphasis (${_emphasis.toStringAsFixed(1)})',
            style: base.titleSmall?.copyWith(color: scheme.primary),
          ),
          const SizedBox(height: 12),
          Text(
            'Display Large',
            style: expressive.displayLarge?.copyWith(fontSize: 32),
          ),
          Text('Headline Large', style: expressive.headlineLarge),
          Text('Headline Medium', style: expressive.headlineMedium),
          Text('Title Large', style: expressive.titleLarge),
          Text(
            'Body Large — The quick brown fox jumps over the lazy dog',
            style: expressive.bodyLarge,
          ),
          Text('Label Large', style: expressive.labelLarge),
          const SizedBox(height: 24),

          Text(
            'Variable Font Axes',
            style: base.titleSmall?.copyWith(color: scheme.primary),
          ),
          const SizedBox(height: 8),
          Text(
            'Weight 400 (light)',
            style: ExpressiveTypography.withVariableAxes(
              base.bodyLarge!,
              weight: 400,
            ),
          ),
          Text(
            'Weight 600 (semibold)',
            style: ExpressiveTypography.withVariableAxes(
              base.bodyLarge!,
              weight: 600,
            ),
          ),
          Text(
            'Weight 900 (black)',
            style: ExpressiveTypography.withVariableAxes(
              base.bodyLarge!,
              weight: 900,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
