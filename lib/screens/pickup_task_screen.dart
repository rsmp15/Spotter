import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../helper.dart';
import '../spotter_widgets.dart';
import '../white_text_field.dart';

class PickupTaskScreen extends StatelessWidget {
  const PickupTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpotterScreen(
      title: 'Pickup task',
      subtitle: 'Verify before starting the ride.',
      content: [
        SpotterCard(
          children: [
            InfoRow(
              label: 'Reach pickup',
              value: 'Done',
              valueColor: Helper.success,
            ),
            InfoRow(
              label: 'Match rider name',
              value: 'Done',
              valueColor: Helper.success,
            ),
            InfoRow(
              label: 'Enter ride OTP',
              value: 'Pending',
              valueColor: Helper.warning,
            ),
          ],
        ),
        WhiteTextField(labelText: 'Rider OTP', hintText: 'Enter six digit OTP'),
      ],
      bottom: PrimaryAction(label: 'Start ride', routeName: AppRoutes.dropTask),
    );
  }
}
