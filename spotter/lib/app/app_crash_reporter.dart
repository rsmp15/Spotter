import 'package:flutter/foundation.dart';

import '../models/production_readiness_models.dart';
import 'app_config.dart';

class AppCrashReporter {
  const AppCrashReporter._();

  static DiagnosticEvent? lastRecordedEvent;

  static void recordFlutterError(FlutterErrorDetails details) {
    if (!AppConfig.enableCrashDiagnostics) return;

    lastRecordedEvent = buildDiagnosticEvent(
      error: details.exception,
      stackTrace: details.stack,
      severity: DiagnosticSeverity.fatal,
      action: 'flutter-error',
    );

    FlutterError.presentError(details);

    if (kDebugMode) {
      debugPrint('Flutter error: ${details.exceptionAsString()}');
      debugPrintStack(stackTrace: details.stack);
    }

    // Wire Firebase Crashlytics, Sentry, or another provider here before launch.
  }

  static bool recordPlatformError(Object error, StackTrace stackTrace) {
    if (!AppConfig.enableCrashDiagnostics) return false;

    lastRecordedEvent = buildDiagnosticEvent(
      error: error,
      stackTrace: stackTrace,
      severity: DiagnosticSeverity.fatal,
      action: 'platform-error',
    );

    if (kDebugMode) {
      debugPrint('Platform error: $error');
      debugPrintStack(stackTrace: stackTrace);
    }

    // Returning true prevents duplicate platform error reports.
    return true;
  }

  static DiagnosticEvent buildDiagnosticEvent({
    required Object error,
    StackTrace? stackTrace,
    DiagnosticSeverity severity = DiagnosticSeverity.error,
    String? screen,
    String? action,
    String? rideReference,
  }) {
    return DiagnosticEvent(
      environment: AppConfig.releaseMode.displayName,
      screen: screen,
      action: action,
      severity: severity,
      message: redact(error.toString()),
      stackAvailable: stackTrace != null,
      rideReference: rideReference == null ? null : redact(rideReference),
    );
  }

  static String redact(String value) {
    return value
        .replaceAll(RegExp(r'\b\d{12,19}\b'), '[REDACTED_NUMBER]')
        .replaceAll(RegExp(r'\b\d{4}\s\d{4}\s\d{4}\b'), '[REDACTED_ID]')
        .replaceAll(
          RegExp(r'-?\d{1,3}\.\d{4,}\s*,\s*-?\d{1,3}\.\d{4,}'),
          '[REDACTED_LOCATION]',
        )
        .replaceAll(
          RegExp(
            r'(api[_-]?key|secret|token|password)=([^,\s]+)',
            caseSensitive: false,
          ),
          r'$1=[REDACTED_SECRET]',
        );
  }
}

