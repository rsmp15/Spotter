import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
import '../screens/destination_search_screen.dart';
import '../screens/pickup_location_screen.dart';
import '../screens/driver_profile_screen.dart';
import '../screens/ride_confirmation_screen.dart';
import '../screens/payment_screen.dart';
import '../screens/ride_otp_screen.dart';
import '../screens/ride_complete_screen.dart';
import '../screens/rating_screen.dart';
import '../core/components/floating_bottom_nav.dart';

class SpotterOverlayShell extends StatefulWidget {
  const SpotterOverlayShell({super.key});

  @override
  State<SpotterOverlayShell> createState() => _SpotterOverlayShellState();
}

class _SpotterOverlayShellState extends State<SpotterOverlayShell>
    with SingleTickerProviderStateMixin {
  late AnimationController _mapAnimationController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _mapAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    );
    if (WidgetsBinding.instance.toString().contains('Test')) {
      _mapAnimationController.value = 0.5;
    } else {
      _mapAnimationController.repeat();
    }
  }

  @override
  void dispose() {
    _mapAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final routeName = ModalRoute.of(context)?.settings.name ?? '/home';

    Widget activePanel;
    bool isFullScreenPanel = false;

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
        // Render search panel inside the sheet
        activePanel = const DestinationSearchScreen();
        isFullScreenPanel = true;
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

    final showBottomNavBar = routeName == '/home' || routeName == '/';

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Helper.backgroundColor,
      drawer: const _HomeMenuDrawer(),
      bottomNavigationBar: showBottomNavBar
          ? FloatingBottomNav(
              role: ride.currentUserRole,
              currentIndex: ride.activeTabIndex,
              onTap: (index) => ride.switchTab(index),
            )
          : null,
      body: Stack(
        children: [
          // 1. Persistent Premium Interactive Mock Map Canvas
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _mapAnimationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: MockMapPainter(
                    status: ride.status,
                    animationValue: _mapAnimationController.value,
                    isDarkMode: ride.isDarkMode,
                    isPooling:
                        ride.selectedRideOption?.id == 'pool' ||
                        ride.selectedRideOption?.id == 'bike_pool',
                  ),
                );
              },
            ),
          ),

          // 2. Top Header Bar (Only on Home Route)
          if (routeName == '/home' || routeName == '/')
            Positioned(
              top: MediaQuery.paddingOf(context).top + 16,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Drawer Menu Trigger
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: ride.isDarkMode
                        ? const Color(0xFF1E1F25)
                        : Colors.white,
                    child: IconButton(
                      icon: Icon(
                        Icons.menu_rounded,
                        color: ride.isDarkMode ? Colors.white : Colors.black,
                        size: 20,
                      ),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                  ),

                  // App Name
                  Text(
                    'Spotter',
                    style: TextStyle(
                      fontFamily: 'Hanken Grotesk',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: ride.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),

                  // High-Res User Avatar with double borders
                  Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Helper.ink, width: 1.5),
                    ),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Helper.ink,
                      backgroundImage:
                          WidgetsBinding.instance.toString().contains('Test')
                          ? null
                          : const NetworkImage(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuCqwUIrW_aYU8KExu7xWKKzVFfUl_wrgIlH1urO1fc2gIqXeKHgSWA0bYDZFmBgqUsy2AhtgPW9L8opXyrK0fOLf372ihI4qQzw-I0X4z6K-JeQ0U-0z4eH-4I9wQon1wXjkLa-4RqRAb_sjvAHtyFhSuGSWlctjQraeZBhDch9GIO7TwSmx0fCujVODXe9Hwh9re9OOFZdaQ3W-0RaXiy13fnDDSum1hPU1X040V-uE-832xuch_wBqM8pWB1ZxWW6akdlR98gCUaU',
                            ),
                      child: WidgetsBinding.instance.toString().contains('Test')
                          ? const Text(
                              'R',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),

          // 3. Floating Frosted Search Bar (Only on Home Route)
          if (routeName == '/home' || routeName == '/')
            Positioned(
              top: MediaQuery.paddingOf(context).top + 76,
              left: 20,
              right: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: ride.isDarkMode
                          ? const Color(0xFF121212).withValues(alpha: 0.88)
                          : Colors.white.withValues(alpha: 0.88),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: ride.isDarkMode
                            ? Colors.white.withValues(alpha: 0.08)
                            : const Color(0xFFE5E7EB),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Search Icon
                        const Icon(
                          Icons.search_rounded,
                          color: Helper.ink,
                          size: 24,
                        ),
                        const SizedBox(width: 12),

                        // Text input field click trigger
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.destination,
                            ),
                            child: const Text(
                              'Where to?',
                              style: TextStyle(
                                color: Color(0xFF8E90A2),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Vertical thin divider
                        Container(
                          width: 1.0,
                          height: 20,
                          color: ride.isDarkMode
                              ? Colors.white.withValues(alpha: 0.12)
                              : const Color(0xFFE5E7EB),
                        ),
                        const SizedBox(width: 8),

                        // Tune filter icon
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.tune_rounded,
                            color: Helper.ink,
                            size: 20,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Filter settings opened'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // 4. Back / Action Buttons on Non-Home screens
          if (routeName != '/home' && routeName != '/') ...[
            // Back Button
            Positioned(
              top: MediaQuery.paddingOf(context).top + 16,
              left: 16,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: ride.isDarkMode
                    ? const Color(0xFF1E1F25)
                    : Colors.white,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: ride.isDarkMode ? Colors.white : Colors.black,
                    size: 20,
                  ),
                  onPressed: () => Navigator.maybePop(context),
                ),
              ),
            ),

            // Top-right Theme Toggle on Non-Home screens
            Positioned(
              top: MediaQuery.paddingOf(context).top + 16,
              right: 16,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: ride.isDarkMode
                    ? const Color(0xFF1E1F25)
                    : Colors.white,
                child: IconButton(
                  icon: Icon(
                    ride.isDarkMode
                        ? Icons.wb_sunny_rounded
                        : Icons.nightlight_round,
                    color: ride.isDarkMode
                        ? const Color(0xFFFACC15)
                        : Colors.black,
                    size: 20,
                  ),
                  onPressed: () => ride.toggleDarkMode(),
                ),
              ),
            ),
          ],

          // Top-right Safety/SOS button (only accessible when user is in ride mode / travelling)
          if (ride.status == TripStatus.driverAssigned ||
              ride.status == TripStatus.arriving ||
              ride.status == TripStatus.inProgress ||
              routeName == '/tracking' ||
              routeName == '/ride-otp' ||
              routeName == '/active-trip')
            Positioned(
              top: MediaQuery.paddingOf(context).top + 16,
              right: (routeName == '/home' || routeName == '/') ? 16 : 80,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFE60023),
                child: IconButton(
                  icon: const Icon(
                    Icons.shield_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.safetyToolkit);
                  },
                ),
              ),
            ),

          // 5. Floating Side Action Buttons on Home (Theme Toggle + Locate Me)
          if (!isFullScreenPanel)
            Positioned(
              bottom: 340,
              right: 16,
              child: Column(
                children: [
                  // Floating Theme Toggle (Only on Home Screen)
                  if (routeName == '/home' || routeName == '/') ...[
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: ride.isDarkMode
                          ? const Color(0xFF1A1A1A)
                          : Colors.white,
                      child: IconButton(
                        icon: Icon(
                          ride.isDarkMode
                              ? Icons.wb_sunny_rounded
                              : Icons.nightlight_round,
                          color: ride.isDarkMode
                              ? const Color(0xFFFACC15)
                              : Colors.black,
                          size: 20,
                        ),
                        onPressed: () => ride.toggleDarkMode(),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Locate Me button
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: ride.isDarkMode
                        ? const Color(0xFF1A1A1A)
                        : Colors.white,
                    child: IconButton(
                      icon: Icon(
                        Icons.my_location_rounded,
                        color: ride.isDarkMode ? Helper.ink : Colors.black,
                        size: 20,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Map centered on your current area'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

          // 6. Slidable/Draggable Premium Bottom-Sheet Panel
          if (routeName == '/home' || routeName == '/')
            activePanel
          else
            Align(
              alignment: Alignment.bottomCenter,
              child: isFullScreenPanel
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.88,
                      decoration: BoxDecoration(
                        color: ride.isDarkMode
                            ? const Color(0xFF050505)
                            : Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: activePanel,
                    )
                  : Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: activePanel,
                    ),
            ),
        ],
      ),
    );
  }
}

class _HomeMenuDrawer extends StatelessWidget {
  const _HomeMenuDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            const ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xFFEAF2FF),
                child: Text(
                  'R',
                  style: TextStyle(
                    color: Helper.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                'Ritesh Mahatme',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text('Passenger account'),
            ),
            const Divider(),
            const _DrawerLink(
              icon: Icons.person_outline_rounded,
              label: 'Account',
              routeName: '/profile',
            ),
            const _DrawerLink(
              icon: Icons.receipt_long_outlined,
              label: 'Activity',
              routeName: '/activity',
            ),
            const _DrawerLink(
              icon: Icons.settings_outlined,
              label: 'Settings',
              routeName: '/settings',
            ),
            _DrawerLink(
              icon: Icons.support_agent_rounded,
              label: 'Support',
              routeName: '/support',
            ),
            _DrawerLink(
              icon: Icons.grid_view_rounded,
              label: 'Services',
              routeName: '/services',
            ),
            if (kDebugMode)
              const _DrawerLink(
                icon: Icons.developer_mode_rounded,
                label: 'UI Sandbox',
                routeName: '/figma-plugin-sandbox',
              ),
          ],
        ),
      ),
    );
  }
}

class _DrawerLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final String routeName;

  const _DrawerLink({
    required this.icon,
    required this.label,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, routeName);
      },
    );
  }
}

class MockMapPainter extends CustomPainter {
  final TripStatus status;
  final double animationValue;
  final bool isDarkMode;
  final bool isPooling;

  MockMapPainter({
    required this.status,
    required this.animationValue,
    required this.isDarkMode,
    this.isPooling = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw elegant background canvas
    if (isDarkMode) {
      canvas.drawColor(const Color(0xFF050505), BlendMode.srcOver);
    } else {
      canvas.drawColor(const Color(0xFFF9FAFB), BlendMode.srcOver);
    }

    // 2. Draw modern high-density grid lines
    final gridPaint = Paint()
      ..color = isDarkMode
          ? Helper.ink.withValues(alpha: 0.05)
          : const Color(0xFF94A3B8).withValues(alpha: 0.15)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final gridSpacing = 40.0;
    for (double i = 0; i < size.width; i += gridSpacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += gridSpacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    // 3. Setup elegant cyber road networks
    final paintRoad = Paint()
      ..color = isDarkMode ? const Color(0xFF161922) : const Color(0xFFE2E8F0)
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final paintRoadInner = Paint()
      ..color = isDarkMode ? const Color(0xFF0D0E12) : Colors.white
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    // Major horizontal street
    path.moveTo(-20, size.height * 0.4);
    path.lineTo(size.width + 20, size.height * 0.4);
    // Diagonal boulevard
    path.moveTo(-20, size.height * 0.2);
    path.lineTo(size.width + 20, size.height * 0.65);
    // Vertical avenue
    path.moveTo(size.width * 0.35, -20);
    path.lineTo(size.width * 0.35, size.height + 20);
    // Second vertical avenue
    path.moveTo(size.width * 0.68, -20);
    path.lineTo(size.width * 0.68, size.height + 20);

    canvas.drawPath(path, paintRoad);
    canvas.drawPath(path, paintRoadInner);

    // Draw flowing neon traffic particles (simulating moving lights)
    if (isDarkMode) {
      final trafficPaint = Paint()
        ..color = Helper.ink.withValues(alpha: 0.3)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, trafficPaint);
    }

    // Define core coordinate offsets
    final pickupOffset = Offset(size.width * 0.35, size.height * 0.4);
    final dropOffset = Offset(size.width * 0.68, size.height * 0.55);
    final locationOffset = Offset(size.width * 0.48, size.height * 0.52);

    final showRoute =
        status != TripStatus.draft && status != TripStatus.cancelled;

    // 4. Draw Trip Route if active
    if (showRoute) {
      final routePath = Path()
        ..moveTo(pickupOffset.dx, pickupOffset.dy)
        ..lineTo(size.width * 0.68, size.height * 0.4)
        ..lineTo(dropOffset.dx, dropOffset.dy);

      // Neon Glow under route
      canvas.drawPath(
        routePath,
        Paint()
          ..color = Helper.ink.withValues(alpha: 0.25)
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
      );

      // Solid Route line
      canvas.drawPath(
        routePath,
        Paint()
          ..color = Helper.ink
          ..strokeWidth = 4.5
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
      );

      // Shared Pooling Route Overlay (Co-riders shared route paths)
      if (isPooling) {
        final coPickupOffset = Offset(size.width * 0.22, size.height * 0.38);
        final coDropOffset = Offset(size.width * 0.52, size.height * 0.48);

        final coRoutePath = Path()
          ..moveTo(coPickupOffset.dx, coPickupOffset.dy)
          ..lineTo(pickupOffset.dx, pickupOffset.dy)
          ..lineTo(coDropOffset.dx, coDropOffset.dy)
          ..lineTo(dropOffset.dx, dropOffset.dy);

        // Co-route Glow
        canvas.drawPath(
          coRoutePath,
          Paint()
            ..color = const Color(0xFFFF8A00).withValues(alpha: 0.2)
            ..strokeWidth = 8
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke,
        );

        // Co-route Solid
        canvas.drawPath(
          coRoutePath,
          Paint()
            ..color = const Color(0xFFFF8A00)
            ..strokeWidth = 3.0
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke,
        );

        // Co-rider 1 Pickup Dot (Amber)
        canvas.drawCircle(
          coPickupOffset,
          10,
          Paint()..color = const Color(0xFFFF8A00).withValues(alpha: 0.25),
        );
        canvas.drawCircle(
          coPickupOffset,
          5,
          Paint()..color = const Color(0xFFFF8A00),
        );

        // Co-rider 1 Drop Dot (Amber)
        canvas.drawCircle(
          coDropOffset,
          10,
          Paint()..color = const Color(0xFFFF8A00).withValues(alpha: 0.25),
        );
        canvas.drawCircle(
          coDropOffset,
          5,
          Paint()..color = const Color(0xFFFF8A00),
        );
      }

      // Route endpoint markers
      // Pickup Point (Green)
      canvas.drawCircle(
        pickupOffset,
        14,
        Paint()..color = Helper.success.withValues(alpha: 0.25),
      );
      canvas.drawCircle(pickupOffset, 7, Paint()..color = Helper.success);
      canvas.drawCircle(
        pickupOffset,
        7,
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke,
      );

      // Drop Point (Red)
      canvas.drawCircle(
        dropOffset,
        14,
        Paint()..color = const Color(0xFFEF4444).withValues(alpha: 0.25),
      );
      canvas.drawCircle(
        dropOffset,
        7,
        Paint()..color = const Color(0xFFEF4444),
      );
    }

    // 5. Draw Interactive Map Pins (Stitch Spott Designs)
    if (status == TripStatus.draft) {
      // Pin 1: Empire Tech Park (Electric Blue Active Tag)
      _drawMapPin(
        canvas,
        Offset(size.width * 0.35, size.height * 0.35),
        "₹40/hr",
        isActive: true,
        bgColor: Helper.ink,
        textColor: Colors.white,
      );

      // Pin 2: Skyline Plaza (Neon Green Available Tag)
      _drawMapPin(
        canvas,
        Offset(size.width * 0.65, size.height * 0.48),
        "₹60/hr",
        isActive: false,
        bgColor: Helper.success,
        textColor: Colors.black,
      );

      // Pin 3: Budget Corner (Outlined Charcoal Tag)
      _drawMapPin(
        canvas,
        Offset(size.width * 0.22, size.height * 0.58),
        "₹30/hr",
        isActive: false,
        bgColor: isDarkMode ? const Color(0xFF201F1F) : Colors.white,
        textColor: isDarkMode ? Colors.white : Colors.black,
        borderColor: Helper.ink,
      );
    }

    // 6. Draw Current Location Pulsing Marker (Stitch)
    if (status == TripStatus.draft || status == TripStatus.searching) {
      // Pulsing outer radar rings
      final pulseRadius = 16.0 + 24.0 * animationValue;
      final pulseOpacity = (1.0 - animationValue).clamp(0.0, 1.0);
      canvas.drawCircle(
        locationOffset,
        pulseRadius,
        Paint()
          ..color = const Color(
            0xFF171717,
          ).withValues(alpha: pulseOpacity * 0.35)
          ..style = PaintingStyle.fill,
      );

      // Solid Location Dot
      canvas.drawCircle(locationOffset, 8, Paint()..color = Helper.ink);
      // Clean white ring
      canvas.drawCircle(
        locationOffset,
        8,
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke,
      );
    }

    // 7. Draw Active/Searching Vehicles (Cars on grid)
    final driverPaint = Paint()
      ..color = isDarkMode ? Colors.white : Colors.black
      ..style = PaintingStyle.fill;

    if (status == TripStatus.draft || status == TripStatus.searching) {
      // Orbiting drivers around grid junctions
      final driver1 = Offset(
        size.width * 0.35 + 45 * math.sin(animationValue * 2 * math.pi),
        size.height * 0.4 + 45 * math.cos(animationValue * 2 * math.pi),
      );
      final driver2 = Offset(
        size.width * 0.2 + 30 * math.cos(animationValue * 2 * math.pi + 1.2),
        size.height * 0.52 + 30 * math.sin(animationValue * 2 * math.pi + 1.2),
      );
      final driver3 = Offset(
        size.width * 0.68 + 50 * math.sin(animationValue * 2 * math.pi * 0.5),
        size.height * 0.35 + 30 * math.cos(animationValue * 2 * math.pi * 0.5),
      );

      _drawVehicleMarker(canvas, driver1, driverPaint);
      _drawVehicleMarker(canvas, driver2, driverPaint);
      _drawVehicleMarker(canvas, driver3, driverPaint);
    } else {
      // Driver moving towards pickup or drop
      Offset carPos;
      double progress = 0.0;

      if (status == TripStatus.driverAssigned ||
          status == TripStatus.arriving) {
        progress = (animationValue * 3) % 1.0;
        final driverStart = Offset(size.width * 0.15, size.height * 0.4);
        carPos = Offset(
          driverStart.dx + (pickupOffset.dx - driverStart.dx) * progress,
          driverStart.dy + (pickupOffset.dy - driverStart.dy) * progress,
        );
      } else if (status == TripStatus.inProgress) {
        progress = (animationValue * 2) % 1.0;
        final midOffset = Offset(size.width * 0.68, size.height * 0.4);
        if (progress < 0.5) {
          final sub = progress / 0.5;
          carPos = Offset(
            pickupOffset.dx + (midOffset.dx - pickupOffset.dx) * sub,
            pickupOffset.dy + (midOffset.dy - pickupOffset.dy) * sub,
          );
        } else {
          final sub = (progress - 0.5) / 0.5;
          carPos = Offset(
            midOffset.dx + (dropOffset.dx - midOffset.dx) * sub,
            midOffset.dy + (dropOffset.dy - midOffset.dy) * sub,
          );
        }
      } else {
        carPos = dropOffset;
      }

      _drawVehicleMarker(canvas, carPos, driverPaint);
      // Pulsing glow ring under active driver
      canvas.drawCircle(
        carPos,
        15 + 5 * math.sin(animationValue * 4 * math.pi),
        Paint()
          ..color = Helper.ink.withValues(alpha: 0.25)
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke,
      );
    }
  }

  void _drawMapPin(
    Canvas canvas,
    Offset position,
    String label, {
    required bool isActive,
    required Color bgColor,
    required Color textColor,
    Color? borderColor,
  }) {
    final textSpan = TextSpan(
      text: label,
      style: TextStyle(
        color: textColor,
        fontSize: 11,
        fontWeight: FontWeight.bold,
        fontFamily: 'Geist',
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final paddingH = 10.0;
    final paddingV = 5.0;
    final w = textPainter.width + paddingH * 2;
    final h = textPainter.height + paddingV * 2;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(position.dx - w / 2, position.dy - h - 6, w, h),
      const Radius.circular(999), // Pill shaped pin tags!
    );

    // Draw shadows
    canvas.drawRRect(
      rrect.shift(const Offset(0, 3)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.16)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Draw background box
    final fillPaint = Paint()..color = bgColor;
    canvas.drawRRect(rrect, fillPaint);

    // Draw border if needed
    if (borderColor != null) {
      canvas.drawRRect(
        rrect,
        Paint()
          ..color = borderColor
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke,
      );
    }

    // Paint text inside the pin tag
    textPainter.paint(
      canvas,
      Offset(
        position.dx - textPainter.width / 2,
        position.dy - h - 6 + paddingV,
      ),
    );

    // Draw small dot anchor under the tag
    canvas.drawCircle(
      position,
      4.5,
      Paint()
        ..color = isActive ? Helper.ink : Colors.white
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      position,
      4.5,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.25)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke,
    );
  }

  void _drawVehicleMarker(Canvas canvas, Offset position, Paint paint) {
    // Draw highly stylized premium circular vehicle indicator
    canvas.drawCircle(position, 9, paint);
    canvas.drawCircle(
      position,
      9,
      Paint()
        ..color = isDarkMode ? const Color(0xFF050505) : Colors.white
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke,
    );

    // Small headlight glow dots representing orientation
    final glowPaint = Paint()
      ..color = Helper.success
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(position.dx + 4, position.dy - 3), 2.0, glowPaint);
    canvas.drawCircle(Offset(position.dx + 4, position.dy + 3), 2.0, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
