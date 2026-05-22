import 'package:spotter/repositories/ride_repository.dart';

class FakeRideRepository implements RideRepository {
  final RideBootstrapData bootstrapData;
  final bool failLoad;
  final bool failCancel;
  final bool failRating;

  const FakeRideRepository({
    this.bootstrapData = MockRideRepository.seedData,
    this.failLoad = false,
    this.failCancel = false,
    this.failRating = false,
  });

  @override
  Future<RideBootstrapData> loadBootstrapData() async {
    if (failLoad) throw StateError('refresh failed');
    return bootstrapData;
  }

  @override
  Future<void> cancelRide({required String reason}) async {
    if (failCancel) throw StateError('cancel failed');
  }

  @override
  Future<void> submitRating({required int rating, required int tip}) async {
    if (failRating) throw StateError('rating failed');
  }
}
