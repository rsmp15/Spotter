import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../helper.dart';
import '../spotter_widgets.dart';

class RideConfirmationScreen extends StatelessWidget {
  const RideConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);

    return SpotterScreen(
      title: 'Confirm ride',
      subtitle: 'Review route, driver and payment before booking.',
      content: [
        RecoveryBanner(state: ride.actionState, onRetry: ride.retryInitialize),
        RideContextCard(
          route: ride.routeLabel,
          fare: ride.fareLabel,
          driver: ride.selectedDriver?.name ?? 'Matching',
          status: ride.status.name,
        ),
        SpotterCard(
          children: [
            InfoRow(label: 'Pickup', value: ride.pickup.detail),
            InfoRow(label: 'Drop', value: ride.destination.detail),
            InfoRow(
              label: 'Driver',
              value: ride.selectedDriver?.name ?? 'Matching',
            ),
            const InfoRow(
              label: 'Ride OTP',
              value: 'Required',
              valueColor: Helper.success,
            ),
          ],
        ),
        SpotterCard(
          children: [
            InfoRow(
              label: 'Amount',
              value: ride.fareLabel,
              valueColor: Helper.primary,
            ),
            const InfoRow(label: 'Cancellation', value: 'Free for 2 min'),
            const InfoRow(
              label: 'Safety',
              value: 'Trip monitored',
              valueColor: Helper.success,
            ),
          ],
        ),
      ],
      bottom: const PrimaryAction(
        label: 'Pay securely',
        routeName: AppRoutes.payment,
      ),
    );
  }
}
