import 'package:flutter/material.dart';

import '../helper.dart';
import '../spotter_widgets.dart';

class PassengerTripsScreen extends StatelessWidget {
  const PassengerTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpotterScreen(
      title: 'My Trips',
      subtitle: 'Upcoming and past intercity trips.',
      showBack: true,
      content: [
        SpotterCard(
          children: [
            StatusChip(label: 'Upcoming', color: Helper.success),
            SizedBox(height: 12),
            InfoRow(label: 'Date', value: 'Today, 4:30 PM'),
            InfoRow(label: 'Route', value: 'Pune → Kolhapur'),
            InfoRow(label: 'Driver', value: 'Arjun K.'),
            InfoRow(label: 'Cost', value: 'Rs 850'),
          ],
        ),
        SpotterCard(
          children: [
            StatusChip(label: 'Completed', color: Helper.muted),
            SizedBox(height: 12),
            InfoRow(label: 'Date', value: '12 Oct, 10:00 AM'),
            InfoRow(label: 'Route', value: 'Mumbai → Pune'),
            InfoRow(label: 'Driver', value: 'Priya M.'),
            InfoRow(label: 'Cost', value: 'Rs 650'),
          ],
        ),
      ],
    );
  }
}
