import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/app/app_routes.dart';

import 'helpers/app_test_harness.dart';

void main() {
  testWidgets('activity screen filters trip history by type', (tester) async {
    await pumpSpotterRoute(tester, AppRoutes.activity);

    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('Rajaji National Park Safari'), findsOneWidget);
    expect(find.text('Hotel Godawari'), findsOneWidget);
    expect(find.text('Package Delivery'), findsOneWidget);

    await tester.tap(find.text('Rides'));
    await tester.pumpAndSettle();

    expect(find.text('Rajaji National Park Safari'), findsOneWidget);
    expect(find.text('Hotel Godawari'), findsOneWidget);
    expect(find.text('Package Delivery'), findsNothing);
  });
}
