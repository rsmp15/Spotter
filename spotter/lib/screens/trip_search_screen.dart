import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../models/ride_models.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/glass_card.dart';
import '../core/components/route_card.dart';
import '../core/components/spott_buttons.dart';
import '../core/components/skeleton_route_card.dart';
import '../core/theme/colors.dart';
import '../core/theme/radius.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';

class TripSearchScreen extends StatefulWidget {
  const TripSearchScreen({super.key});

  @override
  State<TripSearchScreen> createState() => _TripSearchScreenState();
}

class _HomeScreenSearchField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final TextEditingController controller;

  const _HomeScreenSearchField({
    required this.icon,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SpottColors.surface3,
        borderRadius: BorderRadius.circular(SpottRadius.sm),
      ),
      child: TextField(
        controller: controller,
        cursorColor: SpottColors.primary,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 18, color: SpottColors.textSecondary),
          hintText: hintText,
          hintStyle: SpottTextStyles.body.copyWith(color: SpottColors.textTertiary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        style: SpottTextStyles.body.copyWith(color: SpottColors.textPrimary),
      ),
    );
  }
}

class _TripSearchScreenState extends State<TripSearchScreen> {
  final TextEditingController _sourceController = TextEditingController(text: 'Pune');
  final TextEditingController _destController = TextEditingController(text: 'Mumbai');
  bool _isSearching = false;
  bool _searchDone = false;
  Timer? _searchTimer;

  @override
  void dispose() {
    _sourceController.dispose();
    _destController.dispose();
    _searchTimer?.cancel();
    super.dispose();
  }

  void _triggerSearch() {
    setState(() {
      _isSearching = true;
      _searchDone = false;
    });

    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _searchDone = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);

    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: SpottColors.textPrimary),
        title: const Text('Find a Trip', style: SpottTextStyles.titleSmall),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.pageHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: SpottSpacing.sm),

            // Search Inputs Card
            GlassCard(
              padding: const EdgeInsets.all(SpottSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HomeScreenSearchField(
                    icon: Icons.my_location_rounded,
                    hintText: 'Source city',
                    controller: _sourceController,
                  ),
                  const SizedBox(height: 8),
                  _HomeScreenSearchField(
                    icon: Icons.location_on_rounded,
                    hintText: 'Destination city',
                    controller: _destController,
                  ),
                  const SizedBox(height: SpottSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: SpottButton.primary(
                      label: 'Search Trips',
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _triggerSearch();
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: SpottSpacing.lg),

            // Search results label
            Padding(
              padding: const EdgeInsets.only(bottom: SpottSpacing.md),
              child: Text(
                _isSearching ? 'Scanning marketplace...' : 'Available trips',
                style: SpottTextStyles.headline.copyWith(fontSize: 18),
              ),
            ),

            // Skeletal loading indicators
            if (_isSearching) ...[
              const SkeletonRouteCard(),
              const SizedBox(height: SpottSpacing.md),
              const SkeletonRouteCard(),
            ] else if (!_searchDone && ride.activeTrips.isEmpty) ...[
              // Help prompt before search is run
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(SpottSpacing.md),
                decoration: BoxDecoration(
                  color: SpottColors.surface2,
                  borderRadius: BorderRadius.circular(SpottRadius.md),
                  border: Border.all(color: SpottColors.border),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.search_rounded, size: 36, color: SpottColors.textTertiary),
                    const SizedBox(height: 12),
                    Text(
                      'Enter route above and tap search.',
                      style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ] else if (_searchDone && ride.activeTrips.isEmpty) ...[
              // Actionable empty state instead of "No trips found"
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(SpottSpacing.md),
                decoration: BoxDecoration(
                  color: SpottColors.surface2,
                  borderRadius: BorderRadius.circular(SpottRadius.md),
                  border: Border.all(color: SpottColors.border),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.search_off_rounded, size: 36, color: SpottColors.warning),
                    const SizedBox(height: 12),
                    Text(
                      'No direct travelers found for this route.',
                      style: SpottTextStyles.title.copyWith(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try expanding your search radius, selecting nearby departure times, or post your own trip request.',
                      style: SpottTextStyles.caption.copyWith(color: SpottColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    SpottButton.primary(
                      label: 'Expand Search Radius',
                      size: SpottButtonSize.small,
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _triggerSearch();
                      },
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Real trips matching V2 designs
              ...ride.activeTrips.map((trip) {
                final driver = ride.drivers.firstWhere(
                  (d) => d.id == trip.travelerId,
                  orElse: () => ride.drivers.first,
                );

                // Setup realistic display metadata for V2 mockup
                return RouteCard(
                  origin: trip.source,
                  destination: trip.destination,
                  driverName: driver.name,
                  driverAvatar: 'https://i.pravatar.cc/150?u=${driver.name.hashCode}',
                  rating: driver.rating.toString(),
                  costShare: '₹${trip.pricePerSeat}',
                  seatsAvailable: trip.availableSeats,
                  departureTime: 'Today, ${trip.departureTime.hour}:${trip.departureTime.minute.toString().padLeft(2, "0")}',
                  vehicleType: driver.vehicle.contains('Bike') ? 'Bike' : 'Car',
                  tripCount: driver.completedRides,
                  seatsFilled: 2,
                  totalSeats: trip.availableSeats + 2,
                  viewsToday: 15,
                  verificationLevel: 3,
                  responseRate: 98,
                  safetyScore: 97,
                  memberSince: 2023,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.confirmRide),
                );
              }),
            ],
            const SizedBox(height: SpottSpacing.pageBottom),
          ],
        ),
      ),
    );
  }
}
