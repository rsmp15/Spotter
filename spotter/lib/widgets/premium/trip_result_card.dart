import 'package:flutter/material.dart';
import '../../design_system/design_system.dart';
import 'glassmorphism.dart';
import 'trust_badge.dart';

class TripResultCard extends StatelessWidget {
  final VoidCallback onTap;

  const TripResultCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: DSSpacing.xxl), // 24.0
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DSRadius.xl), // 16.0
          color: DSColors.background, // Canvas
          boxShadow: DSShadows.level1, // Level 1 Subtle Drop
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Image Header
            Stack(
              children: [
                Image.network(
                  'https://picsum.photos/seed/route/600/300',
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: DSSpacing.lg,
                  right: DSSpacing.lg,
                  child: Glassmorphism(
                    borderRadius: DSRadius.lg,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(
                      '₹ 450',
                      style: DSTypography.displaySM.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: DSSpacing.lg,
                  left: DSSpacing.lg,
                  child: Glassmorphism(
                    borderRadius: DSRadius.md,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.people_alt, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '2 Mutual Travelers',
                          style: DSTypography.bodySMStrong.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            
            Padding(
              padding: const EdgeInsets.all(DSSpacing.xxl), // 24.0 (card interior padding)
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Route
                  Row(
                    children: [
                      Column(
                        children: [
                          const Icon(Icons.circle, size: 10, color: DSColors.primary),
                          Container(height: 20, width: 2, color: DSColors.border),
                          const Icon(Icons.location_on, size: 14, color: DSColors.success),
                        ],
                      ),
                      const SizedBox(width: DSSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Pune, Maharashtra", style: DSTypography.bodyMD.copyWith(color: DSColors.textSecondary)),
                            const SizedBox(height: 8),
                            Text("Kolhapur, Maharashtra", style: DSTypography.bodyMDStrong.copyWith(color: DSColors.textPrimary)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("10:30 AM", style: DSTypography.bodyMDStrong.copyWith(color: DSColors.textPrimary)),
                          Text("3h 45m", style: DSTypography.bodySM.copyWith(color: DSColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: DSSpacing.lg),
                    child: Divider(color: DSColors.divider),
                  ),
                  
                  // Driver & Vehicle
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'),
                      ),
                      const SizedBox(width: DSSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("Rohan M.", style: DSTypography.bodyMDStrong.copyWith(color: DSColors.textPrimary)),
                                const SizedBox(width: 4),
                                const Icon(Icons.star, size: 14, color: DSColors.warning),
                                Text(" 4.9", style: DSTypography.bodyMD.copyWith(color: DSColors.textSecondary)),
                              ],
                            ),
                            Text("White Hyundai Creta • SUV", style: DSTypography.bodySM.copyWith(color: DSColors.textSecondary)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: DSColors.surfaceVariant, // Canvas Soft
                          borderRadius: BorderRadius.circular(DSRadius.lg),
                        ),
                        child: Text(
                          "3 Seats",
                          style: DSTypography.bodySMStrong.copyWith(color: DSColors.textPrimary),
                        ),
                      )
                    ],
                  ),
                  
                  const SizedBox(height: DSSpacing.lg),
                  
                  // Badges
                  const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      TrustBadge(label: "Aadhaar Verified"),
                      TrustBadge(label: "Accepts Parcels", icon: Icons.local_shipping_outlined, color: DSColors.warning),
                      TrustBadge(label: "Corporate", icon: Icons.business),
                    ],
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

