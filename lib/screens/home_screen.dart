import 'package:flutter/material.dart';

import '../app/app_assets.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../models/ride_models.dart';
import '../spotter_widgets.dart';
import 'rider_bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const RiderBottomNav(activeTab: RiderBottomTab.home),
      body: SafeArea(
        child: ListView(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SearchHeader(
                        onSearchTap: () =>
                            Navigator.pushNamed(context, AppRoutes.destination),
                        onScheduleTap: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Pickup time set to now'),
                              ),
                            ),
                      ),
                      if (ride.actionState.isFailure) ...[
                        const SizedBox(height: 12),
                        RecoveryBanner(
                          state: ride.actionState,
                          onRetry: ride.retryInitialize,
                        ),
                      ],
                      const SizedBox(height: 14),
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
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.wallet),
                      ),
                      const SizedBox(height: 26),
                      _SectionHeader(
                        title: 'Suggestions',
                        trailing: TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, AppRoutes.services),
                          child: const Text(
                            'See all',
                            style: TextStyle(
                              color: Color(0xFF344054),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SuggestionGrid(
                        onRideTap: () =>
                            Navigator.pushNamed(context, AppRoutes.destination),
                        onServicesTap: () =>
                            Navigator.pushNamed(context, AppRoutes.services),
                      ),
                      const SizedBox(height: 28),
                      const _CardRailSection(
                        title: 'Ways to save with Uber',
                        cards: [
                          _RailCardData(
                            title: 'Uber Moto rides',
                            subtitle: 'Affordable motorcycle pick-ups',
                            imageUrl:
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuBWttFyfZrbumHNXp359omeSHMK0SDImZZmUIFA4Bbu5U6XFsx4UDfGWopS7YpgC-rnt0JSsKqCJ1-QZu16kmvHRFTaLseVn3-PmjyOa4BtnxDLIRmunS0BOUeW-UuOfJwiKRbZIqmTefTY5H8rq6FVrjrtv7EcOJbdiV6c8yiK3WuDzVLjtUOvhxTGpIjONq7EXvCNynNLvDj1yPdx0lrM02AJGkNXlSswq6Ry1jDB2nb1dTZ79Or5q35izp3pJXsGYt84riWW_QY',
                          ),
                          _RailCardData(
                            title: 'Shuttle rides',
                            subtitle: 'Low fares, premium travel',
                            imageUrl:
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuBzuymrqQ34y0jXfMVhFwS0y5Af_J32zpmH7OLcBz_9SFrA2zkFkoAq_VFmJugatWqjAVL1WSOWpqLtSa8rxUabrgEIxjZxHyEgJw1ojXJiCaULw-llLvB84zcX74VApU8kcuEuLZz197LUs9Tt2D9rKWg_Skw8B0VdTGFVqnA0uRzS1wf1AGsUbWn6lP3_DbUt5v2XWmzKZ07hY6hnDjIpRu6SQkSsEu_QTguI26UmYi3nCuY9WRyMVzbUXtyev3yMj3OWB0naE7o',
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      const _PremierBanner(),
                      const SizedBox(height: 28),
                      const _CardRailSection(
                        title: 'Ways to plan with Uber',
                        cards: [
                          _RailCardData(
                            title: 'Travel intercity',
                            subtitle: 'Get to remote locations with ease',
                            imageUrl:
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuBhtk3uVqyEvxM_l0VUh_DIiUE-YWCeJrSCyyiR-0uDD8J2e9rvP-ItjaTxzkKHoJAOSuwrwoNcb4Bc9SD8HQpgJiK-5humeJ88nS-ojfeqCmo4Zk7MoobK3p-UKtv-ew8A0NWdet_VBNoQTvwrQKlyuihEMnFc-hsoSlW_MRmTj1CfrXdvIvkrHZBiNfZ0UjjlEOdPIO0C-4aTb1kY2WDolusDPx5aSz07FfMMdcmq7Mdlq3Rcampj5WfOp0A9xtAsXNzUIHDohTI',
                          ),
                          _RailCardData(
                            title: 'Hourly rentals',
                            subtitle: 'Ride from 1 to 12 hours',
                            imageUrl:
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuAyyHj_HfRgGL5HslGwmNH8hgNjM3AKL-8emPDmVZ-4wnHee0qvy9WHot5OvXfIQWstuGREPC6nTq0Q9TXw8yg3eCkHE_zpRYBaM59fjgY-jlNJ_ZRrvmBHxne_wdb8Am2YZUqhWYOcFyRsr4BRrPIudfCJ-UMTCO0KFcV2YskVHCXY-YuOEABLgwyROf4KmLc_FZ3hK9fIolKZRrVI-LH0JRDw6GdEmy5eLGtpZhGBqAEF5gSbfLp8X2QBUfpmzGcCJPEwrPf4nCc',
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      const _CardRailSection(
                        title: 'More ways to use Uber',
                        cards: [
                          _RailCardData(
                            title: 'Safety Toolkit',
                            subtitle: 'On-trip help with safety issues',
                            imageUrl:
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuDHxUWrl5o9jweYAjamWet3k0CmJPNJ9MzizTdqmdqXqdmVPIhx77BiHUvrKEgFQikSSYWacCkVkG7iYTtYL_BOc6_5TPKSdEUuIXV9TnxbMwU0-8027TLeM0Y91YLhLcHiNFtmU__j8b9QHJezdCgVxPXy-B-2FbFXHG2sWRiEMKcu3H-ZB61EN6ws2YusLUY6mjN-Fv3gTGEqRiPEuQlHGF90WXLXTlrfM-XiPCa7LwVXBIvB4Bzqwgvsbb-DoZVrXbvd5pMit7w',
                          ),
                          _RailCardData(
                            title: 'Send a package',
                            subtitle: 'On-demand delivery around town',
                            imageUrl:
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuCHiN1qyKPxSv6H0k_EaJmyp8uE-Cd8D3XX_7FParOFrUggYcZIX9oDmbA-lvrevz5Ud0l0IQ8cwFWd42WAvLCEfYhVXR04OqawxAnzYC_PwS4OExIocxNLbWSjwRPpAyAi9UJUF4Swyvh5nBVoWwRe64jAbCSgCUS-4cnNoAlqKtBXcTwU6TLNjHCXy62wlTU2kLB2Z-NvqnUoQdqQSvVFhan6ayKzc-Ha7H-MNQ3DMzMPgk6tf-cI6rCFrdr7oQ0OwVJhMgnJWxs',
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      const _AroundYouSection(),
                      const SizedBox(height: 16),
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
        constraints: const BoxConstraints(minHeight: 126),
        padding: const EdgeInsets.all(22),
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
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Rs 170.71',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
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
                  width: 58,
                  height: 58,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_active_rounded,
                    color: Color(0xFFEAB308),
                    size: 30,
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        trailing ?? const SizedBox.shrink(),
      ],
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
            assetPath: AppAssets.car,
            badge: 'Promo',
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
            assetPath: AppAssets.carClock,
            badge: 'Promo',
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
  final String assetPath;
  final String? badge;
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
            height: 78,
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
                        color: const Color(0xFF166534),
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
                    width: 48,
                    height: 48,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        fallbackIcon,
                        size: 44,
                        color: const Color(0xFF6B7280),
                      );
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

class _CardRailSection extends StatelessWidget {
  final String title;
  final List<_RailCardData> cards;

  const _CardRailSection({required this.title, required this.cards});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
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
  final String imageUrl;

  const _RailCardData({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}

class _RailCard extends StatelessWidget {
  final _RailCardData data;

  const _RailCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 158,
              width: 280,
              child: _NetworkIllustration(
                imageUrl: data.imageUrl,
                fit: BoxFit.cover,
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 18),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            data.subtitle,
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
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
              Expanded(
                child: _NetworkIllustration(
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCTPHiR5ZhowEJcYeP-lqVGQlZ9fCsqEvt38bY4h7gvk3R42bB5lpk6OXaRMK4fhKCrmt0X6uyyV8NVEMh7OZrcdGlnxM3T7jP8qirl36G8itEEaMTP3Wg3HScSgEOi-wDx-IfFbxKw6LaNya6JLZppREHdssk8B7mENTJdLjfGoCIJAS0qxlnEnMDgjUi5Lcr9cWM9HESY9o0VyL4WAmhDncxu7_T7NbUE6kUJ_DnBKSXBzrg46E9OaO_B6kBQ4h3NPoSK3BVphOY',
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
                color: index == 0
                    ? const Color(0xFF111827)
                    : const Color(0xFFD1D5DB),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AroundYouSection extends StatelessWidget {
  const _AroundYouSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Around you',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 14),
        Container(
          height: 208,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(24),
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
                    color: const Color(0xFF60A5FA).withValues(alpha: 0.22),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
              ),
              const Positioned(
                top: 46,
                left: 74,
                child: Icon(Icons.directions_car_filled_rounded, size: 26),
              ),
              const Positioned(
                bottom: 40,
                right: 54,
                child: Icon(Icons.local_taxi_rounded, size: 26),
              ),
            ],
          ),
        ),
      ],
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
