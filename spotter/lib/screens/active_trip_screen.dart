import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/status_chip.dart';
import '../core/components/spott_buttons.dart';
import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';
import '../core/theme/radius.dart';

class ActiveTripScreen extends StatelessWidget {
  const ActiveTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: SpottColors.textPrimary),
        title: const Text('Active Trip', style: SpottTextStyles.sectionTitle),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(SpottSpacing.lg),
            children: [
              Text('Navigating to destination...', style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary)),
              const SizedBox(height: SpottSpacing.xl),

              // Map Placeholder
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: SpottColors.surface1,
                  borderRadius: BorderRadius.circular(SpottRadius.card),
                  border: Border.all(color: SpottColors.border),
                ),
                child: const Center(
                  child: Icon(Icons.map_rounded, size: 48, color: SpottColors.textSecondary),
                ),
              ),
              const SizedBox(height: SpottSpacing.lg),

              GlassCard(
                padding: const EdgeInsets.all(SpottSpacing.md),
                child: Column(
                  children: [
                    _buildInfoRow('ETA', '45 mins'),
                    const SizedBox(height: SpottSpacing.sm),
                    _buildInfoRow('Next Stop', 'Drop Arjun (Koregaon Park)'),
                  ],
                ),
              ),
              const SizedBox(height: SpottSpacing.md),

              GlassCard(
                padding: const EdgeInsets.all(SpottSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StatusChip(label: 'Passengers', status: ChipStatus.verified),
                    const SizedBox(height: SpottSpacing.md),
                    _buildInfoRow('Arjun K.', 'Drop: Koregaon Park'),
                    const SizedBox(height: SpottSpacing.sm),
                    _buildInfoRow('Priya M.', 'Drop: Viman Nagar'),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
          Positioned(
            bottom: SpottSpacing.lg,
            left: SpottSpacing.lg,
            right: SpottSpacing.lg,
            child: SpottButton.primary(
              label: 'End Trip',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.driverHome),
            ),
          ),
        ],
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
