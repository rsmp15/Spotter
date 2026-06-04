import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../app/app_assets.dart';
import '../models/spott_models.dart';
import '../controllers/ride_controller.dart';
import '../core/components/marketplace_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/status_chip.dart';
import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';

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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: SpottSpacing.sm),
            const Text(
              'How will you\nuse Spott?',
              style: SpottTextStyles.screenTitle,
            ),
            const SizedBox(height: SpottSpacing.xs),
            const Text('You can switch anytime', style: SpottTextStyles.body),
            const SizedBox(height: SpottSpacing.md),

            // Marketplace Metrics
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: const [
                _MetricChip("1.2K Travelers", Icons.people_outline_rounded),
                _MetricChip("342 Routes", Icons.map_outlined),
                _MetricChip("99.2% Safe", Icons.verified_user_outlined),
              ],
            ),
            const SizedBox(height: SpottSpacing.lg),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: SpottSpacing.md),
                children: [
                  // Passenger Card (Primary)
                  _RoleBentoCard(
                    title: 'Find &\nJoin Trips',
                    subtitle: 'Ride with verified travelers',
                    chipLabel: 'MOST POPULAR',
                    chipStatus: ChipStatus.neutral,
                    assetPath: AppAssets.car,
                    onTap: () {
                      ride.updateUserRole(UserRole.passenger);
                      Navigator.pushNamed(context, AppRoutes.home);
                    },
                  ),

                  // Traveler Card (Primary)
                  _RoleBentoCard(
                    title: 'Offer &\nShare Trips',
                    subtitle: 'Recover costs, meet co-travelers',
                    chipLabel: 'EARN MONEY',
                    chipStatus: ChipStatus.verified,
                    assetPath: AppAssets.bike,
                    onTap: () {
                      ride.updateUserRole(UserRole.traveler);
                      Navigator.pushNamed(context, AppRoutes.kyc);
                    },
                  ),

                  // Parcel Sender Card (Secondary)
                  _RoleBentoCard(
                    title: 'Ship via\nTravelers',
                    subtitle: 'Affordable • Fast • Tracked',
                    chipLabel: 'FAST DELIVERY',
                    chipStatus: ChipStatus.pending,
                    assetPath: AppAssets.parcel,
                    isSecondary: true,
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
    );
  }
}

class _MetricChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _MetricChip(this.label, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: SpottColors.surface2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: SpottColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: SpottColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: SpottColors.textPrimary,
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
  final String chipLabel;
  final ChipStatus chipStatus;
  final String assetPath;
  final VoidCallback onTap;
  final bool isSecondary;

  const _RoleBentoCard({
    required this.title,
    required this.subtitle,
    required this.chipLabel,
    required this.chipStatus,
    required this.assetPath,
    required this.onTap,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    final double cardHeight = isSecondary ? 140 : 180;
    final double imageWidth = isSecondary ? 110 : 130;

    return MarketplaceCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      borderRadius: 16,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Container(
              width: imageWidth,
              height: cardHeight,
              color: SpottColors.surface2,
              padding: const EdgeInsets.all(SpottSpacing.md),
              child: Image.asset(assetPath, fit: BoxFit.contain),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(SpottSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatusChip(label: chipLabel, status: chipStatus),
                  const SizedBox(height: SpottSpacing.sm),
                  Text(
                    title,
                    style: SpottTextStyles.sectionTitle.copyWith(
                      fontSize: isSecondary ? 18 : 20,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: SpottSpacing.xs),
                  Text(
                    subtitle,
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
    );
  }
}
