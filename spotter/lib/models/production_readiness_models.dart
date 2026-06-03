enum AppReleaseMode { development, staging, production, unknown }

extension AppReleaseModeLabel on AppReleaseMode {
  String get label => switch (this) {
    AppReleaseMode.development => 'Development',
    AppReleaseMode.staging => 'Staging',
    AppReleaseMode.production => 'Production',
    AppReleaseMode.unknown => 'Unknown',
  };
}

class ReleaseMode {
  final AppReleaseMode name;
  final String rawName;
  final bool diagnosticsEnabled;

  const ReleaseMode({
    required this.name,
    required this.rawName,
    required this.diagnosticsEnabled,
  });

  factory ReleaseMode.fromEnvironment({
    required String environment,
    required bool diagnosticsEnabled,
  }) {
    final normalized = environment.trim().toLowerCase();
    final mode = switch (normalized) {
      'development' || 'dev' => AppReleaseMode.development,
      'staging' || 'stage' => AppReleaseMode.staging,
      'production' || 'prod' => AppReleaseMode.production,
      _ => AppReleaseMode.unknown,
    };

    return ReleaseMode(
      name: mode,
      rawName: environment,
      diagnosticsEnabled: diagnosticsEnabled,
    );
  }

  bool get isProduction => name == AppReleaseMode.production;

  String get displayName => name.label;
}

enum ReadinessCheckCategory {
  configuration,
  diagnostics,
  payment,
  identity,
  location,
  support,
  navigation,
  testCoverage,
  release,
}

enum ReadinessStatus { pass, warning, blocked }

class ReadinessCheck {
  final String id;
  final String label;
  final ReadinessCheckCategory category;
  final ReadinessStatus status;
  final String? reason;
  final bool requiredForProduction;

  const ReadinessCheck({
    required this.id,
    required this.label,
    required this.category,
    required this.status,
    this.reason,
    this.requiredForProduction = true,
  });

  bool get isBlocking =>
      requiredForProduction && status == ReadinessStatus.blocked;

  String get statusLabel => switch (status) {
    ReadinessStatus.pass => 'Pass',
    ReadinessStatus.warning => 'Warning',
    ReadinessStatus.blocked => 'Blocked',
  };
}

class ReadinessReport {
  final List<ReadinessCheck> checks;

  const ReadinessReport({required this.checks});

  bool get isProductionReady => checks.every((check) => !check.isBlocking);

  List<ReadinessCheck> get blockingChecks =>
      checks.where((check) => check.isBlocking).toList(growable: false);
}

enum DiagnosticSeverity { info, warning, error, fatal }

class DiagnosticEvent {
  final String environment;
  final String? screen;
  final String? action;
  final DiagnosticSeverity severity;
  final String message;
  final bool stackAvailable;
  final String? rideReference;

  const DiagnosticEvent({
    required this.environment,
    this.screen,
    this.action,
    required this.severity,
    required this.message,
    required this.stackAvailable,
    this.rideReference,
  });

  bool containsSensitiveData() {
    final combined = [
      message,
      screen,
      action,
      rideReference,
    ].whereType<String>().join(' ');

    return RegExp(r'\b\d{12,19}\b').hasMatch(combined) ||
        RegExp(r'\b\d{4}\s\d{4}\s\d{4}\b').hasMatch(combined) ||
        RegExp(r'-?\d{1,3}\.\d{4,}\s*,\s*-?\d{1,3}\.\d{4,}').hasMatch(combined);
  }
}

enum UserRole { rider, driver, operator }

enum SupportCaseCategory {
  cancellation,
  payment,
  safety,
  route,
  driver,
  rider,
  technical,
  other,
}

enum SupportCaseStatus { draft, submitted, inReview, resolved }

class SupportCase {
  final String caseId;
  final String rideReference;
  final UserRole role;
  final SupportCaseCategory category;
  final SupportCaseStatus status;
  final String description;
  final DateTime createdAt;
  final bool userConsentAuthorized;

  const SupportCase({
    required this.caseId,
    required this.rideReference,
    required this.role,
    required this.category,
    required this.status,
    required this.description,
    required this.createdAt,
    required this.userConsentAuthorized,
  });

  factory SupportCase.forRide({
    required String rideReference,
    required UserRole role,
    required SupportCaseCategory category,
    required String description,
    SupportCaseStatus status = SupportCaseStatus.submitted,
    DateTime? createdAt,
    bool userConsentAuthorized = true,
  }) {
    final timestamp = createdAt ?? DateTime.now();
    final compactTime = timestamp.millisecondsSinceEpoch.toString();
    return SupportCase(
      caseId: 'CASE-$compactTime',
      rideReference: rideReference,
      role: role,
      category: category,
      status: status,
      description: description,
      createdAt: timestamp,
      userConsentAuthorized: userConsentAuthorized,
    );
  }

  bool get isReviewable =>
      rideReference.trim().isNotEmpty &&
      caseId.trim().isNotEmpty &&
      status != SupportCaseStatus.draft;

  String get roleLabel => switch (role) {
    UserRole.rider => 'Rider',
    UserRole.driver => 'Driver',
    UserRole.operator => 'Operator',
  };

  String get categoryLabel => switch (category) {
    SupportCaseCategory.cancellation => 'Cancellation',
    SupportCaseCategory.payment => 'Payment',
    SupportCaseCategory.safety => 'Safety',
    SupportCaseCategory.route => 'Route',
    SupportCaseCategory.driver => 'Driver',
    SupportCaseCategory.rider => 'Rider',
    SupportCaseCategory.technical => 'Technical',
    SupportCaseCategory.other => 'Other',
  };

  String get statusLabel => switch (status) {
    SupportCaseStatus.draft => 'Draft',
    SupportCaseStatus.submitted => 'Submitted',
    SupportCaseStatus.inReview => 'In review',
    SupportCaseStatus.resolved => 'Resolved',
  };
}

enum RecoverableAction {
  refreshRideData,
  cancelRide,
  submitRating,
  payment,
  navigation,
  support,
}

enum RecoverableActionStatus { idle, loading, success, failure }

enum RecoveryAction {
  retry,
  goHome,
  contactSupport,
  cancelRide,
  continueWithDefaults,
}

class RecoverableActionState {
  final RecoverableAction action;
  final RecoverableActionStatus status;
  final String? message;
  final RecoveryAction? primaryRecovery;
  final bool canRetry;

  const RecoverableActionState({
    required this.action,
    required this.status,
    this.message,
    this.primaryRecovery,
    this.canRetry = false,
  });

  static const idle = RecoverableActionState(
    action: RecoverableAction.refreshRideData,
    status: RecoverableActionStatus.idle,
  );

  bool get isFailure => status == RecoverableActionStatus.failure;
}
