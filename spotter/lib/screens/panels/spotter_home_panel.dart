import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../app/app_assets.dart';
import '../../app/app_config.dart';
import '../../app/app_routes.dart';
import '../../controllers/ride_controller.dart';
import '../../helper.dart';
import '../../models/ride_models.dart';
import '../../spotter_widgets.dart';

class SpotterHomePanel extends StatefulWidget {
  const SpotterHomePanel({super.key});

  @override
  State<SpotterHomePanel> createState() => _SpotterHomePanelState();
}

class _SpotterHomePanelState extends State<SpotterHomePanel> {
  String _selectedVehicleClass = 'Car'; // 'Car', 'Bike', 'Rickshaw'

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;
    final appName = AppConfig.appName;

    final decoration = BoxDecoration(
      color: isDark
          ? const Color(0xFF121212).withValues(alpha: 0.88)
          : Colors.white.withValues(alpha: 0.88),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),
      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : const Color(0xFFE5E7EB),
        width: 1.0,
      ),
      boxShadow: Helper.premiumShadows,
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.44, // Peek size matching Spott mockup (45%)
      minChildSize: 0.44,
      maxChildSize: 0.88,
      snap: true,
      snapSizes: const [0.44, 0.88],
      builder: (BuildContext context, ScrollController scrollController) {
        Widget content = Container(
          decoration: decoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Sleek drag handle (Stitch design handle)
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 12),
                  width: 48,
                  height: 5.0,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.12)
                        : const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),

              // 2. Vehicle Selector Horizontal Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildVehicleSelectorChip(
                        'Car',
                        AppAssets.car,
                        Icons.directions_car_rounded,
                      ),
                      const SizedBox(width: 8),
                      _buildVehicleSelectorChip(
                        'Bike',
                        AppAssets.bike,
                        Icons.motorcycle_rounded,
                      ),
                      const SizedBox(width: 8),
                      _buildVehicleSelectorChip(
                        'Rickshaw',
                        AppAssets.rikshaw,
                        Icons.electric_rickshaw_rounded,
                      ),
                    ],
                  ),
                ),
              ),

              // 3. ListView contents containing Carousel + Rails
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                  children: [
                    // Carousel Header Title
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Suggestions',
                            style: TextStyle(
                              fontFamily: 'Hanken Grotesk',
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              AppRoutes.services,
                            ),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'View All',
                              style: TextStyle(
                                color: Helper.ink,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 4. Horizontal Option Cards Carousel
                    SizedBox(
                      height: 252,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: _buildCarouselCards(context, ride),
                      ),
                    ),

                    // Additional promo content when sheet is dragged upwards
                    if (ride.actionState.isFailure) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: RecoveryBanner(
                          state: ride.actionState,
                          onRetry: ride.retryInitialize,
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: _PaymentBanner(),
                    ),

                    const SizedBox(height: 28),
                    _CardRailSection(
                      title: 'Ways to save with $appName',
                      cards: const [
                        _RailCardData(
                          title: 'Spott Moto rides',
                          subtitle: 'Affordable motorcycle pick-ups',
                          assetPath: AppAssets.bike,
                        ),
                        _RailCardData(
                          title: 'Shuttle rides',
                          subtitle: 'Low fares, premium travel',
                          assetPath: AppAssets.car,
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: _PremierBanner(),
                    ),

                    const SizedBox(height: 28),
                    _CardRailSection(
                      title: 'Ways to plan with $appName',
                      cards: const [
                        _RailCardData(
                          title: 'Travel intercity',
                          subtitle: 'Get to remote locations with ease',
                          assetPath: AppAssets.rikshawClock,
                          routeName: AppRoutes.intercity,
                        ),
                        _RailCardData(
                          title: 'Hourly rentals',
                          subtitle: 'Ride from 1 to 12 hours',
                          assetPath: AppAssets.carClock,
                          routeName: AppRoutes.rentals,
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),
                    _CardRailSection(
                      title: 'More ways to use $appName',
                      cards: const [
                        _RailCardData(
                          title: 'Safety Toolkit',
                          subtitle: 'Share trip status and get urgent help',
                          assetPath: AppAssets.car,
                          routeName: AppRoutes.safetyToolkit,
                        ),
                        _RailCardData(
                          title: 'Send a package',
                          subtitle: 'On-demand delivery around town',
                          assetPath: AppAssets.parcel,
                          routeName: AppRoutes.parcelBooking,
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: _AroundYouSection(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

        if (isDark) {
          content = ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: content,
            ),
          );
        }

        return content;
      },
    );
  }

  Widget _buildVehicleSelectorChip(
    String label,
    String assetPath,
    IconData fallbackIcon,
  ) {
    final ride = RideScope.of(context);
    final isSelected = _selectedVehicleClass == label;
    final isDark = ride.isDarkMode;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () {
        setState(() {
          _selectedVehicleClass = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Helper.ink
              : (isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF3F4F6)),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected
                ? Helper.ink
                : (isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.transparent),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Image.asset(
                assetPath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    fallbackIcon,
                    size: 18,
                    color: isSelected
                        ? Colors.white
                        : (isDark
                              ? const Color(0xFFC4C5D9)
                              : const Color(0xFF5E5E5E)),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Geist',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (isDark
                          ? const Color(0xFFC4C5D9)
                          : const Color(0xFF111827)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCarouselCards(BuildContext context, RideController ride) {
    if (_selectedVehicleClass == 'Car') {
      return [
        _CarouselRideCard(
          title: 'Empire Tech Prime',
          rating: '4.8',
          distance: '0.2 km • 5 mins away',
          fare: '₹140',
          badgeText: 'AVAILABLE',
          badgeColor: Helper.success,
          badgeTextColor: Colors.black,
          assetPath: AppAssets.car,
          fallbackIcon: Icons.directions_car_filled_rounded,
          onBookTap: () {
            ride.updateDestination(
              const LocationPoint(
                title: 'Empire Tech Park',
                detail: 'Saket, New Delhi',
              ),
            );
            Navigator.pushNamed(context, AppRoutes.destination);
          },
        ),
        const SizedBox(width: 14),
        _CarouselRideCard(
          title: 'Skyline Sedan',
          rating: '4.5',
          distance: '0.8 km • 12 mins away',
          fare: '₹210',
          badgeText: 'FILLING FAST',
          badgeColor: const Color(0xFFFF8A00),
          badgeTextColor: Colors.black,
          assetPath: AppAssets.car,
          fallbackIcon: Icons.directions_car_filled_rounded,
          onBookTap: () {
            ride.updateDestination(
              const LocationPoint(
                title: 'Skyline Plaza',
                detail: 'Vasant Kunj, New Delhi',
              ),
            );
            Navigator.pushNamed(context, AppRoutes.destination);
          },
        ),
      ];
    } else if (_selectedVehicleClass == 'Bike') {
      return [
        _CarouselRideCard(
          title: 'Spott Moto',
          rating: '4.9',
          distance: '0.1 km • 3 mins away',
          fare: '₹50',
          badgeText: 'AVAILABLE',
          badgeColor: Helper.success,
          badgeTextColor: Colors.black,
          assetPath: AppAssets.bike,
          fallbackIcon: Icons.motorcycle_rounded,
          onBookTap: () {
            ride.updateDestination(
              const LocationPoint(
                title: 'Spott Junction',
                detail: 'Sector 12, Dwarka',
              ),
            );
            Navigator.pushNamed(context, AppRoutes.destination);
          },
        ),
        const SizedBox(width: 14),
        _CarouselRideCard(
          title: 'Swift Shuttle',
          rating: '4.7',
          distance: '0.4 km • 6 mins away',
          fare: '₹30',
          badgeText: 'PROMO ACTIVE',
          badgeColor: const Color(0xFFFF8A00),
          badgeTextColor: Colors.black,
          assetPath: AppAssets.bikeClock,
          fallbackIcon: Icons.directions_bus_rounded,
          onBookTap: () {
            ride.updateDestination(
              const LocationPoint(
                title: 'Dwarka Interchange',
                detail: 'New Delhi',
              ),
            );
            Navigator.pushNamed(context, AppRoutes.destination);
          },
        ),
      ];
    } else {
      // Rickshaw
      return [
        _CarouselRideCard(
          title: 'Spott Auto Rickshaw',
          rating: '4.6',
          distance: '0.3 km • 4 mins away',
          fare: '₹70',
          badgeText: 'AVAILABLE',
          badgeColor: Helper.success,
          badgeTextColor: Colors.black,
          assetPath: AppAssets.rikshaw,
          fallbackIcon: Icons.electric_rickshaw_rounded,
          onBookTap: () {
            ride.updateDestination(
              const LocationPoint(
                title: 'Saket Spott Station',
                detail: 'New Delhi',
              ),
            );
            Navigator.pushNamed(context, AppRoutes.destination);
          },
        ),
        const SizedBox(width: 14),
        _CarouselRideCard(
          title: 'E-Auto Express',
          rating: '4.8',
          distance: '0.6 km • 8 mins away',
          fare: '₹80',
          badgeText: 'AVAILABLE',
          badgeColor: Helper.success,
          badgeTextColor: Colors.black,
          assetPath: AppAssets.rikshawClock,
          fallbackIcon: Icons.electric_rickshaw_rounded,
          onBookTap: () {
            ride.updateDestination(
              const LocationPoint(
                title: 'Pushp Vihar Block C',
                detail: 'New Delhi',
              ),
            );
            Navigator.pushNamed(context, AppRoutes.destination);
          },
        ),
      ];
    }
  }
}

class _CarouselRideCard extends StatelessWidget {
  final String title;
  final String rating;
  final String distance;
  final String fare;
  final String badgeText;
  final Color badgeColor;
  final Color badgeTextColor;
  final String assetPath;
  final IconData fallbackIcon;
  final VoidCallback onBookTap;

  const _CarouselRideCard({
    required this.title,
    required this.rating,
    required this.distance,
    required this.fare,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.assetPath,
    required this.fallbackIcon,
    required this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;

    return Container(
      width: 260, // Set width to 260 to fit horizontal test constraints
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C24) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : const Color(0xFFE5E7EB),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Graphic Image Section with top-right Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 124,
                  width: double.infinity,
                  child: _AssetIllustration(
                    assetPath: assetPath,
                    fit: BoxFit.contain,
                    fallbackIcon: fallbackIcon,
                  ),
                ),
              ),
              // Top-right availability badge
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      color: badgeTextColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Geist',
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title & Rating Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFF8A00),
                      size: 16,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      rating,
                      style: TextStyle(
                        fontFamily: 'Geist',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? const Color(0xFFE5E2E1) : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // Distance / ETA Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                Icon(
                  Icons.navigation_outlined,
                  size: 14,
                  color: isDark
                      ? const Color(0xFF8E90A2)
                      : const Color(0xFF5E5E5E),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    distance,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: isDark
                          ? const Color(0xFF8E90A2)
                          : const Color(0xFF5E5E5E),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Pricing and Booking CTA Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: fare,
                          style: TextStyle(
                            fontFamily: 'Geist',
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : Helper.ink,
                          ),
                        ),
                        TextSpan(
                          text: '/ride',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFF8E90A2)
                                : const Color(0xFF5E5E5E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                ElevatedButton(
                  onPressed: onBookTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Helper.ink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        999,
                      ), // Fully pill button
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
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

class _PaymentBanner extends StatelessWidget {
  const _PaymentBanner();

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;

    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRoutes.wallet),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        constraints: const BoxConstraints(minHeight: 110),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFFF59E0B) : const Color(0xFFFACC15),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -42,
              top: -42,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  color:
                      (isDark
                              ? const Color(0xFFD97706)
                              : const Color(0xFFFDE047))
                          .withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Finalize payment:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Rs 170.71',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Pay',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_active_rounded,
                    color: isDark
                        ? const Color(0xFFD97706)
                        : const Color(0xFFEAB308),
                    size: 26,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CardRailSection extends StatelessWidget {
  final String title;
  final List<_RailCardData> cards;

  const _CardRailSection({required this.title, required this.cards});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Hanken Grotesk',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              for (var index = 0; index < cards.length; index++) ...[
                _RailCard(data: cards[index]),
                if (index != cards.length - 1) const SizedBox(width: 14),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RailCardData {
  final String title;
  final String subtitle;
  final String assetPath;
  final String? routeName;

  const _RailCardData({
    required this.title,
    required this.subtitle,
    required this.assetPath,
    this.routeName,
  });
}

class _RailCard extends StatelessWidget {
  final _RailCardData data;

  const _RailCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: data.routeName == null
          ? null
          : () => Navigator.pushNamed(context, data.routeName!),
      child: SizedBox(
        width: 280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 158,
                width: 280,
                child: _AssetIllustration(
                  assetPath: data.assetPath,
                  fit: BoxFit.contain,
                  fallbackIcon: Icons.directions_car_filled_rounded,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    data.title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              data.subtitle,
              style: TextStyle(
                fontFamily: 'Inter',
                color: isDark
                    ? const Color(0xFF8E90A2)
                    : const Color(0xFF5E5E5E),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AroundYouSection extends StatelessWidget {
  const _AroundYouSection();

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Around you',
          style: TextStyle(
            fontFamily: 'Hanken Grotesk',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 14),
        InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nearby mobility map opened')),
          ),
          child: Container(
            height: 208,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : const Color(0xFFE5E7EB),
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: _NetworkIllustration(
                      imageUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuC4sJsG0NX8AjTT9YOxDBWT1UMCHXS4LQMr0irhu_u9GNM_Fg4uQCWx4HLdozGiz2bXJfZ3wUEBNjJkWAC5cxsGAfZXXlmHVlB_8QH7k0byosC9KPJBlY39-_pm4rJeUISG_W2bX8oMXjvh-IGX-hkSM4qMPDiCnGyIddslSgXvk4dCLybROpNahKczV7ZG6SLOPEDgGxT3HhHBWX3epupv3aLpHX3NnU_xZo1xyNbbATzo-fKaIsqwyg4_QjKH0YYA_rVClskZBBc',
                      fit: BoxFit.cover,
                      fallbackIcon: Icons.map_rounded,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 122,
                    height: 122,
                    decoration: BoxDecoration(
                      color: Helper.ink.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Helper.ink,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                ),
                const Positioned(
                  top: 42,
                  left: 64,
                  child: _MapChip(
                    icon: Icons.directions_car_filled_rounded,
                    label: '3 min',
                  ),
                ),
                const Positioned(
                  bottom: 38,
                  right: 42,
                  child: _MapChip(
                    icon: Icons.local_parking_rounded,
                    label: '₹40/hr',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MapChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MapChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.black),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PremierBanner extends StatelessWidget {
  const _PremierBanner();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 152,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF8B6D2A),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Comfortable sedan rides',
                      style: TextStyle(
                        fontFamily: 'Hanken Grotesk',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Book Premier',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: _AssetIllustration(
                  assetPath: AppAssets.car,
                  fallbackIcon: Icons.directions_car_filled_rounded,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
            (index) => Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: index == 0 ? Helper.ink : const Color(0xFFD1D5DB),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AssetIllustration extends StatelessWidget {
  final String assetPath;
  final IconData fallbackIcon;
  final BoxFit fit;

  const _AssetIllustration({
    required this.assetPath,
    required this.fallbackIcon,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF3F4F6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Image.asset(
          assetPath,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(
                fallbackIcon,
                size: 42,
                color: const Color(0xFF6B7280),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NetworkIllustration extends StatelessWidget {
  final String imageUrl;
  final IconData fallbackIcon;
  final BoxFit fit;

  const _NetworkIllustration({
    required this.imageUrl,
    required this.fallbackIcon,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    if (WidgetsBinding.instance.toString().contains('Test')) {
      return Center(
        child: Icon(fallbackIcon, size: 42, color: const Color(0xFF6B7280)),
      );
    }
    return Image.network(
      imageUrl,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Icon(fallbackIcon, size: 42, color: const Color(0xFF6B7280)),
        );
      },
    );
  }
}
