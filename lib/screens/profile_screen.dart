import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../helper.dart';
import '../spotter_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SpotterScreen(
      title: 'Profile',
      subtitle: 'Account, safety and preferences.',
      content: [
        const SpotterCard(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Color(0xFFEAF2FF),
                  child: Text(
                    'R',
                    style: TextStyle(
                      color: Helper.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ritesh Mahatme',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rider account',
                      style: TextStyle(color: Helper.muted),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 14),
            StatusChip(label: 'Phone verified', color: Helper.success),
          ],
        ),
        SpotterCard(
          onTap: () => Navigator.pushNamed(context, AppRoutes.wallet),
          children: const [InfoRow(label: 'Wallet', value: 'Open')],
        ),
        SpotterCard(
          children: const [
            InfoRow(label: 'Saved places', value: '3'),
            InfoRow(label: 'Payment methods', value: '2'),
            InfoRow(label: 'Safety contacts', value: '1'),
          ],
        ),
        SpotterCard(
          onTap: () => Navigator.pushNamed(context, AppRoutes.support),
          children: const [InfoRow(label: 'Support', value: 'Open')],
        ),
      ],
    );
  }
}
