import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'glass_card.dart';
import 'spott_avatar.dart';
import 'trust_badge.dart';

class RouteCard extends StatelessWidget {
  final String origin;
  final String destination;
  final String driverName;
  final String driverAvatar;
  final String rating;
  final String costShare;
  final int seatsAvailable;
  final String? departureTime;
  final String? vehicleType;
  final int? tripCount;
  final VoidCallback? onTap;

  // V2 Marketplace Extensions
  final int? seatsFilled;
  final int? totalSeats;
  final int? viewsToday;
  final String? demandTag;
  final int verificationLevel;
  final double? responseRate;
  final double? cancellationRate;
  final int? safetyScore;
  final int? memberSince;
  final bool isFeatured;
  final bool isSponsored;

  const RouteCard({
    super.key,
    required this.origin,
    required this.destination,
    required this.driverName,
    required this.driverAvatar,
    required this.rating,
    required this.costShare,
    required this.seatsAvailable,
    this.departureTime,
    this.vehicleType,
    this.tripCount,
    this.onTap,
    this.seatsFilled,
    this.totalSeats,
    this.viewsToday,
    this.demandTag,
    this.verificationLevel = 2,
    this.responseRate,
    this.cancellationRate,
    this.safetyScore,
    this.memberSince,
    this.isFeatured = false,
    this.isSponsored = false,
  });

  @override
  Widget build(BuildContext context) {
    final double numericRating = double.tryParse(rating) ?? 4.8;
    final int numericTrips = tripCount ?? 47;

    return Container(
      margin: const EdgeInsets.only(bottom: DSSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DSRadius.card),
        border: isFeatured || isSponsored
            ? Border.all(color: DSColors.primaryDark.withValues(alpha: 0.4), width: 1.5)
            : null,
      ),
      child: GlassCard(
        onTap: onTap,
        padding: const EdgeInsets.all(DSSpacing.card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Optional Sponsor Tag ──────────────────────────────
            if (isSponsored || isFeatured) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: DSColors.primarySoft,
                        borderRadius: BorderRadius.circular(DSRadius.xs),
                      ),
                      child: Text(
                        isSponsored ? 'SPONSORED' : 'FEATURED',
                        style: DSTypography.caption.copyWith(
                          color: DSColors.primaryDark,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // ── Driver Info & Trust Layer ──────────────────────────
            Row(
              children: [
                SpottAvatar(
                  imageUrl: driverAvatar,
                  radius: 22,
                  isVerified: verificationLevel >= 2,
                ),
                const SizedBox(width: DSSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            driverName,
                            style: DSTypography.labelLarge,
                          ),
                          const SizedBox(width: 6),
                          VerificationBadge(level: verificationLevel, compact: true),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ReputationScoreRow(
                        rating: numericRating,
                        trips: numericTrips,
                        responseRate: responseRate,
                        cancellationRate: cancellationRate,
                        safetyScore: safetyScore,
                        memberSince: memberSince,
                        compact: true,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      costShare,
                      style: DSTypography.titleLarge.copyWith(
                        color: DSColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (departureTime != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        departureTime!,
                        style: DSTypography.caption.copyWith(
                          color: DSColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),

            const SizedBox(height: DSSpacing.md),

            // ── Divider ─────────────────────────────────────────────
            Container(
              height: 1,
              color: DSColors.divider,
            ),

            const SizedBox(height: DSSpacing.md),

            // ── Route & Location Details ────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Clean Route Dots (Google Maps / Uber Inspired)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4),
                  child: Column(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: DSColors.primaryDark,
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 24,
                        color: DSColors.border,
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: DSColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: DSSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        origin,
                        style: DSTypography.body.copyWith(
                          color: DSColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        destination,
                        style: DSTypography.body.copyWith(
                          color: DSColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: DSSpacing.md),

            // ── Occupancy, Demand & Vehicle Info Row ─────────────────
            Row(
              children: [
                // Occupancy
                if (seatsFilled != null && totalSeats != null) ...[
                  Text(
                    '$seatsFilled/$totalSeats seats filled',
                    style: DSTypography.caption.copyWith(
                      color: (totalSeats! - seatsFilled!) <= 1
                          ? DSColors.warning
                          : DSColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ] else ...[
                  Row(
                    children: List.generate(4, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i < seatsAvailable
                                ? DSColors.success
                                : DSColors.surfaceVariant,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: DSSpacing.sm),
                  Text(
                    '$seatsAvailable seats left',
                    style: DSTypography.caption.copyWith(
                      color: DSColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],

                const SizedBox(width: 8),

                // Views Today or Demand indicators
                if (demandTag != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: DSColors.dangerSoft,
                      borderRadius: BorderRadius.circular(DSRadius.xs),
                    ),
                    child: Text(
                      demandTag!,
                      style: DSTypography.caption.copyWith(
                        color: DSColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ] else if (viewsToday != null) ...[
                  Text(
                    '•  $viewsToday viewed today',
                    style: DSTypography.caption.copyWith(
                      color: DSColors.textTertiary,
                    ),
                  ),
                ],

                const Spacer(),

                // Vehicle Tag
                if (vehicleType != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: DSColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(DSRadius.xs),
                      border: Border.all(color: DSColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _vehicleIcon(vehicleType!),
                          size: 12,
                          color: DSColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          vehicleType!,
                          style: DSTypography.caption.copyWith(
                            fontSize: 10,
                            color: DSColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _vehicleIcon(String type) {
    switch (type.toLowerCase()) {
      case 'car':
        return Icons.directions_car_rounded;
      case 'bike':
        return Icons.two_wheeler_rounded;
      case 'auto':
        return Icons.electric_rickshaw_rounded;
      default:
        return Icons.directions_car_rounded;
    }
  }
}
