import 'package:flutter/material.dart';
import '../../theme/spott_theme.dart';
import 'glassmorphism.dart';

class CommunityBanner extends StatelessWidget {
  const CommunityBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Glassmorphism(
      padding: const EdgeInsets.all(SpottTheme.spacingMedium),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Travel within trusted communities",
                  style: SpottTheme.textTheme.titleMedium,
                ),
                const SizedBox(height: SpottTheme.spacingSmall),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTag("KITCOEK"),
                    _buildTag("Kolhapur Riders"),
                    _buildTag("Pune Professionals"),
                    _buildTag("Verified Travelers"),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: SpottTheme.spacingMedium),
          _buildAvatarStack(),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: SpottTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Text(
        text,
        style: SpottTheme.textTheme.labelMedium?.copyWith(
          color: SpottTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildAvatarStack() {
    return SizedBox(
      width: 70,
      height: 40,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: SpottTheme.surface,
              backgroundImage: const NetworkImage(
                'https://i.pravatar.cc/100?img=1',
              ),
            ),
          ),
          Positioned(
            right: 15,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: SpottTheme.surface,
              backgroundImage: const NetworkImage(
                'https://i.pravatar.cc/100?img=2',
              ),
            ),
          ),
          Positioned(
            right: 30,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: SpottTheme.surface,
              backgroundImage: const NetworkImage(
                'https://i.pravatar.cc/100?img=3',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

