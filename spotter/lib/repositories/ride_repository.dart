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

  // Seed data: intercity cost-sharing trips with demo Traveler profiles.
  static const RideBootstrapData seedData = RideBootstrapData(
    pickup: LocationPoint(
      title: 'Pune',
      detail: 'Hinjawadi, Pune, Maharashtra',
    ),
    destination: LocationPoint(
      title: 'Mumbai',
      detail: 'Andheri East, Mumbai, Maharashtra',
    ),
    rideOptions: [
      // Pune → Mumbai
      RideOption(
        id: 'carpool_sedan',
        name: 'Carpool Sedan',
        detail: '3h trip • 3 seats • Cost share',
        fare: 450,
      ),
      // Pune → Bangalore
      RideOption(
        id: 'carpool_suv',
        name: 'Carpool SUV',
        detail: '8h trip • 5 seats • Cost share',
        fare: 1200,
      ),
      // Pune → Nashik
      RideOption(
        id: 'pool',
        name: 'Spott Pool',
        detail: '3h trip • Share private car',
        fare: 350,
      ),
      // Mumbai → Goa
      RideOption(
        id: 'bike_pool',
        name: 'Moto Pool',
        detail: '7h trip • Share private bike',
        fare: 800,
      ),
      // Pune → Lonavala
      RideOption(
        id: 'bike',
        name: 'Bike Pool',
        detail: '1.5h trip • 1 seat',
        fare: 200,
      ),
    ],
    // Traveler profiles (cost-sharing hosts)
    drivers: [
      Driver(
        id: 'tvl_sedan_01',
        name: 'Amit Sharma',
        vehicle: 'Hyundai Verna Sedan - MH 12 TV 4501',
        eta: 'Departs 6:00 AM',
        rating: 4.8,
        completedRides: 126,
      ),
      Driver(
        id: 'tvl_suv_02',
        name: 'Demo Traveler B',
        vehicle: 'Toyota Innova SUV - MH 14 TV 1202',
        eta: 'Departs 5:30 AM',
        rating: 4.9,
        completedRides: 212,
      ),
      Driver(
        id: 'tvl_bike_03',
        name: 'Demo Traveler C',
        vehicle: 'Royal Enfield Bike - MH 12 TV 3503',
        eta: 'Departs 7:00 AM',
        rating: 4.7,
        completedRides: 94,
      ),
      Driver(
        id: 'tvl_pool_04',
        name: 'Demo Traveler D',
        vehicle: 'Maruti Swift - MH 04 TV 3504',
        eta: 'Departs 8:00 AM',
        rating: 4.8,
        completedRides: 154,
      ),
      Driver(
        id: 'tvl_pool_05',
        name: 'Demo Traveler E',
        vehicle: 'Honda City Sedan - MH 12 TV 2005',
        eta: 'Departs 9:00 AM',
        rating: 4.9,
        completedRides: 318,
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
      PaymentMethod(id: 'cash', label: 'Cash', detail: 'Pay after trip'),
    ],
    shareLink: 'https://spott.app/trip/SPT2049',
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

