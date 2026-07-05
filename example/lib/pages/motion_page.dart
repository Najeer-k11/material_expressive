import 'package:flutter/material.dart';
import 'package:material_expressive/material_expressive.dart';

class MotionPage extends StatefulWidget {
  const MotionPage({super.key});

  @override
  State<MotionPage> createState() => _MotionPageState();
}

class _MotionPageState extends State<MotionPage> with TickerProviderStateMixin {
  late final AnimationController _stdCtrl;
  late final AnimationController _expCtrl;
  late final AnimationController _bounceCtrl;
  var _springActive = false;
  var _morphActive = false;

  @override
  void initState() {
    super.initState();
    _stdCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _expCtrl = AnimationController(vsync: this);
    _bounceCtrl = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _stdCtrl.dispose();
    _expCtrl.dispose();
    _bounceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Motion & Springs')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Motion specs
          Text('Motion Specs', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () {
              _stdCtrl.forward(from: 0);
              _expCtrl.animateWithSpring(
                MotionScheme.expressive.defaultSpatial,
                target: 1.0,
              );
              _bounceCtrl.animateWithSpring(
                MotionScheme.expressive.slowSpatial,
                target: 1.0,
              );
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Play All'),
          ),
          const SizedBox(height: 16),
          _AnimBar('Standard (400ms easeOut)', _stdCtrl, scheme.primary),
          const SizedBox(height: 12),
          _AnimBar(
            'Expressive spring (stiffness 380)',
            _expCtrl,
            scheme.secondary,
          ),
          const SizedBox(height: 12),
          _AnimBar('Slow expressive (bouncy)', _bounceCtrl, scheme.tertiary),
          const SizedBox(height: 32),

          // SpringTransition
          Text('SpringTransition', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Center(
            child: GestureDetector(
              onTap: () => setState(() => _springActive = !_springActive),
              child: SpringTransition(
                isActive: _springActive,
                spring: MotionScheme.expressive.defaultSpatial,
                scaleActive: 1.35,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      _springActive ? '🎉' : '👆',
                      style: const TextStyle(fontSize: 36),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // StateMorphContainer
          Text('State Shape Morphing', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Center(
            child: GestureDetector(
              onTap: () => setState(() => _morphActive = !_morphActive),
              child: Column(
                children: [
                  StateMorphContainer(
                    isActive: _morphActive,
                    activeShape: MaterialShapes.circle,
                    inactiveShape: MaterialShapes.square,
                    activeColor: scheme.primary,
                    inactiveColor: scheme.surfaceContainerHigh,
                    size: 72,
                    spring: MotionScheme.expressive.defaultSpatial,
                    child: Icon(
                      Icons.check,
                      color: _morphActive
                          ? scheme.onPrimary
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _morphActive ? 'square → circle' : 'Tap to morph',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Gesture spring
          Text('Gesture Spring Box', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Drag vertically, release to snap back',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Center(
            child: GestureSpringBox(
              spring: MotionScheme.expressive.defaultSpatial,
              maxOffset: 80,
              child: Container(
                width: 120,
                height: 80,
                decoration: BoxDecoration(
                  color: scheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Drag me',
                    style: TextStyle(
                      color: scheme.onSecondaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Page transitions
          Text('Page Transitions', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Shared Axis'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    ExpressivePageRoute(
                      builder: (_) => const _TransitionDemo('Shared Axis'),
                      type: ExpressivePageTransitionType.sharedAxis,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Fade Through'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    ExpressivePageRoute(
                      builder: (_) => const _TransitionDemo('Fade Through'),
                      type: ExpressivePageTransitionType.fadeThrough,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _AnimBar extends StatelessWidget {
  const _AnimBar(this.label, this.ctrl, this.color);
  final String label;
  final AnimationController ctrl;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        SizedBox(
          height: 20,
          child: AnimatedBuilder(
            animation: ctrl,
            builder: (context, child) => FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: ctrl.value.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TransitionDemo extends StatelessWidget {
  const _TransitionDemo(this.name);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Center(
        child: Text(
          '$name transition',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
