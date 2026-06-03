import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/main.dart';

void main() {
  testWidgets('Spott app starts on splash screen', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('SPOTT'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
