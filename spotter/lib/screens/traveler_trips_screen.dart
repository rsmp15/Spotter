import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/status_chip.dart';




class TravelerTripsScreen extends StatelessWidget {
  const TravelerTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: DSColors.textPrimary),
        title: Text('Hosted Trips', style: DSTypography.headline),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DSSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trips you are hosting as a traveler.', style: DSTypography.body.copyWith(color: DSColors.textSecondary)),
            const SizedBox(height: DSSpacing.xl),

            GlassCard(
              padding: const EdgeInsets.all(DSSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StatusChip(label: 'Scheduled', status: ChipStatus.neutral),
                  const SizedBox(height: DSSpacing.md),
                  _buildInfoRow('Date', 'Tomorrow, 8:00 AM'),
                  const SizedBox(height: DSSpacing.sm),
                  _buildInfoRow('Route', 'Pune → Mumbai'),
                  const SizedBox(height: DSSpacing.sm),
                  _buildInfoRow('Seats booked', '2/4'),
                  const SizedBox(height: DSSpacing.sm),
                  _buildInfoRow('Expected Cost Recovery', '₹1200'),
                ],
              ),
            ),
            const SizedBox(height: DSSpacing.md),

            GlassCard(
              padding: const EdgeInsets.all(DSSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StatusChip(label: 'Completed', status: ChipStatus.verified),
                  const SizedBox(height: DSSpacing.md),
                  _buildInfoRow('Date', '10 Oct, 6:00 PM'),
                  const SizedBox(height: DSSpacing.sm),
                  _buildInfoRow('Route', 'Kolhapur → Pune'),
                  const SizedBox(height: DSSpacing.sm),
                  _buildInfoRow('Seats booked', '4/4'),
                  const SizedBox(height: DSSpacing.sm),
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
        Text(label, style: DSTypography.body),
        Text(value, style: DSTypography.body.copyWith(fontWeight: FontWeight.bold, color: DSColors.textPrimary)),
      ],
    );
  }
}
