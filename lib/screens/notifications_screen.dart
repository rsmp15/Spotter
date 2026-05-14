import 'package:flutter/material.dart';

import '../spotter_widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpotterScreen(
      title: 'Notifications',
      subtitle: 'Important ride updates.',
      content: [
        _NotificationTile(
          title: 'Amit accepted your ride',
          time: '2 minutes ago',
        ),
        _NotificationTile(title: 'Ride OTP generated', time: 'Today'),
        _NotificationTile(title: 'Wallet top-up successful', time: 'Today'),
        _NotificationTile(title: 'Safety contact added', time: 'Yesterday'),
      ],
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final String title;
  final String time;

  const _NotificationTile({required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    return SpotterCard(
      height: 78,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(time, style: const TextStyle(color: Color(0xFF667085))),
      ],
    );
  }
}
