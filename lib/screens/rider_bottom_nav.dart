import 'package:flutter/material.dart';

import '../app/app_routes.dart';

enum RiderBottomTab { home, services }

class RiderBottomNav extends StatelessWidget {
  final RiderBottomTab activeTab;

  const RiderBottomNav({super.key, required this.activeTab});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFFF2F4F7))),
            boxShadow: [
              BoxShadow(
                color: Color(0x0D101828),
                blurRadius: 18,
                offset: Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_filled,
                label: 'Home',
                isActive: activeTab == RiderBottomTab.home,
                onTap: () => _switchTab(context, AppRoutes.home),
              ),
              _NavItem(
                icon: Icons.grid_view_rounded,
                label: 'Services',
                isActive: activeTab == RiderBottomTab.services,
                onTap: () => _switchTab(context, AppRoutes.services),
              ),
              _NavItem(
                icon: Icons.receipt_long_outlined,
                label: 'Activity',
                isActive: false,
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.notifications),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                label: 'Account',
                isActive: false,
                onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
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
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? Colors.black : const Color(0xFF98A2B3);

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
