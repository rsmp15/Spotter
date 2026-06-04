import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/radius.dart';

enum VerificationLevel {
  mobile(1, 'Mobile Verified', Icons.phone_android_rounded),
  govId(2, 'ID Verified', Icons.badge_rounded),
  vehicle(3, 'Vehicle Verified', Icons.directions_car_rounded),
  background(4, 'Background Checked', Icons.shield_rounded);

  final int value;
  final String label;
  final IconData icon;
  const VerificationLevel(this.value, this.label, this.icon);
}

/// Dynamic indicator showing the verification status levels (1 to 4)
class VerificationBadge extends StatelessWidget {
  final int level;
  final bool compact;

  const VerificationBadge({
    super.key,
    required this.level,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (level < 1) return const SizedBox.shrink();

    // Determine highest active verification
    final activeLevels = VerificationLevel.values.where((l) => l.value <= level).toList();
    if (activeLevels.isEmpty) return const SizedBox.shrink();

    final highest = activeLevels.last;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: SpottColors.trustVerified.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(SpottRadius.xs),
        border: Border.all(
          color: SpottColors.trustVerified.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            highest.icon,
            size: compact ? 11 : 13,
            color: SpottColors.trustVerified,
          ),
          const SizedBox(width: 4),
          Text(
            compact ? highest.label.replaceFirst(' Verified', '').replaceFirst(' Checked', ' ✓') : highest.label,
            style: TextStyle(
              fontSize: compact ? 10 : 11,
              fontWeight: FontWeight.w600,
              color: SpottColors.trustVerified,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}

/// A horizontal strip showing a series of small, verified badge icons
class VerificationStack extends StatelessWidget {
  final int level;

  const VerificationStack({
    super.key,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: VerificationLevel.values.map((v) {
        final isVerified = v.value <= level;
        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Tooltip(
            message: '${v.label}: ${isVerified ? "Verified" : "Pending"}',
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isVerified ? SpottColors.trustVerified.withValues(alpha: 0.08) : SpottColors.surface3,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isVerified
                      ? SpottColors.trustVerified.withValues(alpha: 0.2)
                      : SpottColors.border,
                  width: 1,
                ),
              ),
              child: Icon(
                isVerified ? Icons.check_rounded : v.icon,
                size: 11,
                color: isVerified ? SpottColors.trustVerified : SpottColors.textTertiary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Renders driver reputation statistics cleanly
class ReputationScoreRow extends StatelessWidget {
  final double rating;
  final int trips;
  final double? responseRate;
  final double? cancellationRate;
  final int? memberSince;
  final int? safetyScore;
  final bool compact;

  const ReputationScoreRow({
    super.key,
    required this.rating,
    required this.trips,
    this.responseRate,
    this.cancellationRate,
    this.memberSince,
    this.safetyScore,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = SpottTextStyles.caption.copyWith(
      color: SpottColors.textSecondary,
      fontWeight: FontWeight.w500,
    );

    final divider = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        '•',
        style: TextStyle(
          color: SpottColors.textTertiary.withValues(alpha: 0.5),
          fontSize: 10,
        ),
      ),
    );

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Star Rating
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
          decoration: BoxDecoration(
            color: SpottColors.warningSoft,
            borderRadius: BorderRadius.circular(SpottRadius.xs),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, size: 12, color: SpottColors.warning),
              const SizedBox(width: 2),
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: SpottColors.warning,
                ),
              ),
            ],
          ),
        ),
        divider,
        Text('$trips Trips', style: style),

        if (responseRate != null && !compact) ...[
          divider,
          Text('${responseRate!.toInt()}% Resp', style: style),
        ],

        if (cancellationRate != null && !compact) ...[
          divider,
          Text('${cancellationRate!.toStringAsFixed(1)}% Cancel', style: style),
        ],

        if (safetyScore != null && !compact) ...[
          divider,
          Text('Score: $safetyScore/100', style: style.copyWith(color: SpottColors.success)),
        ],

        if (memberSince != null && !compact) ...[
          divider,
          Text('Since $memberSince', style: style.copyWith(color: SpottColors.textTertiary)),
        ]
      ],
    );
  }
}

/// Compact trust indicator (original widget kept for backward compatibility)
class TrustBadge extends StatelessWidget {
  final bool isVerified;
  final String? rating;
  final int? tripCount;
  final bool compact;

  const TrustBadge({
    super.key,
    this.isVerified = false,
    this.rating,
    this.tripCount,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isVerified) ...[
          const VerificationBadge(level: 2, compact: true),
          if (rating != null || tripCount != null)
            const SizedBox(width: 6),
        ],
        if (rating != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: SpottColors.warningSoft,
              borderRadius: BorderRadius.circular(SpottRadius.xs),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, size: 11, color: SpottColors.warning),
                const SizedBox(width: 2),
                Text(
                  rating!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: SpottColors.warning,
                  ),
                ),
              ],
            ),
          ),
          if (tripCount != null) const SizedBox(width: 6),
        ],
        if (tripCount != null && !compact)
          Text(
            '$tripCount trips',
            style: SpottTextStyles.caption.copyWith(
              color: SpottColors.textTertiary,
              fontSize: 10,
            ),
          ),
      ],
    );
  }
}
