import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/core/theme/colors.dart';
import 'package:spotter/helper.dart';

void main() {
  test('Helper.buildTheme outputs premium light Material 3 design tokens', () {
    final theme = Helper.buildTheme(isDarkMode: false);

    // Assert Brightness and M3 usage
    expect(theme.brightness, Brightness.light);
    expect(theme.useMaterial3, isTrue);

    // Assert Colors from SpottColors
    expect(theme.colorScheme.primary, SpottColors.primary);
    expect(theme.colorScheme.secondary, SpottColors.primaryDark);
    expect(theme.colorScheme.surface, SpottColors.surface1);
    expect(theme.colorScheme.error, SpottColors.danger);
    expect(theme.scaffoldBackgroundColor, SpottColors.background);

    // Assert Card theme properties
    expect(theme.cardTheme.color, SpottColors.surface1);
    expect(theme.cardTheme.elevation, 0.0);

    // Assert Filled Button theme properties
    final buttonStyle = theme.filledButtonTheme.style;
    expect(buttonStyle, isNotNull);
    
    // Test input decoration theme
    final inputDecorationTheme = theme.inputDecorationTheme;
    expect(inputDecorationTheme.filled, isTrue);
    expect(inputDecorationTheme.fillColor, SpottColors.surface2);
  });
}
