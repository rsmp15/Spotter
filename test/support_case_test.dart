import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/models/production_readiness_models.dart';

void main() {
  test('support case for ride is reviewable with required context', () {
    final supportCase = SupportCase.forRide(
      rideReference: 'SPT2049',
      role: UserRole.rider,
      category: SupportCaseCategory.payment,
      description: 'Charged twice',
      createdAt: DateTime(2026, 5, 14, 12, 0),
    );

    expect(supportCase.isReviewable, isTrue);
    expect(supportCase.rideReference, 'SPT2049');
    expect(supportCase.roleLabel, 'Rider');
    expect(supportCase.categoryLabel, 'Payment');
    expect(supportCase.statusLabel, 'Submitted');
    expect(supportCase.userConsentAuthorized, isTrue);
  });

  test('support case with explicit user consent disabled', () {
    final supportCase = SupportCase.forRide(
      rideReference: 'SPT2049',
      role: UserRole.rider,
      category: SupportCaseCategory.safety,
      description: 'Privacy sensitive incident',
      userConsentAuthorized: false,
      createdAt: DateTime(2026, 5, 14, 12, 0),
    );

    expect(supportCase.isReviewable, isTrue);
    expect(supportCase.userConsentAuthorized, isFalse);
  });

  test('draft support case is not reviewable', () {
    final supportCase = SupportCase.forRide(
      rideReference: 'SPT2049',
      role: UserRole.driver,
      category: SupportCaseCategory.cancellation,
      description: '',
      status: SupportCaseStatus.draft,
      createdAt: DateTime(2026, 5, 14, 12, 0),
    );

    expect(supportCase.isReviewable, isFalse);
  });
}
