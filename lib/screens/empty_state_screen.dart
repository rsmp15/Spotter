import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../helper.dart';
import '../spotter_widgets.dart';

class EmptyStateScreen extends StatelessWidget {
  const EmptyStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpotterScreen(
      title: 'No drivers yet',
      subtitle: 'Try a wider pickup time or a nearby point.',
      content: [
        Center(
          child: CircleAvatar(
            radius: 96,
            backgroundColor: Color(0xFFEAF2FF),
            child: Text(
              'NO MATCH',
              style: TextStyle(
                color: Helper.primary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 28),
        Text(
          'We could not find a driver on this route right now.',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12),
        Text(
          'Edit route, change pickup time or enable alerts for new matches.',
          style: TextStyle(color: Helper.muted),
          textAlign: TextAlign.center,
        ),
      ],
      bottom: PrimaryAction(label: 'Edit route', routeName: AppRoutes.home),
    );
  }
}
