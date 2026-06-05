import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/spott_models.dart';
import '../theme/redbus_theme.dart';

class FloatingBottomNav extends StatelessWidget {
  final UserRole role;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FloatingBottomNav({
    super.key,
    required this.role,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = role == UserRole.passenger ? _passengerTabs : _travelerTabs;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = currentIndex == index;
              final item = items[index];

              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onTap(index);
                },
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Active indicator bar at top
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 3,
                        width: isSelected ? 28 : 0,
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: RBColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Icon(
                        item.icon,
                        size: 22,
                        color: isSelected
                            ? RBColors.primary
                            : RBColors.textLight,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? RBColors.primary
                              : RBColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  static const List<_NavItem> _passengerTabs = [
    _NavItem(icon: Icons.home_outlined, label: 'Home'),
    _NavItem(icon: Icons.grid_view_rounded, label: 'Services'),
    _NavItem(icon: Icons.route_rounded, label: 'Trips'),
    _NavItem(icon: Icons.shield_outlined, label: 'Safety'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  static const List<_NavItem> _travelerTabs = [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dash'),
    _NavItem(icon: Icons.list_alt_rounded, label: 'Requests'),
    _NavItem(icon: Icons.route_rounded, label: 'Trips'),
    _NavItem(icon: Icons.directions_car_rounded, label: 'Vehicle'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
