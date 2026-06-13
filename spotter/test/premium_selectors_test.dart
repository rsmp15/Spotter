import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/widgets/premium/premium_selectors.dart';

void main() {
  testWidgets('PremiumDatePickerBottomSheet renders presets and grid',
      (WidgetTester tester) async {
    final initialDate = DateTime(2026, 6, 9);
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  PremiumDatePickerBottomSheet.show(
                    context,
                    initialDate: initialDate,
                    firstDate: DateTime(2026, 6, 1),
                    lastDate: DateTime(2026, 6, 30),
                  );
                },
                child: const Text('Show Picker'),
              );
            },
          ),
        ),
      ),
    );

    // Show the bottom sheet
    await tester.tap(find.text('Show Picker'));
    await tester.pumpAndSettle();

    // Verify header elements
    expect(find.text('Select Travel Date'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Tomorrow'), findsOneWidget);

    // Verify days are rendered
    expect(find.text('9'), findsOneWidget);
    expect(find.text('15'), findsOneWidget);
    expect(find.text('CONFIRM DATE'), findsOneWidget);

    // Scroll to make sure it is fully visible before tapping
    await tester.ensureVisible(find.text('CONFIRM DATE'));
    await tester.pumpAndSettle();

    // Tap confirm
    await tester.tap(find.text('CONFIRM DATE'));
    await tester.pumpAndSettle();

    // Bottom sheet should be closed
    expect(find.text('Select Travel Date'), findsNothing);
  });

  testWidgets('PremiumPassengersBottomSheet renders stepper and car visualizer',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  PremiumPassengersBottomSheet.show(
                    context,
                    initialSeats: 1,
                    maxSeats: 4,
                  );
                },
                child: const Text('Show Passengers Picker'),
              );
            },
          ),
        ),
      ),
    );

    // Show the bottom sheet
    await tester.tap(find.text('Show Passengers Picker'));
    await tester.pumpAndSettle();

    // Verify header elements
    expect(find.text('Select Passengers'), findsOneWidget);
    expect(find.text('Choose the number of seats you want to book'), findsOneWidget);

    // Verify visual seats
    expect(find.text('DRIVER'), findsOneWidget);
    expect(find.text('1'), findsNWidgets(3)); // Stepper, visual seat '1', and quick pick '1'
    expect(find.text('2'), findsNWidgets(2)); // Visual seat '2' and quick pick '2'

    // Scroll add button into view if needed and tap '+' to increment seats
    await tester.ensureVisible(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();

    // Count should be 2 now
    expect(find.text('2'), findsNWidgets(3)); // Stepper, visual seat '2', and quick pick '2'

    // Scroll confirm button into view and confirm
    await tester.ensureVisible(find.text('CONFIRM SELECTION'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CONFIRM SELECTION'));
    await tester.pumpAndSettle();

    // Sheet should be closed
    expect(find.text('Select Passengers'), findsNothing);
  });
}
