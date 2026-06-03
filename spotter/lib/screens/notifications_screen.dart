import 'package:flutter/material.dart';

import '../spotter_widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SpotterScreen(
      title: 'Notifications',
      subtitle: 'Important ride updates.',
      content: [
        _NotificationTile(
          title: 'Amit accepted your ride',
          time: '2 minutes ago',
          onTap: () => _showNotification(context, 'Ride update opened'),
        ),
        _NotificationTile(
          title: 'Ride OTP generated',
          time: 'Today',
          onTap: () => _showNotification(context, 'Ride OTP details opened'),
        ),
        _NotificationTile(
          title: 'Wallet top-up successful',
          time: 'Today',
          onTap: () => _showNotification(context, 'Wallet receipt opened'),
        ),
        _NotificationTile(
          title: 'Safety contact added',
          time: 'Yesterday',
          onTap: () => _showNotification(context, 'Safety contact opened'),
        ),
      ],
    );
  }

  void _showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _NotificationTile extends StatelessWidget {
  final String title;
  final String time;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.title,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SpotterCard(
      height: 78,
      onTap: onTap,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(time, style: const TextStyle(color: Color(0xFF667085), fontSize: 13)),
      ],
    );
  }
}
