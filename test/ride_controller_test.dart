import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/controllers/ride_controller.dart';
import 'package:spotter/models/ride_models.dart';
import 'package:spotter/repositories/ride_repository.dart';

void main() {
  test('initializes from repository and preserves safe defaults', () async {
    final repository = _FakeRideRepository(
      bootstrapData: const RideBootstrapData(
        pickup: LocationPoint(title: 'Aundh', detail: 'Aundh, Pune'),
        destination: LocationPoint(title: 'Camp', detail: 'Camp, Pune'),
        rideOptions: [
          RideOption(
            id: 'cab',
            name: 'Cab',
            detail: '3 min away - 4 seats',
            fare: 120,
          ),
        ],
        drivers: [
          Driver(
            id: 'driver-1',
            name: 'Neha P',
            vehicle: 'Cab - MH 12 NP 1200',
            eta: '3 min',
            rating: 4.9,
            completedRides: 348,
          ),
        ],
        paymentMethods: [
          PaymentMethod(id: 'upi', label: 'UPI', detail: 'Available'),
        ],
        shareLink: 'https://spotter.app/trip/test',
      ),
    );
    final controller = RideController(repository: repository);

    await controller.initialize();

    expect(controller.loadState, RideLoadState.ready);
    expect(controller.pickup.title, 'Aundh');
    expect(controller.selectedRideOption?.id, 'cab');
    expect(controller.selectedDriver?.id, 'driver-1');
    expect(controller.selectedPaymentMethod?.id, 'upi');
    expect(controller.shareLink, 'https://spotter.app/trip/test');
  });

  test('keeps usable seed data when repository refresh fails', () async {
    final controller = RideController(repository: _FailingRideRepository());

    await controller.initialize();

    expect(controller.loadState, RideLoadState.failure);
    expect(controller.hasLoadFailed, isTrue);
    expect(controller.rideOptions, isNotEmpty);
    expect(controller.selectedRideOption, isNotNull);
    expect(controller.loadErrorMessage, isNotNull);
  });

  test('selecting a ride option chooses the matching driver', () {
    final controller = RideController();
    final bike = controller.rideOptions.singleWhere(
      (option) => option.id == 'bike',
    );

    controller.selectRideOption(bike);

    expect(controller.status, TripStatus.searching);
    expect(controller.selectedDriver?.vehicle.toLowerCase(), contains('bike'));
  });
}

class _FakeRideRepository implements RideRepository {
  final RideBootstrapData bootstrapData;

  const _FakeRideRepository({required this.bootstrapData});

  @override
  Future<RideBootstrapData> loadBootstrapData() async => bootstrapData;

  @override
  Future<void> cancelRide({required String reason}) async {}

  @override
  Future<void> submitRating({required int rating, required int tip}) async {}
}

class _FailingRideRepository implements RideRepository {
  @override
  Future<RideBootstrapData> loadBootstrapData() {
    throw StateError('network unavailable');
  }

  @override
  Future<void> cancelRide({required String reason}) async {}

  @override
  Future<void> submitRating({required int rating, required int tip}) async {}
}
