import 'package:flutter/foundation.dart';

import 'app_config.dart';

class AppCrashReporter {
  const AppCrashReporter._();

  static void recordFlutterError(FlutterErrorDetails details) {
    if (!AppConfig.enableCrashDiagnostics) return;

    FlutterError.presentError(details);

    if (kDebugMode) {
      debugPrint('Flutter error: ${details.exceptionAsString()}');
      debugPrintStack(stackTrace: details.stack);
    }

    // Wire Firebase Crashlytics, Sentry, or another provider here before launch.
  }

  static bool recordPlatformError(Object error, StackTrace stackTrace) {
    if (!AppConfig.enableCrashDiagnostics) return false;

    if (kDebugMode) {
      debugPrint('Platform error: $error');
      debugPrintStack(stackTrace: stackTrace);
    }

    // Returning true prevents duplicate platform error reports.
    return true;
  }
}
