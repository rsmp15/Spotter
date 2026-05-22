import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../helper.dart';
import '../spotter_widgets.dart';

class KycVerificationScreen extends StatelessWidget {
  const KycVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SpotterScreen(
      title: 'Complete KYC',
      subtitle: 'Required before accepting rides.',
      content: [
        const SpotterCard(
          children: [
            Text(
              'Verification progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 14),
            LinearProgressIndicator(value: 0.35, color: Helper.warning),
            SizedBox(height: 10),
            Text(
              '35 percent completed',
              style: TextStyle(
                color: Helper.warning,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        _KycTile(
          title: 'Aadhaar or PAN',
          status: 'Pending',
          onTap: () => _showKycMessage(context, 'Aadhaar or PAN upload opened'),
        ),
        _KycTile(
          title: 'Selfie verification',
          status: 'Pending',
          onTap: () => _showKycMessage(context, 'Selfie verification opened'),
        ),
        _KycTile(
          title: 'Driving licence',
          status: 'Required',
          onTap: () =>
              _showKycMessage(context, 'Driving licence upload opened'),
        ),
        _KycTile(
          title: 'Vehicle document',
          status: 'Required',
          onTap: () =>
              _showKycMessage(context, 'Vehicle document upload opened'),
        ),
      ],
      bottom: const PrimaryAction(
        label: 'Continue demo',
        routeName: AppRoutes.driverHome,
      ),
    );
  }

  void _showKycMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _KycTile extends StatelessWidget {
  final String title;
  final String status;
  final VoidCallback onTap;

  const _KycTile({
    required this.title,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SpotterCard(
      height: 68,
      onTap: onTap,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              status,
              style: const TextStyle(
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
