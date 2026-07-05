import 'package:flutter/material.dart';
import 'package:material_expressive/material_expressive.dart';

class ShapesPage extends StatefulWidget {
  const ShapesPage({super.key});

  @override
  State<ShapesPage> createState() => _ShapesPageState();
}

class _ShapesPageState extends State<ShapesPage> {
  int _morphIndex = 0;

  static const _allShapes = MaterialShapes.allNames;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Shapes & Morphing')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('All 35 Shapes', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 16,
            children: _allShapes.map((name) {
              return Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: ShapeDecoration(
                      color: scheme.primaryContainer,
                      shape: MorphableShapeBorder(
                        points: MaterialShapes.byName(name),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 64,
                    child: Text(
                      name,
                      style: const TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          Text('Live Morphing', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Tap to cycle through all shapes',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: () => setState(
                () => _morphIndex = (_morphIndex + 1) % _allShapes.length,
              ),
              child: Column(
                children: [
                  ShapeMorph(
                    shape: MaterialShapes.byName(_allShapes[_morphIndex]),
                    size: 140,
                    color: scheme.primary,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  ),
                  const SizedBox(height: 12),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      _allShapes[_morphIndex],
                      key: ValueKey(_morphIndex),
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_morphIndex + 1} / ${_allShapes.length}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          Text('RTL Shape Transforms', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: ShapeDecoration(
                      color: scheme.secondaryContainer,
                      shape: MorphableShapeBorder(points: MaterialShapes.arrow),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('LTR', style: TextStyle(fontSize: 11)),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: ShapeDecoration(
                      color: scheme.tertiaryContainer,
                      shape: MorphableShapeBorder(
                        points: RtlShapes.flipHorizontal(MaterialShapes.arrow),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('RTL', style: TextStyle(fontSize: 11)),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: ShapeDecoration(
                      color: scheme.primaryContainer,
                      shape: MorphableShapeBorder(
                        points: RtlShapes.rotate(MaterialShapes.arrow, 0.25),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('90°', style: TextStyle(fontSize: 11)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),

          Text('Shape on Widgets', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              Material(
                color: scheme.primary,
                shape: MorphableShapeBorder(points: MaterialShapes.clover4Leaf),
                clipBehavior: Clip.antiAlias,
                child: const SizedBox(
                  width: 72,
                  height: 72,
                  child: Center(
                    child: Icon(Icons.favorite, color: Colors.white),
                  ),
                ),
              ),
              Material(
                color: scheme.secondary,
                shape: MorphableShapeBorder(points: MaterialShapes.sunny),
                clipBehavior: Clip.antiAlias,
                child: const SizedBox(
                  width: 72,
                  height: 72,
                  child: Center(child: Icon(Icons.star, color: Colors.white)),
                ),
              ),
              Material(
                color: scheme.tertiary,
                shape: MorphableShapeBorder(points: MaterialShapes.heart),
                clipBehavior: Clip.antiAlias,
                child: const SizedBox(
                  width: 72,
                  height: 72,
                  child: Center(
                    child: Icon(Icons.music_note, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
