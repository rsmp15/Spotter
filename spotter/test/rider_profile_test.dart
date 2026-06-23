
import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/app/app_routes.dart';
import 'package:spotter/models/spott_models.dart';

import 'package:spotter/screens/profile_screen.dart';

import 'helpers/app_test_harness.dart';

void main() {


  testWidgets('user profile tab renders without crash', (tester) async {
    final controller = await pumpSpotterRoute(tester, AppRoutes.home, overrideRole: UserRole.user);
    
    // Switch to tab index 3 (Profile tab for User)
    final ride = controller;
    ride.switchTab(3);
    await tester.pumpAndSettle();
    
    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
