import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/design_system/design_system.dart';
import 'package:spotter/helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Helper.buildTheme outputs canonical light Material 3 tokens', () {
    final theme = Helper.buildTheme(isDarkMode: false);

    expect(theme.brightness, Brightness.light);
    expect(theme.useMaterial3, isTrue);

    expect(theme.colorScheme.primary, DSColors.primary);
    expect(theme.colorScheme.secondary, DSColors.accent);
    expect(theme.colorScheme.surface, DSColors.surface);
    expect(theme.colorScheme.error, DSColors.danger);
    expect(theme.scaffoldBackgroundColor, DSColors.background);

    expect(theme.cardTheme.color, DSColors.card);
    expect(theme.cardTheme.elevation, 0.0);

    final buttonStyle = theme.filledButtonTheme.style;
    expect(buttonStyle, isNotNull);

    final inputDecorationTheme = theme.inputDecorationTheme;
    expect(inputDecorationTheme.filled, isTrue);
    expect(inputDecorationTheme.fillColor, DSColors.surfaceVariant);
  });

  test('Helper.buildTheme supports dark-ready semantic tokens', () {
    final theme = Helper.buildTheme(isDarkMode: true);

    expect(theme.brightness, Brightness.dark);
    expect(theme.colorScheme.primary, DSPalettes.dark.primary);
    expect(theme.colorScheme.surface, DSPalettes.dark.surface);
    expect(theme.scaffoldBackgroundColor, DSPalettes.dark.background);
    expect(theme.cardTheme.color, DSPalettes.dark.card);
  });

  test('DSTokenJson exports light and dark semantic tokens', () {
    final tokens = DSTokenJson.asMap();
    final color = tokens['color']! as Map;

    expect(color.keys, containsAll(['light', 'dark']));
    expect(DSTokenJson.encode(), contains('"primary"'));
    expect(DSTokenJson.encode(), contains('"motion"'));
  });
}
