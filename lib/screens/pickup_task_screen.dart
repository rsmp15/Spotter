import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../helper.dart';
import '../spotter_widgets.dart';
import '../white_text_field.dart';

class PickupTaskScreen extends StatefulWidget {
  const PickupTaskScreen({super.key});

  @override
  State<PickupTaskScreen> createState() => _PickupTaskScreenState();
}

class _PickupTaskScreenState extends State<PickupTaskScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _otpController.text = '123456';
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpotterScreen(
      title: 'Pickup task',
      subtitle: 'Verify before starting the ride.',
      content: [
        const SpotterCard(
          children: [
            InfoRow(
              label: 'Reach pickup',
              value: 'Done',
              valueColor: Helper.success,
            ),
            InfoRow(
              label: 'Match rider name',
              value: 'Done',
              valueColor: Helper.success,
            ),
            InfoRow(
              label: 'Enter ride OTP',
              value: 'Pending',
              valueColor: Helper.warning,
            ),
          ],
        ),
        WhiteTextField(
          controller: _otpController,
          labelText: 'Rider OTP',
          hintText: 'Enter six digit OTP',
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _startRide(context),
        ),
      ],
      bottom: PrimaryAction(
        label: 'Start ride',
        onPressed: () => _startRide(context),
      ),
    );
  }

  void _startRide(BuildContext context) {
    if (_otpController.text.trim().length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter the rider OTP')));
      return;
    }

    Navigator.pushNamed(context, AppRoutes.dropTask);
  }
}
