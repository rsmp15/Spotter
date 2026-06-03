import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/app/app_routes.dart';

import 'helpers/app_test_harness.dart';

void main() {
  testWidgets('driver workflow reaches pickup and drop tasks', (tester) async {
    await pumpSpotterRoute(tester, AppRoutes.driverHome);

    expect(find.text('Earn on your trip'), findsOneWidget);

    // 1. Start Travel flow
    await _tapText(tester, 'Start Travel');
    await tester.pumpAndSettle();

    expect(find.text('Where are you heading?'), findsOneWidget);

    // 2. Select a popular destination
    await _tapText(tester, 'Baner');
    await tester.pumpAndSettle();

    expect(find.text('ACCEPTING REQUESTS'), findsOneWidget);

    // 3. Start Active Trip
    await _tapText(tester, 'ACCEPTING REQUESTS');
    await tester.pumpAndSettle();

    expect(find.text('Active Trip'), findsOneWidget);

    // 4. Complete active trip
    await _tapText(tester, 'COMPLETE TRIP');
    await tester.pumpAndSettle();

    expect(find.text('Earn on your trip'), findsOneWidget);
  });
}

Future<void> _tapText(WidgetTester tester, String text) async {
  final finder = find.text(text);
  await tester.ensureVisible(finder);
  await tester.tap(finder);
}
