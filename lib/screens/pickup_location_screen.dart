import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../models/ride_models.dart';
import '../spotter_widgets.dart';
import '../white_text_field.dart';

class PickupLocationScreen extends StatefulWidget {
  const PickupLocationScreen({super.key});

  @override
  State<PickupLocationScreen> createState() => _PickupLocationScreenState();
}

class _PickupLocationScreenState extends State<PickupLocationScreen> {
  late final TextEditingController _pickupController;
  late final TextEditingController _landmarkController;
  bool _seededPickup = false;

  @override
  void initState() {
    super.initState();
    _pickupController = TextEditingController();
    _landmarkController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seededPickup) return;

    _pickupController.text = RideScope.of(context).pickup.detail;
    _seededPickup = true;
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);

    return SpotterScreen(
      title: 'Pickup location',
      subtitle: 'Confirm where your driver should meet you.',
      content: [
        RecoveryBanner(state: ride.actionState, onRetry: ride.retryInitialize),
        RideContextCard(
          route: ride.routeLabel,
          fare: ride.fareLabel,
          driver: ride.selectedDriver?.name ?? 'Matching',
          status: ride.status.name,
        ),
        MapPlaceholder(height: 165),
        WhiteTextField(
          controller: _pickupController,
          labelText: 'Pickup',
          hintText: ride.pickup.detail,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => _savePickup(context),
        ),
        const SizedBox(height: 14),
        WhiteTextField(
          controller: _landmarkController,
          labelText: 'Landmark',
          hintText: 'Near main gate',
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _savePickup(context),
        ),
        const SizedBox(height: 14),
        const SpotterCard(
          children: [
            InfoRow(label: 'Pickup time', value: 'Now'),
            InfoRow(label: 'Contact privacy', value: 'Number masked'),
            InfoRow(label: 'Walk distance', value: '120 m'),
          ],
        ),
      ],
      bottom: PrimaryAction(
        label: 'Choose destination',
        onPressed: () {
          _savePickup(context, showMessage: false);
          Navigator.pushNamed(context, AppRoutes.destination);
        },
      ),
    );
  }

  void _savePickup(BuildContext context, {bool showMessage = true}) {
    final pickup = _pickupController.text.trim();
    if (pickup.isEmpty) return;

    final landmark = _landmarkController.text.trim();
    final detail = landmark.isEmpty ? pickup : '$pickup, $landmark';
    RideScope.of(
      context,
    ).updatePickup(LocationPoint(title: pickup, detail: detail));

    if (showMessage) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pickup details saved')));
    }
  }
}
