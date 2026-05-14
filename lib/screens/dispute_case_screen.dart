import 'package:flutter/material.dart';

import '../helper.dart';
import '../spotter_widgets.dart';
import '../white_text_field.dart';

class DisputeCaseScreen extends StatelessWidget {
  const DisputeCaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpotterScreen(
      title: 'Issue report',
      subtitle: 'Submit evidence and track review.',
      content: [
        SpotterCard(
          children: [
            InfoRow(label: 'Ride', value: 'SPT2049'),
            InfoRow(
              label: 'Issue',
              value: 'Safety concern',
              valueColor: Helper.danger,
            ),
            InfoRow(label: 'Evidence', value: 'Not added'),
            InfoRow(
              label: 'Status',
              value: 'Draft',
              valueColor: Helper.warning,
            ),
          ],
        ),
        WhiteTextField(
          labelText: 'Describe issue',
          hintText: 'Tell us what happened',
        ),
        SizedBox(height: 14),
        SpotterCard(
          children: [
            Text(
              'Add photos, notes or call details. Spotter support will review and respond.',
              style: TextStyle(color: Helper.muted),
            ),
          ],
        ),
      ],
    );
  }
}
