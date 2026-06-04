import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../helper.dart';
import '../spotter_widgets.dart';

class NetworkErrorScreen extends StatelessWidget {
  const NetworkErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpotterScreen(
      title: 'Connection Lost',
      subtitle: 'Please check your network and try again.',
      showBack: true,
      content: [
        Center(
          child: CircleAvatar(
            radius: 96,
            backgroundColor: Helper.canvasSoft,
            child: Text('🌐', style: TextStyle(fontSize: 48)),
          ),
        ),
        SizedBox(height: 28),
        Text(
          'You are offline.',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12),
        Text(
          'Ensure your device is connected to Wi-Fi or cellular data.',
          style: TextStyle(color: Helper.muted),
          textAlign: TextAlign.center,
        ),
      ],
      bottom: PrimaryAction(label: 'Retry', routeName: AppRoutes.home),
    );
  }
}
