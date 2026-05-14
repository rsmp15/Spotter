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
        for (final reason in reasons)
          SpotterCard(
            height: 68,
            onTap: () {
              final messenger = ScaffoldMessenger.of(context);
              ride.cancelRide(reason);
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
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
