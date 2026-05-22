import '../models/production_readiness_models.dart';

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

  static const bool paymentProviderConfigured = bool.fromEnvironment(
    'PAYMENT_PROVIDER_CONFIGURED',
  );

  static const bool identityVerificationConfigured = bool.fromEnvironment(
    'IDENTITY_VERIFICATION_CONFIGURED',
  );

  static const bool locationProviderConfigured = bool.fromEnvironment(
    'LOCATION_PROVIDER_CONFIGURED',
  );

  static const bool supportEscalationConfigured = bool.fromEnvironment(
    'SUPPORT_ESCALATION_CONFIGURED',
  );

  static const bool routeCoverageVerified = bool.fromEnvironment(
    'ROUTE_COVERAGE_VERIFIED',
  );

  static const bool p1RegressionCoverageVerified = bool.fromEnvironment(
    'P1_REGRESSION_COVERAGE_VERIFIED',
  );

  static ReleaseMode get releaseMode => ReleaseMode.fromEnvironment(
    environment: environment,
    diagnosticsEnabled: enableCrashDiagnostics,
  );

  static bool get isProduction => releaseMode.isProduction;
}
