import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/design_system/token_visual_reference.dart';

void main() {
  testWidgets('TokenVisualReference golden test', (WidgetTester tester) async {
    // Set a consistent surface size for the golden test
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TokenVisualReference(),
      ),
    );

    // Wait for fonts to load or animations to settle
    await tester.pumpAndSettle();

    // Expect the widget to match the golden file
    await expectLater(
      find.byType(TokenVisualReference),
      matchesGoldenFile('goldens/token_visual_reference.png'),
    );
    
    // Reset view settings
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
