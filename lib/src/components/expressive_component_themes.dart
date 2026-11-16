import 'package:material_ui/material_ui.dart';

import '../tokens/elevation_tokens.dart';
import '../tokens/radius_tokens.dart';
import '../tokens/shape_tokens.dart';
import '../tokens/spacing_tokens.dart';

/// M3 Expressive styles for standard Material components, applied through
/// [ThemeData] rather than wrapper widgets.
///
/// Each method is named after the [ThemeData] field it fills, e.g.
/// [sliderTheme] → `ThemeData.sliderTheme`. Use [apply] to set them all.
class ExpressiveComponentThemes {
  ExpressiveComponentThemes._();

  static const _radius = ExpressiveRadiusTokens.standard;
  static const _spacing = ExpressiveSpacingTokens.standard;
  static const _elevation = ExpressiveElevationTokens.standard;

  /// Applies every expressive component theme to [base].
  static ThemeData apply(ThemeData base, {bool coloredAppBar = false}) {
    final scheme = base.colorScheme;
    return base.copyWith(
      floatingActionButtonTheme: floatingActionButtonTheme(scheme: scheme),
      navigationBarTheme: navigationBarTheme(scheme: scheme),
      appBarTheme: appBarTheme(scheme: scheme, colored: coloredAppBar),
      iconButtonTheme: iconButtonTheme(scheme: scheme),
      cardTheme: cardTheme(scheme: scheme),
      sliderTheme: sliderTheme(scheme: scheme),
      switchTheme: switchTheme(scheme: scheme),
      checkboxTheme: checkboxTheme(scheme: scheme),
      radioTheme: radioTheme(scheme: scheme),
      datePickerTheme: datePickerTheme(scheme: scheme),
      timePickerTheme: timePickerTheme(scheme: scheme),
      tooltipTheme: tooltipTheme(scheme: scheme),
      popupMenuTheme: popupMenuTheme(scheme: scheme),
      progressIndicatorTheme: progressIndicatorTheme(scheme: scheme),
    );
  }

  /// Expressive FAB — larger, bolder, with expressive shape.
  static FloatingActionButtonThemeData floatingActionButtonTheme({
    required ColorScheme scheme,
    ExpressiveShapeTokens? shape,
    double? radius,
  }) {
    final shapeTokens =
        shape ?? const ExpressiveShapeTokens(type: ExpressiveShapeType.organic);
    return FloatingActionButtonThemeData(
      shape: shapeTokens.shape(radius ?? _radius.xl),
      elevation: 4,
      highlightElevation: _elevation.level4,
      backgroundColor: scheme.primaryContainer,
      foregroundColor: scheme.onPrimaryContainer,
      extendedPadding: EdgeInsets.symmetric(
        horizontal: _spacing.xl,
        vertical: _spacing.lg,
      ),
      extendedTextStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    );
  }

  /// Expressive navigation bar — taller, pill indicators, bolder labels.
  static NavigationBarThemeData navigationBarTheme({
    required ColorScheme scheme,
    double height = 88,
    double? indicatorRadius,
  }) {
    return NavigationBarThemeData(
      height: height,
      elevation: 0,
      backgroundColor: scheme.surfaceContainer,
      indicatorColor: scheme.secondaryContainer,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(indicatorRadius ?? _radius.xxl),
      ),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: scheme.onSecondaryContainer, size: 24);
        }
        return IconThemeData(color: scheme.onSurfaceVariant, size: 24);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          );
        }
        return TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: scheme.onSurfaceVariant,
        );
      }),
    );
  }

  /// Expressive app bar — bolder title, optional colored background.
  static AppBarTheme appBarTheme({
    required ColorScheme scheme,
    bool colored = false,
  }) {
    return AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: _elevation.level2,
      backgroundColor: colored ? scheme.primaryContainer : scheme.surface,
      foregroundColor: colored ? scheme.onPrimaryContainer : scheme.onSurface,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: colored ? scheme.onPrimaryContainer : scheme.onSurface,
      ),
    );
  }

  /// Expressive icon button — larger touch target.
  static IconButtonThemeData iconButtonTheme({required ColorScheme scheme}) {
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        minimumSize: const Size(48, 48),
        padding: EdgeInsets.all(_spacing.md),
      ),
    );
  }

  /// Expressive card — flat, tonal, rounded.
  static CardThemeData cardTheme({
    required ColorScheme scheme,
    double radius = 20,
  }) {
    return CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      color: scheme.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
    );
  }

  /// Expressive icon theme. Set [filled] for the selected-state variant
  /// (bolder, filled, on-primary-container color).
  static IconThemeData iconTheme({
    required ColorScheme scheme,
    double size = 24,
    double? opticalSize,
    bool filled = false,
  }) {
    return IconThemeData(
      color: filled ? scheme.onPrimaryContainer : scheme.onSurface,
      size: size,
      opticalSize: opticalSize ?? size,
      grade: filled ? 200 : 0,
      weight: filled ? 700 : 400,
      fill: filled ? 1 : 0,
    );
  }

  /// Expressive slider — pill-shaped active track, capsule thumb.
  ///
  /// The active track is a thick stadium shape, inactive track is thinner.
  /// Thumb is a rounded rectangle (capsule), not a circle.
  static SliderThemeData sliderTheme({required ColorScheme scheme}) {
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
  static SwitchThemeData switchTheme({required ColorScheme scheme}) {
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
  static CheckboxThemeData checkboxTheme({required ColorScheme scheme}) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.primary;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(scheme.onPrimary),
      side: BorderSide(color: scheme.outline, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius.xs),
      ),
    );
  }

  /// Expressive radio — standard M3 but with vibrant colors.
  static RadioThemeData radioTheme({required ColorScheme scheme}) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.primary;
        return scheme.onSurfaceVariant;
      }),
    );
  }

  /// Expressive date picker — rounded containers, vibrant selection.
  static DatePickerThemeData datePickerTheme({
    required ColorScheme scheme,
    double? borderRadius,
  }) {
    return DatePickerThemeData(
      backgroundColor: scheme.surfaceContainerLow,
      headerBackgroundColor: scheme.primaryContainer,
      headerForegroundColor: scheme.onPrimaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? _radius.xxl),
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
  static TimePickerThemeData timePickerTheme({
    required ColorScheme scheme,
    double? borderRadius,
  }) {
    return TimePickerThemeData(
      backgroundColor: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? _radius.xxl),
      ),
      hourMinuteShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius.md),
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
  static TooltipThemeData tooltipTheme({required ColorScheme scheme}) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: scheme.inverseSurface,
        borderRadius: BorderRadius.circular(_radius.md),
      ),
      textStyle: TextStyle(
        color: scheme.onInverseSurface,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: _spacing.lg,
        vertical: _spacing.sm,
      ),
      waitDuration: const Duration(milliseconds: 500),
    );
  }

  /// Expressive popup menu — rounded, elevated.
  static PopupMenuThemeData popupMenuTheme({
    required ColorScheme scheme,
    double? borderRadius,
  }) {
    return PopupMenuThemeData(
      color: scheme.surfaceContainerLow,
      elevation: _elevation.level2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? _radius.lg),
      ),
      textStyle: TextStyle(color: scheme.onSurface),
    );
  }

  /// Expressive progress indicator — rounded ends, vibrant color.
  static ProgressIndicatorThemeData progressIndicatorTheme({
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

  // ---- Deprecated (removed in 1.0.0) ----

  @Deprecated('Use apply instead. Will be removed in 1.0.0.')
  static ThemeData applyExpressive(
    ThemeData base, {
    bool coloredAppBar = false,
  }) => apply(base, coloredAppBar: coloredAppBar);

  @Deprecated(
    'Use floatingActionButtonTheme instead. Will be removed in 1.0.0.',
  )
  static FloatingActionButtonThemeData expressiveFab({
    required ColorScheme scheme,
    ExpressiveShapeTokens? shape,
    double radius = 24,
  }) => floatingActionButtonTheme(scheme: scheme, shape: shape, radius: radius);

  @Deprecated('Use navigationBarTheme instead. Will be removed in 1.0.0.')
  static NavigationBarThemeData expressiveNavBar({
    required ColorScheme scheme,
    double indicatorRadius = 28,
  }) => navigationBarTheme(scheme: scheme, indicatorRadius: indicatorRadius);

  @Deprecated('Use appBarTheme instead. Will be removed in 1.0.0.')
  static AppBarTheme expressiveAppBar({
    required ColorScheme scheme,
    bool colored = false,
  }) => appBarTheme(scheme: scheme, colored: colored);

  @Deprecated('Use iconButtonTheme instead. Will be removed in 1.0.0.')
  static IconButtonThemeData expressiveIconButton({
    required ColorScheme scheme,
  }) => iconButtonTheme(scheme: scheme);

  @Deprecated('Use cardTheme instead. Will be removed in 1.0.0.')
  static CardThemeData expressiveCarouselCard({
    required ColorScheme scheme,
    double radius = 20,
  }) => cardTheme(scheme: scheme, radius: radius);
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
