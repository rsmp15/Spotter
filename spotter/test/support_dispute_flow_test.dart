import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/app/app_routes.dart';

import 'helpers/app_test_harness.dart';

void main() {
  testWidgets('support screen includes reviewable ride context', (
    tester,
  ) async {
    await pumpSpotterRoute(tester, AppRoutes.support);

    expect(find.text('Help center'), findsOneWidget);
    expect(find.text('Ride reference'), findsOneWidget);
    expect(find.text('SPT2049'), findsOneWidget);
    expect(find.text('Role'), findsOneWidget);
    expect(find.text('Rider'), findsOneWidget);
    expect(find.text('Status'), findsWidgets);
  });

  testWidgets('dispute screen includes support case context', (tester) async {
    await pumpSpotterRoute(tester, AppRoutes.dispute);

    expect(find.text('Issue report'), findsOneWidget);
    expect(find.text('Ride reference'), findsOneWidget);
    expect(find.text('SPT2049'), findsOneWidget);
    expect(find.text('Issue category'), findsOneWidget);
    expect(find.text('Safety'), findsOneWidget);
    expect(find.text('Submitted'), findsOneWidget);
  });
}
