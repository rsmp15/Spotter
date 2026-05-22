import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/app/app_crash_reporter.dart';
import 'package:spotter/models/production_readiness_models.dart';

void main() {
  test('diagnostic event redacts payment, identity, location, and secrets', () {
    final event = AppCrashReporter.buildDiagnosticEvent(
      error: StateError(
        'card 4111111111111111 aadhaar 1234 5678 9012 '
        'at 18.520430, 73.856744 token=abc123',
      ),
      stackTrace: StackTrace.current,
      screen: '/payment',
      action: 'pay',
      rideReference: 'SPT2049',
    );

    expect(event.severity, DiagnosticSeverity.error);
    expect(event.stackAvailable, isTrue);
    expect(event.message, contains('[REDACTED_NUMBER]'));
    expect(event.message, contains('[REDACTED_ID]'));
    expect(event.message, contains('[REDACTED_LOCATION]'));
    expect(event.message, contains('[REDACTED_SECRET]'));
    expect(event.containsSensitiveData(), isFalse);
  });
}
