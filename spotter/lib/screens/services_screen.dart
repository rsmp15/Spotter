import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../helper.dart';
import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';
import '../core/components/marketplace_card.dart';
import '../spotter_widgets.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final colors = _ServiceColors(ride.isDarkMode);

    return Scaffold(
      backgroundColor: colors.background,
      drawer: const SpotterMenuDrawer(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: SpottSpacing.lg,
            vertical: SpottSpacing.lg,
          ),
          children: [
            _buildHeader(context, colors),
            const SizedBox(height: SpottSpacing.xl),
            _buildHeroSearch(context, colors),
            const SizedBox(height: SpottSpacing.xl),
            _buildServiceGrid(context, colors),
            const SizedBox(height: SpottSpacing.xl),
            _buildFeaturedServices(context, colors),
            const SizedBox(height: SpottSpacing.xl),
            _buildActivitySection(context, colors),
            const SizedBox(height: SpottSpacing.xl),
            _buildUtilitiesSection(context, colors),
            const SizedBox(height: SpottSpacing.xl),
            _buildPremiumBanner(context, colors),
            const SizedBox(height: SpottSpacing.xl),
            _buildBecomeTravelerBanner(context, colors),
            const SizedBox(height: SpottSpacing.pageBottom),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, _ServiceColors colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.menu_rounded, color: colors.text, size: 28),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            const SizedBox(width: SpottSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Services',
                  style: SpottTextStyles.headline.copyWith(
                    color: colors.text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Travel • Parcel • Community',
                  style: SpottTextStyles.caption.copyWith(
                    color: colors.subtleText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          tooltip: 'Wallet',
          icon: Icon(Icons.account_balance_wallet_rounded, color: colors.text),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.wallet),
        ),
      ],
    );
  }

  Widget _buildHeroSearch(BuildContext context, _ServiceColors colors) {
    return _MarketCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search Trips & Services',
            style: SpottTextStyles.title.copyWith(
              color: colors.text,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: SpottSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSearchCategory('🔍 Find Ride'),
              _buildSearchCategory('📦 Send Parcel'),
              _buildSearchCategory('🚗 Offer Trip'),
            ],
          ),
          const SizedBox(height: SpottSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.destination),
              style: ElevatedButton.styleFrom(
                backgroundColor: SpottColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: SpottSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text('Search', style: SpottTextStyles.titleSmall),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCategory(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: SpottColors.surface2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: SpottColors.border),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: SpottColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildServiceGrid(BuildContext context, _ServiceColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _GridItem(
                title: 'Find Trip',
                subtitle: '1,240 active rides',
                icon: Icons.directions_car_rounded,
                accentColor: SpottColors.primary,
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.destination),
              ),
            ),
            const SizedBox(width: SpottSpacing.md),
            Expanded(
              child: _GridItem(
                title: 'Offer Trip',
                subtitle: 'Earn ₹800 avg',
                icon: Icons.add_road_rounded,
                accentColor: SpottColors.success,
                onTap: () => Navigator.pushNamed(context, AppRoutes.createTrip),
              ),
            ),
          ],
        ),
        const SizedBox(height: SpottSpacing.md),
        Row(
          children: [
            Expanded(
              child: _GridItem(
                title: 'Send Parcel',
                subtitle: '300 deliveries today',
                icon: Icons.inventory_2_outlined,
                accentColor: SpottColors.warning,
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.parcelBooking),
              ),
            ),
            const SizedBox(width: SpottSpacing.md),
            Expanded(
              child: _GridItem(
                title: 'Nearby',
                subtitle: '42 travelers nearby',
                icon: Icons.people_outline_rounded,
                accentColor: SpottColors.accentPurple,
                onTap: () => Navigator.pushNamed(context, AppRoutes.activity),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeaturedServices(BuildContext context, _ServiceColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Featured This Week', style: SpottTextStyles.headline),
        const SizedBox(height: SpottSpacing.md),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              _buildFeaturedCard(
                title: 'Ride Sharing',
                label1: 'Save up to ₹1200',
                label2: '12k active travelers',
                icon: Icons.directions_car_filled_outlined,
                color: SpottColors.primary,
              ),
              const SizedBox(width: SpottSpacing.md),
              _buildFeaturedCard(
                title: 'Parcel Delivery',
                label1: 'Starting ₹99',
                label2: '99% success rate',
                icon: Icons.local_shipping_outlined,
                color: SpottColors.accentPurple,
              ),
              const SizedBox(width: SpottSpacing.md),
              _buildFeaturedCard(
                title: 'Group Travel',
                label1: 'Weekend trips',
                label2: 'College routes',
                icon: Icons.group_outlined,
                color: SpottColors.success,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard({
    required String title,
    required String label1,
    required String label2,
    required IconData icon,
    required Color color,
  }) {
    return SizedBox(
      width: 200,
      child: _MarketCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: SpottTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              label1,
              style: SpottTextStyles.label.copyWith(
                color: SpottColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label2,
              style: SpottTextStyles.caption.copyWith(
                color: SpottColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitySection(BuildContext context, _ServiceColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Your Activity', style: SpottTextStyles.headline),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.activity),
              child: const Text(
                'See All',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: SpottSpacing.xs),
        Row(
          children: [
            Expanded(
              child: _MarketCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Upcoming Ride',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: SpottColors.primary,
                          ),
                        ),
                        Icon(
                          Icons.directions_car_rounded,
                          color: SpottColors.primary,
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: SpottSpacing.sm),
                    Text(
                      'Kolhapur → Pune',
                      style: SpottTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tomorrow • 9:00 AM',
                      style: SpottTextStyles.caption.copyWith(
                        color: SpottColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: SpottSpacing.md),
            Expanded(
              child: _MarketCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Send Parcel',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: SpottColors.accentPurple,
                          ),
                        ),
                        Icon(
                          Icons.inventory_2_rounded,
                          color: SpottColors.accentPurple,
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: SpottSpacing.sm),
                    Text(
                      'Package Delivered',
                      style: SpottTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '2 hrs ago',
                      style: SpottTextStyles.caption.copyWith(
                        color: SpottColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUtilitiesSection(BuildContext context, _ServiceColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Utilities', style: SpottTextStyles.headline),
        const SizedBox(height: SpottSpacing.md),
        _UtilityRow(
          icon: Icons.account_balance_wallet_rounded,
          title: 'Wallet',
          subtitle: 'Review payments and transactions',
          onTap: () => Navigator.pushNamed(context, AppRoutes.wallet),
        ),
        const SizedBox(height: SpottSpacing.sm),
        _UtilityRow(
          icon: Icons.shield_rounded,
          title: 'Safety Toolkit',
          subtitle: 'Trip sharing, help, and support',
          onTap: () => Navigator.pushNamed(context, AppRoutes.safetyToolkit),
        ),
        const SizedBox(height: SpottSpacing.sm),
        _UtilityRow(
          icon: Icons.person_rounded,
          title: 'Profile',
          subtitle: 'Account details and preferences',
          onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
        ),
        const SizedBox(height: SpottSpacing.sm),
        _UtilityRow(
          icon: Icons.support_agent_rounded,
          title: 'Support',
          subtitle: 'Get help and resolve issues',
          onTap: () => Navigator.pushNamed(context, AppRoutes.support),
        ),
        const SizedBox(height: SpottSpacing.sm),
        _UtilityRow(
          icon: Icons.notifications_rounded,
          title: 'Notifications',
          subtitle: 'Check alerts and messages',
          onTap: () {},
        ),
        const SizedBox(height: SpottSpacing.sm),
        _UtilityRow(
          icon: Icons.share_rounded,
          title: 'Invite Friends',
          subtitle: 'Share Spott and get rewards',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildPremiumBanner(BuildContext context, _ServiceColors colors) {
    return MarketplaceCard(
      onTap: () {},
      borderRadius: 24,
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(SpottSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SPOTT Premium',
                    style: SpottTextStyles.titleSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: SpottSpacing.xs),
                  Text(
                    'Priority support • Early trip access • Exclusive discounts',
                    style: SpottTextStyles.caption.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: SpottSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Learn More',
                style: SpottTextStyles.label.copyWith(
                  color: const Color(0xFF6D28D9),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBecomeTravelerBanner(
    BuildContext context,
    _ServiceColors colors,
  ) {
    return MarketplaceCard(
      onTap: () => Navigator.pushNamed(context, AppRoutes.kyc),
      borderRadius: 24,
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(SpottSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [SpottColors.primary, SpottColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Earn From Empty Seats',
                    style: SpottTextStyles.titleSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: SpottSpacing.xs),
                  Text(
                    'Recover fuel costs and travel smarter.',
                    style: SpottTextStyles.caption.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: SpottSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Join Now',
                style: SpottTextStyles.label.copyWith(
                  color: SpottColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const _GridItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MarketplaceCard(
      onTap: onTap,
      borderRadius: 24,
      padding: const EdgeInsets.all(SpottSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 24),
          ),
          const SizedBox(height: SpottSpacing.md),
          Text(
            title,
            style: SpottTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: SpottTextStyles.caption.copyWith(
              color: SpottColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _UtilityRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _UtilityRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MarketplaceCard(
      onTap: onTap,
      borderRadius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: SpottColors.surface2,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: SpottColors.primary, size: 20),
          ),
          const SizedBox(width: SpottSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: SpottTextStyles.titleSmall.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: SpottTextStyles.caption.copyWith(
                    color: SpottColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: SpottColors.textMuted),
        ],
      ),
    );
  }
}

class _MarketCard extends StatelessWidget {
  final Widget child;

  const _MarketCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SpottSpacing.cardInner),
      decoration: BoxDecoration(
        color: SpottColors.surface1,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: SpottColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ServiceColors {
  final bool isDark;

  const _ServiceColors(this.isDark);

  Color get background =>
      isDark ? Helper.darkBackground : Helper.backgroundColor;
  Color get text => isDark ? Colors.white : Helper.ink;
  Color get subtleText => isDark ? const Color(0xFF98A2B3) : Helper.muted;
}
