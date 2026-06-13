import 'package:flutter/material.dart';
import '../../theme/spott_theme.dart';
import '../../widgets/premium/glassmorphism.dart';
import 'premium_explore_screen.dart';
import 'premium_trips_screen.dart';
import 'premium_create_screen.dart';
import 'premium_community_screen.dart';
import 'premium_wallet_screen.dart';

class PremiumNavigationShell extends StatefulWidget {
  const PremiumNavigationShell({super.key});

  @override
  State<PremiumNavigationShell> createState() => _PremiumNavigationShellState();
}

class _PremiumNavigationShellState extends State<PremiumNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const PremiumExploreScreen(),
    const PremiumTripsScreen(),
    const PremiumCreateScreen(),
    const PremiumCommunityScreen(),
    const PremiumWalletScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SpottTheme.background,
      body: Stack(
        children: [
          _screens[_currentIndex],

          // Floating Bottom Navigation Bar
          Positioned(
            bottom: SpottTheme.spacingLarge,
            left: SpottTheme.spacingLarge,
            right: SpottTheme.spacingLarge,
            child: SafeArea(
              child: Listener(
                behavior: HitTestBehavior.opaque,
                child: Glassmorphism(
                  borderRadius: 40,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNavItem(0, Icons.search_rounded, 'Explore'),
                      _buildNavItem(1, Icons.route_outlined, 'Trips'),
                      _buildCreateButton(),
                      _buildNavItem(3, Icons.people_outline, 'Community'),
                      _buildNavItem(
                        4,
                        Icons.account_balance_wallet_outlined,
                        'Wallet',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? SpottTheme.primary : SpottTheme.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: SpottTheme.textTheme.labelMedium?.copyWith(
                color: isSelected ? Colors.white : SpottTheme.textSecondary,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = 2;
        });
      },
      child: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: SpottTheme.primaryGradient,
          boxShadow: SpottTheme.glowingShadow,
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}
