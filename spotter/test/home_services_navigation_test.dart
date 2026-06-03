import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/app/app_routes.dart';

import 'helpers/app_test_harness.dart';

void main() {
  testWidgets('home bottom nav opens services and returns home', (
    tester,
  ) async {
    await pumpSpotterRoute(tester, AppRoutes.home);

    expect(find.text('Suggestions'), findsWidgets);
    expect(find.text('Where to?'), findsOneWidget);

    await _tapText(tester, 'Services');
    await tester.pumpAndSettle();
    expect(find.text('Services'), findsWidgets);
    expect(find.text('Share rides, send parcels, save money'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Suggestions'), findsWidgets);
    expect(find.text('Where to?'), findsOneWidget);
  });
}

Future<void> _tapText(WidgetTester tester, String text) async {
  final finder = find.text(text);
  await tester.ensureVisible(finder);
  await tester.tap(finder);
}
