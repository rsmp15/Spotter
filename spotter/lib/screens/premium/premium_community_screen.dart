import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../theme/spott_theme.dart';

class PremiumCommunityScreen extends StatelessWidget {
  const PremiumCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SpottTheme.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(SpottTheme.spacingLarge),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Community", style: SpottTheme.textTheme.displayMedium),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: SpottTheme.surface,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            _buildCategories(),
            const SizedBox(height: SpottTheme.spacingLarge),
            Expanded(child: _buildMasonryFeed()),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final categories = ["For You", "Travel Stories", "Groups", "Memories"];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: SpottTheme.spacingLarge,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: SpottTheme.spacingSmall),
        itemBuilder: (context, index) {
          final isSelected = index == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(
              categories[index],
              style: SpottTheme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? Colors.black : SpottTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMasonryFeed() {
    return MasonryGridView.count(
      padding: const EdgeInsets.only(
        left: SpottTheme.spacingLarge,
        right: SpottTheme.spacingLarge,
        bottom: 120, // space for nav bar
      ),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemCount: 10,
      itemBuilder: (context, index) {
        final height = (index % 3 == 0)
            ? 250.0
            : ((index % 2 == 0) ? 200.0 : 300.0);
        return _buildStoryCard(height, index);
      },
    );
  }

  Widget _buildStoryCard(double height, int index) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SpottTheme.radiusMedium),
        image: DecorationImage(
          image: NetworkImage('https://picsum.photos/seed/post$index/400/600'),
          fit: BoxFit.cover,
        ),
        boxShadow: SpottTheme.premiumShadow,
      ),
      child: Stack(
        children: [
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SpottTheme.radiusMedium),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
                stops: const [0.5, 1.0],
              ),
            ),
          ),
          // Content
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  index % 2 == 0 ? "Weekend at Lonavala" : "Morning Drive",
                  style: SpottTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/100?u=$index',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Ritesh M.",
                        style: SpottTheme.textTheme.labelMedium?.copyWith(
                          color: Colors.white70,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

