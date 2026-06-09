class AppAssets {
  static const String car = 'Car.png';
  static const String carClock = 'Car_Clock.png';
  static const String parcel = 'Parcel.png';
  static const String bike = 'Bike.png';
  static const String bikeClock = 'Bike_Clock.png';
  static const String calendar = 'Calendar.png';
  static const String rikshaw = 'Rikshaw.png';
  static const String rikshawClock = 'Rikshaw_Clock.png';
  static const String route = 'route.png';
  static const String safety = 'safety.png';
  static const String verification = 'verification.png';
  static const String support = 'Support.png';

  static String forRideId(String id) {
    switch (id.toLowerCase()) {
      case 'moto':
      case 'bike':
        return bike;
      case 'auto':
      case 'rickshaw':
      case 'rikshaw':
        return rikshaw;
      default:
        return car;
    }
  }

  static String forVehicleText(String value) {
    final text = value.toLowerCase();
    if (text.contains('bike') || text.contains('moto')) {
      return bike;
    }
    if (text.contains('auto') ||
        text.contains('rickshaw') ||
        text.contains('rikshaw')) {
      return rikshaw;
    }
    return car;
  }
}
