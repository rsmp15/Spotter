import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../app/app_assets.dart';
import '../../app/app_config.dart';
import '../../app/app_routes.dart';
import '../../controllers/ride_controller.dart';
import '../../helper.dart';
import '../../models/ride_models.dart';
import '../../spotter_widgets.dart';

class SpotterHomePanel extends StatelessWidget {
  const SpotterHomePanel({super.key});

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

    final appName = AppConfig.appName;
    final isDark = ride.isDarkMode;

    final decoration = BoxDecoration(
      color: isDark
          ? const Color(0xFF0C0F14).withValues(alpha: 0.82)
          : Colors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      border: isDark
          ? Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1.5)
          : null,
      boxShadow: Helper.premiumShadows,
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.38,
      minChildSize: 0.35,
      maxChildSize: 0.88,
      snap: true,
      snapSizes: const [0.38, 0.88],
      builder: (BuildContext context, ScrollController scrollController) {
        Widget content = Container(
          decoration: decoration,
          child: Column(
            children: [
              // Premium drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  children: [
                    const _SearchHeader(),
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
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Suggestions',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, AppRoutes.services),
                          child: Text(
                            'See all',
                            style: TextStyle(
                              color: isDark
                                  ? const Color(0xFF98A2B3)
                                  : const Color(0xFF5E5E5E),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const _SuggestionGrid(),
                    const SizedBox(height: 24),
                    const _PaymentBanner(),
                    const SizedBox(height: 28),
                    _CardRailSection(
                      title: 'Ways to save with $appName',
                      cards: const [
                        _RailCardData(
                          title: 'Spotter Moto rides',
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
                    _CardRailSection(
                      title: 'Ways to plan with $appName',
                      cards: const [
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
                    _CardRailSection(
                      title: 'More ways to use $appName',
                      cards: const [
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
                  ],
                ),
              ),
            ],
          ),
        );

        if (isDark) {
          content = ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
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
}

class _SearchHeader extends StatelessWidget {
  const _SearchHeader();

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;

    return Row(
      children: [
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => Navigator.pushNamed(context, AppRoutes.destination),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Where to?',
                    style: TextStyle(
                      color: isDark
                          ? Colors.grey[300]
                          : const Color(0xFF374151),
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
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pickup time set to now')),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : const Color(0xFFE5E7EB),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x12000000),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time_filled_rounded,
                  size: 15,
                  color: isDark ? Colors.white : Colors.black,
                ),
                const SizedBox(width: 6),
                Text(
                  'Now',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: isDark ? Colors.white : Colors.black,
                ),
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
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;

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
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history_rounded,
                size: 20,
                color: isDark ? Colors.white : const Color(0xFF4B5563),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.title,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF111827),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location.detail,
                    style: TextStyle(
                      color: isDark
                          ? Colors.grey[400]
                          : const Color(0xFF6B7280),
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
  const _PaymentBanner();

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;

    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRoutes.wallet),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        constraints: const BoxConstraints(minHeight: 120),
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

class _SuggestionGrid extends StatelessWidget {
  const _SuggestionGrid();

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
            onTap: () => Navigator.pushNamed(context, AppRoutes.destination),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SuggestionTile(
            label: 'Package',
            assetPath: AppAssets.parcel,
            fallbackIcon: Icons.inventory_2_rounded,
            onTap: () => Navigator.pushNamed(context, AppRoutes.services),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SuggestionTile(
            label: 'Rentals',
            badge: 'Promo',
            assetPath: AppAssets.carClock,
            fallbackIcon: Icons.schedule_rounded,
            onTap: () => Navigator.pushNamed(context, AppRoutes.services),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SuggestionTile(
            label: 'Reserve',
            assetPath: AppAssets.calendar,
            fallbackIcon: Icons.event_available_rounded,
            onTap: () => Navigator.pushNamed(context, AppRoutes.services),
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
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        children: [
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6),
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
                        color: isDark ? Colors.white : Colors.black,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        badge!,
                        style: TextStyle(
                          color: isDark ? Colors.black : Colors.white,
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
                      return Icon(
                        fallbackIcon,
                        size: 32,
                        color: isDark ? Colors.white : Helper.ink,
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
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.grey[300] : Colors.black,
            ),
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
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : Colors.black,
          ),
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
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;

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
                  style: TextStyle(
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
              color: isDark ? Colors.grey[400] : const Color(0xFF6B7280),
              fontSize: 12,
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
              const Expanded(
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
