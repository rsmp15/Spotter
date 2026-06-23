import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'app_routes.dart';
import '../controllers/ride_controller.dart';
import '../helper.dart';
import '../models/ride_models.dart';


// Import our panel views
import '../screens/panels/spotter_home_panel.dart';
import '../screens/panels/spotter_fare_panel.dart';
import '../screens/panels/spotter_matching_panel.dart';
import '../screens/panels/spotter_tracking_panel.dart';

// Import fallback/standard screens to wrap in our sheet for perfect continuity
import '../screens/home_screen.dart';
import '../screens/destination_search_screen.dart';
import '../screens/pickup_location_screen.dart';
import '../screens/driver_profile_screen.dart';
import '../screens/ride_confirmation_screen.dart';
import '../screens/payment_screen.dart';
import '../screens/ride_otp_screen.dart';
import '../screens/ride_complete_screen.dart';
import '../screens/rating_screen.dart';
import '../core/components/floating_bottom_nav.dart';
import '../design_system/design_system.dart';
import '../screens/services_screen.dart';
import '../screens/activity_screen.dart';
import '../screens/profile_screen.dart';

class SpotterOverlayShell extends StatefulWidget {
  const SpotterOverlayShell({super.key});

  @override
  State<SpotterOverlayShell> createState() => _SpotterOverlayShellState();
}

class _SpotterOverlayShellState extends State<SpotterOverlayShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ll.LatLng _getLatLngForLocation(LocationPoint point) {
    final name = point.title.toLowerCase();
    final detail = point.detail.toLowerCase();

    if (name.contains('station') || name.contains('pune') || detail.contains('pune')) {
      if (name.contains('station')) return const ll.LatLng(18.5284, 73.8739);
      if (name.contains('koregaon')) return const ll.LatLng(18.5362, 73.8930);
      if (name.contains('viman')) return const ll.LatLng(18.5679, 73.9143);
      if (name.contains('wagholi')) return const ll.LatLng(18.5793, 73.9806);
      return const ll.LatLng(18.5204, 73.8567);
    }

    if (name.contains('dadar') || name.contains('mumbai') || detail.contains('mumbai')) {
      return const ll.LatLng(19.0178, 72.8478);
    }

    if (name.contains('citywalk') || name.contains('saket') || detail.contains('saket')) {
      return const ll.LatLng(28.5290, 77.2193);
    }

    if (name.contains('kullar') || name.contains('farms')) {
      return const ll.LatLng(28.4975, 77.1648);
    }

    if (name.contains('promenade') || name.contains('vasant') || detail.contains('vasant')) {
      return const ll.LatLng(28.5425, 77.1561);
    }

    return const ll.LatLng(18.5204, 73.8567); // Fallback Pune
  }



  Widget _buildFlutterMap(RideController ride, bool isDark) {
    final pickupLatLng = _getLatLngForLocation(ride.pickup);
    final destLatLng = _getLatLngForLocation(ride.destination);

    ll.LatLng center = pickupLatLng;
    double zoom = 14.0;

    final showRoute = ride.status != TripStatus.draft && ride.status != TripStatus.cancelled;

    if (showRoute) {
      center = ll.LatLng(
        (pickupLatLng.latitude + destLatLng.latitude) / 2,
        (pickupLatLng.longitude + destLatLng.longitude) / 2,
      );
      zoom = 12.0;
    }

    final tileUrl = isDark
        ? 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
        : 'https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png';

    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: zoom,
        interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
      ),
      children: [
        TileLayer(
          urlTemplate: tileUrl,
          userAgentPackageName: 'com.spotter.app',
        ),
        if (showRoute) ...[
          PolylineLayer(
            polylines: [
              Polyline(
                points: [pickupLatLng, destLatLng],
                color: isDark ? Colors.white : Colors.black,
                strokeWidth: 4.5,
              ),
            ],
          ),
        ],
        MarkerLayer(
          markers: [
            // Pickup marker
            Marker(
              point: pickupLatLng,
              width: 32,
              height: 32,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF05A357).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFF05A357),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            if (showRoute)
              Marker(
                point: destLatLng,
                width: 32,
                height: 32,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white : Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            // Mock driver marker
            if (ride.status == TripStatus.driverAssigned ||
                ride.status == TripStatus.arriving ||
                ride.status == TripStatus.inProgress)
              Marker(
                point: ll.LatLng(
                  pickupLatLng.latitude + 0.003,
                  pickupLatLng.longitude - 0.002,
                ),
                width: 36,
                height: 36,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white : Colors.black,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? Colors.black : Colors.white,
                      width: 1.5,
                    ),
                    boxShadow: Helper.premiumShadows,
                  ),
                  child: Icon(
                    CupertinoIcons.car_detailed,
                    color: isDark ? Colors.black : Colors.white,
                    size: 18,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  // ── Floating top bar (SPOTT navigation) ──────────────────
  Widget _buildFloatingTopBar(RideController ride, bool isDark) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Profile Button
            _FloatingCircleButton(
              isDark: isDark,
              onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
              child: Text(
                'R',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Non-home floating action buttons (back + theme toggle) ────────────────
  Widget _buildNonHomeActions(RideController ride, bool isDark) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _FloatingCircleButton(
              isDark: isDark,
              onTap: () => Navigator.maybePop(context),
              child: Icon(
                CupertinoIcons.arrow_left,
                color: isDark ? Colors.white : Colors.black,
                size: 18,
              ),
            ),
            _FloatingCircleButton(
              isDark: isDark,
              onTap: () => ride.toggleDarkMode(),
              child: Icon(
                ride.isDarkMode ? CupertinoIcons.sun_max_fill : CupertinoIcons.moon_fill,
                color: isDark ? const Color(0xFFFACC15) : Colors.black,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;
    final routeName = ModalRoute.of(context)?.settings.name ?? '/home';
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;

    Widget activePanel;
    bool isFullScreenPanel = false;
    final isHome = routeName == '/home' || routeName == '/';

    if (isHome) {
      final role = ride.currentUserRole;
      final tabIndex = ride.activeTabIndex;
      Widget? tabBody;
      bool showMapAndHomeLayout = false;

      switch (tabIndex) {
        case 0:
          tabBody = const HomeScreen();
          showMapAndHomeLayout = false;
          break;
        case 1:
          tabBody = const ServicesScreen();
          break;
        case 2:
          tabBody = const ActivityScreen();
          break;
        case 3:
          tabBody = const ProfileScreen();
          break;
        default:
          tabBody = const HomeScreen();
          showMapAndHomeLayout = false;
      }

      if (!showMapAndHomeLayout) {
        return Scaffold(
          backgroundColor: isDark ? Colors.black : const Color(0xFFE4DCDF),
          body: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 96),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      ));
                      return SlideTransition(
                        position: offsetAnimation,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: SizedBox(
                      key: ValueKey<String>('${role.name}_$tabIndex'),
                      child: tabBody,
                    ),
                  ),
                ),
              ),
              _buildFloatingBottomNav(context, ride, tabIndex, palette),
            ],
          ),
        );
      }
    }

    // Map active route to corresponding sheet panel/screen
    switch (routeName) {
      case '/home':
      case '/':
        activePanel = const SpotterHomePanel();
        break;
      case '/pickup':
        activePanel = const PickupLocationScreen();
        isFullScreenPanel = true;
        break;
      case '/destination':
        activePanel = const DestinationSearchScreen();
        isFullScreenPanel = false;
        break;
      case '/fare':
        activePanel = const SpotterFarePanel();
        break;
      case '/drivers':
        activePanel = const SpotterMatchingPanel();
        break;
      case '/driver-profile':
        activePanel = const DriverProfileScreen();
        isFullScreenPanel = true;
        break;
      case '/confirm-ride':
        activePanel = const RideConfirmationScreen();
        break;
      case '/payment':
        activePanel = const PaymentScreen();
        break;
      case '/tracking':
        activePanel = const SpotterTrackingPanel();
        break;
      case '/ride-otp':
        activePanel = const RideOtpScreen();
        break;
      case '/ride-complete':
        activePanel = const RideCompleteScreen();
        isFullScreenPanel = true;
        break;
      case '/rating':
        activePanel = const RatingScreen();
        isFullScreenPanel = true;
        break;
      default:
        activePanel = const SpotterHomePanel();
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? Colors.black : const Color(0xFFE4DCDF),
      body: Stack(
        children: [
          // 1. Persistent Interactive Map (full screen)
          Positioned.fill(
            child: _buildFlutterMap(ride, isDark),
          ),

          // 2. Home overlay: floating top bar (menu | tabs | profile)
          if (isHome)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildFloatingTopBar(ride, isDark),
            ),

          // 3. Non-home overlay: back + theme toggle
          if (!isHome)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildNonHomeActions(ride, isDark),
            ),

          // 4. SOS / Safety Button (during active trip)
          if (ride.status == TripStatus.driverAssigned ||
              ride.status == TripStatus.arriving ||
              ride.status == TripStatus.inProgress ||
              routeName == '/tracking' ||
              routeName == '/ride-otp' ||
              routeName == '/active-trip')
            Positioned(
              top: MediaQuery.paddingOf(context).top + 14,
              right: 80,
              child: _FloatingCircleButton(
                isDark: isDark,
                onTap: () => Navigator.pushNamed(context, AppRoutes.safetyToolkit),
                backgroundColor: const Color(0xFFE60023),
                child: const Icon(
                  CupertinoIcons.shield_fill,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),

          // 5. Bottom Sheet Panel
          if (isHome)
            activePanel
          else
            Align(
              alignment: Alignment.bottomCenter,
              child: isFullScreenPanel
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.88,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF121212) : Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        boxShadow: Helper.premiumShadows,
                      ),
                      child: activePanel,
                    )
                  : activePanel,
            ),

          // 6. Floating Bottom Nav (home only)
          if (isHome)
            _buildFloatingBottomNav(context, ride, ride.activeTabIndex, palette),
        ],
      ),
    );
  }

  Widget _buildFloatingBottomNav(
    BuildContext context,
    RideController ride,
    int currentIndex,
    DSColorPalette palette,
  ) {
    final isDark = ride.isDarkMode;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Positioned(
      bottom: bottomPadding + 12.0, // Dynamic float offset
      left: 16,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: isDark ? const Color(0xFF29413B) : const Color(0xFFEEEEEE),
            width: 1.0,
          ),
        ),
        child: FloatingBottomNav(
          currentIndex: currentIndex,
          onTap: (index) => ride.switchTab(index),
        ),
      ),
    );
  }
}

// ── Reusable floating circle action button ──────────────────────────────────
class _FloatingCircleButton extends StatelessWidget {
  final Widget child;
  final bool isDark;
  final VoidCallback onTap;
  final Color? backgroundColor;

  const _FloatingCircleButton({
    required this.child,
    required this.isDark,
    required this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: backgroundColor ?? (isDark ? const Color(0xFF1E1E1E) : Colors.white),
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 12,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}

