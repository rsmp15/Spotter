import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../design_system/design_system.dart';
class FloatingBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FloatingBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = _passengerTabs;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;

    return Container(
      height: 64, // Sleek height
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(items.length, (index) {
          final isSelected = currentIndex == index;
          final item = items[index];

          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onTap(index);
            },
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              height: isSelected ? 40 : 48,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 18 : 12,
              ),
              decoration: BoxDecoration(
                color: isSelected ? palette.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSelected ? item.activeCupertinoIcon : item.inactiveCupertinoIcon,
                    size: 22,
                    color: isSelected ? palette.background : palette.textSecondary,
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: palette.background,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  static const List<_NavItem> _passengerTabs = [
    _NavItem(
      label: 'Home',
      activeCupertinoIcon: CupertinoIcons.house_fill,
      inactiveCupertinoIcon: CupertinoIcons.house,
    ),
    _NavItem(
      label: 'Services',
      activeCupertinoIcon: CupertinoIcons.square_grid_2x2_fill,
      inactiveCupertinoIcon: CupertinoIcons.square_grid_2x2,
    ),
    _NavItem(
      label: 'Trips',
      activeCupertinoIcon: CupertinoIcons.clock_fill,
      inactiveCupertinoIcon: CupertinoIcons.clock,
    ),
    _NavItem(
      label: 'Profile',
      activeCupertinoIcon: CupertinoIcons.person_fill,
      inactiveCupertinoIcon: CupertinoIcons.person,
    ),
  ];
}

class _NavItem {
  final String label;
  final IconData activeCupertinoIcon;
  final IconData inactiveCupertinoIcon;

  const _NavItem({
    required this.label,
    required this.activeCupertinoIcon,
    required this.inactiveCupertinoIcon,
  });
}
