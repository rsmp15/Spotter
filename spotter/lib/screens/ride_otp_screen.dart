import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../helper.dart';
import '../spotter_widgets.dart';

class RideOtpScreen extends StatelessWidget {
  const RideOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);

    return SpotterScreen(
      title: 'Ride OTP',
      subtitle: 'Share only after matching the vehicle and driver.',
      content: [
        const SpotterCard(
          children: [
            Center(
              child: Text(
                '738492',
                style: TextStyle(
                  color: Helper.primary,
                  fontSize: 44,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            SizedBox(height: 12),
            Center(
              child: Text(
                'Valid for 10 minutes',
                style: TextStyle(
                  color: Helper.muted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SpotterCard(
          children: [
            InfoRow(label: 'Driver ID', value: 'Matched'),
            InfoRow(label: 'Vehicle plate', value: 'Matched'),
            InfoRow(label: 'Start trip', value: 'After OTP'),
          ],
        ),
      ],
      bottom: PrimaryAction(
        label: 'End demo ride',
        onPressed: () {
          ride.markCompleted();
          Navigator.pushNamed(context, AppRoutes.rideComplete);
        },
      ),
    );
  }
}

