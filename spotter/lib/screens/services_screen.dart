import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';




import 'package:spotter/design_system/design_system.dart';
import '../core/components/redbus_sections.dart';
import '../spotter_widgets.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DSColors.background,
      drawer: const SpotterMenuDrawer(),
      body: Column(
        children: [
          _buildRedHeader(context),
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. Hero Search Section (White bg, search bar)
                SliverToBoxAdapter(
                  child: RBSectionContainer(
                    style: RBSectionStyle.white,
                    child: _buildHeroSearch(context),
                  ),
                ),

                // Separator spacing
                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // 2. Marketplace Categories (Bento Grid on neutral background)
                SliverToBoxAdapter(
                  child: RBSectionContainer(
                    style: RBSectionStyle.marketplace,
                    topRadius: 32,
                    bottomRadius: 32,
                    child: _buildMarketplaceCategories(context),
                  ),
                ),

                // Spacing 48px
                const SliverToBoxAdapter(child: SizedBox(height: 48)),

                // 3. Featured Services Carousel (Rewards styled soft colored)
                SliverToBoxAdapter(
                  child: RBSectionContainer(
                    style: RBSectionStyle.rewards,
                    topRadius: 32,
                    bottomRadius: 32,
                    child: _buildFeaturedServices(context),
                  ),
                ),

                // Spacing 48px
                const SliverToBoxAdapter(child: SizedBox(height: 48)),

                // 4. Recent Activity (White background)
                SliverToBoxAdapter(
                  child: RBSectionContainer(
                    style: RBSectionStyle.white,
                    child: _buildRecentActivity(context),
                  ),
                ),

                // Spacing 48px
                const SliverToBoxAdapter(child: SizedBox(height: 48)),

                // 5. Earn with Spotter (Community styled tint)
                SliverToBoxAdapter(
                  child: RBSectionContainer(
                    style: RBSectionStyle.community,
                    topRadius: 32,
                    bottomRadius: 32,
                    child: _buildEarnWithSpott(context),
                  ),
                ),

                // Spacing 48px
                const SliverToBoxAdapter(child: SizedBox(height: 48)),

                // 6. Utilities Section (Floating style container)
                SliverToBoxAdapter(
                  child: _buildUtilitiesSection(context),
                ),

                // Spacing 48px
                const SliverToBoxAdapter(child: SizedBox(height: 48)),

                // 7. Premium Banner (Wallet styled slate container)
                SliverToBoxAdapter(
                  child: RBSectionContainer(
                    style: RBSectionStyle.wallet,
                    topRadius: 32,
                    bottomRadius: 32,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(24),
                    child: _buildPremiumBanner(context),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 120.0)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // â”€â”€ 1. Red Header â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildRedHeader(BuildContext context) {
    return Container(
      color: DSColors.primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 24),
                onPressed: () => Scaffold.of(context).openDrawer(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),
              const Text(
                'spotter',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: const NetworkImage('https://i.pravatar.cc/150?img=11'),
                      onError: (exception, stackTrace) {},
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(color: Colors.white24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // â”€â”€ 2. Hero Search â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildHeroSearch(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 32, 
              fontWeight: FontWeight.w900, 
              color: DSColors.textPrimary, 
              height: 1.1,
              fontFamily: 'Inter',
            ),
            children: [
              TextSpan(text: 'Where to '),
              TextSpan(
                text: 'next?',
                style: TextStyle(
                  color: DSColors.primary, 
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Share rides, send parcels, save money',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: DSColors.textSecondary,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: DSSpacing.lg),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: DSColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              const Icon(Icons.search_rounded, color: DSColors.textSecondary),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Search destinations...',
                  style: TextStyle(color: DSColors.textSecondary, fontSize: 16),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.tripSearch),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DSColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(88, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  elevation: 0,
                ),
                child: const Text('Explore', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // â”€â”€ 3. Marketplace Categories â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildMarketplaceCategories(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RBSectionHeader(
          title: 'Explore Services',
          actionLabel: 'See all',
          onAction: () {},
        ),
        Row(
          children: [
            Expanded(
              child: _CategoryGridItem(
                title: 'Ride Sharing',
                icon: Icons.directions_car_rounded,
                accentColor: DSColors.primary,
                onTap: () => Navigator.pushNamed(context, AppRoutes.tripSearch),
              ),
            ),
            const SizedBox(width: DSSpacing.md),
            Expanded(
              child: _CategoryGridItem(
                title: 'Delivery',
                icon: Icons.local_shipping_rounded,
                accentColor: DSColors.primaryDark,
                onTap: () => Navigator.pushNamed(context, AppRoutes.parcelBooking),
              ),
            ),
          ],
        ),
        const SizedBox(height: DSSpacing.md),
        Row(
          children: [
            Expanded(
              child: _CategoryGridItem(
                title: 'Travel',
                icon: Icons.flight_takeoff_rounded,
                accentColor: DSColors.primary,
                onTap: () => Navigator.pushNamed(context, AppRoutes.createTrip),
              ),
            ),
            const SizedBox(width: DSSpacing.md),
            Expanded(
              child: _CategoryGridItem(
                title: 'Community',
                icon: Icons.forum_rounded,
                accentColor: DSColors.success,
                onTap: () => Navigator.pushNamed(context, AppRoutes.activity),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // â”€â”€ 4. Featured Services Carousel â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildFeaturedServices(BuildContext context) {
    return RBCarouselSection(
      title: 'Featured Offers',
      subtitle: 'Exclusive discounts and campaign packages',
      items: [
        _buildFeaturedCard(
          imageUrl: 'https://images.unsplash.com/photo-1522199710521-72d69614c71c?auto=format&fit=crop&q=80',
          tag: '20% OFF',
          title: 'Weekend Escapes',
          subtitle: 'Special rates on round trips to popular getaways.',
          buttonText: 'View Offer',
          onTap: () {},
        ),
        _buildFeaturedCard(
          imageUrl: 'https://images.unsplash.com/photo-1587293852726-70cdb56c2866?auto=format&fit=crop&q=80',
          tag: 'NEW',
          title: 'Express Parcel',
          subtitle: 'Same-day delivery along active routes.',
          buttonText: 'Book Now',
          onTap: () {},
        ),
      ],
      itemHeight: 280,
    );
  }

  Widget _buildFeaturedCard({
    required String imageUrl,
    required String tag,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: DSColors.glass,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: DSColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Header
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Image.network(
                  imageUrl,
                  height: 90,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 90,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(DSRadius.pill),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: DSTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: DSTypography.caption.copyWith(
                    color: DSColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onTap,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: DSColors.textPrimary,
                      side: const BorderSide(color: DSColors.borderSubtle),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(DSRadius.button),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(buttonText),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // â”€â”€ 5. Recent Activity â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RBSectionHeader(
          title: 'Recent Activity',
          actionLabel: 'View All',
          onAction: () => Navigator.pushNamed(context, AppRoutes.activity),
        ),
        Container(
          decoration: BoxDecoration(
            color: DSColors.glass,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: DSColors.borderSubtle),
          ),
          child: Column(
            children: [
              _ActivityStatusTile(
                title: 'Pune â†’ Mumbai',
                time: 'Tomorrow, 9:00 AM',
                status: 'Upcoming',
                statusColor: DSColors.primary,
                icon: Icons.directions_car_rounded,
                isLast: false,
              ),
              _ActivityStatusTile(
                title: 'Parcel Delivery',
                time: 'Delivered yesterday',
                status: 'Completed',
                statusColor: DSColors.success,
                icon: Icons.check_circle_rounded,
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // â”€â”€ 6. Earn With SPOTT â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildEarnWithSpott(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RBSectionHeader(
          title: 'Earn With SPOTT',
          subtitle: 'Offer empty rides or deliver packages to save fuel',
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: DSColors.borderSubtle),
          ),
          child: Column(
            children: [
              _buildRevenueRow(
                context,
                title: 'Offer Empty Seats',
                subtitle: 'Share your vehicle and save fuel.',
                extraText: 'â‚¹800/trip',
                icon: Icons.airline_seat_recline_normal_rounded,
                onTap: () => Navigator.pushNamed(context, AppRoutes.createTrip),
                isLast: false,
              ),
              _buildRevenueRow(
                context,
                title: 'Parcel Dispatch',
                subtitle: 'Deliver packages along your route.',
                extraText: 'â‚¹300 extra',
                icon: Icons.local_shipping_rounded,
                onTap: () => Navigator.pushNamed(context, AppRoutes.kyc),
                isLast: false,
              ),
              _buildRevenueRow(
                context,
                title: 'Refer Friends',
                subtitle: 'Share SPOTT and earn.',
                extraText: 'â‚¹100 bonus',
                icon: Icons.card_giftcard_rounded,
                onTap: () {},
                isLast: true,
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
    required bool isLast,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: isLast ? null : Border(
            bottom: BorderSide(color: DSColors.borderSubtle),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: DSColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: DSColors.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: DSTypography.titleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: DSTypography.caption.copyWith(
                      color: DSColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  extraText,
                  style: DSTypography.labelLarge.copyWith(
                    color: DSColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: DSColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // â”€â”€ 7. Utilities â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildUtilitiesSection(BuildContext context) {
    return RBSectionContainer(
      style: RBSectionStyle.floating,
      child: Column(
        children: [
          Text(
            'Utilities',
            style: DSTypography.headline.copyWith(
              color: const Color(0xFF141b2b),
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 24,
            crossAxisSpacing: 12,
            children: [
              _UtilityCircularButton(
                icon: Icons.account_balance_wallet_rounded,
                label: 'Wallet',
                color: const Color(0xFF141b2b),
                onTap: () => Navigator.pushNamed(context, AppRoutes.wallet),
              ),
              _UtilityCircularButton(
                icon: Icons.security_rounded,
                label: 'Safety',
                color: const Color(0xFF005f90),
                onTap: () => RideScope.of(context).switchTab(3),
              ),
              _UtilityCircularButton(
                icon: Icons.notifications_rounded,
                label: 'Alerts',
                color: DSColors.primary,
                onTap: () {},
              ),
              _UtilityCircularButton(
                icon: Icons.card_giftcard_rounded,
                label: 'Invite',
                color: DSColors.primary,
                onTap: () {},
              ),
              _UtilityCircularButton(
                icon: Icons.help_center_rounded,
                label: 'Help',
                color: const Color(0xFF5e3f3c),
                onTap: () => Navigator.pushNamed(context, AppRoutes.support),
              ),
              _UtilityCircularButton(
                icon: Icons.settings_rounded,
                label: 'Settings',
                color: const Color(0xFF141b2b),
                onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // â”€â”€ 8. Premium Banner â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildPremiumBanner(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.workspace_premium_rounded, color: Color(0xFFffdad7), size: 24),
            const SizedBox(width: 8),
            const Text(
              'SPOTT BLACK',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFFffdad7),
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Elevate your\nexperience.',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Priority matching, zero platform fees, and VIP support.',
          style: DSTypography.body.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DSRadius.button),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Upgrade Now',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    );
  }
}

// â”€â”€ Helpers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _CategoryGridItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const _CategoryGridItem({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 110,
        decoration: BoxDecoration(
          color: DSColors.glass,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: DSColors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            const Spacer(),
            Text(
              title,
              style: DSTypography.labelLarge.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityStatusTile extends StatelessWidget {
  final String title;
  final String time;
  final String status;
  final Color statusColor;
  final IconData icon;
  final bool isLast;

  const _ActivityStatusTile({
    required this.title,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.icon,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isLast ? null : Border(
          bottom: BorderSide(color: DSColors.borderSubtle),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: DSColors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: DSColors.textSecondary, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: DSTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: DSTypography.caption.copyWith(
                    color: DSColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: DSTypography.labelLarge.copyWith(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UtilityCircularButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _UtilityCircularButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: DSColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
