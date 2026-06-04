import 'dart:math';

import 'package:flutter/material.dart';

import '../models/production_readiness_models.dart' hide UserRole;
import '../models/ride_models.dart';
import '../models/spott_models.dart' hide TripStatus;
import '../models/spott_models.dart' as spott;
import '../repositories/ride_repository.dart';

enum RideLoadState { idle, loading, ready, failure }

class RideController extends ChangeNotifier {
  final RideRepository _repository;

  UserRole currentUserRole = UserRole.passenger;

  void updateUserRole(UserRole role) {
    currentUserRole = role;
    notifyListeners();
  }

  LocationPoint pickup = MockRideRepository.seedData.pickup;
  LocationPoint destination = MockRideRepository.seedData.destination;

  List<RideOption> rideOptions = MockRideRepository.seedData.rideOptions;
  List<Driver> drivers = MockRideRepository.seedData.drivers;
  List<PaymentMethod> paymentMethods =
      MockRideRepository.seedData.paymentMethods;

  RideOption? selectedRideOption;
  Driver? selectedDriver;
  PaymentMethod? selectedPaymentMethod;
  RideLoadState loadState = RideLoadState.idle;
  TripStatus status = TripStatus.draft;
  int driverRating = 5;
  int tipAmount = 0;
  String cancellationReason = '';
  String? loadErrorMessage;
  String shareLink = MockRideRepository.seedData.shareLink;
  RecoverableActionState actionState = RecoverableActionState.idle;
  bool isDarkMode = true;
  int activeTabIndex = 0;

  // Parcel delivery states
  ParcelPackage? activeParcel;
  TripStatus parcelStatus = TripStatus.draft;
  Driver? assignedParcelDriver;
  String parcelVerificationPin = _generatePin();

  // Active trips search result
  List<Trip> activeTrips = [];

  // Vehicle Management State
  List<Vehicle> vehicles = [];
  String? selectedVehicleId;

  // Traveler Trips Management State
  List<Trip> travelerTrips = [];

  // Mock passenger DB for requests mapping
  static const Map<String, Map<String, dynamic>> mockPassengerDb = {
    'usr_psg_01': {'name': 'Sneha Patil', 'rating': 4.7, 'seats': 2},
    'usr_psg_02': {'name': 'Vikram Joshi', 'rating': 4.5, 'seats': 1},
    'usr_psg_03': {'name': 'Meera Rao', 'rating': 4.9, 'seats': 1},
  };

  // Traveler flow: incoming seat-requests from passengers
  List<TripRequest> tripRequests = [];
  bool isParcelBookingActive = false;

  void createParcelBooking({
    required String senderName,
    required String senderPhone,
    required String receiverName,
    required String receiverPhone,
    required ParcelCategory category,
    required ParcelSizeClass size,
    required LocationPoint pickup,
    required LocationPoint destination,
    required int fare,
    required Driver driver,
  }) {
    activeParcel = ParcelPackage(
      senderName: senderName,
      senderPhone: senderPhone,
      receiverName: receiverName,
      receiverPhone: receiverPhone,
      category: category,
      size: size,
      pickup: pickup,
      destination: destination,
      fare: fare,
    );
    assignedParcelDriver = driver;
    parcelStatus = TripStatus.searching;
    isParcelBookingActive = true;
    notifyListeners();
  }

  void updateParcelStatus(TripStatus newStatus) {
    parcelStatus = newStatus;
    notifyListeners();
  }

  void clearParcelBooking() {
    activeParcel = null;
    assignedParcelDriver = null;
    parcelStatus = TripStatus.draft;
    isParcelBookingActive = false;
    parcelVerificationPin = _generatePin();
    notifyListeners();
  }

  /// Accept a pending trip request (Traveler flow).
  void acceptRequest(String id) {
    tripRequests = tripRequests.map((req) {
      if (req.id == id && req.status == TripRequestStatus.pending) {
        return req.copyWith(status: TripRequestStatus.accepted);
      }
      return req;
    }).toList();
    notifyListeners();
  }

  /// Reject a pending trip request (Traveler flow).
  void rejectRequest(String id) {
    tripRequests = tripRequests.map((req) {
      if (req.id == id && req.status == TripRequestStatus.pending) {
        return req.copyWith(status: TripRequestStatus.rejected);
      }
      return req;
    }).toList();
    notifyListeners();
  }

  void toggleDarkMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  void switchTab(int tabIndex) {
    activeTabIndex = tabIndex;
    notifyListeners();
  }

  bool _disposed = false;

  RideController({RideRepository? repository})
    : _repository = repository ?? const MockRideRepository() {
    _selectSafeDefaults();

    // Seed default vehicles
    vehicles = [
      const Vehicle(
        id: 'veh_01',
        userId: 'current_user',
        vehicleType: 'Car',
        vehicleNumber: 'MH-12-PQ-9876',
        vehicleModel: 'Honda City',
        verificationStatus: VerificationStatus.verified,
      ),
      const Vehicle(
        id: 'veh_02',
        userId: 'current_user',
        vehicleType: 'Bike',
        vehicleNumber: 'MH-12-RS-5432',
        vehicleModel: 'Honda Activa 6G',
        verificationStatus: VerificationStatus.verified,
      ),
      const Vehicle(
        id: 'veh_03',
        userId: 'current_user',
        vehicleType: 'Car',
        vehicleNumber: 'MH-12-XY-0001',
        vehicleModel: 'Maruti Swift',
        verificationStatus: VerificationStatus.pending,
      ),
    ];
    selectedVehicleId = 'veh_02';

    // Seed drivers including current user
    drivers = [
      ...MockRideRepository.seedData.drivers,
      const Driver(
        id: 'current_user',
        name: 'Ritesh Mahatme (You)',
        vehicle: 'Honda Activa 6G - MH 12 RS 5432',
        eta: 'Departs 10:00 PM',
        rating: 5.0,
        completedRides: 147,
      ),
    ];

    // Seed traveler trips
    travelerTrips = [
      Trip(
        id: 'trip_traveler_01',
        travelerId: 'current_user',
        source: 'Pune',
        destination: 'Kolhapur',
        departureTime: DateTime.now().add(const Duration(hours: 5)),
        availableSeats: 2,
        pricePerSeat: 450,
        parcelAllowed: true,
        status: spott.TripStatus.active,
      ),
    ];

    // Seed active trips for search
    activeTrips = [
      Trip(
        id: 'trip_01',
        travelerId: 'tvl_sedan_01', // Demo Traveler A
        source: 'Pune',
        destination: 'Mumbai',
        departureTime: DateTime.now().add(const Duration(hours: 2)),
        availableSeats: 3,
        pricePerSeat: 350,
        parcelAllowed: true,
        status: spott.TripStatus.active,
      ),
      Trip(
        id: 'trip_02',
        travelerId: 'tvl_suv_02', // Demo Traveler B
        source: 'Pune',
        destination: 'Mumbai',
        departureTime: DateTime.now().add(const Duration(hours: 3)),
        availableSeats: 5,
        pricePerSeat: 1200,
        parcelAllowed: false,
        status: spott.TripStatus.active,
      ),
      Trip(
        id: 'trip_03',
        travelerId: 'tvl_bike_03', // Demo Traveler C
        source: 'Pune',
        destination: 'Mumbai',
        departureTime: DateTime.now().add(const Duration(hours: 1)),
        availableSeats: 1,
        pricePerSeat: 800,
        parcelAllowed: true,
        status: spott.TripStatus.active,
      ),
      ...travelerTrips,
    ];

    // Seed incoming requests for Traveler flow
    tripRequests = [
      const TripRequest(
        id: 'req_01',
        tripId: 'trip_pune_mumbai',
        passengerId: 'usr_psg_01',
      ),
      const TripRequest(
        id: 'req_02',
        tripId: 'trip_pune_mumbai',
        passengerId: 'usr_psg_02',
      ),
      const TripRequest(
        id: 'req_03',
        tripId: 'trip_pune_mumbai',
        passengerId: 'usr_psg_03',
      ),
    ];
  }

  bool get isLoading => loadState == RideLoadState.loading;

  bool get hasLoadFailed => loadState == RideLoadState.failure;

  bool get hasActionFailed => actionState.isFailure;

  String get routeLabel => '${pickup.title} -> ${destination.title}';

  String get rideSummary {
    final ride = selectedRideOption;
    if (ride == null) return routeLabel;
    return '${ride.name} to ${destination.title}';
  }

  String get fareLabel => selectedRideOption?.fareLabel ?? 'Rs 0';

  Future<void> initialize() async {
    if (loadState == RideLoadState.loading) return;

    loadState = RideLoadState.loading;
    loadErrorMessage = null;
    notifyListeners();

    try {
      final data = await _repository.loadBootstrapData();
      if (_disposed) return;

      _applyBootstrapData(data);
      loadState = RideLoadState.ready;
      actionState = const RecoverableActionState(
        action: RecoverableAction.refreshRideData,
        status: RecoverableActionStatus.success,
      );
      notifyListeners();
    } catch (_) {
      if (_disposed) return;

      loadState = RideLoadState.failure;
      loadErrorMessage = 'Unable to refresh ride data. Please try again.';
      actionState = const RecoverableActionState(
        action: RecoverableAction.refreshRideData,
        status: RecoverableActionStatus.failure,
        message:
            'Unable to refresh ride data. Continue with safe defaults or retry.',
        primaryRecovery: RecoveryAction.retry,
        canRetry: true,
      );
      notifyListeners();
    }
  }

  Future<void> retryInitialize() => initialize();

  void updatePickup(LocationPoint value) {
    pickup = value;
    notifyListeners();
  }

  void updateDestination(LocationPoint value) {
    destination = value;
    notifyListeners();
  }

  void selectRideOption(RideOption value) {
    selectedRideOption = value;
    selectedDriver = _bestDriverFor(value) ?? selectedDriver;
    status = TripStatus.searching;
    notifyListeners();
  }

  void selectDriver(Driver value) {
    selectedDriver = value;
    status = TripStatus.driverAssigned;
    notifyListeners();
  }

  void selectPaymentMethod(PaymentMethod value) {
    selectedPaymentMethod = value;
    notifyListeners();
  }

  void markArriving() {
    status = TripStatus.arriving;
    notifyListeners();
  }

  void markInProgress() {
    status = TripStatus.inProgress;
    notifyListeners();
  }

  void markCompleted() {
    status = TripStatus.completed;
    notifyListeners();
  }

  Future<bool> cancelRide(String reason) async {
    cancellationReason = reason;
    actionState = const RecoverableActionState(
      action: RecoverableAction.cancelRide,
      status: RecoverableActionStatus.loading,
    );
    notifyListeners();
    try {
      await _repository.cancelRide(reason: reason);
      status = TripStatus.cancelled;
      actionState = const RecoverableActionState(
        action: RecoverableAction.cancelRide,
        status: RecoverableActionStatus.success,
      );
      notifyListeners();
      return true;
    } catch (_) {
      actionState = const RecoverableActionState(
        action: RecoverableAction.cancelRide,
        status: RecoverableActionStatus.failure,
        message:
            'We could not cancel this ride yet. Your trip details are still available.',
        primaryRecovery: RecoveryAction.retry,
        canRetry: true,
      );
      notifyListeners();
      return false;
    }
  }

  Future<bool> submitRating({required int rating, required int tip}) async {
    driverRating = rating;
    tipAmount = tip;
    actionState = const RecoverableActionState(
      action: RecoverableAction.submitRating,
      status: RecoverableActionStatus.loading,
    );
    notifyListeners();
    try {
      await _repository.submitRating(rating: rating, tip: tip);
      actionState = const RecoverableActionState(
        action: RecoverableAction.submitRating,
        status: RecoverableActionStatus.success,
      );
      notifyListeners();
      return true;
    } catch (_) {
      actionState = const RecoverableActionState(
        action: RecoverableAction.submitRating,
        status: RecoverableActionStatus.failure,
        message:
            'We could not submit your rating. Your ride context is still saved.',
        primaryRecovery: RecoveryAction.retry,
        canRetry: true,
      );
      notifyListeners();
      return false;
    }
  }

  void clearActionState() {
    actionState = RecoverableActionState.idle;
    notifyListeners();
  }

  void _applyBootstrapData(RideBootstrapData data) {
    pickup = data.pickup;
    destination = data.destination;
    rideOptions = List.unmodifiable(data.rideOptions);
    drivers = List.unmodifiable([
      ...data.drivers,
      const Driver(
        id: 'current_user',
        name: 'Ritesh Mahatme (You)',
        vehicle: 'Honda Activa 6G - MH 12 RS 5432',
        eta: 'Departs 10:00 PM',
        rating: 5.0,
        completedRides: 147,
      ),
    ]);
    paymentMethods = List.unmodifiable(data.paymentMethods);
    shareLink = data.shareLink;
    _selectSafeDefaults();
  }

  void _selectSafeDefaults() {
    selectedRideOption = _validRideOptionOrFirst(selectedRideOption);
    selectedDriver = _validDriverOrFirst(selectedDriver);
    selectedPaymentMethod = _validPaymentMethodOrFirst(selectedPaymentMethod);
  }

  RideOption? _validRideOptionOrFirst(RideOption? selected) {
    if (selected != null &&
        rideOptions.any((option) => option.id == selected.id)) {
      return selected;
    }

    return rideOptions.isEmpty ? null : rideOptions.first;
  }

  Driver? _validDriverOrFirst(Driver? selected) {
    if (selected != null && drivers.any((driver) => driver.id == selected.id)) {
      return selected;
    }

    return drivers.isEmpty ? null : drivers.first;
  }

  PaymentMethod? _validPaymentMethodOrFirst(PaymentMethod? selected) {
    if (selected != null &&
        paymentMethods.any((method) => method.id == selected.id)) {
      return selected;
    }

    return paymentMethods.isEmpty ? null : paymentMethods.first;
  }

  Driver? _bestDriverFor(RideOption option) {
    if (drivers.isEmpty) return null;

    final id = option.id.toLowerCase();
    if (id.contains('bike') || id.contains('moto')) {
      return drivers.firstWhere(
        (driver) =>
            driver.vehicle.toLowerCase().contains('bike') ||
            driver.vehicle.toLowerCase().contains('moto'),
        orElse: () => drivers.first,
      );
    }
    if (id.contains('pool') || id.contains('suv')) {
      return drivers.firstWhere(
        (driver) =>
            driver.vehicle.toLowerCase().contains('suv') ||
            !driver.vehicle.toLowerCase().contains('bike'),
        orElse: () => drivers.first,
      );
    }
    return drivers.firstWhere(
      (driver) => driver.vehicle.toLowerCase().contains(id),
      orElse: () => drivers.first,
    );
  }

  /// Generate a random 4-digit PIN for parcel verification.
  static String _generatePin() {
    return (Random().nextInt(9000) + 1000).toString();
  }

  Future<void> confirmRide() async {
    status = TripStatus.driverAssigned;
    notifyListeners();
  }

  // --- Vehicle CRUD ---
  void addVehicle(Vehicle vehicle) {
    vehicles = [...vehicles, vehicle];
    selectedVehicleId ??= vehicle.id;
    notifyListeners();
  }

  void updateVehicle(Vehicle vehicle) {
    vehicles = vehicles.map((v) => v.id == vehicle.id ? vehicle : v).toList();
    notifyListeners();
  }

  void deleteVehicle(String id) {
    vehicles = vehicles.where((v) => v.id != id).toList();
    if (selectedVehicleId == id) {
      selectedVehicleId = vehicles.isNotEmpty ? vehicles.first.id : null;
    }
    notifyListeners();
  }

  void setSelectedVehicle(String id) {
    selectedVehicleId = id;
    notifyListeners();
  }

  // --- Trip CRUD ---
  void addTrip(Trip trip) {
    travelerTrips = [...travelerTrips, trip];
    activeTrips = [...activeTrips, trip];
    notifyListeners();
  }

  void updateTrip(Trip trip) {
    travelerTrips = travelerTrips
        .map((t) => t.id == trip.id ? trip : t)
        .toList();
    activeTrips = activeTrips.map((t) => t.id == trip.id ? trip : t).toList();
    notifyListeners();
  }

  void deleteTrip(String id) {
    travelerTrips = travelerTrips.where((t) => t.id != id).toList();
    activeTrips = activeTrips.where((t) => t.id != id).toList();
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class RideScope extends InheritedNotifier<RideController> {
  const RideScope({
    super.key,
    required RideController controller,
    required super.child,
  }) : super(notifier: controller);

  static RideController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<RideScope>();
    assert(scope != null, 'RideScope was not found in the widget tree.');
    return scope!.notifier!;
  }
}
