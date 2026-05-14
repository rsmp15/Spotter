import 'package:flutter/material.dart';

import '../models/ride_models.dart';
import '../repositories/ride_repository.dart';

enum RideLoadState { idle, loading, ready, failure }

class RideController extends ChangeNotifier {
  final RideRepository _repository;

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

  bool _disposed = false;

  RideController({RideRepository? repository})
    : _repository = repository ?? const MockRideRepository() {
    _selectSafeDefaults();
  }

  bool get isLoading => loadState == RideLoadState.loading;

  bool get hasLoadFailed => loadState == RideLoadState.failure;

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
      notifyListeners();
    } catch (_) {
      if (_disposed) return;

      loadState = RideLoadState.failure;
      loadErrorMessage = 'Unable to refresh ride data. Please try again.';
      notifyListeners();
    }
  }

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

  Future<void> cancelRide(String reason) async {
    cancellationReason = reason;
    status = TripStatus.cancelled;
    notifyListeners();
    await _repository.cancelRide(reason: reason);
  }

  Future<void> submitRating({required int rating, required int tip}) async {
    driverRating = rating;
    tipAmount = tip;
    notifyListeners();
    await _repository.submitRating(rating: rating, tip: tip);
  }

  void _applyBootstrapData(RideBootstrapData data) {
    pickup = data.pickup;
    destination = data.destination;
    rideOptions = List.unmodifiable(data.rideOptions);
    drivers = List.unmodifiable(data.drivers);
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

    final vehicleNeedle = option.id == 'bike' ? 'bike' : option.id;
    return drivers.firstWhere(
      (driver) => driver.vehicle.toLowerCase().contains(vehicleNeedle),
      orElse: () => drivers.first,
    );
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
