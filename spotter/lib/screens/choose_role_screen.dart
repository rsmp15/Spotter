import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app/app_routes.dart';
import '../app/app_assets.dart';
import '../models/spott_models.dart';
import '../controllers/ride_controller.dart';
import '../core/components/glass_scaffold.dart';
import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);

    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: SpottColors.textPrimary),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Custom map pin logo matching the design
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFFF9D5DB),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on_rounded,
                color: Color(0xFF6B1D2F),
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Spott',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF6B1D2F),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: const [
          SizedBox(width: 48), // To balance back button
        ],
      ),
      body: Stack(
        children: [
          // Faint map background matching the image
          Positioned.fill(
            child: Opacity(
              opacity: 0.04,
              child: Image.asset(
                AppAssets.route,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: SpottSpacing.sm),
                Text(
                  'How will you\nuse Spott?',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: SpottSpacing.xs),
                Text(
                  'You can switch anytime',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: SpottSpacing.lg),

                // Premium Marketplace Metrics Cards
                Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        value: '1.2K',
                        label: 'Travelers',
                        icon: Icons.group_rounded,
                        themeColor: const Color(0xFF6B1D2F),
                        borderColor: const Color(0xFFF9D5DB),
                        bgColor: const Color(0xFFFFF5F6),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricCard(
                        value: '342',
                        label: 'Routes',
                        icon: Icons.map_rounded,
                        themeColor: const Color(0xFF6B1D2F),
                        borderColor: const Color(0xFFF9D5DB),
                        bgColor: const Color(0xFFFFF5F6),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricCard(
                        value: '99.2%',
                        label: 'Safety Rating',
                        icon: Icons.verified_user_rounded,
                        themeColor: const Color(0xFF10B981),
                        borderColor: const Color(0xFFD1FAE5),
                        bgColor: const Color(0xFFF0FDF4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SpottSpacing.lg),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: SpottSpacing.md),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // Passenger Card
                      _RoleBentoCard(
                        title: 'Find &\nJoin Trips',
                        subtitle: 'Ride with verified, local travelers',
                        tag: 'MOST POPULAR',
                        tagColor: const Color(0xFF6B1D2F),
                        assetPath: AppAssets.car,
                        onTap: () {
                          ride.updateUserRole(UserRole.passenger);
                          Navigator.pushNamed(context, AppRoutes.home);
                        },
                      ),

                      // Traveler Card
                      _RoleBentoCard(
                        title: 'Offer &\nShare Trips',
                        subtitle: 'Recover costs, build community',
                        tag: 'EARN MONEY',
                        tagColor: const Color(0xFF047857),
                        assetPath: AppAssets.bike,
                        onTap: () {
                          ride.updateUserRole(UserRole.traveler);
                          Navigator.pushNamed(context, AppRoutes.kyc);
                        },
                      ),

                      // Parcel Sender Card
                      _RoleBentoCard(
                        title: 'Ship via\nTravelers',
                        subtitle: 'Affordable 📦 Fast 🛡️ Fully Tracked',
                        tag: 'FAST DELIVERY',
                        tagColor: const Color(0xFFB45309),
                        assetPath: AppAssets.parcel,
                        onTap: () {
                          ride.updateUserRole(UserRole.parcelSender);
                          Navigator.pushNamed(context, AppRoutes.home);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color themeColor;
  final Color borderColor;
  final Color bgColor;

  const _MetricCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.themeColor,
    required this.borderColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: themeColor.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              Icon(
                icon,
                color: themeColor,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleBentoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String tag;
  final Color tagColor;
  final String assetPath;
  final VoidCallback onTap;

  const _RoleBentoCard({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.tagColor,
    required this.assetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: Colors.black.withValues(alpha: 0.06), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Left Image Container
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB).withValues(alpha: 0.5), // Faint grey background
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(assetPath, fit: BoxFit.contain),
                ),
                const SizedBox(width: 16),
                // Middle text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        tag,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: tagColor,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Trailing Chevron
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.black26,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
