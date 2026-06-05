import 'package:flutter/material.dart';

import '../app/app_routes.dart';

import '../spotter_widgets.dart';

class JobDetailScreen extends StatelessWidget {
  const JobDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpotterScreen(
      title: 'Request details',
      subtitle: 'Check rider, route and payout.',
      content: [
        MapPlaceholder(height: 170),
        SpotterCard(
          children: [
            InfoRow(label: 'Pickup', value: 'Baner Pune'),
            InfoRow(label: 'Drop', value: 'Koregaon Park'),
            InfoRow(label: 'Rider rating', value: '4.8'),
            InfoRow(label: 'Payout', value: 'Rs 390'),
          ],
        ),
        SpotterCard(
          children: [
            InfoRow(label: 'Ride OTP', value: 'Required'),
            InfoRow(label: 'Payment', value: 'Protected'),
          ],
        ),
      ],
      bottom: PrimaryAction(
        label: 'Accept request',
        routeName: AppRoutes.pickupTask,
      ),
    );
  }
}
