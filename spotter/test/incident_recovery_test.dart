import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/app/app_routes.dart';

import 'helpers/app_test_harness.dart';
import 'helpers/fake_ride_repository.dart';

void main() {
  testWidgets('cancellation failure stays on ride context with retry message', (
    tester,
  ) async {
    await pumpSpotterRoute(
      tester,
      AppRoutes.cancelRide,
      repository: const FakeRideRepository(failCancel: true),
    );

    await tester.ensureVisible(find.text('Driver is too far'));
    await tester.tap(find.text('Driver is too far'));
    await tester.pumpAndSettle();

    expect(find.text('Cancel ride'), findsOneWidget);
    expect(find.textContaining('could not cancel'), findsOneWidget);
    expect(find.text('Trip context'), findsOneWidget);
  });

  testWidgets('rating failure stays on ride context with retry message', (
    tester,
  ) async {
    await pumpSpotterRoute(
      tester,
      AppRoutes.rating,
      repository: const FakeRideRepository(failRating: true),
    );

    await tester.ensureVisible(find.text('Submit rating'));
    await tester.tap(find.text('Submit rating'));
    await tester.pumpAndSettle();

    expect(find.text('Rate your ride'), findsOneWidget);
    expect(find.textContaining('could not submit your rating'), findsOneWidget);
    expect(find.text('Trip context'), findsOneWidget);
  });
}
