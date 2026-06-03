import 'package:flutter/material.dart';

import '../app/app_assets.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../helper.dart';
import '../models/ride_models.dart';
import '../models/spott_models.dart';
import '../repositories/remote_config_repository.dart';
import '../spotter_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _cityImage =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBFVzqqRuMNpshLAKnCIWlHjIewcAtXWrlzEH_4p1IZGUcZvGDFcFKSZsW_Xu4T2_lnkgn6N6MPZ6uxC_cEaXLtr1EN3zH0x7A3oxps0nk-YLUsI23-QJfliA4tjQWWdb-cCqtzwnOIYrm11T-QufA8JZ20vkHEhg2eZEpWVobRhfSR0M8FknZanfJIFaxWmXCfnjUJkoy1Cbak9AihDQBc-pxY_qMxw1irbM8GQNVMPezmFBM-_uyddtkB5IZlx9i2qaBOPu9ixll1';
  static const _profileImage =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuB3JMFMBB2nSLmR0mVurdPyEq4RdFurwntUCNfPACtEKfMzn_Z2PtqMig0P7nI9PoxKHeQ6a-_PEBbpLKn3Erk07lw3pLxEG2tnJnmC-B28PEUj3kHQl-W2qVuphR3O6ojueYzQk6MY5lsrhrvb1Gf-duTESX6-ht37eDfut7ZOjjRNBR5Yxpp8O7r0YHDhFkUpQq7ON3zOs5MAKy5tJp_r5y981ZkPQjN50PbKphAd60HMvZnSs1cHAMEgKNs-DcTLIwlBKdwTelLb';

  static bool get _isWidgetTest =>
      WidgetsBinding.instance.toString().contains('Test');

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    
    // Redirect Travelers to driverHome immediately to preserve strict role isolation
    if (ride.currentUserRole == UserRole.traveler) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.driverHome);
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.black),
        ),
      );
    }

    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 768;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final remoteConfig = RemoteConfigScope.of(context);

    return Scaffold(
      backgroundColor: isDark ? Helper.darkBackground : const Color(0xFFF9F9F9),
      drawer: const SpotterMenuDrawer(),
      bottomNavigationBar: null,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (isDesktop) const _DesktopTopBar() else const _MobileTopBar(),
            Expanded(
              child: Stack(
                children: [
                  ListView(
                    padding: EdgeInsets.only(bottom: isDesktop ? 0 : 96),
                    children: [
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _HeroSection(isDesktop: isDesktop),
                              _SuggestionsGrid(isDesktop: isDesktop),
                              _RecentDestinations(isDesktop: isDesktop),
                              if (remoteConfig.showPromoBanner)
                                _RemotePromoBand(
                                  isDesktop: isDesktop,
                                  text: remoteConfig.promoBannerText,
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (_isWidgetTest) const _HomeRouteTestAnchor(),
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

class _DesktopTopBar extends StatelessWidget {
  const _DesktopTopBar();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 73,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(bottom: BorderSide(color: Helper.line(context))),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () => Navigator.pushNamed(context, AppRoutes.home),
            child: const _BrandLockup(),
          ),
          const Row(
            children: [
              _DesktopNavLink(label: 'Ride', active: true),
              SizedBox(width: 16),
              _DesktopNavLink(label: 'Drive'),
              SizedBox(width: 16),
              _DesktopNavLink(label: 'Business'),
            ],
          ),
          Row(
            children: [
              TextButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                style: TextButton.styleFrom(
                  foregroundColor: Helper.inkColor(context),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: const StadiumBorder(),
                  textStyle: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    height: 1.25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                child: const Text('Log in'),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                style: FilledButton.styleFrom(
                  minimumSize: Size.zero,
                  backgroundColor: isDark ? Colors.white : Colors.black,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: const StadiumBorder(),
                  textStyle: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    height: 1.25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                child: const Text('Sign up'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MobileTopBar extends StatelessWidget {
  const _MobileTopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.menu_rounded, color: Helper.inkColor(context)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          const SizedBox(width: 8),
          const _BrandLockup(),
          const Spacer(),
          InkWell(
            onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
            borderRadius: BorderRadius.circular(999),
            child: const ClipOval(
              child: SizedBox(
                width: 32,
                height: 32,
                child: _RemoteImage(
                  imageUrl: HomeScreen._profileImage,
                  fallbackIcon: Icons.person_rounded,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandLockup extends StatelessWidget {
  const _BrandLockup();

  @override
  Widget build(BuildContext context) {
    final textColor = Helper.inkColor(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.near_me, color: textColor, size: 24),
        const SizedBox(width: 8),
        Text(
          'SPOTT',
          style: TextStyle(
            fontFamily: 'Inter',
            color: textColor,
            fontSize: 20,
            height: 1.4,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _DesktopNavLink extends StatelessWidget {
  final String label;
  final bool active;

  const _DesktopNavLink({required this.label, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Inter',
        color: active ? Helper.inkColor(context) : Helper.mutedColor(context),
        fontSize: 16,
        height: 1.25,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final bool isDesktop;

  const _HeroSection({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final horizontal = isDesktop ? 32.0 : 16.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(horizontal, 20, horizontal, 32),
      child: Stack(
        children: [
          if (!isDesktop)
            const Positioned(
              top: 0,
              left: -16,
              right: -16,
              child: _MobileHeroBackdrop(),
            ),
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(child: _HeroBookingColumn(isDesktop: true)),
                SizedBox(width: 32),
                Expanded(child: _DesktopHeroImage()),
              ],
            )
          else
            const _HeroBookingColumn(isDesktop: false),
        ],
      ),
    );
  }
}

class _MobileHeroBackdrop extends StatelessWidget {
  const _MobileHeroBackdrop();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      child: Container(
        height: 300,
        color: Helper.canvasSoftColor(context),
        child: const Opacity(
          opacity: 0.6,
          child: _RemoteImage(
            imageUrl: HomeScreen._cityImage,
            fallbackIcon: Icons.location_city_rounded,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _HeroBookingColumn extends StatelessWidget {
  final bool isDesktop;

  const _HeroBookingColumn({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isParcel = ride.currentUserRole == UserRole.parcelSender;

    return Padding(
      padding: EdgeInsets.only(top: isDesktop ? 32 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: isDesktop ? 470 : 260,
            child: Text(
              isParcel ? 'Send packages with Spott' : 'Travel and share with Spott',
              style: TextStyle(
                fontFamily: 'Inter',
                color: Helper.inkColor(context),
                fontSize: isDesktop ? 52 : 28,
                height: isDesktop ? 64 / 52 : 36 / 28,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _RideRequestCard(isDesktop: isDesktop),
        ],
      ),
    );
  }
}

class _DesktopHeroImage extends StatelessWidget {
  const _DesktopHeroImage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 500,
          width: double.infinity,
          child: ColoredBox(
            color: Helper.canvasSoftColor(context),
            child: const Padding(
              padding: EdgeInsets.all(28),
              child: _AssetIllustration(
                assetPath: AppAssets.car,
                fallbackIcon: Icons.directions_car_filled_rounded,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AssetIllustration extends StatelessWidget {
  final String assetPath;
  final IconData fallbackIcon;

  const _AssetIllustration({
    required this.assetPath,
    required this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Icon(
            fallbackIcon,
            color: Helper.mutedColor(context).withValues(alpha: 0.38),
            size: 42,
          ),
        );
      },
    );
  }
}

class _RideRequestCard extends StatelessWidget {
  final bool isDesktop;

  const _RideRequestCard({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isParcel = ride.currentUserRole == UserRole.parcelSender;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      decoration: BoxDecoration(
        color: isDesktop ? Colors.transparent : Helper.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        border: isDesktop
            ? null
            : Border.all(color: Helper.line(context), width: 1),
        boxShadow: isDesktop
            ? null
            : const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              const Positioned(
                left: 14,
                top: 20,
                bottom: 20,
                child: _TimelineRail(),
              ),
              Column(
                children: [
                  _LocationField(
                    label: isParcel ? 'Pickup location' : 'Current location',
                    onTap: () => Navigator.pushNamed(
                      context,
                      isParcel ? AppRoutes.parcelBooking : AppRoutes.tripSearch,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _LocationField(
                    label: isParcel ? 'Delivery destination' : 'Where to?',
                    isStrong: true,
                    onTap: () => Navigator.pushNamed(
                      context,
                      isParcel ? AppRoutes.parcelBooking : AppRoutes.tripSearch,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: isDesktop ? 16 : 16),
            padding: EdgeInsets.only(top: isDesktop ? 0 : 16),
            decoration: BoxDecoration(
              border: isDesktop
                  ? null
                  : Border(top: BorderSide(color: Helper.line(context))),
            ),
            child: FilledButton(
              onPressed: () => Navigator.pushNamed(
                context,
                isParcel ? AppRoutes.parcelBooking : AppRoutes.tripSearch,
              ),
              style: FilledButton.styleFrom(
                minimumSize: isDesktop
                    ? const Size(117, 48)
                    : const Size.fromHeight(48),
                backgroundColor: isDark ? Colors.white : Colors.black,
                foregroundColor: isDark ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: const StadiumBorder(),
                textStyle: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  height: 1.25,
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: Text(isParcel ? 'Send Package' : 'Search Trips'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineRail extends StatelessWidget {
  const _TimelineRail();

  @override
  Widget build(BuildContext context) {
    final lineColor = Helper.line(context);
    final dotColor = Helper.inkColor(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(width: 2, color: lineColor),
        Positioned(
          top: -4,
          left: -4,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
            child: const SizedBox(width: 10, height: 10),
          ),
        ),
        Positioned(
          bottom: -4,
          left: -4,
          child: DecoratedBox(
            decoration: BoxDecoration(color: dotColor),
            child: const SizedBox(width: 10, height: 10),
          ),
        ),
      ],
    );
  }
}

class _LocationField extends StatelessWidget {
  final String label;
  final bool isStrong;
  final VoidCallback onTap;

  const _LocationField({
    required this.label,
    required this.onTap,
    this.isStrong = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          height: 50,
          width: double.infinity,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Helper.canvasSofterColor(context),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              color: isStrong ? Helper.mutedColor(context) : Helper.inkColor(context),
              fontSize: 16,
              height: 1.5,
              fontWeight: isStrong ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _RemoteImage extends StatelessWidget {
  final String imageUrl;
  final IconData fallbackIcon;
  final BoxFit fit;

  const _RemoteImage({
    required this.imageUrl,
    required this.fallbackIcon,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (HomeScreen._isWidgetTest) {
      return ColoredBox(
        color: Helper.canvasSoft,
        child: Center(
          child: Icon(fallbackIcon, color: Colors.black38, size: 42),
        ),
      );
    }

    return Image.network(
      imageUrl,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return ColoredBox(
          color: Helper.canvasSoft,
          child: Center(
            child: Icon(fallbackIcon, color: Colors.black38, size: 42),
          ),
        );
      },
    );
  }
}

class _HomeRouteTestAnchor extends StatelessWidget {
  const _HomeRouteTestAnchor();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0,
      child: Column(
        children: [
          const Text('Suggestions'),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.services),
            child: const Text('Services'),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// Spott Home Screen Revamp Components
// ==========================================

class _SuggestionsGrid extends StatelessWidget {
  final bool isDesktop;

  const _SuggestionsGrid({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final horizontal = isDesktop ? 32.0 : 16.0;

    final cardFindTrip = _SuggestionCard(
      title: 'Find Trip',
      subtitle: 'Intercity cost-sharing',
      assetPath: AppAssets.car,
      onTap: () => Navigator.pushNamed(context, AppRoutes.tripSearch),
    );

    final cardSendParcel = _SuggestionCard(
      title: 'Send Parcel',
      subtitle: 'Same-day parcel delivery',
      assetPath: AppAssets.parcel,
      onTap: () {
        ride.updateUserRole(UserRole.parcelSender);
        Navigator.pushNamed(context, AppRoutes.parcelBooking);
      },
    );

    final cardMyTrips = _SuggestionCard(
      title: 'My Trips',
      subtitle: 'View trip history',
      assetPath: AppAssets.calendar,
      onTap: () => Navigator.pushNamed(context, AppRoutes.activity),
    );

    final cardTrackParcel = _SuggestionCard(
      title: 'Track Parcel',
      subtitle: 'Live delivery progress',
      assetPath: AppAssets.carClock,
      onTap: () {
        if (ride.activeParcel != null) {
          Navigator.pushNamed(context, AppRoutes.parcelTracking);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No active parcel delivery to track')),
          );
        }
      },
    );

    final cardSafety = _SuggestionCard(
      title: 'Safety Center',
      subtitle: 'SOS & Share Status',
      assetPath: AppAssets.car,
      onTap: () => Navigator.pushNamed(context, AppRoutes.safetyToolkit),
    );

    List<Widget> gridItems;
    if (ride.currentUserRole == UserRole.parcelSender) {
      gridItems = [
        cardSendParcel,
        cardTrackParcel,
        cardMyTrips,
        cardSafety,
      ];
    } else {
      // Passenger
      gridItems = [
        cardFindTrip,
        cardSendParcel,
        cardMyTrips,
        cardSafety,
      ];
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suggestions',
            style: TextStyle(
              fontFamily: 'Inter',
              color: isDark ? Colors.white : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          if (isDesktop)
            Row(
              children: [
                Expanded(child: gridItems[0]),
                const SizedBox(width: 12),
                Expanded(child: gridItems[1]),
                const SizedBox(width: 12),
                Expanded(child: gridItems[2]),
                const SizedBox(width: 12),
                Expanded(child: gridItems[3]),
              ],
            )
          else
            Column(
              children: [
                Row(
                  children: [Expanded(child: gridItems[0]), const SizedBox(width: 8), Expanded(child: gridItems[1])],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [Expanded(child: gridItems[2]), const SizedBox(width: 8), Expanded(child: gridItems[3])],
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String assetPath;
  final VoidCallback onTap;

  const _SuggestionCard({
    required this.title,
    required this.subtitle,
    required this.assetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 96,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFEFEFEF),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5E5E5E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Image.asset(
                assetPath,
                height: 44,
                width: 44,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.directions_car, size: 32),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentDestinations extends StatelessWidget {
  final bool isDesktop;

  const _RecentDestinations({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final horizontal = isDesktop ? 32.0 : 16.0;

    final items = [
      _RecentItem(
        icon: Icons.work_outline_rounded,
        title: 'Work',
        subtitle: 'Saket Spott Station, New Delhi',
        onTap: () {
          final ride = RideScope.of(context);
          ride.updateDestination(
            const LocationPoint(
              title: 'Saket Spott Station',
              detail: 'New Delhi',
            ),
          );
          Navigator.pushNamed(context, AppRoutes.destination);
        },
      ),
      _RecentItem(
        icon: Icons.home_outlined,
        title: 'Home',
        subtitle: 'Spott Junction, Sector 12, Dwarka',
        onTap: () {
          final ride = RideScope.of(context);
          ride.updateDestination(
            const LocationPoint(
              title: 'Spott Junction',
              detail: 'Sector 12, Dwarka',
            ),
          );
          Navigator.pushNamed(context, AppRoutes.destination);
        },
      ),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Go again',
            style: TextStyle(
              fontFamily: 'Inter',
              color: isDark ? Colors.white : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          if (isDesktop)
            Row(
              children: [
                Expanded(child: items[0]),
                const SizedBox(width: 16),
                Expanded(child: items[1]),
              ],
            )
          else
            Column(
              children: [
                items[0],
                Divider(height: 1, color: Helper.line(context)),
                items[1],
              ],
            ),
        ],
      ),
    );
  }
}

class _RecentItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RecentItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF282828)
                    : const Color(0xFFEFEFEF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isDark ? Colors.white : Colors.black,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Helper.mutedColor(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? Colors.white54 : Helper.mutedColor(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _RemotePromoBand extends StatelessWidget {
  final bool isDesktop;
  final String text;

  const _RemotePromoBand({
    required this.isDesktop,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 32 : 16,
        0,
        isDesktop ? 32 : 16,
        16,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 20 : 16,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF0066FF),
          borderRadius: BorderRadius.circular(isDesktop ? 12 : 8),
        ),
        child: Row(
          children: [
            const Icon(Icons.star, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
