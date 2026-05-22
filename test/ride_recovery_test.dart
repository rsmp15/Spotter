import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/controllers/ride_controller.dart';
import 'package:spotter/models/production_readiness_models.dart';
import 'package:spotter/models/ride_models.dart';

import 'helpers/fake_ride_repository.dart';

void main() {
  test(
    'failed refresh keeps safe defaults and exposes retry recovery',
    () async {
      final controller = RideController(
        repository: const FakeRideRepository(failLoad: true),
      );

      await controller.initialize();

      expect(controller.loadState, RideLoadState.failure);
      expect(controller.rideOptions, isNotEmpty);
      expect(controller.actionState.action, RecoverableAction.refreshRideData);
      expect(controller.actionState.isFailure, isTrue);
      expect(controller.actionState.canRetry, isTrue);
    },
  );

  test('failed cancel preserves active ride context', () async {
    final controller = RideController(
      repository: const FakeRideRepository(failCancel: true),
    );
    await controller.initialize();
    final originalRoute = controller.routeLabel;

    final result = await controller.cancelRide('Driver is too far');

    expect(result, isFalse);
    expect(controller.status, isNot(TripStatus.cancelled));
    expect(controller.routeLabel, originalRoute);
    expect(controller.actionState.action, RecoverableAction.cancelRide);
    expect(controller.actionState.isFailure, isTrue);
  });
}
