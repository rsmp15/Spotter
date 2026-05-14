import '../models/ride_models.dart';

class RideBootstrapData {
  final LocationPoint pickup;
  final LocationPoint destination;
  final List<RideOption> rideOptions;
  final List<Driver> drivers;
  final List<PaymentMethod> paymentMethods;
  final String shareLink;

  const RideBootstrapData({
    required this.pickup,
    required this.destination,
    required this.rideOptions,
    required this.drivers,
    required this.paymentMethods,
    required this.shareLink,
  });
}

abstract interface class RideRepository {
  Future<RideBootstrapData> loadBootstrapData();

  Future<void> cancelRide({required String reason});

  Future<void> submitRating({required int rating, required int tip});
}

class MockRideRepository implements RideRepository {
  const MockRideRepository();

  static const RideBootstrapData seedData = RideBootstrapData(
    pickup: LocationPoint(
      title: 'Baner',
      detail: 'Current location, Baner Road Pune',
    ),
    destination: LocationPoint(
      title: 'Koregaon Park',
      detail: 'Koregaon Park, Pune',
    ),
    rideOptions: [
      RideOption(
        id: 'auto',
        name: 'Auto',
        detail: '2 min away - 3 seats',
        fare: 49,
      ),
      RideOption(
        id: 'bike',
        name: 'Moto Bike',
        detail: '1 min away - 1 seat',
        fare: 35,
      ),
      RideOption(
        id: 'cab',
        name: 'Cab',
        detail: '4 min away - 4 seats',
        fare: 76,
      ),
    ],
    drivers: [
      Driver(
        id: 'drv_auto_amit',
        name: 'Amit Sharma',
        vehicle: 'Auto rickshaw - MH 12 AB 2049',
        eta: '2 min',
        rating: 4.8,
        completedRides: 126,
      ),
      Driver(
        id: 'drv_cab_priya',
        name: 'Priya K',
        vehicle: 'Cab - MH 12 PK 9182',
        eta: '4 min',
        rating: 4.9,
        completedRides: 212,
      ),
      Driver(
        id: 'drv_bike_rahul',
        name: 'Rahul M',
        vehicle: 'Moto bike - MH 12 RM 3721',
        eta: '1 min',
        rating: 4.7,
        completedRides: 94,
      ),
    ],
    paymentMethods: [
      PaymentMethod(id: 'upi', label: 'UPI apps', detail: 'Available'),
      PaymentMethod(
        id: 'card',
        label: 'Cards',
        detail: 'Visa, Mastercard, RuPay',
      ),
      PaymentMethod(
        id: 'wallet',
        label: 'Wallet balance',
        detail: 'Rs 220 available',
      ),
      PaymentMethod(id: 'cash', label: 'Cash', detail: 'Pay after ride'),
    ],
    shareLink: 'https://spotter.app/trip/SPT2049',
  );

  @override
  Future<RideBootstrapData> loadBootstrapData() async {
    return seedData;
  }

  @override
  Future<void> cancelRide({required String reason}) async {}

  @override
  Future<void> submitRating({required int rating, required int tip}) async {}
}
