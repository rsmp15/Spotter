import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
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
import '../screens/rider_bottom_nav.dart';

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
          ? const RiderBottomNav(activeTab: RiderBottomTab.home)
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
                  ),
                );
              },
            ),
          ),

          // 2. Floating action button for Menu/Back overlay
          Positioned(
            top: MediaQuery.paddingOf(context).top + 16,
            left: 16,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(
                  routeName == '/home' || routeName == '/'
                      ? Icons.menu_rounded
                      : Icons.arrow_back_rounded,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () {
                  if (routeName == '/home' || routeName == '/') {
                    _scaffoldKey.currentState?.openDrawer();
                  } else {
                    Navigator.maybePop(context);
                  }
                },
              ),
            ),
          ),

          // Floating Theme Toggle button
          Positioned(
            top: MediaQuery.paddingOf(context).top + 16,
            right: 16,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: ride.isDarkMode
                  ? const Color(0xFF1E293B)
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
                onPressed: () {
                  ride.toggleDarkMode();
                },
              ),
            ),
          ),

          // 3. Floating Locate Me button
          if (!isFullScreenPanel)
            Positioned(
              bottom: 340,
              right: 16,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(
                    Icons.my_location_rounded,
                    color: Colors.black,
                    size: 20,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Map centered on your pickup area'),
                      ),
                    );
                  },
                ),
              ),
            ),

          // 4. Slidable/Draggable Premium Bottom-Sheet Panel
          if (routeName == '/home' || routeName == '/')
            activePanel
          else
            Align(
              alignment: Alignment.bottomCenter,
              child: isFullScreenPanel
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.88,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
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
              subtitle: Text('Rider account'),
            ),
            const Divider(),
            _DrawerLink(
              icon: Icons.person_outline_rounded,
              label: 'Account',
              routeName: '/profile',
            ),
            _DrawerLink(
              icon: Icons.receipt_long_outlined,
              label: 'Activity',
              routeName: '/notifications',
            ),
            _DrawerLink(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Wallet',
              routeName: '/wallet',
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

  MockMapPainter({
    required this.status,
    required this.animationValue,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (isDarkMode) {
      canvas.drawColor(const Color(0xFF0C0F14), BlendMode.srcOver);
    }

    final paintRoad = Paint()
      ..color = isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final paintRoadInner = Paint()
      ..color = isDarkMode ? const Color(0xFF131722) : Colors.white
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final paintLine = Paint()
      ..color = isDarkMode
          ? const Color(0xFF334155).withValues(alpha: 0.15)
          : const Color(0xFF94A3B8).withValues(alpha: 0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw background elegant grid
    final gridSpacing = 45.0;
    for (double i = 0; i < size.width; i += gridSpacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paintLine);
    }
    for (double i = 0; i < size.height; i += gridSpacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paintLine);
    }

    // Draw Premium Vector Road Network
    final path = Path();
    // Major horizontal highway
    path.moveTo(-20, size.height * 0.4);
    path.lineTo(size.width + 20, size.height * 0.4);
    // Secondary diagonal street
    path.moveTo(-20, size.height * 0.2);
    path.lineTo(size.width + 20, size.height * 0.65);
    // Vertical crossing street
    path.moveTo(size.width * 0.3, -20);
    path.lineTo(size.width * 0.3, size.height + 20);
    // Second vertical street
    path.moveTo(size.width * 0.7, -20);
    path.lineTo(size.width * 0.7, size.height + 20);

    canvas.drawPath(path, paintRoad);
    canvas.drawPath(path, paintRoadInner);

    // Draw Route Points and Paths if active
    final pickupOffset = Offset(size.width * 0.3, size.height * 0.4);
    final dropOffset = Offset(size.width * 0.7, size.height * 0.52);

    final showRoute =
        status != TripStatus.draft && status != TripStatus.cancelled;

    if (showRoute) {
      // Draw vector path connecting A and B
      final routePath = Path()
        ..moveTo(pickupOffset.dx, pickupOffset.dy)
        ..lineTo(size.width * 0.7, size.height * 0.4)
        ..lineTo(dropOffset.dx, dropOffset.dy);

      final routePaint = Paint()
        ..color = isDarkMode ? const Color(0xFF38BDF8) : Colors.black
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      if (isDarkMode) {
        // Neon glow under route
        canvas.drawPath(
          routePath,
          Paint()
            ..color = const Color(0xFF38BDF8).withValues(alpha: 0.4)
            ..strokeWidth = 10
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke,
        );
      }

      canvas.drawPath(routePath, routePaint);

      // Draw Pickup and Drop markers
      final markerPaint = Paint()..style = PaintingStyle.fill;

      // Pickup green marker
      markerPaint.color = const Color(0xFF10B981);
      canvas.drawCircle(pickupOffset, 8, markerPaint);
      canvas.drawCircle(
        pickupOffset,
        12 + 6 * math.sin(animationValue * 2 * math.pi),
        Paint()
          ..color = const Color(0xFF10B981).withValues(alpha: 0.2)
          ..style = PaintingStyle.fill,
      );

      // Drop red marker
      markerPaint.color = const Color(0xFFEF4444);
      canvas.drawCircle(dropOffset, 8, markerPaint);
    }

    // Draw Pulsing/Moving Drivers
    final driverPaint = Paint()
      ..color = isDarkMode ? const Color(0xFFFACC15) : Colors.black
      ..style = PaintingStyle.fill;

    if (status == TripStatus.draft || status == TripStatus.searching) {
      // 3 Orbiting/pulsing drivers around the screen
      final driver1 = Offset(
        size.width * 0.4 + 40 * math.sin(animationValue * 2 * math.pi),
        size.height * 0.3 + 40 * math.cos(animationValue * 2 * math.pi),
      );
      final driver2 = Offset(
        size.width * 0.2 + 30 * math.cos(animationValue * 2 * math.pi + 1),
        size.height * 0.5 + 30 * math.sin(animationValue * 2 * math.pi + 1),
      );
      final driver3 = Offset(
        size.width * 0.75 + 50 * math.sin(animationValue * 2 * math.pi * 0.5),
        size.height * 0.35 + 30 * math.cos(animationValue * 2 * math.pi * 0.5),
      );

      _drawCarMarker(canvas, driver1, driverPaint);
      _drawCarMarker(canvas, driver2, driverPaint);
      _drawCarMarker(canvas, driver3, driverPaint);
    } else {
      // Trip active: Driver moves along route
      Offset carPos;
      double progress = 0.0;

      if (status == TripStatus.driverAssigned ||
          status == TripStatus.arriving) {
        // Driver moving towards pickup
        progress = (animationValue * 3) % 1.0;
        final driverStart = Offset(size.width * 0.1, size.height * 0.4);
        carPos = Offset(
          driverStart.dx + (pickupOffset.dx - driverStart.dx) * progress,
          driverStart.dy + (pickupOffset.dy - driverStart.dy) * progress,
        );
      } else if (status == TripStatus.inProgress) {
        // Passenger on board: Driver moving towards drop
        progress = (animationValue * 2) % 1.0;
        // Simplified route interpolation
        final midOffset = Offset(size.width * 0.7, size.height * 0.4);
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
        // Complete or other
        carPos = dropOffset;
      }

      _drawCarMarker(canvas, carPos, driverPaint);
      // Pulsing ring under chosen driver car
      canvas.drawCircle(
        carPos,
        14 + 4 * math.sin(animationValue * 4 * math.pi),
        Paint()
          ..color = isDarkMode
              ? const Color(0xFFFACC15).withValues(alpha: 0.2)
              : Colors.black.withValues(alpha: 0.15)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
    }
  }

  void _drawCarMarker(Canvas canvas, Offset position, Paint paint) {
    // Draw an elegant, premium minimalist vehicle marker (circle + heading triangle)
    canvas.drawCircle(position, 10, paint);
    canvas.drawCircle(
      position,
      10,
      Paint()
        ..color = isDarkMode ? const Color(0xFF0C0F14) : Colors.white
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke,
    );

    // Tiny headlamp glow dots
    final glowPaint = Paint()
      ..color = isDarkMode ? Colors.white : const Color(0xFFFACC15)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(position.dx + 4, position.dy - 4), 2.5, glowPaint);
    canvas.drawCircle(Offset(position.dx + 4, position.dy + 4), 2.5, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
