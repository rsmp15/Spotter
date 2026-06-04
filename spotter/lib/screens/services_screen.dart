import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../core/theme/colors.dart';
import '../core/theme/radius.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';
import '../core/theme/shadows.dart';
import '../spotter_widgets.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SpottColors.background,
      drawer: const SpotterMenuDrawer(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: SpottSpacing.pageHorizontal,
            vertical: SpottSpacing.pageTop,
          ),
          children: [
            _buildHeader(context),
            const SizedBox(height: SpottSpacing.lg),
            _buildHeroSearch(context),
            const SizedBox(height: SpottSpacing.xl),
            _buildMarketplaceCategories(context),
            const SizedBox(height: SpottSpacing.xl),
            _buildFeaturedServices(context),
            const SizedBox(height: SpottSpacing.xl),
            _buildRecentActivity(context),
            const SizedBox(height: SpottSpacing.xl),
            _buildEarnWithSpott(context),
            const SizedBox(height: SpottSpacing.xl),
            _buildUtilitiesSection(context),
            const SizedBox(height: SpottSpacing.xl),
            _buildPremiumBanner(context),
            const SizedBox(height: SpottSpacing.pageBottom),
          ],
        ),
      ),
    );
  }

  // ── 1. Header ──────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.menu_rounded,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            const SizedBox(width: SpottSpacing.sm),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Marketplace', style: SpottTextStyles.headline),
                SizedBox(height: 2),
                Text(
                  'Find trips, send packages, and earn',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: SpottColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          tooltip: 'Wallet',
          icon: const Icon(
            Icons.account_balance_wallet_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.wallet),
        ),
      ],
    );
  }

  // ── 2. Hero Search ──────────────────────────────────────────────────
  Widget _buildHeroSearch(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SpottSpacing.md),
      decoration: BoxDecoration(
        color: SpottColors.surface1,
        borderRadius: BorderRadius.circular(SpottRadius.primaryCard), // 24px
        border: Border.all(color: SpottColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Explore SPOTT Market', style: SpottTextStyles.title),
          const SizedBox(height: SpottSpacing.md),
          TextField(
            readOnly: true,
            onTap: () => Navigator.pushNamed(context, AppRoutes.tripSearch),
            decoration: InputDecoration(
              hintText: 'Search destinations or routes...',
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: SpottColors.textSecondary,
              ),
              fillColor: SpottColors.surface2,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SpottRadius.button),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 3. Marketplace Categories (Bento Grid) ─────────────────────────
  Widget _buildMarketplaceCategories(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Marketplace Categories', style: SpottTextStyles.headline),
        const SizedBox(height: SpottSpacing.md),
        Row(
          children: [
            Expanded(
              child: _CategoryGridItem(
                title: 'Find Trip',
                subtitle: 'Join shared rides',
                icon: Icons.directions_car_rounded,
                accentColor: SpottColors.primary,
                onTap: () => Navigator.pushNamed(context, AppRoutes.tripSearch),
              ),
            ),
            const SizedBox(width: SpottSpacing.md),
            Expanded(
              child: _CategoryGridItem(
                title: 'Send Parcel',
                subtitle: 'Fast deliveries',
                icon: Icons.inventory_2_outlined,
                accentColor: SpottColors.accentPurple,
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.parcelBooking),
              ),
            ),
          ],
        ),
        const SizedBox(height: SpottSpacing.md),
        Row(
          children: [
            Expanded(
              child: _CategoryGridItem(
                title: 'Offer Trip',
                subtitle: 'Earn from fuel costs',
                icon: Icons.add_road_rounded,
                accentColor: SpottColors.success,
                onTap: () => Navigator.pushNamed(context, AppRoutes.createTrip),
              ),
            ),
            const SizedBox(width: SpottSpacing.md),
            Expanded(
              child: _CategoryGridItem(
                title: 'Traveler Community',
                subtitle: 'Discover verified riders',
                icon: Icons.people_outline_rounded,
                accentColor: SpottColors.warning,
                onTap: () => Navigator.pushNamed(context, AppRoutes.activity),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── 4. Featured Services Carousel ──────────────────────────────────
  Widget _buildFeaturedServices(BuildContext context) {
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
                title: 'Group Travel',
                label1: 'Weekend road trips',
                label2: 'Save up to ₹800',
                icon: Icons.group_work_rounded,
                color: SpottColors.accentPurple,
              ),
              const SizedBox(width: SpottSpacing.md),
              _buildFeaturedCard(
                title: 'Parcel Dispatch',
                label1: 'Deliver on your route',
                label2: 'Extra ₹300 per packet',
                icon: Icons.inventory_2_rounded,
                color: SpottColors.success,
              ),
              const SizedBox(width: SpottSpacing.md),
              _buildFeaturedCard(
                title: 'SPOTT Verified',
                label1: 'Instant Govt ID matching',
                label2: '100% Trust Scores',
                icon: Icons.shield_rounded,
                color: SpottColors.primary,
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
    return Container(
      width: 220,
      padding: const EdgeInsets.all(SpottSpacing.md),
      decoration: BoxDecoration(
        color: SpottColors.surface1,
        borderRadius: BorderRadius.circular(SpottRadius.primaryCard), // 24px
        border: Border.all(color: SpottColors.border),
      ),
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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            label1,
            style: SpottTextStyles.body.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label2,
            style: SpottTextStyles.caption.copyWith(
              color: SpottColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ── 5. Recent Activity ─────────────────────────────────────────────
  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Transactions', style: SpottTextStyles.headline),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.activity),
              child: const Text(
                'View All',
                style: TextStyle(
                  color: SpottColors.accentPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _ActivityStatusCard(
                title: 'Pune → Mumbai',
                time: 'Tomorrow, 9:00 AM',
                status: 'Upcoming Seat Match',
                statusColor: SpottColors.primary,
                icon: Icons.directions_car_rounded,
              ),
            ),
            const SizedBox(width: SpottSpacing.md),
            Expanded(
              child: _ActivityStatusCard(
                title: 'Parcel Delivery',
                time: 'Delivered yesterday',
                status: 'Closed Match',
                statusColor: SpottColors.success,
                icon: Icons.check_circle_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── 6. Earn With SPOTT (Revenue Drivers - supply side) ──────────────
  Widget _buildEarnWithSpott(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Earn With SPOTT', style: SpottTextStyles.headline),
        const SizedBox(height: SpottSpacing.md),
        Container(
          padding: const EdgeInsets.all(SpottSpacing.md),
          decoration: BoxDecoration(
            color: SpottColors.surface1,
            borderRadius: BorderRadius.circular(
              SpottRadius.primaryCard,
            ), // 24px
            border: Border.all(color: SpottColors.border),
          ),
          child: Column(
            children: [
              _buildRevenueRow(
                context,
                title: 'Offer Empty Seats',
                subtitle: 'Share your vehicle and save fuel costs.',
                extraText: '₹800/trip avg.',
                icon: Icons.airline_seat_recline_normal_rounded,
                onTap: () => Navigator.pushNamed(context, AppRoutes.createTrip),
              ),
              const Divider(height: 24, color: SpottColors.border),
              _buildRevenueRow(
                context,
                title: 'Parcel Dispatch Partner',
                subtitle: 'Deliver packages along your trip route.',
                extraText: '₹150–₹400 extra',
                icon: Icons.local_shipping_rounded,
                onTap: () => Navigator.pushNamed(context, AppRoutes.kyc),
              ),
              const Divider(height: 24, color: SpottColors.border),
              _buildRevenueRow(
                context,
                title: 'Refer Friends & Co-Riders',
                subtitle: 'Share SPOTT and earn referral codes.',
                extraText: 'Earn ₹100',
                icon: Icons.card_giftcard_rounded,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRevenueRow(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String extraText,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: SpottColors.surface2,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: SpottColors.accentPurple, size: 22),
          ),
          const SizedBox(width: SpottSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: SpottTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
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
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                extraText,
                style: SpottTextStyles.label.copyWith(
                  color: SpottColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: SpottColors.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── 7. Utilities ───────────────────────────────────────────────────
  Widget _buildUtilitiesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Utilities', style: SpottTextStyles.headline),
        const SizedBox(height: SpottSpacing.md),
        _UtilityRowTile(
          icon: Icons.account_balance_wallet_rounded,
          title: 'Wallet Balance & Earnings',
          subtitle: 'Track payouts and ride contributions',
          onTap: () => Navigator.pushNamed(context, AppRoutes.wallet),
        ),
        const SizedBox(height: SpottSpacing.sm),
        _UtilityRowTile(
          icon: Icons.shield_rounded,
          title: 'Emergency Safety Kit',
          subtitle: 'SOS trigger, live tracker, trusted contacts',
          onTap: () => Navigator.pushNamed(context, AppRoutes.safetyToolkit),
        ),
        const SizedBox(height: SpottSpacing.sm),
        _UtilityRowTile(
          icon: Icons.person_rounded,
          title: 'Marketplace Profile',
          subtitle: 'Host trust ratings, active vehicles',
          onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
        ),
        const SizedBox(height: SpottSpacing.sm),
        _UtilityRowTile(
          icon: Icons.support_agent_rounded,
          title: 'Resolution Center & Help',
          subtitle: 'Submit claims, support queries',
          onTap: () => Navigator.pushNamed(context, AppRoutes.support),
        ),
      ],
    );
  }

  // ── 8. Premium Banner ──────────────────────────────────────────────
  Widget _buildPremiumBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SpottSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(SpottRadius.primaryCard), // 24px
        boxShadow: SpottShadows.elevation3,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SPOTT PREMIUM',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Unlock priority trust status',
                  style: SpottTextStyles.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  'No matching fees • Premium badge • Early access.',
                  style: SpottTextStyles.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF4F46E5),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Upgrade',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bento category card helper ────────────────────────────────────────
class _CategoryGridItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const _CategoryGridItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(SpottSpacing.md),
        height: 110,
        decoration: BoxDecoration(
          color: SpottColors.surface1, // Solid card Surface
          borderRadius: BorderRadius.circular(
            SpottRadius.primaryCard,
          ), // 24px bento
          border: Border.all(color: SpottColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            const Spacer(),
            Text(
              title,
              style: SpottTextStyles.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: SpottTextStyles.caption.copyWith(
                color: SpottColors.textSecondary,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Activity Status Card helper ───────────────────────────────────────
class _ActivityStatusCard extends StatelessWidget {
  final String title;
  final String time;
  final String status;
  final Color statusColor;
  final IconData icon;

  const _ActivityStatusCard({
    required this.title,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SpottSpacing.md),
      decoration: BoxDecoration(
        color: SpottColors.surface1,
        borderRadius: BorderRadius.circular(SpottRadius.secondaryCard), // 20px
        border: Border.all(color: SpottColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: SpottColors.textSecondary, size: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SpottSpacing.md),
          Text(
            title,
            style: SpottTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(time, style: SpottTextStyles.caption.copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}

// ── Utility Row Tile helper ───────────────────────────────────────────
class _UtilityRowTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _UtilityRowTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SpottRadius.secondaryCard),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: SpottColors.surface1,
          borderRadius: BorderRadius.circular(
            SpottRadius.secondaryCard,
          ), // 20px
          border: Border.all(color: SpottColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: SpottColors.surface2,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: SpottColors.accentPurple, size: 20),
            ),
            const SizedBox(width: SpottSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: SpottTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: SpottTextStyles.caption.copyWith(
                      color: SpottColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: SpottColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
