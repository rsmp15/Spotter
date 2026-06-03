import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../helper.dart';
import '../spotter_widgets.dart';

class CancelRideScreen extends StatelessWidget {
  const CancelRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    const reasons = [
      'Driver is too far',
      'Changed my plans',
      'Wrong pickup location',
      'Found another ride',
    ];

    return SpotterScreen(
      title: 'Cancel ride',
      subtitle: 'Tell us what happened before ending this ride.',
      content: [
        RecoveryBanner(
          state: ride.actionState,
          onRetry: () {
            if (ride.cancellationReason.isNotEmpty) {
              ride.cancelRide(ride.cancellationReason);
            }
          },
        ),
        RideContextCard(
          route: ride.routeLabel,
          fare: ride.fareLabel,
          driver: ride.selectedDriver?.name ?? 'Matching',
          status: ride.status.name,
        ),
        for (final reason in reasons)
          SpotterCard(
            height: 68,
            onTap: () async {
              final messenger = ScaffoldMessenger.of(context);
              final success = await ride.cancelRide(reason);
              if (!context.mounted) return;
              if (!success) {
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Cancellation failed. Please try again.'),
                  ),
                );
                return;
              }
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              );
              messenger.showSnackBar(
                SnackBar(content: Text('Ride cancelled: $reason')),
              );
            },
            children: [
              Row(
                children: [
                  const Icon(Icons.radio_button_unchecked, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      reason,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ],
          ),
        const SpotterCard(
          color: Color(0xFFFFF4E8),
          children: [
            Text(
              'Cancellation is free for the first 2 minutes after driver assignment.',
              style: TextStyle(
                color: Helper.warning,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
