import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../helper.dart';
import '../models/production_readiness_models.dart';
import '../spotter_widgets.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final supportCase = SupportCase.forRide(
      rideReference: ride.shareLink.split('/').last,
      role: UserRole.rider,
      category: SupportCaseCategory.technical,
      description: 'Help request from ride flow',
    );

    return SpotterScreen(
      title: 'Help and safety',
      subtitle: 'Get support for any ride.',
      content: [
        RideContextCard(
          route: ride.routeLabel,
          fare: ride.fareLabel,
          driver: ride.selectedDriver?.name ?? 'Matching',
          status: ride.status.name,
        ),
        SpotterCard(
          children: [
            InfoRow(label: 'Ride reference', value: supportCase.rideReference),
            InfoRow(label: 'Role', value: supportCase.roleLabel),
            InfoRow(label: 'Issue category', value: supportCase.categoryLabel),
            InfoRow(
              label: 'Status',
              value: supportCase.statusLabel,
              valueColor: Helper.primary,
            ),
          ],
        ),
        SpotterCard(
          children: [
            PrimaryAction(
              label: 'Report unsafe behavior',
              routeName: AppRoutes.dispute,
            ),
            const SizedBox(height: 12),
            PrimaryAction(
              label: 'Payment problem',
              routeName: AppRoutes.dispute,
            ),
          ],
        ),
        _SupportActionCard(
          label: 'Refund request',
          onTap: () => _showSupportMessage(context, 'Refund request opened'),
        ),
        _SupportActionCard(
          label: 'Lost item',
          onTap: () => _showSupportMessage(context, 'Lost item case opened'),
        ),
        _SupportActionCard(
          label: 'Driver issue',
          onTap: () => Navigator.pushNamed(context, AppRoutes.dispute),
        ),
        _SupportActionCard(
          label: 'Safety center',
          onTap: () => _showSupportMessage(context, 'Safety center opened'),
        ),
      ],
    );
  }

  void _showSupportMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SupportActionCard extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SupportActionCard({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SpotterCard(
      height: 64,
      onTap: onTap,
      children: [
        InfoRow(label: label, value: 'Open', valueColor: Helper.primary),
      ],
    );
  }
}
