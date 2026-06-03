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

enum ParcelCategory {
  documents,
  collegeItems,
  laundry,
  boxPackage,
}

enum ParcelSizeClass {
  light,
  medium,
  heavy,
}

class ParcelPackage {
  final String senderName;
  final String senderPhone;
  final String receiverName;
  final String receiverPhone;
  final ParcelCategory category;
  final ParcelSizeClass size;
  final LocationPoint pickup;
  final LocationPoint destination;
  final int fare;

  const ParcelPackage({
    required this.senderName,
    required this.senderPhone,
    required this.receiverName,
    required this.receiverPhone,
    required this.category,
    required this.size,
    required this.pickup,
    required this.destination,
    required this.fare,
  });

  String get fareLabel => 'Rs $fare';
}

