import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../spotter_widgets.dart';
import '../white_text_field.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _untilController = TextEditingController();

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _untilController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fromController.text = 'Baner';
    _toController.text = 'Koregaon Park';
    _untilController.text = 'Today 6 PM';
  }

  @override
  Widget build(BuildContext context) {
    return SpotterScreen(
      title: 'Create availability',
      subtitle: 'Tell riders where you can pick up.',
      content: [
        WhiteTextField(
          controller: _fromController,
          labelText: 'From',
          hintText: 'Baner',
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 14),
        WhiteTextField(
          controller: _toController,
          labelText: 'To',
          hintText: 'Koregaon Park',
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 14),
        WhiteTextField(
          controller: _untilController,
          labelText: 'Available until',
          hintText: 'Today 6 PM',
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _publishAvailability(context),
        ),
        const SizedBox(height: 14),
        const SpotterCard(
          children: [
            InfoRow(label: 'Visible to riders', value: 'Yes'),
            InfoRow(label: 'Allowed pickup radius', value: '5 km'),
          ],
        ),
      ],
      bottom: PrimaryAction(
        label: 'Publish availability',
        onPressed: () => _publishAvailability(context),
      ),
    );
  }

  void _publishAvailability(BuildContext context) {
    if (_fromController.text.trim().isEmpty ||
        _toController.text.trim().isEmpty ||
        _untilController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete availability details')),
      );
      return;
    }

    Navigator.pushNamed(context, AppRoutes.jobRequests);
  }
}
