import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/radius.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';
import '../theme/shadows.dart';
import 'spott_avatar.dart';

class SpottAppliCard extends StatelessWidget {
  final String route;
  final String price;
  final int trustScore;
  final String travelerName;
  final String travelerAvatarUrl;
  final int tripsCompleted;
  final String responseRate;
  final String vehicleInfo;
  final String savings;
  final String travelersCount;
  final String seatsLeft;
  final String imageBannerUrl;
  final VoidCallback onViewDetails;
  final VoidCallback onShowInterest;

  const SpottAppliCard({
    super.key,
    required this.route,
    required this.price,
    required this.trustScore,
    required this.travelerName,
    required this.travelerAvatarUrl,
    required this.tripsCompleted,
    required this.responseRate,
    required this.vehicleInfo,
    required this.savings,
    required this.travelersCount,
    required this.seatsLeft,
    required this.imageBannerUrl,
    required this.onViewDetails,
    required this.onShowInterest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: SpottColors.surface1, // Solid Surface #111318 as per rules
        borderRadius: BorderRadius.circular(SpottRadius.primaryCard), // 24px
        border: Border.all(
          color: SpottColors.border,
          width: 1.0,
        ), // 1px border #222530
        boxShadow: SpottShadows.elevation2,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SpottRadius.primaryCard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Top Banner (40%) ──────────────────────────────────────
            SizedBox(
              height: 140,
              child: Stack(
                children: [
                  // Cover Image with soft gradient overlay
                  Positioned.fill(
                    child: Image.network(
                      imageBannerUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Icon(
                            Icons.landscape_rounded,
                            color: SpottColors.textTertiary,
                            size: 48,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.4),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.6),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),

                  // Overlay Translucent Chips
                  Positioned(
                    top: SpottSpacing.sm,
                    left: SpottSpacing.sm,
                    child: Row(
                      children: [
                        _buildTranslucentChip(
                          label: 'OPEN',
                          color: SpottColors.success,
                        ),
                        const SizedBox(width: 6),
                        _buildTranslucentChip(
                          label: 'VERIFIED',
                          color: SpottColors.success,
                          icon: Icons.verified_user_rounded,
                        ),
                        const SizedBox(width: 6),
                        _buildTranslucentChip(
                          label: 'POPULAR',
                          color: SpottColors.accentPurple,
                        ),
                      ],
                    ),
                  ),

                  // Floating Avatar overlayed on bottom right
                  Positioned(
                    bottom: -16,
                    right: SpottSpacing.md,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: SpottColors.surface1,
                          width: 3.5,
                        ),
                      ),
                      child: SpottAvatar(
                        imageUrl: travelerAvatarUrl,
                        radius: 22,
                        isVerified: true,
                      ),
                    ),
                  ),

                  // Price Tag Overlay
                  Positioned(
                    bottom: SpottSpacing.sm,
                    left: SpottSpacing.sm,
                    child: Text(
                      price,
                      style: SpottTextStyles.headline.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Middle Area ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SpottSpacing.md,
                SpottSpacing.lg,
                SpottSpacing.md,
                SpottSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title / Route
                  Text(
                    route,
                    style: SpottTextStyles.title.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),

                  // Subtitle (Traveler Name & Vehicle Details)
                  Text(
                    'by $travelerName • $vehicleInfo',
                    style: SpottTextStyles.body.copyWith(
                      color: SpottColors.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: SpottSpacing.md),

                  // Reputation & Trust Indicators (Head of Design specifications)
                  Row(
                    children: [
                      // Numeric Trust Score
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: SpottColors.successSoft,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$trustScore Trust Score',
                          style: SpottTextStyles.caption.copyWith(
                            color: SpottColors.success,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Mini Stats (Trips & Response Rate)
                      Expanded(
                        child: Text(
                          '• $tripsCompleted trips • $responseRate resp.',
                          style: SpottTextStyles.caption.copyWith(
                            color: SpottColors.textSecondary,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SpottSpacing.md),

                  // Stats Row: Trips, Travelers, Savings
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: SpottColors.surface2, // Solid Secondary Surface
                      borderRadius: BorderRadius.circular(
                        SpottRadius.secondaryCard,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetricCol('Seats Left', seatsLeft),
                        _buildDivider(),
                        _buildMetricCol('Travelers', travelersCount),
                        _buildDivider(),
                        _buildMetricCol('Avg. Saving', savings),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ── Bottom CTAs ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(
                left: SpottSpacing.md,
                right: SpottSpacing.md,
                bottom: SpottSpacing.md,
              ),
              child: Row(
                children: [
                  // Secondary: Show Interest
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onShowInterest,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: SpottColors.textPrimary,
                        side: const BorderSide(color: SpottColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            SpottRadius.button,
                          ), // 18px
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Show Interest',
                        style: SpottTextStyles.label.copyWith(fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: SpottSpacing.sm),
                  // Primary: View Details (Pinterest Red Brand CTA)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onViewDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SpottColors.primary, // Brand CTA Red
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            SpottRadius.button,
                          ), // 18px
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'View Details',
                        style: SpottTextStyles.label.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslucentChip({
    required String label,
    required Color color,
    IconData? icon,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(SpottRadius.pill),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(SpottRadius.pill),
            border: Border.all(
              color: color.withValues(alpha: 0.35),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: color, size: 10),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 9,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCol(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: SpottTextStyles.caption.copyWith(
            fontSize: 10,
            color: SpottColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: SpottTextStyles.label.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 24, color: SpottColors.border);
  }
}
