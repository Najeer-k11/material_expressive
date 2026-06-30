import 'dart:math' as math;
import 'package:flutter/material.dart';

/// An icon that animates between two states using AnimatedIconData.
class ExpressiveAnimatedIcon extends StatefulWidget {
  const ExpressiveAnimatedIcon({
    super.key,
    required this.icon,
    this.isActive = false,
    this.size = 24,
    this.color,
    this.activeColor,
    this.duration = const Duration(milliseconds: 350),
    this.curve = Curves.easeInOut,
    this.onPressed,
    this.semanticLabel,
  });

  final AnimatedIconData icon;
  final bool isActive;
  final double size;
  final Color? color;
  final Color? activeColor;
  final Duration duration;
  final Curve curve;
  final VoidCallback? onPressed;
  final String? semanticLabel;

  @override
  State<ExpressiveAnimatedIcon> createState() => _ExpressiveAnimatedIconState();
}

class _ExpressiveAnimatedIconState extends State<ExpressiveAnimatedIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: widget.isActive ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(ExpressiveAnimatedIcon old) {
    super.didUpdateWidget(old);
    if (widget.isActive != old.isActive) {
      widget.isActive ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.onSurface;
    return IconButton(
      onPressed: widget.onPressed,
      icon: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) => AnimatedIcon(
          icon: widget.icon,
          progress: CurvedAnimation(parent: _ctrl, curve: widget.curve),
          size: widget.size,
          color: Color.lerp(color, widget.activeColor ?? color, _ctrl.value),
          semanticLabel: widget.semanticLabel,
        ),
      ),
    );
  }
}

/// An icon that rotates when toggled.
class RotatingIcon extends StatefulWidget {
  const RotatingIcon({
    super.key,
    required this.icon,
    this.isRotated = false,
    this.turns = 0.5,
    this.size = 24,
    this.color,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.onPressed,
  });

  final IconData icon;
  final bool isRotated;
  final double turns;
  final double size;
  final Color? color;
  final Duration duration;
  final Curve curve;
  final VoidCallback? onPressed;

  @override
  State<RotatingIcon> createState() => _RotatingIconState();
}

class _RotatingIconState extends State<RotatingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: widget.isRotated ? 1.0 : 0.0,
    );
    _rotation = Tween(
      begin: 0.0,
      end: widget.turns,
    ).animate(CurvedAnimation(parent: _ctrl, curve: widget.curve));
  }

  @override
  void didUpdateWidget(RotatingIcon old) {
    super.didUpdateWidget(old);
    if (widget.isRotated != old.isRotated) {
      widget.isRotated ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.onSurface;
    return IconButton(
      onPressed: widget.onPressed,
      icon: AnimatedBuilder(
        animation: _rotation,
        builder: (context, child) => Transform.rotate(
          angle: _rotation.value * 2 * math.pi,
          child: child,
        ),
        child: Icon(widget.icon, size: widget.size, color: color),
      ),
    );
  }
}

/// An icon that bounces when toggled.
class BouncingIcon extends StatefulWidget {
  const BouncingIcon({
    super.key,
    required this.icon,
    this.activeIcon,
    this.isActive = false,
    this.size = 24,
    this.color,
    this.activeColor,
    this.duration = const Duration(milliseconds: 400),
    this.onPressed,
  });

  final IconData icon;
  final IconData? activeIcon;
  final bool isActive;
  final double size;
  final Color? color;
  final Color? activeColor;
  final Duration duration;
  final VoidCallback? onPressed;

  @override
  State<BouncingIcon> createState() => _BouncingIconState();
}

class _BouncingIconState extends State<BouncingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.7), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.7, end: 1.2), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(BouncingIcon old) {
    super.didUpdateWidget(old);
    if (widget.isActive != old.isActive) _ctrl.forward(from: 0);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = widget.isActive
        ? (widget.activeColor ?? scheme.primary)
        : (widget.color ?? scheme.onSurface);
    final iconData = widget.isActive
        ? (widget.activeIcon ?? widget.icon)
        : widget.icon;
    return IconButton(
      onPressed: widget.onPressed,
      icon: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Icon(iconData, size: widget.size, color: color),
      ),
    );
  }
}

/// Cross-fade morph between two icons.
class MorphingIcon extends StatelessWidget {
  const MorphingIcon({
    super.key,
    required this.icon,
    required this.activeIcon,
    this.isActive = false,
    this.size = 24,
    this.color,
    this.activeColor,
    this.duration = const Duration(milliseconds: 300),
    this.onPressed,
  });

  final IconData icon;
  final IconData activeIcon;
  final bool isActive;
  final double size;
  final Color? color;
  final Color? activeColor;
  final Duration duration;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final c = isActive
        ? (activeColor ?? scheme.primary)
        : (color ?? scheme.onSurface);
    return IconButton(
      onPressed: onPressed,
      icon: AnimatedSwitcher(
        duration: duration,
        transitionBuilder: (child, anim) => ScaleTransition(
          scale: anim,
          child: FadeTransition(opacity: anim, child: child),
        ),
        child: Icon(
          isActive ? activeIcon : icon,
          key: ValueKey(isActive),
          size: size,
          color: c,
        ),
      ),
    );
  }
}

/// Hover scale icon (desktop).
class HoverIcon extends StatefulWidget {
  const HoverIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.color,
    this.hoverColor,
    this.hoverScale = 1.15,
    this.duration = const Duration(milliseconds: 150),
    this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final double size;
  final Color? color;
  final Color? hoverColor;
  final double hoverScale;
  final Duration duration;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  State<HoverIcon> createState() => _HoverIconState();
}

class _HoverIconState extends State<HoverIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = _hovered
        ? (widget.hoverColor ?? scheme.primary)
        : (widget.color ?? scheme.onSurface);
    Widget icon = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? widget.hoverScale : 1.0,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: IconButton(
          onPressed: widget.onPressed,
          icon: Icon(widget.icon, size: widget.size, color: color),
        ),
      ),
    );
    if (widget.tooltip != null) {
      icon = Tooltip(message: widget.tooltip!, child: icon);
    }
    return icon;
  }
}

/// Selection icon with elastic animation.
class SelectionIcon extends StatefulWidget {
  const SelectionIcon({
    super.key,
    this.isSelected = false,
    this.icon = Icons.check_circle,
    this.unselectedIcon = Icons.circle_outlined,
    this.size = 24,
    this.color,
    this.unselectedColor,
    this.duration = const Duration(milliseconds: 300),
    this.onChanged,
  });

  final bool isSelected;
  final IconData icon;
  final IconData unselectedIcon;
  final double size;
  final Color? color;
  final Color? unselectedColor;
  final Duration duration;
  final ValueChanged<bool>? onChanged;

  @override
  State<SelectionIcon> createState() => _SelectionIconState();
}

class _SelectionIconState extends State<SelectionIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: widget.isSelected ? 1.0 : 0.0,
    );
    _scale = Tween(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
  }

  @override
  void didUpdateWidget(SelectionIcon old) {
    super.didUpdateWidget(old);
    if (widget.isSelected != old.isSelected) {
      widget.isSelected ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selColor = widget.color ?? scheme.primary;
    final unselColor = widget.unselectedColor ?? scheme.onSurfaceVariant;
    return GestureDetector(
      onTap: () => widget.onChanged?.call(!widget.isSelected),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) => Transform.scale(
          scale: _scale.value,
          child: Icon(
            widget.isSelected ? widget.icon : widget.unselectedIcon,
            size: widget.size,
            color: Color.lerp(unselColor, selColor, _ctrl.value),
          ),
        ),
      ),
    );
  }
}
