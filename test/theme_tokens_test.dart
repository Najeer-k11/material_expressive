import 'package:flutter_test/flutter_test.dart';
import 'package:material_expressive/material_expressive.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('ExpressiveTheme.of falls back to standard tokens', (
    tester,
  ) async {
    late ExpressiveThemeData data;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            data = ExpressiveTheme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(data.radius.xxl, ExpressiveRadiusTokens.standard.xxl);
    expect(data.colors.primary, ThemeData().colorScheme.primary);
  });

  testWidgets('components read radius from the provided theme', (tester) async {
    const custom = ExpressiveRadiusTokens(
      none: 0,
      xs: 1,
      sm: 2,
      md: 3,
      lg: 4,
      xl: 5,
      xxl: 42,
      full: 9999,
    );
    final data = ExpressiveThemeData.fromSeed(
      seedColor: Colors.indigo,
      radius: custom,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: ExpressiveTheme(
          data: data,
          child: const Scaffold(body: ExpressiveSearchBar()),
        ),
      ),
    );
    final box = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    final decoration = box.decoration! as BoxDecoration;
    expect(decoration.borderRadius, BorderRadius.circular(42));
    expect(data.shape.xxl, isA<ExpressiveOrganicBorder>());
  });

  test('ExpressiveDeviceType matches breakpoint tokens', () {
    expect(
      ExpressiveDeviceType.fromWindowSizeClass(
        ExpressiveWindowSizeClass.fromWidth(599),
      ),
      ExpressiveDeviceType.phone,
    );
    expect(
      ExpressiveDeviceType.fromWindowSizeClass(
        ExpressiveWindowSizeClass.fromWidth(600),
      ),
      ExpressiveDeviceType.tablet,
    );
    expect(
      ExpressiveDeviceType.fromWindowSizeClass(
        ExpressiveWindowSizeClass.fromWidth(1200),
      ),
      ExpressiveDeviceType.desktop,
    );
  });
}
