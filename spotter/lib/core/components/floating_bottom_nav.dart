import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/spott_models.dart';
import '../theme/colors.dart';
import '../theme/radius.dart';
import '../theme/spacing.dart';
import '../theme/shadows.dart';

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
    const activeColor = SpottColors.primary;
    const inactiveColor = SpottColors.textTertiary;

    return Padding(
      padding: const EdgeInsets.only(
        left: SpottSpacing.md,
        right: SpottSpacing.md,
        bottom: SpottSpacing.md,
      ),
      child: Container(
        height: 82,
        decoration: BoxDecoration(
          color: SpottColors.backgroundElevated,
          borderRadius: BorderRadius.circular(SpottRadius.nav), // 30
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
          boxShadow: SpottShadows.navFloat,
        ),
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
                height: 72,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ── Icon with optional red glow halo ──
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? const Color(0x33E60023)
                            : Colors.transparent,
                        boxShadow: isSelected
                            ? SpottShadows.navGlowRed
                            : null,
                      ),
                      child: Center(
                        child: Icon(
                          item.icon,
                          size: 22,
                          color: isSelected ? activeColor : inactiveColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? activeColor : inactiveColor,
                        fontFamily: 'Inter',
                      ),
                    ),
                    // Active indicator dot
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      margin: const EdgeInsets.only(top: 3),
                      width: isSelected ? 4 : 0,
                      height: isSelected ? 4 : 0,
                      decoration: BoxDecoration(
                        color: activeColor,
                        shape: BoxShape.circle,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: activeColor.withValues(alpha: 0.4),
                                  blurRadius: 6,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  static const List<_NavItem> _passengerTabs = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.search_rounded, label: 'Search'),
    _NavItem(icon: Icons.route_rounded, label: 'Trips'),
    _NavItem(icon: Icons.shield_rounded, label: 'Safety'),
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
