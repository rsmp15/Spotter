import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/app/app_routes.dart';

import 'helpers/app_test_harness.dart';

void main() {
  testWidgets('activity screen filters trip history by type', (tester) async {
    await pumpSpotterRoute(tester, AppRoutes.activity);

    expect(find.text('Your activity'), findsOneWidget);
    expect(find.text('Downtown Garage'), findsOneWidget);
    expect(find.text('Ride to Airport'), findsOneWidget);
    expect(find.text('Package to Kalyani Nagar'), findsOneWidget);

    await tester.tap(find.text('Rides'));
    await tester.pumpAndSettle();

    expect(find.text('Ride to Airport'), findsOneWidget);
    expect(find.text('Moto from Office'), findsOneWidget);
    expect(find.text('Downtown Garage'), findsNothing);
    expect(find.text('Package to Kalyani Nagar'), findsNothing);
  });
}
