import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';
import '../theme/radius.dart';
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
      margin: const EdgeInsets.only(bottom: SpottSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SpottRadius.card),
        border: isFeatured || isSponsored
            ? Border.all(color: SpottColors.accentPurple.withValues(alpha: 0.4), width: 1.5)
            : null,
      ),
      child: GlassCard(
        onTap: onTap,
        padding: const EdgeInsets.all(SpottSpacing.cardInner),
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
                        color: SpottColors.accentPurpleSoft,
                        borderRadius: BorderRadius.circular(SpottRadius.xs),
                      ),
                      child: Text(
                        isSponsored ? 'SPONSORED' : 'FEATURED',
                        style: SpottTextStyles.overline.copyWith(
                          color: SpottColors.accentPurple,
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
                const SizedBox(width: SpottSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            driverName,
                            style: SpottTextStyles.label,
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
                      style: SpottTextStyles.title.copyWith(
                        color: SpottColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (departureTime != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        departureTime!,
                        style: SpottTextStyles.caption.copyWith(
                          color: SpottColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),

            const SizedBox(height: SpottSpacing.md),

            // ── Divider ─────────────────────────────────────────────
            Container(
              height: 1,
              color: SpottColors.divider,
            ),

            const SizedBox(height: SpottSpacing.md),

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
                          color: SpottColors.accentPurple,
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 24,
                        color: SpottColors.border,
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: SpottColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: SpottSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        origin,
                        style: SpottTextStyles.body.copyWith(
                          color: SpottColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        destination,
                        style: SpottTextStyles.body.copyWith(
                          color: SpottColors.textPrimary,
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

            const SizedBox(height: SpottSpacing.md),

            // ── Occupancy, Demand & Vehicle Info Row ─────────────────
            Row(
              children: [
                // Occupancy
                if (seatsFilled != null && totalSeats != null) ...[
                  Text(
                    '$seatsFilled/$totalSeats seats filled',
                    style: SpottTextStyles.caption.copyWith(
                      color: (totalSeats! - seatsFilled!) <= 1
                          ? SpottColors.warning
                          : SpottColors.textSecondary,
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
                                ? SpottColors.success
                                : SpottColors.surface2,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: SpottSpacing.sm),
                  Text(
                    '$seatsAvailable seats left',
                    style: SpottTextStyles.caption.copyWith(
                      color: SpottColors.success,
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
                      color: SpottColors.dangerSoft,
                      borderRadius: BorderRadius.circular(SpottRadius.xs),
                    ),
                    child: Text(
                      demandTag!,
                      style: SpottTextStyles.caption.copyWith(
                        color: SpottColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ] else if (viewsToday != null) ...[
                  Text(
                    '•  $viewsToday viewed today',
                    style: SpottTextStyles.caption.copyWith(
                      color: SpottColors.textTertiary,
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
                      color: SpottColors.surface2,
                      borderRadius: BorderRadius.circular(SpottRadius.xs),
                      border: Border.all(color: SpottColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _vehicleIcon(vehicleType!),
                          size: 12,
                          color: SpottColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          vehicleType!,
                          style: SpottTextStyles.caption.copyWith(
                            fontSize: 10,
                            color: SpottColors.textSecondary,
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
