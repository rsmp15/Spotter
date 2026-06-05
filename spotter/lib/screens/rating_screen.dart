import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../spotter_widgets.dart';
import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_avatar.dart';
import '../core/components/spott_buttons.dart';

import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';
import '../core/theme/radius.dart';

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

    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: SpottColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.pageHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: SpottSpacing.lg),
            Text('Rate your ride', style: SpottTextStyles.display),
            const SizedBox(height: SpottSpacing.sm),
            Text('Help keep Spott reliable.', style: SpottTextStyles.body),
            const SizedBox(height: SpottSpacing.xl),
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
            const SizedBox(height: SpottSpacing.md),

            GlassCard(
              padding: const EdgeInsets.all(SpottSpacing.cardInner),
              child: Column(
                children: [
                  Row(
                    children: [
                      SpottAvatar(
                        imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704d',
                        radius: 26,
                        isVerified: true,
                      ),
                      const SizedBox(width: SpottSpacing.md),
                      Expanded(
                        child: Text(
                          driver?.name ?? 'Amit Sharma',
                          style: SpottTextStyles.title,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SpottSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starIndex = index + 1;
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => rating = starIndex);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(
                            starIndex <= rating ? Icons.star_rounded : Icons.star_border_rounded,
                            color: SpottColors.warning,
                            size: 40,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SpottSpacing.md),
            
            GlassCard(
              padding: const EdgeInsets.all(SpottSpacing.cardInner),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add tip', style: SpottTextStyles.titleSmall),
                  const SizedBox(height: SpottSpacing.md),
                  Wrap(
                    spacing: SpottSpacing.sm,
                    runSpacing: SpottSpacing.sm,
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
                            color: isSelected ? SpottColors.primarySoft : SpottColors.surface3,
                            borderRadius: BorderRadius.circular(SpottRadius.pill),
                            border: Border.all(
                              color: isSelected ? SpottColors.primary : SpottColors.border,
                            ),
                          ),
                          child: Text(
                            amount == 0 ? 'No tip' : '₹$amount',
                            style: SpottTextStyles.label.copyWith(
                              color: isSelected ? SpottColors.primary : SpottColors.textPrimary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(SpottSpacing.pageHorizontal),
          child: SpottButton.primary(
            label: 'Submit rating',
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final success = await ride.submitRating(rating: rating, tip: tip);
              if (!context.mounted) return;
              if (!success) {
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Rating failed. Please try again.'),
                    backgroundColor: SpottColors.danger,
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
                  content: Text('Thanks for rating your ride'),
                  backgroundColor: SpottColors.success,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
