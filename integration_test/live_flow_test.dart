import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:spotter/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('full E2E rider live flow walkthrough', (WidgetTester tester) async {
    // Set standard physical size to make sure all elements fit and are visible on the viewport
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Helper to perform a 3-second wait at each step
    Future<void> stepWait() async {
      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    }

    // Helper to tap text and wait
    Future<void> tapText(String text) async {
      final finder = find.text(text);
      await tester.ensureVisible(finder);
      await tester.tap(finder);
      await tester.pumpAndSettle();
      await stepWait();
    }

    // 1. Boot up the real application
    app.main();
    await tester.pumpAndSettle();
    await stepWait();

    // Verify we are on Splash screen
    expect(find.text('Spotter'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    // 2. Tap "Get Started" to navigate to Onboarding screen
    await tapText('Get Started');
    expect(find.text('Rides Made Easy'), findsOneWidget);

    // 3. On Onboarding screen, tap "Get Started" to navigate to Login
    await tapText('Get Started');
    expect(find.text('Enter Your Number'), findsOneWidget);

    // 4. Enter phone number and tap "Get OTP"
    await tester.enterText(find.byType(EditableText), '9876543210');
    await tester.pumpAndSettle();
    await stepWait();
    await tapText('Get OTP');
    expect(find.text('Verify Your Number'), findsOneWidget);

    // 5. Enter OTP and tap "Verify And Continue"
    await tester.enterText(find.byType(EditableText), '123456');
    await tester.pumpAndSettle();
    await stepWait();
    await tapText('Verify And Continue');
    expect(find.text('Choose role'), findsOneWidget);

    // 6. Choose "Rider" role by selecting Book rides
    await tapText('Book rides');
    expect(find.text('Where to?'), findsOneWidget);

    // 7. Tap "Where to?" to go to plan ride / choose destination
    await tapText('Where to?');
    expect(find.text('Plan your ride'), findsOneWidget);

    // 8. Select "Select Citywalk Mall" as destination
    await tapText('Select Citywalk Mall');
    expect(find.text('Price estimate'), findsOneWidget);

    // 9. Find drivers
    await tapText('Find drivers');
    expect(find.text('Driver matches'), findsOneWidget);

    // 10. View best driver
    await tapText('View best driver');
    expect(find.text('Driver profile'), findsOneWidget);

    // 11. Choose driver
    await tapText('Choose driver');
    expect(find.text('Confirm ride'), findsOneWidget);

    // 12. Proceed to payment page
    await tapText('Pay securely');
    expect(find.text('Payment'), findsOneWidget);

    // 13. Pay the fare (exact amount Rs 49)
    await tapText('Pay Rs 49');
    expect(find.text('Live tracking'), findsOneWidget);

    // 14. Show OTP
    await tapText('Show ride OTP');
    expect(find.text('Ride OTP'), findsOneWidget);

    // 15. End demo ride
    await tapText('End demo ride');
    expect(find.text('Ride complete'), findsOneWidget);

    // 16. Rate driver
    await tapText('Rate driver');
    expect(find.text('Rate your ride'), findsOneWidget);
  });
}
