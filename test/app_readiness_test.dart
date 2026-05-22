import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/app/app_readiness.dart';
import 'package:spotter/models/production_readiness_models.dart';

void main() {
  test('production readiness passes when all required checks pass', () {
    final report = AppReadiness.evaluate(
      releaseMode: ReleaseMode.fromEnvironment(
        environment: 'production',
        diagnosticsEnabled: true,
      ),
      paymentProviderConfigured: true,
      identityVerificationConfigured: true,
      locationProviderConfigured: true,
      supportEscalationConfigured: true,
      routeCoverageVerified: true,
      p1RegressionCoverageVerified: true,
    );

    expect(report.isProductionReady, isTrue);
    expect(report.blockingChecks, isEmpty);
  });

  test('production readiness blocks missing launch dependencies', () {
    final report = AppReadiness.evaluate(
      releaseMode: ReleaseMode.fromEnvironment(
        environment: 'production',
        diagnosticsEnabled: false,
      ),
      paymentProviderConfigured: false,
      identityVerificationConfigured: false,
      locationProviderConfigured: false,
      supportEscalationConfigured: false,
      routeCoverageVerified: false,
      p1RegressionCoverageVerified: false,
    );

    expect(report.isProductionReady, isFalse);
    expect(report.blockingChecks.length, greaterThanOrEqualTo(6));
    expect(
      report.blockingChecks.map((check) => check.reason),
      everyElement(isNotNull),
    );
  });

  test('non-production disabled diagnostics are warning not blocker', () {
    final report = AppReadiness.evaluate(
      releaseMode: ReleaseMode.fromEnvironment(
        environment: 'staging',
        diagnosticsEnabled: false,
      ),
      paymentProviderConfigured: true,
      identityVerificationConfigured: true,
      locationProviderConfigured: true,
      supportEscalationConfigured: true,
      routeCoverageVerified: true,
      p1RegressionCoverageVerified: true,
    );

    final diagnostics = report.checks.singleWhere(
      (check) => check.id == 'crash-diagnostics',
    );
    expect(diagnostics.status, ReadinessStatus.warning);
    expect(diagnostics.isBlocking, isFalse);
  });
}
