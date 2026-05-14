import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/main.dart';

void main() {
  testWidgets('Spotter app starts on splash screen', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Spotter'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
