import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../models/spott_models.dart';
import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';
import '../core/theme/shadows.dart';
import '../core/theme/radius.dart';
import '../core/theme/gradients.dart';
import '../core/components/spott_avatar.dart';
import '../core/components/spott_appli_card.dart';
import '../core/components/animated_entrance.dart';
import '../core/components/scene_decorations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _originController = TextEditingController(
    text: 'Pune',
  );
  final TextEditingController _destinationController = TextEditingController(
    text: 'Mumbai',
  );

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
            left: SpottSpacing.pageHorizontal,
            right: SpottSpacing.pageHorizontal,
            top: SpottSpacing.pageTop,
            bottom: SpottSpacing.pageBottom,
          ),
          children: [
            _buildHeroScene(context),
            const SizedBox(height: SpottSpacing.xl),
            _buildBentoGrid(context),
            const SizedBox(height: SpottSpacing.xl),
            _buildTrendingJourneys(context),
            const SizedBox(height: SpottSpacing.xl),
            _buildNearbyTravelers(context),
            const SizedBox(height: SpottSpacing.xl),
            _buildPopularRoutes(),
            const SizedBox(height: SpottSpacing.xl),
            _buildParcelBanner(context),
            const SizedBox(height: SpottSpacing.xl),
            _buildTravelerBanner(context),
            const SizedBox(height: SpottSpacing.xl),
            _buildSafetyCenter(context),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // SCENE 1: Hero Search — The Destination Scene
  // ════════════════════════════════════════════════════════════════════
  Widget _buildHeroScene(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SpottColors.surface1,
        borderRadius: BorderRadius.circular(SpottRadius.hero), // 30
        border: Border.all(color: SpottColors.border, width: 1.0),
        boxShadow: SpottShadows.elevation2,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SpottRadius.hero),
        child: Stack(
          children: [
            // Layer 1: Large blurred red glow (top-right)
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Color(0x26E60023), Colors.transparent],
                  ),
                ),
              ),
            ),
            // Layer 2: Indigo ambient glow (bottom-left)
            Positioned(
              bottom: -30,
              left: -30,
              child: Container(
                width: 160,
                height: 160,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Color(0x1A6366F1), Colors.transparent],
                  ),
                ),
              ),
            ),
            // Layer 3: Route pattern illustration
            Positioned.fill(
              child: CustomPaint(painter: RoutePatternPainter()),
            ),
            // Layer 4: Floating ambient dots
            Positioned.fill(
              child: CustomPaint(painter: FloatingDotsPainter()),
            ),
            // Layer 5: Content
            Padding(
              padding: const EdgeInsets.all(SpottSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Header Row ──────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.verified_user_rounded,
                                color: SpottColors.success,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Arjun Sharma • Trust Score 92',
                                style: SpottTextStyles.caption.copyWith(
                                  color: SpottColors.success,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Where are you\ngoing today?',
                            style: SpottTextStyles.displayLarge,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.profile),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: SpottColors.border,
                              width: 2.0,
                            ),
                          ),
                          child: const SpottAvatar(
                            imageUrl:
                                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
                            radius: 28,
                            isVerified: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SpottSpacing.lg),

                  // ── Route Input ─────────────────────────────────
                  Row(
                    children: [
                      Column(
                        children: [
                          const Icon(
                            Icons.radio_button_unchecked,
                            color: SpottColors.accentPurple,
                            size: 18,
                          ),
                          Container(
                            width: 1.5,
                            height: 40,
                            color: SpottColors.border,
                          ),
                          const Icon(
                            Icons.location_on_rounded,
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
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 6),
                              ),
                              style: SpottTextStyles.titleSmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Divider(
                              height: 16,
                              color: SpottColors.border,
                            ),
                            TextField(
                              controller: _destinationController,
                              decoration: const InputDecoration(
                                hintText: 'Destination',
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 6),
                              ),
                              style: SpottTextStyles.titleSmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: SpottSpacing.sm),
                      Container(
                        decoration: BoxDecoration(
                          color: SpottColors.surface2,
                          shape: BoxShape.circle,
                          border: Border.all(color: SpottColors.border),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.swap_vert_rounded,
                            color: SpottColors.accentPurple,
                          ),
                          onPressed: _swapLocations,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SpottSpacing.md),
                  const Divider(height: 1, color: SpottColors.border),
                  const SizedBox(height: SpottSpacing.md),

                  // ── Date + Passenger ────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                color: SpottColors.textSecondary,
                                size: 16,
                              ),
                              const SizedBox(width: SpottSpacing.sm),
                              Text(
                                'Today',
                                style: SpottTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 20,
                        color: SpottColors.border,
                      ),
                      const SizedBox(width: SpottSpacing.md),
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person_outline_rounded,
                                color: SpottColors.textSecondary,
                                size: 18,
                              ),
                              const SizedBox(width: SpottSpacing.sm),
                              Text(
                                '1 Passenger',
                                style: SpottTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SpottSpacing.md),

                  // ── Search CTA with glow ────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SpottRadius.button),
                      boxShadow: SpottShadows.glowPrimary,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.tripSearch);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SpottColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: SpottSpacing.md,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(SpottRadius.button),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Search Trips',
                        style: SpottTextStyles.label.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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

  // ════════════════════════════════════════════════════════════════════
  // SCENE 2: Bento Action Grid — 4 Unique Personalities
  // ════════════════════════════════════════════════════════════════════
  Widget _buildBentoGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Explore Services', style: SpottTextStyles.headline),
        const SizedBox(height: SpottSpacing.md),
        Row(
          children: [
            Expanded(
              child: AnimatedEntrance(
                delay: 0,
                child: _BentoSceneCard(
                  title: 'Find Ride',
                  stat: '1,240 Active',
                  icon: Icons.directions_car_rounded,
                  decorationIcon: Icons.directions_car_filled_rounded,
                  gradient: SpottGradients.bentoRide,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.tripSearch),
                ),
              ),
            ),
            const SizedBox(width: SpottSpacing.md),
            Expanded(
              child: AnimatedEntrance(
                delay: 1,
                child: _BentoSceneCard(
                  title: 'Send Parcel',
                  stat: '300 Today',
                  icon: Icons.inventory_2_rounded,
                  decorationIcon: Icons.local_shipping_rounded,
                  gradient: SpottGradients.bentoParcel,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.parcelBooking),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: SpottSpacing.md),
        Row(
          children: [
            Expanded(
              child: AnimatedEntrance(
                delay: 2,
                child: _BentoSceneCard(
                  title: 'Offer Trip',
                  stat: 'Earn ₹800 Avg',
                  icon: Icons.add_road_rounded,
                  decorationIcon: Icons.monetization_on_rounded,
                  gradient: SpottGradients.bentoTrip,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.createTrip),
                ),
              ),
            ),
            const SizedBox(width: SpottSpacing.md),
            Expanded(
              child: AnimatedEntrance(
                delay: 3,
                child: _BentoSceneCard(
                  title: 'Nearby',
                  stat: '42 Nearby',
                  icon: Icons.people_outline_rounded,
                  decorationIcon: Icons.location_on_rounded,
                  gradient: SpottGradients.bentoNearby,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.activity),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // SCENE 3: Trending Journeys — Appli-Level Image Cards
  // ════════════════════════════════════════════════════════════════════
  Widget _buildTrendingJourneys(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Trending Journeys', style: SpottTextStyles.headline),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.tripSearch),
              child: Text(
                'See All',
                style: SpottTextStyles.caption.copyWith(
                  color: SpottColors.accentPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: SpottSpacing.md),
        SizedBox(
          height: 380,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              AnimatedEntrance(
                delay: 0,
                child: SpottAppliCard(
                  route: 'Pune → Mumbai',
                  price: '₹450',
                  trustScore: 92,
                  travelerName: 'Arjun Sharma',
                  travelerAvatarUrl:
                      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=150',
                  tripsCompleted: 143,
                  responseRate: '98%',
                  vehicleInfo: 'Hyundai i20 (AC)',
                  seatsLeft: '3 seats left',
                  travelersCount: '12 travelers today',
                  savings: '₹800 vs Bus',
                  imageBannerUrl:
                      'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&q=80&w=600',
                  onShowInterest: () {},
                  onViewDetails: () {
                    Navigator.pushNamed(context, AppRoutes.tripDetails);
                  },
                ),
              ),
              const SizedBox(width: SpottSpacing.md),
              AnimatedEntrance(
                delay: 1,
                child: SpottAppliCard(
                  route: 'Pune → Bangalore',
                  price: '₹1,400',
                  trustScore: 96,
                  travelerName: 'Sneha Patil',
                  travelerAvatarUrl:
                      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=150',
                  tripsCompleted: 286,
                  responseRate: '99%',
                  vehicleInfo: 'Honda City (AC)',
                  seatsLeft: '2 seats left',
                  travelersCount: '8 travelers today',
                  savings: '₹1,400 saving',
                  imageBannerUrl:
                      'https://images.unsplash.com/photo-1506015391300-4802dc74de2e?auto=format&fit=crop&q=80&w=600',
                  onShowInterest: () {},
                  onViewDetails: () {
                    Navigator.pushNamed(context, AppRoutes.tripDetails);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // SCENE 4: Popular Routes — Route Visualization Cards
  // ════════════════════════════════════════════════════════════════════
  Widget _buildPopularRoutes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Popular Shared Routes', style: SpottTextStyles.headline),
        const SizedBox(height: SpottSpacing.md),
        SizedBox(
          height: 185,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              AnimatedEntrance(
                delay: 0,
                child: _RouteVisualizationCard(
                  origin: 'Pune',
                  destination: 'Kolhapur',
                  travelers: '34 travelers',
                  savings: 'Save ₹350',
                ),
              ),
              const SizedBox(width: SpottSpacing.md),
              AnimatedEntrance(
                delay: 1,
                child: _RouteVisualizationCard(
                  origin: 'Mumbai',
                  destination: 'Nashik',
                  travelers: '18 travelers',
                  savings: 'Save ₹280',
                ),
              ),
              const SizedBox(width: SpottSpacing.md),
              AnimatedEntrance(
                delay: 2,
                child: _RouteVisualizationCard(
                  origin: 'Pune',
                  destination: 'Goa',
                  travelers: '22 travelers',
                  savings: 'Save ₹500',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // SCENE 5: Nearby Travelers — Premium Profile Cards
  // ════════════════════════════════════════════════════════════════════
  Widget _buildNearbyTravelers(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nearby Verified Travelers',
          style: SpottTextStyles.headline,
        ),
        const SizedBox(height: SpottSpacing.md),
        SizedBox(
          height: 290,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              AnimatedEntrance(
                delay: 0,
                child: _NearbyProfileCard(
                  name: 'Vikram Joshi',
                  avatarUrl:
                      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=150',
                  rating: '4.9',
                  vehicle: 'Skoda Slavia',
                  responseRate: '96%',
                  status: 'Heading to Kolhapur at 5 PM',
                  govVerified: true,
                  carVerified: true,
                ),
              ),
              const SizedBox(width: SpottSpacing.md),
              AnimatedEntrance(
                delay: 1,
                child: _NearbyProfileCard(
                  name: 'Meera Rao',
                  avatarUrl:
                      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&q=80&w=150',
                  rating: '4.8',
                  vehicle: 'Suzuki Swift',
                  responseRate: '98%',
                  status: 'Heading to Mumbai at 7:30 PM',
                  govVerified: true,
                  carVerified: true,
                ),
              ),
              const SizedBox(width: SpottSpacing.md),
              AnimatedEntrance(
                delay: 2,
                child: _NearbyProfileCard(
                  name: 'Arjun Sharma',
                  avatarUrl:
                      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=150',
                  rating: '4.9',
                  vehicle: 'Hyundai i20',
                  responseRate: '98%',
                  status: 'Heading to Bangalore at 6 AM',
                  govVerified: true,
                  carVerified: false,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // SCENE 6: Parcel Banner — Ad Campaign Style
  // ════════════════════════════════════════════════════════════════════
  Widget _buildParcelBanner(BuildContext context) {
    return ShimmerSweep(
      child: Container(
        padding: const EdgeInsets.all(SpottSpacing.lg),
        decoration: BoxDecoration(
          gradient: SpottGradients.parcelBanner,
          borderRadius: BorderRadius.circular(SpottRadius.banner),
        ),
        child: Stack(
          children: [
            // Parcel route decoration
            Positioned.fill(
              child: CustomPaint(painter: ParcelRoutePainter()),
            ),
            // Package icon silhouette
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(
                Icons.inventory_2_rounded,
                size: 100,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'PARCEL DELIVERY',
                    style: SpottTextStyles.overline.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: SpottSpacing.md),
                Text(
                  'Send Parcels from ₹99',
                  style: SpottTextStyles.title.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Fast peer-to-peer dispatch via verified travelers.',
                  style: SpottTextStyles.body.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: SpottSpacing.md),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.parcelBooking);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFB45309),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(SpottRadius.button),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Send Parcel Now',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // SCENE 7: Become Traveler — Emotional + Diagonal Split
  // ════════════════════════════════════════════════════════════════════
  Widget _buildTravelerBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SpottSpacing.lg),
      decoration: BoxDecoration(
        gradient: SpottGradients.travelerBanner,
        borderRadius: BorderRadius.circular(SpottRadius.banner),
      ),
      child: Stack(
        children: [
          // Diagonal split decoration
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(SpottRadius.banner),
              child: ClipPath(
                clipper: DiagonalSplitClipper(),
                child: Container(
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
          ),
          // Car silhouette
          Positioned(
            right: 16,
            bottom: 8,
            child: Icon(
              Icons.directions_car_rounded,
              size: 80,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recover Fuel Costs',
                style: SpottTextStyles.title.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Drivers earn ₹800 avg per trip. Offer seats or deliver parcels.',
                style: SpottTextStyles.body.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: SpottSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.createTrip);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF4338CA),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(SpottRadius.button),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Offer a Ride',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹800/trip',
                        style: SpottTextStyles.label.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'avg earning',
                        style: SpottTextStyles.caption.copyWith(
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // SCENE 8: Safety Center — Trust Module
  // ════════════════════════════════════════════════════════════════════
  Widget _buildSafetyCenter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SpottSpacing.lg),
      decoration: BoxDecoration(
        color: SpottColors.surface1,
        borderRadius: BorderRadius.circular(SpottRadius.primaryCard),
        border: Border.all(color: SpottColors.border),
      ),
      child: Stack(
        children: [
          // Shield watermark
          Positioned(
            right: -20,
            top: -20,
            child: ShieldWatermark(size: 160, opacity: 0.04),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: SpottSpacing.md),
                  const Text(
                    'Safety & Trust Center',
                    style: SpottTextStyles.title,
                  ),
                ],
              ),
              const SizedBox(height: SpottSpacing.lg),
              _buildTrustItem('Verified IDs for all travelers', 0),
              _buildTrustItem('Live GPS coordinate sharing', 1),
              _buildTrustItem('Emergency SOS with 1-tap', 2),
              _buildTrustItem('Community-protected network', 3),
              const SizedBox(height: SpottSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.safetyToolkit);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: SpottColors.textPrimary,
                    side: const BorderSide(color: SpottColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(SpottRadius.button),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Learn More',
                    style: SpottTextStyles.label.copyWith(fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrustItem(String label, int index) {
    return AnimatedEntrance(
      delay: index,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: SpottColors.success,
              size: 18,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: SpottTextStyles.body.copyWith(
                color: SpottColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// BENTO SCENE CARD — Each card has its own visual personality
// ══════════════════════════════════════════════════════════════════════
class _BentoSceneCard extends StatelessWidget {
  final String title;
  final String stat;
  final IconData icon;
  final IconData decorationIcon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _BentoSceneCard({
    required this.title,
    required this.stat,
    required this.icon,
    required this.decorationIcon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(SpottRadius.primaryCard),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(SpottRadius.primaryCard),
          child: Stack(
            children: [
              // Decorative silhouette (bottom-right, huge, very low opacity)
              Positioned(
                right: -10,
                bottom: -10,
                child: Icon(
                  decorationIcon,
                  size: 80,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(SpottSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, color: Colors.white, size: 24),
                    const Spacer(),
                    Text(
                      title,
                      style: SpottTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      stat,
                      style: SpottTextStyles.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// ROUTE VISUALIZATION CARD — Route with ○ → ● visualization
// ══════════════════════════════════════════════════════════════════════
class _RouteVisualizationCard extends StatelessWidget {
  final String origin;
  final String destination;
  final String travelers;
  final String savings;

  const _RouteVisualizationCard({
    required this.origin,
    required this.destination,
    required this.travelers,
    required this.savings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 185,
      decoration: BoxDecoration(
        color: SpottColors.surface1,
        borderRadius: BorderRadius.circular(SpottRadius.primaryCard),
        border: Border.all(color: SpottColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SpottRadius.primaryCard),
        child: Stack(
          children: [
            // Highway texture
            Positioned.fill(
              child: CustomPaint(painter: HighwayLinePainter()),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(SpottSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    origin,
                    style: SpottTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Route visualization
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Column(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: SpottColors.accentPurple,
                          ),
                        ),
                        Container(
                          width: 2,
                          height: 28,
                          color: SpottColors.border,
                        ),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: SpottColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    destination,
                    style: SpottTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        travelers,
                        style: SpottTextStyles.caption.copyWith(
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        savings,
                        style: SpottTextStyles.caption.copyWith(
                          color: SpottColors.success,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// NEARBY PROFILE CARD — Premium traveler profile with green glow avatar
// ══════════════════════════════════════════════════════════════════════
class _NearbyProfileCard extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final String rating;
  final String vehicle;
  final String responseRate;
  final String status;
  final bool govVerified;
  final bool carVerified;

  const _NearbyProfileCard({
    required this.name,
    required this.avatarUrl,
    required this.rating,
    required this.vehicle,
    required this.responseRate,
    required this.status,
    required this.govVerified,
    required this.carVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(SpottSpacing.md),
      decoration: BoxDecoration(
        color: SpottColors.surface1,
        borderRadius: BorderRadius.circular(SpottRadius.primaryCard),
        border: Border.all(color: SpottColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar row with rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Avatar with green glow ring
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3310B981),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SpottAvatar(
                  imageUrl: avatarUrl,
                  radius: 24,
                  isVerified: true,
                ),
              ),
              // Rating badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: SpottColors.warningSoft,
                  borderRadius: BorderRadius.circular(SpottRadius.xs),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 12,
                      color: SpottColors.warning,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      rating,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: SpottColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: SpottTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            vehicle,
            style: SpottTextStyles.caption.copyWith(
              color: SpottColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          // Verification badges
          Row(
            children: [
              if (govVerified) _buildVerifyChip('Govt ✓'),
              if (govVerified && carVerified) const SizedBox(width: 6),
              if (carVerified) _buildVerifyChip('Car ✓'),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$responseRate Response',
            style: SpottTextStyles.caption.copyWith(
              color: SpottColors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          // Status
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: SpottColors.accentPurple,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  status,
                  style: SpottTextStyles.caption.copyWith(
                    color: SpottColors.accentPurple,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Ghost button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: SpottColors.textPrimary,
                side: const BorderSide(color: SpottColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(SpottRadius.button),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: Text(
                'View Profile',
                style: SpottTextStyles.label.copyWith(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: SpottColors.successSoft,
        borderRadius: BorderRadius.circular(SpottRadius.xs),
        border: Border.all(
          color: SpottColors.success.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: SpottColors.success,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}
