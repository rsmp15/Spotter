import 'package:flutter/material.dart';

import '../controllers/ride_controller.dart';
import '../helper.dart';
import '../models/production_readiness_models.dart';
import '../spotter_widgets.dart';
import '../white_text_field.dart';

class DisputeCaseScreen extends StatefulWidget {
  const DisputeCaseScreen({super.key});

  @override
  State<DisputeCaseScreen> createState() => _DisputeCaseScreenState();
}

class _DisputeCaseScreenState extends State<DisputeCaseScreen> {
  final TextEditingController _issueController = TextEditingController();

  @override
  void dispose() {
    _issueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final supportCase = SupportCase.forRide(
      rideReference: ride.shareLink.split('/').last,
      role: UserRole.rider,
      category: SupportCaseCategory.safety,
      description: 'Safety concern',
      userConsentAuthorized: true,
    );

    return SpotterScreen(
      title: 'Issue report',
      subtitle: 'Submit evidence and track review.',
      content: [
        SpotterCard(
          children: [
            InfoRow(label: 'Ride reference', value: supportCase.rideReference),
            InfoRow(label: 'Role', value: supportCase.roleLabel),
            InfoRow(
              label: 'Issue category',
              value: supportCase.categoryLabel,
              valueColor: Helper.danger,
            ),
            InfoRow(
              label: 'Status',
              value: supportCase.statusLabel,
              valueColor: Helper.warning,
            ),
          ],
        ),
        WhiteTextField(
          controller: _issueController,
          labelText: 'Describe issue',
          hintText: 'Tell us what happened',
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submitIssue(context),
        ),
        const SizedBox(height: 14),
        const SpotterCard(
          children: [
            Text(
              'Add photos, notes or call details. Spotter support will review and respond.',
              style: TextStyle(color: Helper.muted),
            ),
          ],
        ),
      ],
      bottom: PrimaryAction(
        label: 'Submit issue',
        onPressed: () => _submitIssue(context),
      ),
    );
  }

  void _submitIssue(BuildContext context) {
    if (_issueController.text.trim().length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Describe the issue before submitting')),
      );
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Issue report submitted')));
  }
}
