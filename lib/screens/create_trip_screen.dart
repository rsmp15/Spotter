import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../spotter_widgets.dart';
import '../white_text_field.dart';

class CreateTripScreen extends StatelessWidget {
  const CreateTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpotterScreen(
      title: 'Create availability',
      subtitle: 'Tell riders where you can pick up.',
      content: [
        WhiteTextField(labelText: 'From', hintText: 'Baner'),
        SizedBox(height: 14),
        WhiteTextField(labelText: 'To', hintText: 'Koregaon Park'),
        SizedBox(height: 14),
        WhiteTextField(labelText: 'Available until', hintText: 'Today 6 PM'),
        SizedBox(height: 14),
        SpotterCard(
          children: [
            InfoRow(label: 'Visible to riders', value: 'Yes'),
            InfoRow(label: 'Allowed pickup radius', value: '5 km'),
          ],
        ),
      ],
      bottom: PrimaryAction(
        label: 'Publish availability',
        routeName: AppRoutes.jobRequests,
      ),
    );
  }
}
