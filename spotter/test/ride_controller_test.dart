import 'package:flutter_test/flutter_test.dart';
import 'package:spotter/controllers/ride_controller.dart';
import 'package:spotter/models/ride_models.dart';
import 'package:spotter/repositories/ride_repository.dart';
import 'package:spotter/models/spott_models.dart' hide TripStatus;
import 'package:spotter/models/spott_models.dart' as spott;

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

  test('vehicle CRUD operations', () {
    final controller = RideController();
    
    // Initial seeded vehicles
    expect(controller.vehicles.length, 3);
    expect(controller.selectedVehicleId, 'veh_02');

    // Add Vehicle
    const newVehicle = Vehicle(
      id: 'veh_test',
      userId: 'current_user',
      vehicleType: 'Car',
      vehicleNumber: 'MH-12-XY-9999',
      vehicleModel: 'Tesla Model S',
      verificationStatus: VerificationStatus.verified,
    );
    controller.addVehicle(newVehicle);
    expect(controller.vehicles.length, 4);
    expect(controller.vehicles.last.id, 'veh_test');

    // Set Active
    controller.setSelectedVehicle('veh_test');
    expect(controller.selectedVehicleId, 'veh_test');

    // Update Vehicle
    final updatedVehicle = newVehicle.copyWith(vehicleModel: 'Tesla Model 3');
    controller.updateVehicle(updatedVehicle);
    expect(controller.vehicles.last.vehicleModel, 'Tesla Model 3');

    // Delete Vehicle
    controller.deleteVehicle('veh_test');
    expect(controller.vehicles.length, 3);
    // Since active was deleted, selected should fallback to first remaining or other
    expect(controller.selectedVehicleId, isNot('veh_test'));
  });

  test('traveler trip CRUD operations', () {
    final controller = RideController();

    // Initial seeded traveler trip
    expect(controller.travelerTrips.length, 1);
    expect(controller.activeTrips.any((t) => t.id == 'trip_traveler_01'), isTrue);

    // Add Trip
    final newTrip = Trip(
      id: 'trip_test',
      travelerId: 'current_user',
      source: 'Pune',
      destination: 'Mumbai',
      departureTime: DateTime.now().add(const Duration(hours: 4)),
      availableSeats: 3,
      pricePerSeat: 500,
      parcelAllowed: true,
      status: spott.TripStatus.active,
    );
    controller.addTrip(newTrip);
    expect(controller.travelerTrips.length, 2);
    expect(controller.travelerTrips.last.id, 'trip_test');
    expect(controller.activeTrips.any((t) => t.id == 'trip_test'), isTrue);

    // Update Trip
    final updatedTrip = newTrip.copyWith(pricePerSeat: 550);
    controller.updateTrip(updatedTrip);
    expect(controller.travelerTrips.last.pricePerSeat, 550);
    expect(controller.activeTrips.firstWhere((t) => t.id == 'trip_test').pricePerSeat, 550);

    // Delete Trip
    controller.deleteTrip('trip_test');
    expect(controller.travelerTrips.length, 1);
    expect(controller.activeTrips.any((t) => t.id == 'trip_test'), isFalse);
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
