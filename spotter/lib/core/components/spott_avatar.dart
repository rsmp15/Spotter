import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';
import '../theme/gradients.dart';

class SpottAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final bool isVerified;
  final bool isOnline;
  final bool isPremium;
  final String? rating;

  const SpottAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 24.0,
    this.isVerified = false,
    this.isOnline = false,
    this.isPremium = false,
    this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Premium gradient ring or standard border
        Container(
          padding: const EdgeInsets.all(2.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isPremium ? SpottGradients.premium : null,
            border: !isPremium
                ? Border.all(color: DSColors.surface, width: 2.0)
                : null,
          ),
          child: CircleAvatar(
            radius: radius,
            backgroundImage: NetworkImage(imageUrl),
            backgroundColor: DSColors.surfaceVariant,
            onBackgroundImageError: (exception, stackTrace) {},
            child: _buildFallback(),
          ),
        ),

        // Online pulse indicator
        if (isOnline)
          Positioned(
            right: 1,
            bottom: 1,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: DSColors.success,
                shape: BoxShape.circle,
                border: Border.all(color: DSColors.background, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: DSColors.success.withValues(alpha: 0.4),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),

        // Verification badge
        if (isVerified)
          Positioned(
            right: -3,
            top: -3,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                gradient: SpottGradients.trust,
                shape: BoxShape.circle,
                border: Border.all(color: DSColors.background, width: 2.0),
                boxShadow: [
                  BoxShadow(
                    color: DSColors.success.withValues(alpha: 0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Icon(Icons.check, size: 10, color: Colors.white),
            ),
          ),

        // Rating pill
        if (rating != null)
          Positioned(
            bottom: -8,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: DSColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: DSColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, size: 10, color: DSColors.warning),
                    const SizedBox(width: 2),
                    Text(
                      rating!,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: DSColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget? _buildFallback() {
    // This renders behind the NetworkImage; visible only on load error
    return null;
  }
}

