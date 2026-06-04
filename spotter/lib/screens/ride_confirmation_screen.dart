import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_avatar.dart';
import '../core/components/spott_buttons.dart';
import '../core/components/status_chip.dart';
import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';
import '../controllers/ride_controller.dart';

class RideConfirmationScreen extends StatelessWidget {
  const RideConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final driver = ride.selectedDriver;

    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: SpottColors.textPrimary),
        title: const Text('Confirm booking', style: SpottTextStyles.titleSmall),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.pageHorizontal),
        child: Column(
          children: [
            const SizedBox(height: SpottSpacing.md),
            
            // ── Route Card ──────────────────────────────────────
            GlassCard(
              padding: const EdgeInsets.all(SpottSpacing.cardInner),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Trip Summary', style: SpottTextStyles.label),
                      const StatusChip(label: 'Pending', status: ChipStatus.pending),
                    ],
                  ),
                  const SizedBox(height: SpottSpacing.md),
                  _buildInfoRow('Route', 'Pune → Mumbai'),
                  const SizedBox(height: SpottSpacing.sm),
                  _buildInfoRow('Date', '5 Jun 2026'),
                  const SizedBox(height: SpottSpacing.sm),
                  _buildInfoRow('Departure', '7:30 AM'),
                  const SizedBox(height: SpottSpacing.sm),
                  _buildInfoRow('Seats requested', '2'),
                  const SizedBox(height: SpottSpacing.md),
                  
                  // Divider
                  Container(height: 1, color: SpottColors.borderSubtle),
                  const SizedBox(height: SpottSpacing.md),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Cost share', style: SpottTextStyles.titleSmall),
                      Text(
                        '₹700',
                        style: SpottTextStyles.title.copyWith(color: SpottColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: SpottSpacing.md),
            
            // ── Driver Card ──────────────────────────────────────
            GlassCard(
              padding: const EdgeInsets.all(SpottSpacing.cardInner),
              child: Row(
                children: [
                  SpottAvatar(
                    imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704d',
                    radius: 24,
                    isVerified: true,
                    rating: '4.9',
                  ),
                  const SizedBox(width: SpottSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(driver?.name ?? 'Amit Sharma', style: SpottTextStyles.label),
                        const SizedBox(height: 2),
                        Text('Swift Dzire • MH 12 AB 1234', style: SpottTextStyles.caption),
                      ],
                    ),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'By booking, you agree to the community guidelines.',
                style: SpottTextStyles.caption.copyWith(color: SpottColors.textTertiary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SpottSpacing.md),
              SpottButton.primary(
                label: 'Confirm Booking',
                onPressed: () async {
                  await ride.confirmRide();
                  if (!context.mounted) return;
                  Navigator.pushReplacementNamed(context, AppRoutes.bookingSuccess);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: SpottTextStyles.body),
        Text(value, style: SpottTextStyles.label),
      ],
    );
  }
}
