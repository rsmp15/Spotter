import 'package:flutter/material.dart';

import '../helper.dart';
import '../spotter_widgets.dart';

class ParcelHistoryScreen extends StatelessWidget {
  const ParcelHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpotterScreen(
      title: 'Parcel History',
      subtitle: 'Past parcel deliveries.',
      showBack: true,
      content: [
        SpotterCard(
          children: [
            StatusChip(label: 'Delivered', color: Helper.success),
            SizedBox(height: 12),
            InfoRow(label: 'Date', value: '15 Oct, 2:30 PM'),
            InfoRow(label: 'Route', value: 'Pune → Mumbai'),
            InfoRow(label: 'Item', value: 'Documents'),
            InfoRow(label: 'Cost', value: 'Rs 300'),
          ],
        ),
        SpotterCard(
          children: [
            StatusChip(label: 'Delivered', color: Helper.success),
            SizedBox(height: 12),
            InfoRow(label: 'Date', value: '02 Oct, 11:00 AM'),
            InfoRow(label: 'Route', value: 'Pune → Kolhapur'),
            InfoRow(label: 'Item', value: 'Small box'),
            InfoRow(label: 'Cost', value: 'Rs 400'),
          ],
        ),
      ],
    );
  }
}

