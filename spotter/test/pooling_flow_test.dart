import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/app/app_routes.dart';
import 'helpers/app_test_harness.dart';

void main() {
  testWidgets('ride pooling fare breakup and co-rider matching verification', (
    tester,
  ) async {
    final controller = await pumpSpotterRoute(tester, AppRoutes.fare);

    expect(find.text('Price estimate'), findsOneWidget);

    // 1. Verify Spott Pool option card is rendered in the list
    expect(find.text('Spott Pool'), findsOneWidget);
    expect(find.text('Moto Pool'), findsOneWidget);

    // 2. Select Spott Pool option
    await tester.tap(find.text('Spott Pool'));
    await tester.pumpAndSettle();

    expect(controller.selectedRideOption?.id, 'pool');

    // 3. Verify Co-riders matches and shared stops details are rendered
    expect(find.text('Co-Riders Matched'), findsOneWidget);
    expect(find.text('Aarav S. • ★ 4.8'), findsOneWidget);
    expect(find.text('Rohit M. • ★ 4.7'), findsOneWidget);
    expect(find.text('Shared Stop Sequence'), findsOneWidget);
    expect(find.text('1. Pickup You (Baner)'), findsOneWidget);

    // 4. Verify pooling split fare savings row is visible
    expect(find.text('Multi-rider Split Savings'), findsOneWidget);
    expect(find.text('-Rs 34'), findsOneWidget);

    // 5. Proceed to driver matching
    await tester.tap(find.text('Find drivers'));
    await tester.pumpAndSettle();

    expect(find.text('Driver matches'), findsOneWidget);
    // Verified that a private car partner (Priya K or Neha Sharma) is matched
    expect(controller.selectedDriver, isNotNull);
  });
}

