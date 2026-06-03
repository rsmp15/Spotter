import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../helper.dart';
import '../spotter_widgets.dart';

class RideCompleteScreen extends StatelessWidget {
  const RideCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);

    return SpotterScreen(
      title: 'Ride complete',
      subtitle: 'Thanks for riding with Spott.',
      content: [
        const Center(
          child: CircleAvatar(
            radius: 84,
            backgroundColor: Helper.canvasSoft,
            child: const Text(
              'DONE',
              style: TextStyle(
                color: Helper.ink,
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        SpotterCard(
          children: [
            const InfoRow(label: 'Ride ID', value: 'SPT2049'),
            InfoRow(
              label: 'Paid',
              value: ride.fareLabel,
              valueColor: Helper.primary,
            ),
            const InfoRow(label: 'Completed at', value: '1:08 PM'),
            InfoRow(
              label: 'Driver',
              value: ride.selectedDriver?.name ?? 'Amit Sharma',
            ),
          ],
        ),
      ],
      bottom: const PrimaryAction(
        label: 'Rate driver',
        routeName: AppRoutes.rating,
      ),
    );
  }
}
