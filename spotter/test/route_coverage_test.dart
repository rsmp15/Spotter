import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/app/app_routes.dart';
import 'package:spotter/models/spott_models.dart';

import 'helpers/app_test_harness.dart';

void main() {
  testWidgets('all declared routes render a screen or fallback for user', (
    tester,
  ) async {
    for (final route in AppRoutes.allRoutes) {
      await pumpSpotterRoute(tester, route, overrideRole: UserRole.user);

      expect(find.byType(Scaffold), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'Route failed for user: $route');
    }
  });



  testWidgets('unknown route shows recoverable page not found fallback', (
    tester,
  ) async {
    await pumpSpotterRoute(tester, '/missing-route');

    expect(find.text('Page not found'), findsOneWidget);
    expect(find.text('Back to home'), findsOneWidget);
  });
}
