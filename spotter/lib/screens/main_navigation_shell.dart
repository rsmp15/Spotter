import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

import '../controllers/ride_controller.dart';
import '../core/components/floating_bottom_nav.dart';
import '../design_system/design_system.dart';

// Passenger Screens
import 'home_screen.dart';
import 'services_screen.dart';
import 'activity_screen.dart';
import 'profile_screen.dart';

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
          final ride = RideScope.of(context);
          ride.switchTab(widget.initialTab!);
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
          final ride = RideScope.of(context);
          ride.switchTab(widget.initialTab!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;

    final List<Widget> userScreens = const [
      HomeScreen(),
      ServicesScreen(),
      ActivityScreen(),
      ProfileScreen(),
    ];

    final screens = userScreens;

    // Ensure index doesn't crash if it exceeds length
    final safeIndex = ride.activeTabIndex < screens.length ? ride.activeTabIndex : 0;

    final shellBg = (safeIndex == 0 && !isDark)
        ? const Color(0xFFE4DCDF)
        : palette.background;

    return Scaffold(
      backgroundColor: shellBg,
      body: BottomBar(
        layout: BottomBarLayout(
          width: MediaQuery.of(context).size.width - 32, // Floating margin
          offset: MediaQuery.of(context).padding.bottom + 12.0, // Dynamic float offset
          borderRadius: BorderRadius.circular(30),
          respectSafeArea: false, // Turn off safe area stretching to float the bar
        ),
        theme: BottomBarThemeData(
          barDecoration: BoxDecoration(
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
        ),
        body: SizedBox.expand(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            layoutBuilder: (currentChild, previousChildren) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  for (final child in previousChildren)
                    IgnorePointer(
                      ignoring: true,
                      child: child,
                    ),
                  ?currentChild,
                ],
              );
            },
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
        ),
        child: FloatingBottomNav(
          currentIndex: safeIndex,
          onTap: (index) => ride.switchTab(index),
        ),
      ),
    );
  }
}
