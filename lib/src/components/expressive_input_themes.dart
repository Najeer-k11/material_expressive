import 'package:material_ui/material_ui.dart';

import 'expressive_component_themes.dart';

/// Deprecated: merged into [ExpressiveComponentThemes].
@Deprecated('Use ExpressiveComponentThemes instead. Will be removed in 1.0.0.')
class ExpressiveInputThemes {
  ExpressiveInputThemes._();

  static SliderThemeData expressiveSlider({required ColorScheme scheme}) =>
      ExpressiveComponentThemes.sliderTheme(scheme: scheme);

  static SwitchThemeData expressiveSwitch({required ColorScheme scheme}) =>
      ExpressiveComponentThemes.switchTheme(scheme: scheme);

  static CheckboxThemeData expressiveCheckbox({required ColorScheme scheme}) =>
      ExpressiveComponentThemes.checkboxTheme(scheme: scheme);

  static RadioThemeData expressiveRadio({required ColorScheme scheme}) =>
      ExpressiveComponentThemes.radioTheme(scheme: scheme);

  static DatePickerThemeData expressiveDatePicker({
    required ColorScheme scheme,
    double borderRadius = 28,
  }) => ExpressiveComponentThemes.datePickerTheme(
    scheme: scheme,
    borderRadius: borderRadius,
  );

  static TimePickerThemeData expressiveTimePicker({
    required ColorScheme scheme,
    double borderRadius = 28,
  }) => ExpressiveComponentThemes.timePickerTheme(
    scheme: scheme,
    borderRadius: borderRadius,
  );

  static TooltipThemeData expressiveTooltip({required ColorScheme scheme}) =>
      ExpressiveComponentThemes.tooltipTheme(scheme: scheme);

  static PopupMenuThemeData expressivePopupMenu({
    required ColorScheme scheme,
    double borderRadius = 16,
  }) => ExpressiveComponentThemes.popupMenuTheme(
    scheme: scheme,
    borderRadius: borderRadius,
  );

  static ProgressIndicatorThemeData expressiveProgressIndicator({
    required ColorScheme scheme,
  }) => ExpressiveComponentThemes.progressIndicatorTheme(scheme: scheme);

  /// Applies only the input-component themes (slider, switch, checkbox,
  /// radio, pickers, tooltip, popup menu, progress indicator).
  static ThemeData applyAll(ThemeData base) {
    final scheme = base.colorScheme;
    return base.copyWith(
      sliderTheme: ExpressiveComponentThemes.sliderTheme(scheme: scheme),
      switchTheme: ExpressiveComponentThemes.switchTheme(scheme: scheme),
      checkboxTheme: ExpressiveComponentThemes.checkboxTheme(scheme: scheme),
      radioTheme: ExpressiveComponentThemes.radioTheme(scheme: scheme),
      datePickerTheme: ExpressiveComponentThemes.datePickerTheme(
        scheme: scheme,
      ),
      timePickerTheme: ExpressiveComponentThemes.timePickerTheme(
        scheme: scheme,
      ),
      tooltipTheme: ExpressiveComponentThemes.tooltipTheme(scheme: scheme),
      popupMenuTheme: ExpressiveComponentThemes.popupMenuTheme(scheme: scheme),
      progressIndicatorTheme: ExpressiveComponentThemes.progressIndicatorTheme(
        scheme: scheme,
      ),
    );
  }
}
