import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../helper.dart';
import '../spotter_widgets.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SpotterScreen(
      title: 'Help and safety',
      subtitle: 'Get support for any ride.',
      content: [
        SpotterCard(
          children: [
            PrimaryAction(
              label: 'Report unsafe behavior',
              routeName: AppRoutes.issue,
            ),
            const SizedBox(height: 12),
            PrimaryAction(label: 'Payment problem', routeName: AppRoutes.issue),
          ],
        ),
        const SpotterCard(
          children: [
            InfoRow(
              label: 'Refund request',
              value: 'Open',
              valueColor: Helper.primary,
            ),
            InfoRow(
              label: 'Lost item',
              value: 'Open',
              valueColor: Helper.primary,
            ),
            InfoRow(
              label: 'Driver issue',
              value: 'Open',
              valueColor: Helper.primary,
            ),
            InfoRow(
              label: 'Safety center',
              value: 'Open',
              valueColor: Helper.primary,
            ),
          ],
        ),
      ],
    );
  }
}
