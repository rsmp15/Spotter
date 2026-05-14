import 'package:flutter/material.dart';

import '../helper.dart';
import '../spotter_widgets.dart';

class AdminReviewScreen extends StatelessWidget {
  const AdminReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpotterScreen(
      title: 'Admin review',
      subtitle: 'Trust and safety operations.',
      content: [
        SpotterCard(
          children: [
            InfoRow(
              label: 'Pending KYC',
              value: '148',
              valueColor: Helper.warning,
            ),
            InfoRow(
              label: 'Flagged rides',
              value: '12',
              valueColor: Helper.danger,
            ),
            InfoRow(
              label: 'Open issues',
              value: '7',
              valueColor: Helper.primary,
            ),
            InfoRow(label: 'High risk routes', value: '4'),
          ],
        ),
        SpotterCard(
          children: [
            StatusChip(label: 'Needs action', color: Helper.danger),
            SizedBox(height: 12),
            Text(
              'Safety case SPT2031',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            InfoRow(label: 'Evidence', value: '3 photos'),
            InfoRow(
              label: 'SLA',
              value: '4 hours left',
              valueColor: Helper.warning,
            ),
          ],
        ),
      ],
    );
  }
}
