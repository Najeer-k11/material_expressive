import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A contained/partitioned loading indicator (M3 Expressive).
///
/// Shows segmented progress arcs instead of a single continuous indicator.
class ContainedLoadingIndicator extends StatefulWidget {
  const ContainedLoadingIndicator({
    super.key,
    this.size = 48,
    this.strokeWidth = 4,
    this.segments = 4,
    this.gapDegrees = 12,
    this.color,
    this.backgroundColor,
  });

  final double size;
  final double strokeWidth;
  final int segments;
  final double gapDegrees;
  final Color? color;
  final Color? backgroundColor;

  @override
  State<ContainedLoadingIndicator> createState() => _ContainedLoadingState();
}

class _ContainedLoadingState extends State<ContainedLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    final bg =
        widget.backgroundColor ??
        Theme.of(context).colorScheme.surfaceContainerHighest;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return CustomPaint(
            painter: _SegmentedArcPainter(
              progress: _ctrl.value,
              color: color,
              backgroundColor: bg,
              strokeWidth: widget.strokeWidth,
              segments: widget.segments,
              gapDegrees: widget.gapDegrees,
            ),
          );
        },
      ),
    );
  }
}

class _SegmentedArcPainter extends CustomPainter {
  _SegmentedArcPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
    required this.segments,
    required this.gapDegrees,
  });

  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;
  final int segments;
  final double gapDegrees;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final totalGap = gapDegrees * segments;
    final segmentSweep = (360 - totalGap) / segments;
    final rotation = progress * 360;

    // Background track
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < segments; i++) {
      final startAngle = (i * (segmentSweep + gapDegrees)) - 90 + rotation;
      canvas.drawArc(
        rect,
        startAngle * math.pi / 180,
        segmentSweep * math.pi / 180,
        false,
        bgPaint,
      );
    }

    // Foreground (animated fill per segment)
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < segments; i++) {
      final segStart = i / segments;
      final segEnd = (i + 1) / segments;
      final double cycleValue = math.sin(progress * math.pi);
      final localProgress = ((cycleValue - segStart) / (segEnd - segStart))
          .clamp(0.0, 1.0);

      if (localProgress > 0) {
        final startAngle = (i * (segmentSweep + gapDegrees)) - 90 + rotation;
        final sweep = segmentSweep * localProgress;
        canvas.drawArc(
          rect,
          startAngle * math.pi / 180,
          sweep * math.pi / 180,
          false,
          fgPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_SegmentedArcPainter old) => progress != old.progress;
}
