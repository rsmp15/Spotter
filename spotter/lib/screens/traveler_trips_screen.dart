import 'package:flutter/material.dart';

import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/status_chip.dart';
import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';

class TravelerTripsScreen extends StatelessWidget {
  const TravelerTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: SpottColors.textPrimary),
        title: const Text('Hosted Trips', style: SpottTextStyles.sectionTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SpottSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trips you are hosting as a traveler.', style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary)),
            const SizedBox(height: SpottSpacing.xl),

            GlassCard(
              padding: const EdgeInsets.all(SpottSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StatusChip(label: 'Scheduled', status: ChipStatus.neutral),
                  const SizedBox(height: SpottSpacing.md),
                  _buildInfoRow('Date', 'Tomorrow, 8:00 AM'),
                  const SizedBox(height: SpottSpacing.sm),
                  _buildInfoRow('Route', 'Pune → Mumbai'),
                  const SizedBox(height: SpottSpacing.sm),
                  _buildInfoRow('Seats booked', '2/4'),
                  const SizedBox(height: SpottSpacing.sm),
                  _buildInfoRow('Expected Cost Recovery', '₹1200'),
                ],
              ),
            ),
            const SizedBox(height: SpottSpacing.md),

            GlassCard(
              padding: const EdgeInsets.all(SpottSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StatusChip(label: 'Completed', status: ChipStatus.verified),
                  const SizedBox(height: SpottSpacing.md),
                  _buildInfoRow('Date', '10 Oct, 6:00 PM'),
                  const SizedBox(height: SpottSpacing.sm),
                  _buildInfoRow('Route', 'Kolhapur → Pune'),
                  const SizedBox(height: SpottSpacing.sm),
                  _buildInfoRow('Seats booked', '4/4'),
                  const SizedBox(height: SpottSpacing.sm),
                  _buildInfoRow('Cost Recovery', '₹3400'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: SpottTextStyles.body),
        Text(value, style: SpottTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: SpottColors.textPrimary)),
      ],
    );
  }
}
