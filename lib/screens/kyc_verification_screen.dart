import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../helper.dart';
import '../spotter_widgets.dart';

class KycVerificationScreen extends StatelessWidget {
  const KycVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpotterScreen(
      title: 'Complete KYC',
      subtitle: 'Required before accepting rides.',
      content: [
        SpotterCard(
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
        _KycTile(title: 'Aadhaar or PAN', status: 'Pending'),
        _KycTile(title: 'Selfie verification', status: 'Pending'),
        _KycTile(title: 'Driving licence', status: 'Required'),
        _KycTile(title: 'Vehicle document', status: 'Required'),
      ],
      bottom: PrimaryAction(
        label: 'Continue demo',
        routeName: AppRoutes.driverHome,
      ),
    );
  }
}

class _KycTile extends StatelessWidget {
  final String title;
  final String status;

  const _KycTile({required this.title, required this.status});

  @override
  Widget build(BuildContext context) {
    return SpotterCard(
      height: 68,
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
