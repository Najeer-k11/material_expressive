// Verifies the pre-0.10 public API still compiles and behaves through the
// deprecated aliases.
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package

import 'package:flutter_test/flutter_test.dart';
import 'package:material_expressive/material_expressive.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  test('renamed types are aliases of the new types', () {
    expect(RotatingIcon, ExpressiveRotatingIcon);
    expect(MotionScheme.expressive, ExpressiveMotionScheme.expressive);
    expect(WindowSizeClass.fromWidth(700), ExpressiveWindowSizeClass.medium);
    expect(ExpressiveMotion.standard, same(ExpressiveMotionSpec.standard));
  });

  test('deprecated named parameters still map to the new fields', () {
    final split = ExpressiveSplitButton(
      label: 'x',
      onPressed: () {},
      onDropdown: () {},
      cornerRadius: 10,
    );
    expect(split.cornerRadius, 10);
    expect(split.borderRadius, isNull);

    const group = ExpressiveButtonGroup(
      buttons: [],
      cornerRadius: 12,
      animationDuration: Duration(milliseconds: 50),
    );
    expect(group.cornerRadius, 12);
    expect(group.animationDuration, const Duration(milliseconds: 50));

    const icon = ExpressiveIcon(Icons.add, containerColor: Color(0xFF00FF00));
    expect(icon.containerColor, const Color(0xFF00FF00));

    const wavy = ExpressiveWavyLinearProgressIndicator(
      animationDuration: Duration(seconds: 1),
    );
    expect(wavy.animationDuration, const Duration(seconds: 1));
  });

  test('old theme entry points forward to the new ones', () {
    final data = ExpressiveTheme.fromSeed(seedColor: Colors.indigo);
    final base = data.materialTheme;
    final viaOld = ExpressiveComponentThemes.applyExpressive(base);
    final viaNew = ExpressiveComponentThemes.apply(base);
    expect(viaOld.sliderTheme, viaNew.sliderTheme);
    expect(viaOld.navigationBarTheme.height, viaNew.navigationBarTheme.height);
    expect(
      ExpressiveVibrantColorScheme.harmonize(Colors.red, Colors.blue),
      ExpressiveColorHarmonization.harmonize(Colors.red, Colors.blue),
    );
  });

  testWidgets('ExpressiveThemeProvider is still found by ExpressiveTheme.of', (
    tester,
  ) async {
    final data = ExpressiveThemeData.fromSeed(seedColor: Colors.teal);
    late ExpressiveThemeData found;
    await tester.pumpWidget(
      ExpressiveThemeProvider(
        themeData: data,
        child: Builder(
          builder: (context) {
            found = ExpressiveThemeProvider.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(found, same(data));
  });
}
