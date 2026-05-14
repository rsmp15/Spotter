import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../helper.dart';
import '../spotter_widgets.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpotterScreen(
      title: 'Earn on your trip',
      subtitle: 'Go online and accept nearby rides.',
      content: [
        SpotterCard(
          children: [
            Text('Today earnings', style: TextStyle(color: Helper.muted)),
            SizedBox(height: 8),
            Text(
              'Rs 1240',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
            InfoRow(label: 'Active trips', value: '2'),
            InfoRow(label: 'Rating', value: '4.9', valueColor: Helper.success),
          ],
        ),
        SpotterCard(
          children: [
            Text(
              'Nearby requests',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            InfoRow(
              label: 'Best payout',
              value: 'Rs 650',
              valueColor: Helper.primary,
            ),
            InfoRow(label: 'Closest pickup', value: '1.2 km'),
            InfoRow(label: 'Vehicle needed', value: 'Auto'),
          ],
        ),
      ],
      bottom: PrimaryAction(
        label: 'Add availability',
        routeName: AppRoutes.createTrip,
      ),
    );
  }
}

class DriverRequestsAction extends StatelessWidget {
  const DriverRequestsAction({super.key});

  @override
  Widget build(BuildContext context) {
    return const PrimaryAction(
      label: 'View requests',
      routeName: AppRoutes.jobRequests,
    );
  }
}
