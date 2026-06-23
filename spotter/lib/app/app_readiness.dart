import '../models/production_readiness_models.dart';
import 'app_config.dart';
import 'app_routes.dart';

class AppReadiness {
  const AppReadiness._();

  static ReadinessReport evaluate({
    ReleaseMode? releaseMode,
    bool? paymentProviderConfigured,
    bool? identityVerificationConfigured,
    bool? locationProviderConfigured,
    bool? supportEscalationConfigured,
    bool? routeCoverageVerified,
    bool? p1RegressionCoverageVerified,
  }) {
    final mode = releaseMode ?? AppConfig.releaseMode;
    final checks = <ReadinessCheck>[
      _releaseModeCheck(mode),
      _diagnosticsCheck(mode),
      _providerCheck(
        id: 'payment-provider',
        label: 'Payment provider setup',
        category: ReadinessCheckCategory.payment,
        configured:
            paymentProviderConfigured ?? AppConfig.paymentProviderConfigured,
        reason: 'Configure a production payment provider before launch.',
      ),
      _providerCheck(
        id: 'identity-verification',
        label: 'Identity verification setup',
        category: ReadinessCheckCategory.identity,
        configured:
            identityVerificationConfigured ??
            AppConfig.identityVerificationConfigured,
        reason:
            'Configure production KYC or identity verification before launch.',
      ),
      _providerCheck(
        id: 'location-provider',
        label: 'Location provider setup',
        category: ReadinessCheckCategory.location,
        configured:
            locationProviderConfigured ?? AppConfig.locationProviderConfigured,
        reason: 'Configure production location services before launch.',
      ),
      _providerCheck(
        id: 'support-escalation',
        label: 'Support escalation setup',
        category: ReadinessCheckCategory.support,
        configured:
            supportEscalationConfigured ??
            AppConfig.supportEscalationConfigured,
        reason: 'Configure support escalation ownership before launch.',
      ),
      _providerCheck(
        id: 'route-coverage',
        label: 'Route coverage verified',
        category: ReadinessCheckCategory.navigation,
        configured: routeCoverageVerified ?? AppConfig.routeCoverageVerified,
        reason:
            'Verify all ${AppRoutes.allRoutes.length} app routes and fallback navigation.',
      ),
      _providerCheck(
        id: 'p1-regression-coverage',
        label: 'P1 regression coverage verified',
        category: ReadinessCheckCategory.testCoverage,
        configured:
            p1RegressionCoverageVerified ??
            AppConfig.p1RegressionCoverageVerified,
        reason: 'Run and pass P1 ride-flow regression coverage before launch.',
      ),
    ];

    return ReadinessReport(checks: checks);
  }

  static ReadinessCheck _releaseModeCheck(ReleaseMode mode) {
    if (mode.name == AppReleaseMode.unknown) {
      return ReadinessCheck(
        id: 'release-mode',
        label: 'Release mode configuration',
        category: ReadinessCheckCategory.release,
        status: ReadinessStatus.blocked,
        reason: 'Use development, staging, or production as the release mode.',
      );
    }

    return const ReadinessCheck(
      id: 'release-mode',
      label: 'Release mode configuration',
      category: ReadinessCheckCategory.release,
      status: ReadinessStatus.pass,
    );
  }

  static ReadinessCheck _diagnosticsCheck(ReleaseMode mode) {
    if (mode.isProduction && !mode.diagnosticsEnabled) {
      return const ReadinessCheck(
        id: 'crash-diagnostics',
        label: 'Crash diagnostics',
        category: ReadinessCheckCategory.diagnostics,
        status: ReadinessStatus.blocked,
        reason: 'Enable crash diagnostics for production releases.',
      );
    }

    return ReadinessCheck(
      id: 'crash-diagnostics',
      label: 'Crash diagnostics',
      category: ReadinessCheckCategory.diagnostics,
      status: mode.diagnosticsEnabled
          ? ReadinessStatus.pass
          : ReadinessStatus.warning,
      reason: mode.diagnosticsEnabled
          ? null
          : 'Diagnostics are disabled for this non-production build.',
      requiredForProduction: mode.isProduction,
    );
  }

  static ReadinessCheck _providerCheck({
    required String id,
    required String label,
    required ReadinessCheckCategory category,
    required bool configured,
    required String reason,
  }) {
    return ReadinessCheck(
      id: id,
      label: label,
      category: category,
      status: configured ? ReadinessStatus.pass : ReadinessStatus.blocked,
      reason: configured ? null : reason,
    );
  }
}

