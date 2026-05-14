import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../helper.dart';
import '../spotter_widgets.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SpotterScreen(
      title: 'Choose role',
      subtitle: 'Ride as a passenger or earn as a driver.',
      content: [
        SpotterCard(
          onTap: () => Navigator.pushNamed(context, AppRoutes.home),
          children: const [
            StatusChip(label: 'Rider'),
            SizedBox(height: 12),
            Text(
              'Book rides',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Find verified autos, bikes and cabs for your route.',
              style: TextStyle(color: Helper.muted),
            ),
          ],
        ),
        SpotterCard(
          onTap: () => Navigator.pushNamed(context, AppRoutes.kyc),
          children: const [
            StatusChip(label: 'Earn', color: Helper.success),
            SizedBox(height: 12),
            Text(
              'Drive with Spotter',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Accept rides that fit your location and vehicle.',
              style: TextStyle(color: Helper.muted),
            ),
          ],
        ),
      ],
    );
  }
}
