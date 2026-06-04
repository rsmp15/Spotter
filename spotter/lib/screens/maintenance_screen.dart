import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../helper.dart';
import '../spotter_widgets.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpotterScreen(
      title: 'Optimizing Platform',
      subtitle: 'Spott is undergoing upgrades. We\'ll be back shortly.',
      showBack: false,
      content: [
        Center(
          child: CircleAvatar(
            radius: 96,
            backgroundColor: Helper.canvasSoft,
            child: Text('⚙️', style: TextStyle(fontSize: 48)),
          ),
        ),
        SizedBox(height: 28),
        Text(
          'Scheduled Maintenance',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12),
        Text(
          'We are making the app faster and more reliable.',
          style: TextStyle(color: Helper.muted),
          textAlign: TextAlign.center,
        ),
      ],
      bottom: PrimaryAction(label: 'Check Status', routeName: AppRoutes.splash),
    );
  }
}
