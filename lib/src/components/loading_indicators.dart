import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

/// Organic blob loading indicator.
class ExpressiveOrganicLoadingIndicator extends StatefulWidget {
  const ExpressiveOrganicLoadingIndicator({
    super.key,
    this.size = 48,
    this.color,
    this.blobCount = 3,
  });
  final double size;
  final Color? color;
  final int blobCount;

  @override
  State<ExpressiveOrganicLoadingIndicator> createState() =>
      _OrganicLoadingState();
}

class _OrganicLoadingState extends State<ExpressiveOrganicLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
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
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) => CustomPaint(
          painter: _BlobPainter(
            progress: _ctrl.value,
            color: color,
            count: widget.blobCount,
          ),
        ),
      ),
    );
  }
}

class _BlobPainter extends CustomPainter {
  _BlobPainter({
    required this.progress,
    required this.color,
    required this.count,
  });
  final double progress;
  final Color color;
  final int count;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxR = size.width / 4;
    for (int i = 0; i < count; i++) {
      final phase = (progress + i / count) % 1.0;
      final angle = phase * 2 * math.pi;
      final offset = Offset(
        center.dx + math.cos(angle) * maxR * 0.6,
        center.dy + math.sin(angle) * maxR * 0.6,
      );
      final r = maxR * (0.5 + 0.3 * math.sin(phase * math.pi));
      canvas.drawCircle(
        offset,
        r,
        Paint()..color = color.withValues(alpha: 0.6 - i * 0.15),
      );
    }
  }

  @override
  bool shouldRepaint(_BlobPainter old) => progress != old.progress;
}

/// Pulsing dots loading indicator.
class ExpressivePulsingDotsIndicator extends StatefulWidget {
  const ExpressivePulsingDotsIndicator({
    super.key,
    this.size = 48,
    this.color,
    this.dotCount = 3,
  });
  final double size;
  final Color? color;
  final int dotCount;

  @override
  State<ExpressivePulsingDotsIndicator> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<ExpressivePulsingDotsIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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
    final dotSize = widget.size / (widget.dotCount * 2 + 1);
    return SizedBox(
      width: widget.size,
      height: dotSize * 2,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.dotCount, (i) {
            final phase = (_ctrl.value + i / widget.dotCount) % 1.0;
            final scale = 0.5 + 0.5 * math.sin(phase * math.pi);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: dotSize * 0.3),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.5 + 0.5 * scale),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

/// Morphing shape loading indicator.
class ExpressiveMorphingShapeIndicator extends StatefulWidget {
  const ExpressiveMorphingShapeIndicator({
    super.key,
    this.size = 48,
    this.color,
  });
  final double size;
  final Color? color;

  @override
  State<ExpressiveMorphingShapeIndicator> createState() =>
      _MorphingShapeState();
}

class _MorphingShapeState extends State<ExpressiveMorphingShapeIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
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
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          final p = _ctrl.value;
          final half = widget.size / 2;
          final r = p < 0.33
              ? half - (half - 8) * (p / 0.33)
              : p < 0.66
              ? 8 + (half * 0.3) * ((p - 0.33) / 0.33)
              : 8 + half * 0.3 + (half - 8 - half * 0.3) * ((p - 0.66) / 0.34);
          return Transform.rotate(
            angle: p * math.pi,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(r),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---- Deprecated aliases (removed in 1.0.0) ----

@Deprecated(
  'Use ExpressiveOrganicLoadingIndicator instead. Will be removed in 1.0.0.',
)
typedef OrganicLoadingIndicator = ExpressiveOrganicLoadingIndicator;

@Deprecated(
  'Use ExpressivePulsingDotsIndicator instead. Will be removed in 1.0.0.',
)
typedef PulsingDotsIndicator = ExpressivePulsingDotsIndicator;

@Deprecated(
  'Use ExpressiveMorphingShapeIndicator instead. Will be removed in 1.0.0.',
)
typedef MorphingShapeIndicator = ExpressiveMorphingShapeIndicator;
