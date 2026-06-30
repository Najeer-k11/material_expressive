import 'package:flutter/material.dart';

/// Expressive theme extensions for input components.
///
/// Styles Slider, Switch, Checkbox, Radio, DatePicker, TimePicker,
/// Tooltip, PopupMenu via ThemeData — not widget wrappers.
class ExpressiveInputThemes {
  ExpressiveInputThemes._();

  /// Expressive slider — pill-shaped active track, capsule thumb.
  ///
  /// The active track is a thick stadium shape, inactive track is thinner.
  /// Thumb is a rounded rectangle (capsule), not a circle.
  static SliderThemeData expressiveSlider({required ColorScheme scheme}) {
    return SliderThemeData(
      activeTrackColor: scheme.primary,
      inactiveTrackColor: scheme.surfaceContainerHighest,
      thumbColor: scheme.primary,
      overlayColor: scheme.primary.withValues(alpha: 0.12),
      thumbShape: const _ExpressiveSliderThumbShape(),
      trackShape: const _ExpressiveSliderTrackShape(),
      trackHeight: 12,
      valueIndicatorColor: scheme.inverseSurface,
      valueIndicatorTextStyle: TextStyle(
        color: scheme.onInverseSurface,
        fontWeight: FontWeight.w600,
      ),
      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
      showValueIndicator: ShowValueIndicator.onDrag,
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
    );
  }

  /// Expressive switch — larger, with colored track.
  static SwitchThemeData expressiveSwitch({required ColorScheme scheme}) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.onPrimary;
        return scheme.outline;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.primary;
        return scheme.surfaceContainerHighest;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.transparent;
        return scheme.outline;
      }),
    );
  }

  /// Expressive checkbox — rounded, with animated fill.
  static CheckboxThemeData expressiveCheckbox({required ColorScheme scheme}) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.primary;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(scheme.onPrimary),
      side: BorderSide(color: scheme.outline, width: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }

  /// Expressive radio — standard M3 but with vibrant colors.
  static RadioThemeData expressiveRadio({required ColorScheme scheme}) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.primary;
        return scheme.onSurfaceVariant;
      }),
    );
  }

  /// Expressive date picker — rounded containers, vibrant selection.
  static DatePickerThemeData expressiveDatePicker({
    required ColorScheme scheme,
    double borderRadius = 28,
  }) {
    return DatePickerThemeData(
      backgroundColor: scheme.surfaceContainerLow,
      headerBackgroundColor: scheme.primaryContainer,
      headerForegroundColor: scheme.onPrimaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      dayStyle: TextStyle(color: scheme.onSurface),
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.onPrimary;
        return scheme.onSurface;
      }),
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.primary;
        return Colors.transparent;
      }),
      todayForegroundColor: WidgetStateProperty.all(scheme.primary),
      todayBorder: BorderSide(color: scheme.primary),
      yearForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.onPrimary;
        return scheme.onSurface;
      }),
      yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.primary;
        return Colors.transparent;
      }),
      rangePickerBackgroundColor: scheme.surfaceContainerLow,
      rangeSelectionBackgroundColor: scheme.primaryContainer.withValues(
        alpha: 0.3,
      ),
    );
  }

  /// Expressive time picker — rounded, vibrant.
  static TimePickerThemeData expressiveTimePicker({
    required ColorScheme scheme,
    double borderRadius = 28,
  }) {
    return TimePickerThemeData(
      backgroundColor: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      hourMinuteShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      hourMinuteColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return scheme.primaryContainer;
        }
        return scheme.surfaceContainerHigh;
      }),
      hourMinuteTextColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return scheme.onPrimaryContainer;
        }
        return scheme.onSurface;
      }),
      dialHandColor: scheme.primary,
      dialBackgroundColor: scheme.surfaceContainerHighest,
      dialTextColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.onPrimary;
        return scheme.onSurface;
      }),
      dayPeriodColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return scheme.primaryContainer;
        }
        return Colors.transparent;
      }),
      entryModeIconColor: scheme.onSurfaceVariant,
    );
  }

  /// Expressive tooltip — rounded, larger padding.
  static TooltipThemeData expressiveTooltip({required ColorScheme scheme}) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: scheme.inverseSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: TextStyle(
        color: scheme.onInverseSurface,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      waitDuration: const Duration(milliseconds: 500),
    );
  }

  /// Expressive popup menu — rounded, elevated.
  static PopupMenuThemeData expressivePopupMenu({
    required ColorScheme scheme,
    double borderRadius = 16,
  }) {
    return PopupMenuThemeData(
      color: scheme.surfaceContainerLow,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      textStyle: TextStyle(color: scheme.onSurface),
    );
  }

  /// Expressive progress indicator — rounded ends, vibrant color.
  static ProgressIndicatorThemeData expressiveProgressIndicator({
    required ColorScheme scheme,
  }) {
    return ProgressIndicatorThemeData(
      color: scheme.primary,
      linearTrackColor: scheme.surfaceContainerHighest,
      circularTrackColor: scheme.surfaceContainerHighest,
      linearMinHeight: 6,
      borderRadius: BorderRadius.circular(3),
    );
  }

  /// Apply all input themes to a ThemeData.
  static ThemeData applyAll(ThemeData base) {
    final scheme = base.colorScheme;
    return base.copyWith(
      sliderTheme: expressiveSlider(scheme: scheme),
      switchTheme: expressiveSwitch(scheme: scheme),
      checkboxTheme: expressiveCheckbox(scheme: scheme),
      radioTheme: expressiveRadio(scheme: scheme),
      datePickerTheme: expressiveDatePicker(scheme: scheme),
      timePickerTheme: expressiveTimePicker(scheme: scheme),
      tooltipTheme: expressiveTooltip(scheme: scheme),
      popupMenuTheme: expressivePopupMenu(scheme: scheme),
      progressIndicatorTheme: expressiveProgressIndicator(scheme: scheme),
    );
  }
}

/// Capsule/stadium-shaped thumb for the expressive slider.
class _ExpressiveSliderThumbShape extends SliderComponentShape {
  const _ExpressiveSliderThumbShape();

  static const double _thumbWidth = 8;
  static const double _thumbHeight = 28;
  static const double _thumbRadius = 4;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(_thumbWidth, _thumbHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: _thumbWidth, height: _thumbHeight),
      const Radius.circular(_thumbRadius),
    );

    // Shadow
    canvas.drawRRect(
      rect.shift(const Offset(0, 1)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    // Thumb
    canvas.drawRRect(
      rect,
      Paint()..color = sliderTheme.thumbColor ?? Colors.white,
    );
  }
}

/// Expressive track shape: active portion is thick/pill, inactive is thinner.
class _ExpressiveSliderTrackShape extends SliderTrackShape {
  const _ExpressiveSliderTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight ?? 12;
    final trackLeft = offset.dx + 14;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final trackWidth = parentBox.size.width - 28;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final canvas = context.canvas;
    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
    );

    final activeTrackHeight = sliderTheme.trackHeight ?? 12;
    final inactiveTrackHeight = activeTrackHeight * 0.5;
    final radius = activeTrackHeight / 2;
    final inactiveRadius = inactiveTrackHeight / 2;

    // Inactive track (thinner, right side)
    final inactiveRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        thumbCenter.dx,
        trackRect.center.dy - inactiveRadius,
        trackRect.right,
        trackRect.center.dy + inactiveRadius,
      ),
      Radius.circular(inactiveRadius),
    );
    canvas.drawRRect(
      inactiveRect,
      Paint()..color = sliderTheme.inactiveTrackColor ?? Colors.grey,
    );

    // Active track (full height, pill shaped, left side)
    final activeRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        trackRect.left,
        trackRect.center.dy - radius,
        thumbCenter.dx,
        trackRect.center.dy + radius,
      ),
      Radius.circular(radius),
    );
    canvas.drawRRect(
      activeRect,
      Paint()..color = sliderTheme.activeTrackColor ?? Colors.blue,
    );
  }
}
