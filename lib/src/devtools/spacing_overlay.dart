import 'package:flutter/material.dart';

/// An overlay that visualizes spacing grid.
class SpacingOverlay extends StatelessWidget {
  const SpacingOverlay({
    super.key,
    required this.child,
    this.enabled = true,
    this.gridSize = 8,
    this.gridColor,
  });

  final Widget child;
  final bool enabled;
  final double gridSize;
  final Color? gridColor;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _GridPainter(
                gridSize: gridSize,
                color:
                    gridColor ??
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter({required this.gridSize, required this.color});
  final double gridSize;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) =>
      gridSize != old.gridSize || color != old.color;
}
