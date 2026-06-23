import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'shimmer_loading.dart';
import 'glass_card.dart';

class SkeletonRouteCard extends StatelessWidget {
  const SkeletonRouteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(DSSpacing.card),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const ShimmerLoading.circle(radius: 22),
              const SizedBox(width: DSSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerLoading(height: 14, width: 120),
                    const SizedBox(height: 6),
                    Row(
                      children: const [
                        ShimmerLoading(height: 10, width: 40),
                        SizedBox(width: 6),
                        ShimmerLoading(height: 10, width: 50),
                      ],
                    ),
                  ],
                ),
              ),
              const ShimmerLoading(height: 20, width: 60),
            ],
          ),
          const SizedBox(height: DSSpacing.md),
          const Divider(height: 1),
          const SizedBox(height: DSSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: const [
                  ShimmerLoading.circle(radius: 4),
                  SizedBox(height: 18),
                  ShimmerLoading.circle(radius: 4),
                ],
              ),
              const SizedBox(width: DSSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ShimmerLoading(height: 12, width: double.infinity),
                    SizedBox(height: 16),
                    ShimmerLoading(height: 12, width: 180),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: DSSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              ShimmerLoading(height: 10, width: 90),
              ShimmerLoading(height: 16, width: 60),
            ],
          ),
        ],
      ),
    );
  }
}

class SkeletonTravelerCard extends StatelessWidget {
  const SkeletonTravelerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(DSSpacing.md),
      child: Row(
        children: [
          const ShimmerLoading.circle(radius: 24),
          const SizedBox(width: DSSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ShimmerLoading(height: 14, width: 140),
                SizedBox(height: 6),
                ShimmerLoading(height: 10, width: 100),
              ],
            ),
          ),
          const ShimmerLoading(height: 24, width: 50),
        ],
      ),
    );
  }
}

