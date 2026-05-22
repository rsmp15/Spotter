import 'package:flutter/material.dart';
import '../../app/app_assets.dart';
import '../../app/app_routes.dart';
import '../../controllers/ride_controller.dart';
import '../../helper.dart';
import '../../models/ride_models.dart';
import '../../spotter_widgets.dart';

class UberHomePanel extends StatelessWidget {
  const UberHomePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final recentLocations = <LocationPoint>[
      const LocationPoint(
        title: 'Select Citywalk Mall',
        detail:
            'Saket District Center, District Center, Sector 6, Pushp Vihar, New Delhi, Delhi 110017',
      ),
      const LocationPoint(
        title: '5, Kullar Farms Rd',
        detail:
            'New Manglapuri, Manglapuri Village, Sultanpur, New Delhi, Delhi',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: Helper.premiumShadows,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4.5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SearchHeader(
                  onSearchTap: () =>
                      Navigator.pushNamed(context, AppRoutes.destination),
                  onScheduleTap: () =>
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pickup time set to now')),
                      ),
                ),
                if (ride.actionState.isFailure) ...[
                  const SizedBox(height: 12),
                  RecoveryBanner(
                    state: ride.actionState,
                    onRetry: ride.retryInitialize,
                  ),
                ],
                const SizedBox(height: 16),
                for (final location in recentLocations)
                  _RecentLocationTile(
                    location: location,
                    onTap: () {
                      ride.updateDestination(location);
                      Navigator.pushNamed(context, AppRoutes.destination);
                    },
                  ),
                const SizedBox(height: 18),
                _PaymentBanner(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.wallet),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Suggestions',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.services),
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          color: Color(0xFF5E5E5E),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _SuggestionGrid(
                  onRideTap: () =>
                      Navigator.pushNamed(context, AppRoutes.destination),
                  onServicesTap: () =>
                      Navigator.pushNamed(context, AppRoutes.services),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchHeader extends StatelessWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onScheduleTap;

  const _SearchHeader({required this.onSearchTap, required this.onScheduleTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onSearchTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search_rounded, color: Color(0xFF111827)),
                  SizedBox(width: 12),
                  Text(
                    'Where to?',
                    style: TextStyle(
                      color: Color(0xFF374151),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onScheduleTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x12000000),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: const [
                Icon(Icons.access_time_filled_rounded, size: 15),
                SizedBox(width: 6),
                Text(
                  'Now',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                SizedBox(width: 2),
                Icon(Icons.keyboard_arrow_down_rounded, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RecentLocationTile extends StatelessWidget {
  final LocationPoint location;
  final VoidCallback onTap;

  const _RecentLocationTile({required this.location, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2),
              padding: const EdgeInsets.all(9),
              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history_rounded,
                size: 20,
                color: Color(0xFF4B5563),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.title,
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location.detail,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 13,
                      height: 1.25,
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

class _PaymentBanner extends StatelessWidget {
  final VoidCallback onTap;

  const _PaymentBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        constraints: const BoxConstraints(minHeight: 120),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFACC15),
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
                  color: const Color(0xFFFDE047).withValues(alpha: 0.55),
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
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Rs 170.71',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 26,
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
                  child: const Icon(
                    Icons.notifications_active_rounded,
                    color: Color(0xFFEAB308),
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

class _SuggestionGrid extends StatelessWidget {
  final VoidCallback onRideTap;
  final VoidCallback onServicesTap;

  const _SuggestionGrid({required this.onRideTap, required this.onServicesTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SuggestionTile(
            label: 'Ride',
            badge: 'Promo',
            assetPath: AppAssets.car,
            fallbackIcon: Icons.local_taxi_rounded,
            onTap: onRideTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SuggestionTile(
            label: 'Package',
            assetPath: AppAssets.parcel,
            fallbackIcon: Icons.inventory_2_rounded,
            onTap: onServicesTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SuggestionTile(
            label: 'Rentals',
            badge: 'Promo',
            assetPath: AppAssets.carClock,
            fallbackIcon: Icons.schedule_rounded,
            onTap: onServicesTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SuggestionTile(
            label: 'Reserve',
            assetPath: AppAssets.calendar,
            fallbackIcon: Icons.event_available_rounded,
            onTap: onServicesTap,
          ),
        ),
      ],
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final String label;
  final String? badge;
  final String assetPath;
  final IconData fallbackIcon;
  final VoidCallback onTap;

  const _SuggestionTile({
    required this.label,
    required this.assetPath,
    required this.fallbackIcon,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        children: [
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Stack(
              children: [
                if (badge != null)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF000000), // Premium black badge
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
                  child: Image.asset(
                    assetPath,
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(fallbackIcon, size: 32, color: Helper.ink);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
