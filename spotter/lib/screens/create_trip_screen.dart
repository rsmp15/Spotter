import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../models/spott_models.dart' hide TripStatus;
import '../models/spott_models.dart' as spott;
import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_buttons.dart';
import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';
import '../core/theme/radius.dart';

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
  String? _selectedVehicleId;

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
    _fromController.text = 'Pune';
    _toController.text = 'Kolhapur';
    _priceController.text = '450';
  }

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);

    // Lazily set default vehicle selection
    if (_selectedVehicleId == null && ride.selectedVehicleId != null) {
      _selectedVehicleId = ride.selectedVehicleId;
    }

    final departureDateStr = '${_departureDate.day}/${_departureDate.month}/${_departureDate.year}';
    final departureTimeStr = _departureTime.format(context);

    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: SpottColors.textPrimary),
        title: const Text('Offer a Trip', style: SpottTextStyles.sectionTitle),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(SpottSpacing.lg),
            children: [
              Text('Share your route, choose a vehicle, and split costs.', style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary)),
              const SizedBox(height: SpottSpacing.xl),

              // Source and Destination Fields
              TextField(
                controller: _fromController,
                textInputAction: TextInputAction.next,
                style: SpottTextStyles.body.copyWith(color: SpottColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'From',
                  hintText: 'e.g. Pune',
                  labelStyle: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary),
                  hintStyle: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary),
                  filled: true,
                  fillColor: SpottColors.surface1,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(SpottRadius.md), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: SpottSpacing.md),
              TextField(
                controller: _toController,
                textInputAction: TextInputAction.next,
                style: SpottTextStyles.body.copyWith(color: SpottColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'To',
                  hintText: 'e.g. Kolhapur',
                  labelStyle: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary),
                  hintStyle: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary),
                  filled: true,
                  fillColor: SpottColors.surface1,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(SpottRadius.md), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: SpottSpacing.lg),

              // Vehicle Selector Card
              GlassCard(
                padding: const EdgeInsets.all(SpottSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Vehicle', style: SpottTextStyles.sectionTitle),
                    const SizedBox(height: SpottSpacing.md),
                    if (ride.vehicles.isEmpty)
                      TextButton.icon(
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.vehicleManagement),
                        icon: const Icon(Icons.add_circle_outline_rounded, color: SpottColors.primary),
                        label: Text('No vehicles found. Add a vehicle first.', style: SpottTextStyles.body.copyWith(color: SpottColors.primary, fontWeight: FontWeight.bold)),
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.md),
                        decoration: BoxDecoration(
                          color: SpottColors.surface1,
                          borderRadius: BorderRadius.circular(SpottRadius.md),
                          border: Border.all(color: SpottColors.border),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedVehicleId ?? (ride.vehicles.isNotEmpty ? ride.vehicles.first.id : null),
                            isExpanded: true,
                            dropdownColor: SpottColors.surface1,
                            style: SpottTextStyles.body.copyWith(color: SpottColors.textPrimary),
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: SpottColors.textPrimary),
                            items: ride.vehicles.map((v) {
                              return DropdownMenuItem(
                                value: v.id,
                                child: Text('${v.vehicleModel} (${v.vehicleNumber})'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedVehicleId = value);
                              }
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: SpottSpacing.lg),

              // Available seats selector
              GlassCard(
                padding: const EdgeInsets.all(SpottSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Available seats', style: SpottTextStyles.sectionTitle),
                    const SizedBox(height: SpottSpacing.md),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _availableSeats > 1 ? () => setState(() => _availableSeats--) : null,
                          icon: const Icon(Icons.remove_circle_outline_rounded, color: SpottColors.textPrimary),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.lg),
                          child: Text('$_availableSeats', style: SpottTextStyles.screenTitle),
                        ),
                        IconButton(
                          onPressed: _availableSeats < 6 ? () => setState(() => _availableSeats++) : null,
                          icon: const Icon(Icons.add_circle_outline_rounded, color: SpottColors.textPrimary),
                        ),
                        const SizedBox(width: SpottSpacing.sm),
                        Text('seats', style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SpottSpacing.lg),

              // Price per seat
              TextField(
                controller: _priceController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                style: SpottTextStyles.body.copyWith(color: SpottColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Price per seat (₹)',
                  hintText: '450',
                  labelStyle: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary),
                  hintStyle: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary),
                  filled: true,
                  fillColor: SpottColors.surface1,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(SpottRadius.md), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: SpottSpacing.lg),

              // Departure date and time
              GlassCard(
                padding: const EdgeInsets.all(SpottSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Departure Details', style: SpottTextStyles.sectionTitle),
                    const SizedBox(height: SpottSpacing.md),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _departureDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() => _departureDate = picked);
                        }
                      },
                      child: _buildInfoRow('Date (Tap to change)', departureDateStr),
                    ),
                    const SizedBox(height: SpottSpacing.sm),
                    const Divider(color: SpottColors.border),
                    const SizedBox(height: SpottSpacing.sm),
                    InkWell(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _departureTime,
                        );
                        if (picked != null) {
                          setState(() => _departureTime = picked);
                        }
                      },
                      child: _buildInfoRow('Time (Tap to change)', departureTimeStr),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SpottSpacing.lg),

              // Parcel allowed toggle
              GlassCard(
                padding: const EdgeInsets.all(SpottSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Parcels allowed', style: SpottTextStyles.sectionTitle.copyWith(color: SpottColors.primary)),
                        Switch(
                          value: _parcelAllowed,
                          onChanged: (v) => setState(() => _parcelAllowed = v),
                          activeColor: SpottColors.primary,
                        ),
                      ],
                    ),
                    Text('Allow passengers to send parcels on this trip', style: SpottTextStyles.caption),
                  ],
                ),
              ),
              const SizedBox(height: SpottSpacing.lg),

              // Route context info
              GlassCard(
                padding: const EdgeInsets.all(SpottSpacing.lg),
                child: Column(
                  children: [
                    _buildInfoRow('Visible to passengers', 'Yes'),
                    const SizedBox(height: SpottSpacing.sm),
                    _buildInfoRow('Allowed pickup radius', '5 km'),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
          Positioned(
            bottom: SpottSpacing.lg,
            left: SpottSpacing.lg,
            right: SpottSpacing.lg,
            child: SpottButton.primary(
              label: 'Publish Trip',
              onPressed: () => _publishTrip(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: SpottTextStyles.body),
        Text(value, style: SpottTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: SpottColors.textPrimary)),
      ],
    );
  }

  void _publishTrip(BuildContext context) {
    final ride = RideScope.of(context);
    final selectedVehId = _selectedVehicleId ?? (ride.vehicles.isNotEmpty ? ride.vehicles.first.id : null);

    if (selectedVehId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add and select a vehicle first.')));
      return;
    }

    if (_fromController.text.trim().isEmpty || _toController.text.trim().isEmpty || _priceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Complete all trip details')));
      return;
    }

    final price = int.tryParse(_priceController.text.trim()) ?? 0;
    if (price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid price')));
      return;
    }

    final newTrip = Trip(
      id: 'trip_tvl_${DateTime.now().millisecondsSinceEpoch}',
      travelerId: 'current_user',
      source: _fromController.text.trim(),
      destination: _toController.text.trim(),
      departureTime: DateTime(_departureDate.year, _departureDate.month, _departureDate.day, _departureTime.hour, _departureTime.minute),
      availableSeats: _availableSeats,
      pricePerSeat: price,
      parcelAllowed: _parcelAllowed,
      status: spott.TripStatus.active,
    );

    ride.addTrip(newTrip);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Trip published successfully!'), backgroundColor: SpottColors.success),
    );

    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }
}
