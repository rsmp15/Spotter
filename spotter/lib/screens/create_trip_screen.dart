import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../spotter_widgets.dart';
import '../white_text_field.dart';
import 'driver_bottom_nav.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  int _availableSeats = 2;
  bool _parcelAllowed = false;
  DateTime _departureDate = DateTime.now();
  TimeOfDay _departureTime = const TimeOfDay(hour: 18, minute: 0);

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fromController.text = 'Baner';
    _toController.text = 'Koregaon Park';
    _priceController.text = '150';
  }

  @override
  Widget build(BuildContext context) {
    final departureDateStr = '${_departureDate.day}/${_departureDate.month}/${_departureDate.year}';
    final departureTimeStr = _departureTime.format(context);

    return SpotterScreen(
      title: 'Offer a Trip',
      subtitle: 'Share your route and split travel costs.',
      showBack: false, // Hide back button since bottom nav is active
      bottomNavigationBar: const DriverBottomNav(activeTab: DriverBottomTab.createAvailability),
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

        // Available seats selector
        SpotterCard(
          children: [
            const Text(
              'Available seats',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  onPressed: _availableSeats > 1
                      ? () => setState(() => _availableSeats--)
                      : null,
                  icon: const Icon(Icons.remove_circle_outline_rounded),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '$_availableSeats',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                ),
                IconButton(
                  onPressed: _availableSeats < 6
                      ? () => setState(() => _availableSeats++)
                      : null,
                  icon: const Icon(Icons.add_circle_outline_rounded),
                ),
                const SizedBox(width: 8),
                const Text('seats', style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Price per seat
        WhiteTextField(
          controller: _priceController,
          labelText: 'Price per seat (Rs)',
          hintText: '150',
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 14),

        // Departure date and time
        SpotterCard(
          children: [
            const Text(
              'Departure',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            InfoRow(label: 'Date', value: departureDateStr),
            InfoRow(label: 'Time', value: departureTimeStr),
          ],
        ),
        const SizedBox(height: 14),

        // Parcel allowed toggle
        SpotterCard(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Parcels allowed',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                Switch(
                  value: _parcelAllowed,
                  onChanged: (v) => setState(() => _parcelAllowed = v),
                  activeColor: Colors.black,
                ),
              ],
            ),
            const Text(
              'Allow passengers to send parcels on this trip',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Route context info
        SpotterCard(
          children: [
            InfoRow(label: 'Visible to passengers', value: 'Yes'),
            InfoRow(label: 'Allowed pickup radius', value: '5 km'),
          ],
        ),
      ],
      bottom: PrimaryAction(
        label: 'Publish Trip',
        onPressed: () => _publishTrip(context),
      ),
    );
  }

  void _publishTrip(BuildContext context) {
    if (_fromController.text.trim().isEmpty ||
        _toController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete all trip details')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Trip published successfully!')),
    );
    Navigator.pushNamed(context, AppRoutes.driverHome);
  }
}
