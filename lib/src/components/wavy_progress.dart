import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A wavy/sinusoidal linear progress indicator (M3 Expressive style).
///
/// The track has a sine wave shape instead of a straight line.
class WavyLinearProgressIndicator extends StatefulWidget {
  const WavyLinearProgressIndicator({
    super.key,
    this.value,
    this.height = 6,
    this.waveAmplitude = 3,
    this.waveLength = 24,
    this.color,
    this.backgroundColor,
    this.borderRadius = 3,
    this.animationDuration = const Duration(milliseconds: 1800),
  });

  /// Progress value (0.0 to 1.0). Null for indeterminate.
  final double? value;
  final double height;
  final double waveAmplitude;
  final double waveLength;
  final Color? color;
  final Color? backgroundColor;
  final double borderRadius;
  final Duration animationDuration;

  @override
  State<WavyLinearProgressIndicator> createState() =>
      _WavyLinearProgressState();
}

class _WavyLinearProgressState extends State<WavyLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.animationDuration)
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fgColor = widget.color ?? scheme.primary;
    final bgColor = widget.backgroundColor ?? scheme.surfaceContainerHighest;

    return RepaintBoundary(
      child: SizedBox(
        height: widget.height + widget.waveAmplitude * 2,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            return CustomPaint(
              painter: _WavyLinearPainter(
                progress: widget.value,
                phase: _ctrl.value * 2 * math.pi,
                amplitude: widget.waveAmplitude,
                waveLength: widget.waveLength,
                foregroundColor: fgColor,
                backgroundColor: bgColor,
                strokeWidth: widget.height,
                borderRadius: widget.borderRadius,
              ),
              size: Size.infinite,
            );
          },
        ),
      ),
    );
  }
}

class _WavyLinearPainter extends CustomPainter {
  _WavyLinearPainter({
    required this.progress,
    required this.phase,
    required this.amplitude,
    required this.waveLength,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.strokeWidth,
    required this.borderRadius,
  });

  final double? progress;
  final double phase;
  final double amplitude;
  final double waveLength;
  final Color foregroundColor;
  final Color backgroundColor;
  final double strokeWidth;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final cy = size.height / 2;
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final fgPaint = Paint()
      ..color = foregroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw background wave
    final bgPath = _wavePath(size, cy, 0, size.width, phase);
    canvas.drawPath(bgPath, bgPaint);

    // Draw foreground
    if (progress != null) {
      // Determinate
      final endX = size.width * progress!.clamp(0.0, 1.0);
      if (endX > 0) {
        final fgPath = _wavePath(size, cy, 0, endX, phase);
        canvas.drawPath(fgPath, fgPaint);
      }
    } else {
      // Indeterminate: sliding segment
      final segWidth = size.width * 0.4;
      final startX =
          (phase / (2 * math.pi) * (size.width + segWidth)) - segWidth;
      final endX = startX + segWidth;
      final clampedStart = startX.clamp(0.0, size.width);
      final clampedEnd = endX.clamp(0.0, size.width);
      if (clampedEnd > clampedStart) {
        final fgPath = _wavePath(size, cy, clampedStart, clampedEnd, phase);
        canvas.drawPath(fgPath, fgPaint);
      }
    }
  }

  Path _wavePath(
    Size size,
    double cy,
    double startX,
    double endX,
    double phase,
  ) {
    final path = Path();
    var first = true;
    for (double x = startX; x <= endX; x += 1.5) {
      final y =
          cy + amplitude * math.sin((x / waveLength) * 2 * math.pi + phase);
      if (first) {
        path.moveTo(x, y);
        first = false;
      } else {
        path.lineTo(x, y);
      }
    }
    return path;
  }

  @override
  bool shouldRepaint(_WavyLinearPainter old) =>
      progress != old.progress || phase != old.phase;
}

/// A wavy circular progress indicator (M3 Expressive style).
///
/// The circular track undulates with a sine wave along its circumference.
class WavyCircularProgressIndicator extends StatefulWidget {
  const WavyCircularProgressIndicator({
    super.key,
    this.value,
    this.size = 48,
    this.strokeWidth = 4,
    this.waveAmplitude = 2,
    this.waveCycles = 6,
    this.color,
    this.backgroundColor,
    this.animationDuration = const Duration(milliseconds: 2000),
  });

  /// Progress value (0.0 to 1.0). Null for indeterminate.
  final double? value;
  final double size;
  final double strokeWidth;
  final double waveAmplitude;
  final int waveCycles;
  final Color? color;
  final Color? backgroundColor;
  final Duration animationDuration;

  @override
  State<WavyCircularProgressIndicator> createState() =>
      _WavyCircularProgressState();
}

class _WavyCircularProgressState extends State<WavyCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.animationDuration)
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fgColor = widget.color ?? scheme.primary;
    final bgColor = widget.backgroundColor ?? scheme.surfaceContainerHighest;

    return RepaintBoundary(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) => CustomPaint(
            painter: _WavyCircularPainter(
              progress: widget.value,
              phase: _ctrl.value * 2 * math.pi,
              amplitude: widget.waveAmplitude,
              waveCycles: widget.waveCycles,
              foregroundColor: fgColor,
              backgroundColor: bgColor,
              strokeWidth: widget.strokeWidth,
            ),
          ),
        ),
      ),
    );
  }
}

class _WavyCircularPainter extends CustomPainter {
  _WavyCircularPainter({
    required this.progress,
    required this.phase,
    required this.amplitude,
    required this.waveCycles,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  final double? progress;
  final double phase;
  final double amplitude;
  final int waveCycles;
  final Color foregroundColor;
  final Color backgroundColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = (size.width - strokeWidth - amplitude * 2) / 2;
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final fgPaint = Paint()
      ..color = foregroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Background: full wavy circle
    final bgPath = _wavyCirclePath(center, baseRadius, 0, 2 * math.pi, phase);
    canvas.drawPath(bgPath, bgPaint);

    // Foreground
    if (progress != null) {
      final sweep = 2 * math.pi * progress!.clamp(0.0, 1.0);
      if (sweep > 0) {
        final fgPath = _wavyCirclePath(
          center,
          baseRadius,
          -math.pi / 2,
          -math.pi / 2 + sweep,
          phase,
        );
        canvas.drawPath(fgPath, fgPaint);
      }
    } else {
      // Indeterminate: rotating segment
      final start = phase * 2;
      const sweep = math.pi * 0.8;
      final fgPath = _wavyCirclePath(
        center,
        baseRadius,
        start,
        start + sweep,
        phase,
      );
      canvas.drawPath(fgPath, fgPaint);
    }
  }

  Path _wavyCirclePath(
    Offset center,
    double radius,
    double startAngle,
    double endAngle,
    double phase,
  ) {
    final path = Path();
    const steps = 80;
    final totalAngle = endAngle - startAngle;
    var first = true;
    for (int i = 0; i <= steps; i++) {
      final t = i / steps;
      final angle = startAngle + totalAngle * t;
      final wave = amplitude * math.sin(angle * waveCycles + phase);
      final r = radius + wave;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (first) {
        path.moveTo(x, y);
        first = false;
      } else {
        path.lineTo(x, y);
      }
    }
    return path;
  }

  @override
  bool shouldRepaint(_WavyCircularPainter old) =>
      progress != old.progress || phase != old.phase;
}
