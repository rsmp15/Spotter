import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/app/app_routes.dart';
import 'package:spotter/models/ride_models.dart';
import 'helpers/app_test_harness.dart';

void main() {
  testWidgets('parcel booking flow from setup through delivery verification receipt', (
    tester,
  ) async {
    final controller = await pumpSpotterRoute(tester, AppRoutes.parcelBooking);

    // 1. Verify all booking form fields exist
    expect(find.text('Send a Package'), findsOneWidget);
    expect(find.text('Sender Name'), findsOneWidget);
    expect(find.text('Receiver Name'), findsOneWidget);
    expect(find.text('Receiver Phone'), findsOneWidget);

    // 2. Select category and size chips
    await _tapText(tester, 'Laundry / Clothes');
    await tester.pumpAndSettle();

    await _tapText(tester, 'Medium');
    await tester.pumpAndSettle();

    // 3. Select private car delivery partner
    await _tapText(tester, 'Private Car');
    await tester.pumpAndSettle();

    // 4. Fill in recipient form inputs
    final inputs = find.byType(TextFormField);
    
    // Fill Receiver Name (3rd field)
    await tester.enterText(inputs.at(2), 'Amit Kumar');
    await tester.pumpAndSettle();

    // Fill Receiver Phone (4th field)
    await tester.enterText(inputs.at(3), '9876543210');
    await tester.pumpAndSettle();

    // 4b. Upload package photo and accept safety declaration
    await _tapText(tester, 'Upload Package Photo');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    // 5. Submit booking and verify matching partner selection
    await _tapText(tester, 'Assign Delivery Partner');
    await tester.pumpAndSettle();

    expect(controller.activeParcel, isNotNull);
    expect(controller.activeParcel!.receiverName, 'Amit Kumar');
    expect(controller.activeParcel!.size, ParcelSizeClass.medium);
    expect(controller.isParcelBookingActive, isTrue);

    // Should be on tracking screen
    expect(find.text('Track Parcel'), findsOneWidget);
    expect(find.text('Amit Sharma'), findsOneWidget); // Car driver matching Amit Sharma
    expect(find.text('Delivery Milestone'), findsOneWidget);

    // Simulate OTP entering and submit via text input action done
    await tester.enterText(find.byType(EditableText).last, controller.parcelVerificationPin);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Verify complete receipt screen
    expect(find.text('Delivery Receipt'), findsOneWidget);
    expect(find.text('Amit Kumar'), findsOneWidget);
    expect(controller.parcelStatus, TripStatus.completed);

    // Tap return to home
    await _tapText(tester, 'Return to Home');
    await tester.pumpAndSettle();

    expect(controller.activeParcel, isNull);
    expect(controller.isParcelBookingActive, isFalse);
  });
}

Future<void> _tapText(WidgetTester tester, String text) async {
  final finder = find.text(text);
  await tester.ensureVisible(finder);
  await tester.tap(finder);
}

