import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';

enum DriverBottomTab { home, createAvailability, requests, kyc }

class DriverBottomNav extends StatelessWidget {
  final DriverBottomTab activeTab;

  const DriverBottomNav({super.key, required this.activeTab});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;

    return Material(
      color: isDark ? const Color(0xFF0C0F14) : Colors.white,
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFF2F4F7),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black26 : const Color(0x0D101828),
                blurRadius: 18,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.dashboard_outlined,
                activeIcon: Icons.dashboard,
                isActive: activeTab == DriverBottomTab.home,
                isDark: isDark,
                onTap: () => _switchTab(context, AppRoutes.driverHome),
              ),
              _NavItem(
                icon: Icons.add_circle_outline_rounded,
                activeIcon: Icons.add_circle_rounded,
                isActive: activeTab == DriverBottomTab.createAvailability,
                isDark: isDark,
                onTap: () => _switchTab(context, AppRoutes.createTrip),
              ),
              _NavItem(
                icon: Icons.work_outline_rounded,
                activeIcon: Icons.work_rounded,
                isActive: activeTab == DriverBottomTab.requests,
                isDark: isDark,
                onTap: () => _switchTab(context, AppRoutes.jobRequests),
              ),
              _NavItem(
                icon: Icons.badge_outlined,
                activeIcon: Icons.badge,
                isActive: activeTab == DriverBottomTab.kyc,
                isDark: isDark,
                onTap: () => _switchTab(context, AppRoutes.kyc),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _switchTab(BuildContext context, String routeName) {
    if (ModalRoute.of(context)?.settings.name == routeName) return;
    Navigator.pushReplacementNamed(context, routeName);
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = isDark ? Colors.black : Colors.white;
    final inactiveColor = isDark ? const Color(0xFF64748B) : const Color(0xFF5E5E5E);

    Widget itemContent = Padding(
      padding: const EdgeInsets.all(12),
      child: Icon(
        isActive ? activeIcon : icon,
        color: isActive ? activeColor : inactiveColor,
        size: 26,
      ),
    );

    Widget child;
    if (isActive) {
      child = Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.white : Colors.black,
          shape: BoxShape.circle,
        ),
        child: itemContent,
      );
    } else {
      child = itemContent;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: child,
    );
  }
}
