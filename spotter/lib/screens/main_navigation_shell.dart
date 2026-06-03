import 'package:flutter/material.dart';

import '../controllers/ride_controller.dart';
import 'activity_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'rider_bottom_nav.dart';
import 'services_screen.dart';

class MainNavigationShell extends StatefulWidget {
  final RiderBottomTab? initialTab;

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
    final isDark = ride.isDarkMode;

    const screens = [
      HomeScreen(),
      ServicesScreen(),
      ActivityScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0B0B) : const Color(0xFFF9F9F9),
      body: IndexedStack(
        index: ride.activeTab.index,
        children: screens,
      ),
      bottomNavigationBar: RiderBottomNav(activeTab: ride.activeTab),
    );
  }
}
