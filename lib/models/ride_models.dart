enum TripStatus {
  draft,
  searching,
  driverAssigned,
  arriving,
  inProgress,
  completed,
  cancelled,
}

class LocationPoint {
  final String title;
  final String detail;

  const LocationPoint({required this.title, required this.detail});
}

class RideOption {
  final String id;
  final String name;
  final String detail;
  final int fare;

  const RideOption({
    required this.id,
    required this.name,
    required this.detail,
    required this.fare,
  });

  String get fareLabel => 'Rs $fare';
}

class Driver {
  final String id;
  final String name;
  final String vehicle;
  final String eta;
  final double rating;
  final int completedRides;

  const Driver({
    required this.id,
    required this.name,
    required this.vehicle,
    required this.eta,
    required this.rating,
    required this.completedRides,
  });
}

class PaymentMethod {
  final String id;
  final String label;
  final String detail;

  const PaymentMethod({
    required this.id,
    required this.label,
    required this.detail,
  });
}
