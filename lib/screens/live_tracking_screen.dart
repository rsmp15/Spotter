import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../helper.dart';
import '../spotter_widgets.dart';

class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);

    return SpotterScreen(
      title: 'Live tracking',
      subtitle: ride.rideSummary,
      content: [
        const MapPlaceholder(height: 220),
        SpotterCard(
          children: [
            const StatusChip(label: 'Driver assigned', color: Helper.success),
            const SizedBox(height: 12),
            const InfoRow(
              label: 'Current status',
              value: 'Reaching pickup',
              valueColor: Helper.primary,
            ),
            InfoRow(
              label: 'Expected arrival',
              value: ride.selectedDriver?.eta ?? '2 min',
            ),
            InfoRow(
              label: 'Driver',
              value: ride.selectedDriver?.name ?? 'Amit Sharma',
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: PrimaryAction(label: 'Chat', routeName: AppRoutes.chat),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PrimaryAction(
                label: 'Support',
                routeName: AppRoutes.support,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: PrimaryAction(
                label: 'Share',
                routeName: AppRoutes.shareTrip,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PrimaryAction(
                label: 'Cancel',
                routeName: AppRoutes.cancelRide,
              ),
            ),
          ],
        ),
      ],
      bottom: const PrimaryAction(
        label: 'Show ride OTP',
        routeName: AppRoutes.rideOtp,
      ),
    );
  }
}
