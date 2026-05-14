import 'package:flutter/material.dart';

import '../helper.dart';
import '../spotter_widgets.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpotterScreen(
      title: 'Wallet',
      subtitle: 'Payments, offers and ride history.',
      content: [
        SpotterCard(
          color: Color(0xFFEAFBF4),
          children: [
            Text(
              'Available balance',
              style: TextStyle(
                color: Helper.success,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Rs 220',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SpotterCard(
          children: [
            InfoRow(label: 'Koregaon Park ride', value: '- Rs 49'),
            InfoRow(
              label: 'Wallet top-up',
              value: '+ Rs 250',
              valueColor: Helper.success,
            ),
            InfoRow(
              label: 'Referral reward',
              value: '+ Rs 19',
              valueColor: Helper.success,
            ),
          ],
        ),
      ],
    );
  }
}
