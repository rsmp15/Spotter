import 'package:flutter/material.dart';

import '../app/app_routes.dart';

import '../spotter_widgets.dart';

class DropTaskScreen extends StatelessWidget {
  const DropTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpotterScreen(
      title: 'Drop task',
      subtitle: 'Complete the trip at destination.',
      content: [
        MapPlaceholder(height: 180),
        SpotterCard(
          children: [
            InfoRow(label: 'Rider', value: 'Ritesh M'),
            InfoRow(label: 'Drop', value: 'Koregaon Park'),
            InfoRow(label: 'Payment', value: 'Confirmed'),
          ],
        ),
      ],
      bottom: PrimaryAction(
        label: 'Complete trip',
        routeName: AppRoutes.driverHome,
      ),
    );
  }
}
