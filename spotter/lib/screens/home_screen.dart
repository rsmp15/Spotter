import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../models/spott_models.dart';
import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';
import '../core/theme/shadows.dart';
import '../core/components/spott_avatar.dart';
import '../core/components/marketplace_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);

    // Redirect Travelers to driverHome
    if (ride.currentUserRole == UserRole.traveler) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.driverHome);
      });
      return const Scaffold(
        backgroundColor: SpottColors.background,
        body: Center(
          child: CircularProgressIndicator(color: SpottColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: SpottColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(
            left: SpottSpacing.lg,
            right: SpottSpacing.lg,
            top: SpottSpacing.lg,
            bottom: SpottSpacing.pageBottom,
          ),
          children: [
            _buildHeader(),
            const SizedBox(height: SpottSpacing.sm),
            _buildSocialProof(),
            const SizedBox(height: SpottSpacing.lg),
            _buildServiceGrid(context),
            const SizedBox(height: SpottSpacing.lg),
            _buildSearchCard(),
            const SizedBox(height: SpottSpacing.xl),
            _buildFeaturedTrips(),
            const SizedBox(height: SpottSpacing.xl),
            _buildPopularRoutes(),
            const SizedBox(height: SpottSpacing.xl),
            _buildBecomeTravelerBanner(context),
            const SizedBox(height: SpottSpacing.xl),
            _buildRecommendedTravelers(),
            const SizedBox(height: SpottSpacing.xl),
            _buildParcelDeliveryBanner(context),
            const SizedBox(height: SpottSpacing.xl),
            _buildSafetyCenter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '👋 Good Morning, Ritesh',
              style: SpottTextStyles.body.copyWith(
                color: SpottColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SpottSpacing.xs),
            const Text(
              'Where to headed today?',
              style: SpottTextStyles.displayLarge,
            ),
          ],
        ),
        const SpottAvatar(
          imageUrl:
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
          radius: 24,
          isVerified: true,
          isOnline: true,
          isPremium: true,
        ),
      ],
    );
  }

  Widget _buildSocialProof() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: SpottColors.primarySoft,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: SpottColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '2,184 trips available today',
                style: SpottTextStyles.caption.copyWith(
                  color: SpottColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _ServiceCard(
                title: 'Find Ride',
                subtitle: 'Join travelers',
                icon: Icons.directions_car_rounded,
                iconColor: SpottColors.primary,
                onTap: () {
                  // Keep user on passenger home
                },
              ),
            ),
            const SizedBox(width: SpottSpacing.md),
            Expanded(
              child: _ServiceCard(
                title: 'Send Parcel',
                subtitle: 'Fast delivery',
                icon: Icons.inventory_2_outlined,
                iconColor: SpottColors.accentPurple,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.parcelBooking);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: SpottSpacing.md),
        Row(
          children: [
            Expanded(
              child: _ServiceCard(
                title: 'Offer Trip',
                subtitle: 'Earn from seats',
                icon: Icons.add_road_rounded,
                iconColor: SpottColors.success,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.createTrip);
                },
              ),
            ),
            const SizedBox(width: SpottSpacing.md),
            Expanded(
              child: _ServiceCard(
                title: 'Activity',
                subtitle: 'Track updates',
                icon: Icons.explore_outlined,
                iconColor: SpottColors.warning,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.activity);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchCard() {
    return _PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              // Vertical route connecting dots graphic
              Column(
                children: [
                  const Icon(
                    Icons.radio_button_unchecked,
                    color: SpottColors.textSecondary,
                    size: 18,
                  ),
                  Container(width: 2, height: 36, color: SpottColors.border),
                  const Icon(
                    Icons.location_on,
                    color: SpottColors.primary,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(width: SpottSpacing.md),
              Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: _originController,
                      decoration: const InputDecoration(
                        hintText: 'Current Location',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                      ),
                      style: SpottTextStyles.bodyLarge,
                    ),
                    const Divider(height: 12, color: SpottColors.divider),
                    TextField(
                      controller: _destinationController,
                      decoration: const InputDecoration(
                        hintText: 'Destination',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                      ),
                      style: SpottTextStyles.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: SpottSpacing.sm),
              // Swap Button
              Container(
                decoration: BoxDecoration(
                  color: SpottColors.surface2,
                  shape: BoxShape.circle,
                  border: Border.all(color: SpottColors.border),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.swap_vert_rounded,
                    color: SpottColors.primary,
                  ),
                  onPressed: _swapLocations,
                ),
              ),
            ],
          ),
          const Divider(height: SpottSpacing.xl, color: SpottColors.divider),
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: SpottColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: SpottSpacing.md),
              Expanded(child: Text('Today', style: SpottTextStyles.bodyLarge)),
              const Icon(
                Icons.person_outline,
                color: SpottColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: SpottSpacing.sm),
              Text('1 Passenger', style: SpottTextStyles.bodyLarge),
            ],
          ),
          const SizedBox(height: SpottSpacing.lg),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: SpottColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: SpottSpacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Search Trips',
              style: SpottTextStyles.titleSmall,
            ),
          ),
        ],
      ),
    );
  }

  void _swapLocations() {
    setState(() {
      final temp = _originController.text;
      _originController.text = _destinationController.text;
      _destinationController.text = temp;
    });
  }

  Widget _buildFeaturedTrips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Featured Trips', style: SpottTextStyles.headline),
            Text(
              'See All',
              style: SpottTextStyles.caption.copyWith(
                color: SpottColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: SpottSpacing.md),
        SizedBox(
          height: 190,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              _buildFeaturedTripCard(
                route: 'Pune → Mumbai',
                time: 'Leaving in 18 mins',
                seats: '9/12 Seats Filled',
                seatsValue: 9 / 12,
                views: '23 users viewing',
                price: '₹450',
                isHighDemand: true,
              ),
              const SizedBox(width: SpottSpacing.md),
              _buildFeaturedTripCard(
                route: 'Mumbai → Nashik',
                time: 'Leaving in 45 mins',
                seats: '3/4 Seats Filled',
                seatsValue: 3 / 4,
                views: '12 users viewing',
                price: '₹350',
                isHighDemand: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedTripCard({
    required String route,
    required String time,
    required String seats,
    required double seatsValue,
    required String views,
    required String price,
    required bool isHighDemand,
  }) {
    return SizedBox(
      width: 280,
      child: _PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  route,
                  style: SpottTextStyles.title.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  price,
                  style: SpottTextStyles.title.copyWith(
                    color: SpottColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SpottSpacing.xs),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: SpottColors.warningSoft,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    time,
                    style: SpottTextStyles.caption.copyWith(
                      color: SpottColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (isHighDemand) ...[
                  const SizedBox(width: SpottSpacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: SpottColors.primarySoft,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '🔥 High Demand',
                      style: SpottTextStyles.caption.copyWith(
                        color: SpottColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  seats,
                  style: SpottTextStyles.label.copyWith(fontSize: 11),
                ),
                Text(
                  views,
                  style: SpottTextStyles.caption.copyWith(fontSize: 10),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: seatsValue,
                backgroundColor: SpottColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  SpottColors.accentPurple,
                ),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularRoutes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Popular Routes', style: SpottTextStyles.headline),
        const SizedBox(height: SpottSpacing.md),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              _buildRouteCard(
                route: 'Pune → Bangalore',
                departures: '42 travelers this week',
                savings: 'Save ₹800 vs Bus',
                price: '₹1200',
              ),
              const SizedBox(width: SpottSpacing.md),
              _buildRouteCard(
                route: 'Mumbai → Nashik',
                departures: '18 travelers this week',
                savings: 'Save ₹300 vs Bus',
                price: '₹600',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRouteCard({
    required String route,
    required String departures,
    required String savings,
    required String price,
  }) {
    return SizedBox(
      width: 240,
      child: _PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    route,
                    style: SpottTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: SpottColors.successSoft,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    savings,
                    style: SpottTextStyles.caption.copyWith(
                      color: SpottColors.success,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: SpottSpacing.xs),
            Text(departures, style: SpottTextStyles.caption),
            const Spacer(),
            // Minimal visual route line graphic
            Row(
              children: [
                const Icon(
                  Icons.circle_outlined,
                  size: 8,
                  color: SpottColors.textTertiary,
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: SpottColors.border,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 10,
                  color: SpottColors.textTertiary,
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: SpottColors.border,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                ),
                const Icon(
                  Icons.location_on,
                  size: 10,
                  color: SpottColors.primary,
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(Icons.star, color: SpottColors.warning, size: 14),
                const SizedBox(width: 4),
                const Text('4.9', style: SpottTextStyles.label),
                const Spacer(),
                Text(
                  'From $price',
                  style: SpottTextStyles.label.copyWith(
                    color: SpottColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBecomeTravelerBanner(BuildContext context) {
    return MarketplaceCard(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.createTrip);
      },
      borderRadius: 24,
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(SpottSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [SpottColors.primary, SpottColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Earn from Empty Seats',
                    style: SpottTextStyles.titleSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: SpottSpacing.xs),
                  Text(
                    'Offer your trip, recover fuel costs & meet co-travelers.',
                    style: SpottTextStyles.caption.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: SpottSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Offer Trip',
                style: SpottTextStyles.label.copyWith(
                  color: SpottColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedTravelers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recommended Travelers', style: SpottTextStyles.headline),
        const SizedBox(height: SpottSpacing.md),
        _PremiumCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpottAvatar(
                imageUrl:
                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=150',
                radius: 32,
                isVerified: true,
                isOnline: true,
              ),
              const SizedBox(width: SpottSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Arjun Sharma',
                          style: SpottTextStyles.title.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '₹450',
                          style: SpottTextStyles.title.copyWith(
                            color: SpottColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: SpottSpacing.xs),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: SpottColors.warning,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        const Text('4.9', style: SpottTextStyles.label),
                        const SizedBox(width: SpottSpacing.sm),
                        const Text('•', style: SpottTextStyles.caption),
                        const SizedBox(width: SpottSpacing.sm),
                        const Text('542 Trips', style: SpottTextStyles.caption),
                      ],
                    ),
                    const SizedBox(height: SpottSpacing.sm),
                    Row(
                      children: [
                        Text(
                          'Hyundai i20',
                          style: SpottTextStyles.body.copyWith(
                            color: SpottColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: SpottSpacing.sm),
                        const Text('•', style: SpottTextStyles.caption),
                        const SizedBox(width: SpottSpacing.sm),
                        Text(
                          '98% response rate',
                          style: SpottTextStyles.caption.copyWith(
                            color: SpottColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: SpottSpacing.sm),
                    Row(
                      children: [
                        _buildTrustBadge(
                          'Govt ID',
                          Icons.verified_user_rounded,
                        ),
                        const SizedBox(width: SpottSpacing.sm),
                        _buildTrustBadge(
                          'Vehicle',
                          Icons.directions_car_rounded,
                        ),
                      ],
                    ),
                    const SizedBox(height: SpottSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: SpottColors.primary,
                          side: const BorderSide(color: SpottColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: SpottSpacing.sm,
                          ),
                        ),
                        child: const Text(
                          'Book Seat',
                          style: SpottTextStyles.label,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrustBadge(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: SpottColors.trustVerified, size: 14),
        const SizedBox(width: 4),
        Text(
          label,
          style: SpottTextStyles.caption.copyWith(
            color: SpottColors.trustVerified,
          ),
        ),
      ],
    );
  }

  Widget _buildParcelDeliveryBanner(BuildContext context) {
    return MarketplaceCard(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.parcelBooking);
      },
      borderRadius: 24,
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(SpottSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(SpottSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inventory_2_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: SpottSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Send Parcels with Travelers',
                    style: SpottTextStyles.titleSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: SpottSpacing.xs),
                  Text(
                    'Reliable, peer-to-peer delivery starting at just ₹99.',
                    style: SpottTextStyles.caption.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: SpottSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Book',
                style: SpottTextStyles.label.copyWith(
                  color: const Color(0xFF2563EB),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyCenter() {
    return _PremiumCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: SpottColors.successSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: SpottColors.success,
              size: 22,
            ),
          ),
          const SizedBox(width: SpottSpacing.md),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Safety Center',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: SpottColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Live tracking, SOS, and verified travelers.',
                  style: TextStyle(
                    fontSize: 12,
                    color: SpottColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumCard extends StatelessWidget {
  final Widget child;

  const _PremiumCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SpottSpacing.cardInner),
      decoration: BoxDecoration(
        color: SpottColors.surface1,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: SpottColors.border),
        boxShadow: SpottShadows.elevation1,
      ),
      child: child,
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MarketplaceCard(
      onTap: onTap,
      borderRadius: 24,
      padding: const EdgeInsets.all(SpottSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: SpottSpacing.md),
          Text(
            title,
            style: SpottTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: SpottTextStyles.caption.copyWith(
              color: SpottColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
