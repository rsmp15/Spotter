import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/app/app_routes.dart';

import 'helpers/app_test_harness.dart';

void main() {
  testWidgets('driver workflow reaches pickup and drop tasks', (tester) async {
    await pumpSpotterRoute(tester, AppRoutes.driverHome);

    expect(find.text('Earn on your trip'), findsOneWidget);

    await _tapText(tester, 'Add availability');
    await tester.pumpAndSettle();
    expect(find.text('Create availability'), findsOneWidget);

    await _tapText(tester, 'Publish availability');
    await tester.pumpAndSettle();
    expect(find.text('Route jobs'), findsOneWidget);

    await _tapText(tester, 'View best request');
    await tester.pumpAndSettle();
    expect(find.text('Request details'), findsOneWidget);

    await _tapText(tester, 'Accept request');
    await tester.pumpAndSettle();
    expect(find.text('Pickup task'), findsOneWidget);

    await _tapText(tester, 'Start ride');
    await tester.pumpAndSettle();
    expect(find.text('Drop task'), findsOneWidget);
  });
}

Future<void> _tapText(WidgetTester tester, String text) async {
  final finder = find.text(text);
  await tester.ensureVisible(finder);
  await tester.tap(finder);
}
