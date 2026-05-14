class AppConfig {
  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Spotter',
  );

  static const String environment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  static const bool enableCrashDiagnostics = bool.fromEnvironment(
    'ENABLE_CRASH_DIAGNOSTICS',
    defaultValue: true,
  );

  static bool get isProduction => environment == 'production';
}
