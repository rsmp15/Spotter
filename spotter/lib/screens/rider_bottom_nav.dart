import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';

enum RiderBottomTab { home, services, activity, profile }

class RiderBottomNav extends StatelessWidget {
  final RiderBottomTab activeTab;

  const RiderBottomNav({super.key, required this.activeTab});

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
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                isActive: activeTab == RiderBottomTab.home,
                isDark: isDark,
                onTap: () => _switchTab(context, AppRoutes.home),
              ),
              _NavItem(
                icon: Icons.grid_view_outlined,
                activeIcon: Icons.grid_view_rounded,
                isActive: activeTab == RiderBottomTab.services,
                isDark: isDark,
                onTap: () => _switchTab(context, AppRoutes.services),
              ),
              _NavItem(
                icon: Icons.receipt_long_outlined,
                activeIcon: Icons.receipt_long,
                isActive: activeTab == RiderBottomTab.activity,
                isDark: isDark,
                onTap: () => _switchTab(context, AppRoutes.activity),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                isActive: activeTab == RiderBottomTab.profile,
                isDark: isDark,
                onTap: () => _switchTab(context, AppRoutes.profile),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _switchTab(BuildContext context, String routeName) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final mainRoutes = [
      AppRoutes.home,
      AppRoutes.services,
      AppRoutes.activity,
      AppRoutes.profile,
    ];

    if (mainRoutes.contains(currentRoute)) {
      final ride = RideScope.of(context);
      if (routeName == AppRoutes.home) ride.switchTab(RiderBottomTab.home);
      if (routeName == AppRoutes.services) ride.switchTab(RiderBottomTab.services);
      if (routeName == AppRoutes.activity) ride.switchTab(RiderBottomTab.activity);
      if (routeName == AppRoutes.profile) ride.switchTab(RiderBottomTab.profile);
    } else {
      if (ModalRoute.of(context)?.settings.name == routeName) return;
      Navigator.pushReplacementNamed(context, routeName);
    }
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
