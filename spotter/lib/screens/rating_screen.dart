import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotter/design_system/design_system.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../spotter_widgets.dart';
import '../core/components/spott_avatar.dart';
import '../core/components/spott_buttons.dart';
import '../core/components/glass_scaffold.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int rating = 5;
  int tip = 0;

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final driver = ride.selectedDriver;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;

    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            CupertinoIcons.arrow_left,
            color: palette.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: DSSpacing.lg),
            Text(
              'Rate your ride',
              style: DSTypography.headline.copyWith(
                fontWeight: FontWeight.w800,
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(height: DSSpacing.sm),
            Text(
              'Help keep SPOTT reliable.',
              style: DSTypography.body.copyWith(
                color: palette.textSecondary,
              ),
            ),
            const SizedBox(height: DSSpacing.xl),
            RecoveryBanner(
              state: ride.actionState,
              onRetry: () {
                ride.submitRating(rating: rating, tip: tip);
              },
            ),
            RideContextCard(
              route: ride.routeLabel,
              fare: ride.fareLabel,
              driver: driver?.name ?? 'Amit Sharma',
              status: ride.status.name,
            ),
            const SizedBox(height: DSSpacing.md),

            Container(
              padding: const EdgeInsets.all(DSSpacing.md),
              decoration: BoxDecoration(
                color: palette.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: palette.border),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SpottAvatar(
                        imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704d',
                        radius: 26,
                        isVerified: true,
                      ),
                      const SizedBox(width: DSSpacing.md),
                      Expanded(
                        child: Text(
                          driver?.name ?? 'Amit Sharma',
                          style: DSTypography.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: palette.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: DSSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starIndex = index + 1;
                      final isSelected = starIndex <= rating;
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => rating = starIndex);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Icon(
                            isSelected ? CupertinoIcons.star_fill : CupertinoIcons.star,
                            color: isSelected ? palette.textPrimary : palette.textSecondary.withValues(alpha: 0.4),
                            size: 36,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: DSSpacing.md),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(DSSpacing.md),
              decoration: BoxDecoration(
                color: palette.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: palette.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add tip',
                    style: DSTypography.titleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: DSSpacing.md),
                  Wrap(
                    spacing: DSSpacing.sm,
                    runSpacing: DSSpacing.sm,
                    children: [0, 10, 20, 50].map((amount) {
                      final isSelected = tip == amount;
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => tip = amount);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? palette.textPrimary : palette.surfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? Colors.transparent : palette.border,
                            ),
                          ),
                          child: Text(
                            amount == 0 ? 'No tip' : '₹$amount',
                            style: DSTypography.labelLarge.copyWith(
                              color: isSelected ? palette.background : palette.textPrimary,
                              fontFamily: 'Inter',
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: DSSpacing.xl),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SpottButton.primary(
            label: 'Submit rating',
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final success = await ride.submitRating(rating: rating, tip: tip);
              if (!context.mounted) return;
              if (!success) {
                messenger.showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      'Rating failed. Please try again.',
                      style: TextStyle(fontFamily: 'Inter', color: Colors.white),
                    ),
                    backgroundColor: Colors.black,
                  ),
                );
                return;
              }
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              );
              messenger.showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    'Thanks for rating your ride',
                    style: TextStyle(fontFamily: 'Inter', color: Colors.white),
                  ),
                  backgroundColor: Colors.black,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


