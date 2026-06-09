import 'package:flutter/material.dart';

import '../controllers/ride_controller.dart';
import '../models/spott_models.dart';
import '../core/components/floating_bottom_nav.dart';

// Passenger Screens
import 'home_screen.dart';
import 'services_screen.dart';
import 'activity_screen.dart';
import 'profile_screen.dart';

// Traveler Screens
import 'driver_home_screen.dart';
import 'passenger_requests_screen.dart';
import 'traveler_trips_screen.dart';
import 'vehicle_management_screen.dart';

class MainNavigationShell extends StatefulWidget {
  final int? initialTab;

  const MainNavigationShell({super.key, this.initialTab});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  @override
  void initState() {
    super.initState();
    if (widget.initialTab != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          RideScope.of(context).switchTab(widget.initialTab!);
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant MainNavigationShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTab != null && widget.initialTab != oldWidget.initialTab) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          RideScope.of(context).switchTab(widget.initialTab!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final role = ride.currentUserRole;

    final List<Widget> passengerScreens = const [
      HomeScreen(),
      ServicesScreen(),
      ActivityScreen(), // Passenger Trips
      ProfileScreen(),
    ];

    final List<Widget> travelerScreens = const [
      DriverHomeScreen(),
      PassengerRequestsScreen(),
      TravelerTripsScreen(),
      VehicleManagementScreen(),
      ProfileScreen(),
    ];

    final screens = role == UserRole.passenger ? passengerScreens : travelerScreens;

    // Ensure index doesn't crash if it exceeds length
    final safeIndex = ride.activeTabIndex < screens.length ? ride.activeTabIndex : 0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.05),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: KeyedSubtree(
              key: ValueKey<int>(safeIndex),
              child: screens[safeIndex],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FloatingBottomNav(
              role: role,
              currentIndex: safeIndex,
              onTap: (index) => ride.switchTab(index),
            ),
          ),
        ],
      ),
    );
  }
}
