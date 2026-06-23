import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/app/app_routes.dart';

import 'helpers/app_test_harness.dart';

void main() {
  testWidgets('rider flow preserves trip context from home through rating', (
    tester,
  ) async {
    final controller = await pumpSpotterRoute(tester, AppRoutes.home);

    expect(find.text('Where to?'), findsOneWidget);
    expect(controller.selectedRideOption, isNotNull);

    await _tapText(tester, 'Where to?');
    await tester.pumpAndSettle();
    
    // Tap the "Where to?" banner to expand the sheet (min state to max state)
    await _tapText(tester, 'Where to?');
    await tester.pumpAndSettle();

    // Select the first suggestion (e.g. "Select Citywalk Mall" or "Home")
    await _tapText(tester, 'Home');
    await tester.pumpAndSettle();

    // Verify we are on the fare estimation screen (SpotterFarePanel)
    expect(find.text('Price estimate'), findsOneWidget);

    // Tap "Find drivers" to start searching
    await _tapText(tester, 'Find drivers');
    await tester.pumpAndSettle();
    expect(find.text('Driver matches'), findsOneWidget);

    // Tap the first driver card (e.g., Amit Sharma)
    await _tapText(tester, 'Amit Sharma');
    await tester.pumpAndSettle();
    expect(find.text('Traveler Profile'), findsOneWidget);

    // Choose the traveler
    await _tapText(tester, 'Choose This Traveler');
    await tester.pumpAndSettle();
    expect(find.text('Confirm ride'), findsOneWidget);

    await _tapText(tester, 'Pay securely');
    await tester.pumpAndSettle();
    expect(find.text('Payment'), findsOneWidget);

    await _tapText(tester, 'Pay ${controller.fareLabel}');
    await tester.pumpAndSettle();
    expect(find.text('Live tracking'), findsOneWidget);

    await _tapText(tester, 'Show ride OTP');
    await tester.pumpAndSettle();
    expect(find.text('Ride OTP'), findsOneWidget);

    await _tapText(tester, 'End demo ride');
    await tester.pumpAndSettle();
    expect(find.text('Ride complete'), findsOneWidget);

    await _tapText(tester, 'Rate driver');
    await tester.pumpAndSettle();
    expect(find.text('Rate your ride'), findsOneWidget);
  });

  testWidgets('destination screen accepts a typed destination', (tester) async {
    final controller = await pumpSpotterRoute(tester, AppRoutes.destination);

    // Expand the sheet if it's collapsed
    if (find.byType(EditableText).evaluate().isEmpty) {
      await tester.tap(find.text('Where to?'));
      await tester.pumpAndSettle();
    }

    await tester.enterText(find.byType(EditableText).last, 'India Gate');
    await tester.pumpAndSettle();

    await _tapText(tester, 'Use "India Gate"');
    await tester.pumpAndSettle();

    expect(controller.destination.title, 'India Gate');
    expect(find.text('Price estimate'), findsOneWidget);
  });
}

Future<void> _tapText(WidgetTester tester, String text) async {
  final finder = find.text(text);
  await tester.ensureVisible(finder);
  await tester.tap(finder);
}
