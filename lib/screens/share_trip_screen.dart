import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/ride_controller.dart';
import '../helper.dart';
import '../spotter_widgets.dart';

class ShareTripScreen extends StatelessWidget {
  const ShareTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);

    return SpotterScreen(
      title: 'Share trip',
      subtitle: 'Send live ride status to someone you trust.',
      content: [
        SpotterCard(
          children: [
            const StatusChip(label: 'Live link ready', color: Helper.success),
            const SizedBox(height: 14),
            Text(
              ride.shareLink,
              style: const TextStyle(
                color: Helper.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${ride.selectedDriver?.name ?? 'Your driver'} is taking you from ${ride.pickup.title} to ${ride.destination.title}.',
              style: const TextStyle(color: Helper.muted),
            ),
          ],
        ),
        const SpotterCard(
          children: [
            InfoRow(label: 'Shared details', value: 'Route, driver, ETA'),
            InfoRow(label: 'Contact privacy', value: 'Phone hidden'),
            InfoRow(label: 'Expires', value: 'After trip ends'),
          ],
        ),
      ],
      bottom: PrimaryAction(
        label: 'Copy share link',
        onPressed: () async {
          await Clipboard.setData(ClipboardData(text: ride.shareLink));
          if (!context.mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Trip link copied')));
        },
      ),
    );
  }
}
