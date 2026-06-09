import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/app_routes.dart';
import '../core/components/spott_buttons.dart';
import '../core/components/status_chip.dart';
import '../theme/spott_theme.dart';

class ActiveTripScreen extends StatelessWidget {
  const ActiveTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SpottTheme.background,
      appBar: AppBar(
        backgroundColor: SpottTheme.background,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        title: Text('Active Trip', style: SpottTheme.textTheme.titleLarge),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(SpottTheme.spacingLarge),
            children: [
              Text(
                'Navigating to destination',
                style: SpottTheme.textTheme.headlineMedium,
              ),
              const SizedBox(height: SpottTheme.spacingLarge),

              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: SpottTheme.surface,
                  borderRadius: BorderRadius.circular(SpottTheme.radiusXLarge),
                  boxShadow: SpottTheme.premiumShadow,
                ),
                child: const Center(
                  child: Icon(Icons.map_rounded, size: 48, color: Colors.white70),
                ),
              ),
              const SizedBox(height: SpottTheme.spacingLarge),

              Container(
                decoration: BoxDecoration(
                  color: SpottTheme.surface,
                  borderRadius: BorderRadius.circular(SpottTheme.radiusLarge),
                  boxShadow: SpottTheme.premiumShadow,
                ),
                padding: const EdgeInsets.all(SpottTheme.spacingLarge),
                child: Column(
                  children: [
                    _buildInfoRow('ETA', '45 mins'),
                    const SizedBox(height: SpottTheme.spacingSmall),
                    _buildInfoRow('Next Stop', 'Drop Arjun (Koregaon Park)'),
                  ],
                ),
              ),
              const SizedBox(height: SpottTheme.spacingLarge),

              Container(
                decoration: BoxDecoration(
                  color: SpottTheme.surface,
                  borderRadius: BorderRadius.circular(SpottTheme.radiusLarge),
                  boxShadow: SpottTheme.premiumShadow,
                ),
                padding: const EdgeInsets.all(SpottTheme.spacingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StatusChip(label: 'Passengers', status: ChipStatus.verified),
                    const SizedBox(height: SpottTheme.spacingLarge),
                    _buildInfoRow('Arjun K.', 'Drop: Koregaon Park'),
                    const SizedBox(height: SpottTheme.spacingSmall),
                    _buildInfoRow('Priya M.', 'Drop: Viman Nagar'),
                  ],
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
          Positioned(
            bottom: SpottTheme.spacingLarge,
            left: SpottTheme.spacingLarge,
            right: SpottTheme.spacingLarge,
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
        Text(label, style: SpottTheme.textTheme.bodyLarge),
        Text(
          value,
          style: SpottTheme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
