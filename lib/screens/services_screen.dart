import 'package:flutter/material.dart';

import '../app/app_assets.dart';
import '../app/app_routes.dart';
import 'rider_bottom_nav.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const RiderBottomNav(
        activeTab: RiderBottomTab.services,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Services',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Go anywhere, get anything',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: _PrimaryServiceCard(
                              title: 'Ride',
                              assetPath: AppAssets.car,
                              fallbackIcon: Icons.local_taxi_rounded,
                              badge: 'Promo',
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.destination,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _PrimaryServiceCard(
                              title: 'Package',
                              assetPath: AppAssets.parcel,
                              fallbackIcon: Icons.inventory_2_rounded,
                              onTap: () => _showServiceMessage(
                                context,
                                'Package pickup request started',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _PrimaryServiceCard(
                              title: 'Rentals',
                              assetPath: AppAssets.carClock,
                              fallbackIcon: Icons.schedule_rounded,
                              badge: 'Promo',
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.destination,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _SecondaryServiceCard(
                              title: 'Reserve',
                              assetPath: AppAssets.calendar,
                              fallbackIcon: Icons.event_available_rounded,
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.destination,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SecondaryServiceCard(
                              title: 'Shuttle',
                              assetPath: AppAssets.bike,
                              fallbackIcon: Icons.airport_shuttle_rounded,
                              onTap: () => _showServiceMessage(
                                context,
                                'Nearby shuttle routes checked',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SecondaryServiceCard(
                              title: 'Intercity',
                              assetPath: AppAssets.rikshawClock,
                              fallbackIcon: Icons.directions_car_filled_rounded,
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.destination,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SecondaryServiceCard(
                              title: 'Travel',
                              assetPath: AppAssets.bikeClock,
                              fallbackIcon: Icons.luggage_rounded,
                              onTap: () => _showServiceMessage(
                                context,
                                'Travel options saved for later',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _showServiceMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _PrimaryServiceCard extends StatelessWidget {
  final String title;
  final String assetPath;
  final IconData fallbackIcon;
  final String? badge;
  final VoidCallback? onTap;

  const _PrimaryServiceCard({
    required this.title,
    required this.assetPath,
    required this.fallbackIcon,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 116,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          children: [
            if (badge != null)
              Positioned(
                top: 6,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D6A4F),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ServiceImage(
                    assetPath: assetPath,
                    fallbackIcon: fallbackIcon,
                    size: 50,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
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
}

class _SecondaryServiceCard extends StatelessWidget {
  final String title;
  final String assetPath;
  final IconData fallbackIcon;
  final VoidCallback? onTap;

  const _SecondaryServiceCard({
    required this.title,
    required this.assetPath,
    required this.fallbackIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        children: [
          Container(
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: _ServiceImage(
                assetPath: assetPath,
                fallbackIcon: fallbackIcon,
                size: 38,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _ServiceImage extends StatelessWidget {
  final String assetPath;
  final IconData fallbackIcon;
  final double size;

  const _ServiceImage({
    required this.assetPath,
    required this.fallbackIcon,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(fallbackIcon, size: size, color: const Color(0xFF6B7280));
      },
    );
  }
}
