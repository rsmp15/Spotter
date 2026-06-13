import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';

import '../models/spott_models.dart' as spott;
import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_buttons.dart';




import '../widgets/premium/premium_selectors.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  int _availableSeats = 3;
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
    _fromController.text = 'Pune, Maharashtra';
    _toController.text = 'Mumbai, Maharashtra';
    _priceController.text = '400';
  }

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);

    // Lazily set default vehicle selection
    if (_selectedVehicleId == null && ride.vehicles.isNotEmpty) {
      _selectedVehicleId = ride.selectedVehicleId ?? ride.vehicles.first.id;
    }

    final departureDateStr = '${_departureDate.day.toString().padLeft(2, '0')}/${_departureDate.month.toString().padLeft(2, '0')}/${_departureDate.year}';
    final departureTimeStr = _departureTime.format(context);
    final estimatedEarnings = (_availableSeats * (int.tryParse(_priceController.text.trim()) ?? 0));

    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: DSColors.textPrimary),
        title: Text('Offer a Trip', style: DSTypography.headline),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 120),
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: DSSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: DSSpacing.sm),
                    Text('Offer Your Trip', style: DSTypography.headline.copyWith(fontSize: 40)),
                    const SizedBox(height: DSSpacing.xs),
                    Text('Recover fuel costs and travel together.', style: DSTypography.body.copyWith(color: DSColors.textSecondary)),
                    const SizedBox(height: DSSpacing.xl),
                  ],
                ),
              ),

              // Hero Illustration
              Container(
                margin: const EdgeInsets.symmetric(horizontal: DSSpacing.lg),
                height: 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(DSRadius.lg),
                  image: const DecorationImage(
                    image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDzmjjpgD0roYcmddNYxGI144s2clVXmjXKPd6PqVvNeAZ8AEeObpGgmfX6Af5AeMgKiarDaGn58_dTOmYYbyrHYKjmvPuIBWySDcwRUDg2ZKBHKMI_ZLBhE-lN9tkBrHEaIgXN9rw1_9aKBYQlZy9iBMcI5V5l59XRXQI04uVV_iOpg2xdpmAEiSf5um10kQlCJltPi1XZQITwGBSbToXjm0vOY-rhkRchHPKxKGbw5xsO1VO0mtHi35Jhx25DehJW6MQgHieWFyQ1'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(DSRadius.lg),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black.withValues(alpha:0.6), Colors.transparent],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: DSSpacing.lg,
                      right: DSSpacing.lg,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: DSSpacing.lg, vertical: DSSpacing.sm),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha:0.9),
                          borderRadius: BorderRadius.circular(DSRadius.pill),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.payments_rounded, color: DSColors.primary, size: 20),
                            const SizedBox(width: DSSpacing.sm),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Average Earning', style: DSTypography.caption.copyWith(fontWeight: FontWeight.bold, fontSize: 10)),
                                Text('₹850', style: DSTypography.titleLarge.copyWith(color: DSColors.primary, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Main Form Area
              Transform.translate(
                offset: const Offset(0, -40),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: DSSpacing.lg),
                  child: GlassCard(
                    padding: const EdgeInsets.all(DSSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Route Section
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 32, height: 32,
                                    decoration: BoxDecoration(color: DSColors.surface, shape: BoxShape.circle),
                                    child: const Icon(Icons.circle_outlined, size: 16),
                                  ),
                                  Expanded(child: Container(width: 2, color: DSColors.borderSubtle)),
                                  Container(
                                    width: 32, height: 32,
                                    decoration: const BoxDecoration(color: DSColors.primary, shape: BoxShape.circle),
                                    child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(width: DSSpacing.md),
                              Expanded(
                                child: Column(
                                  children: [
                                    _buildTextField(label: 'Leaving From', controller: _fromController),
                                    const SizedBox(height: DSSpacing.lg),
                                    _buildTextField(label: 'Going To', controller: _toController),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: DSSpacing.lg),
                        const Divider(color: DSColors.borderSubtle),
                        const SizedBox(height: DSSpacing.lg),

                        // Details Grid
                        Row(
                          children: [
                            Expanded(
                              child: _buildTouchableInput(
                                label: 'Date',
                                value: departureDateStr,
                                icon: Icons.calendar_today_rounded,
                                onTap: () async {
                                  final picked = await PremiumDatePickerBottomSheet.show(
                                    context,
                                    initialDate: _departureDate,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(const Duration(days: 365)),
                                    primaryColor: DSColors.primary,
                                  );
                                  if (picked != null) setState(() => _departureDate = picked);
                                },
                              ),
                            ),
                            const SizedBox(width: DSSpacing.md),
                            Expanded(
                              child: _buildTouchableInput(
                                label: 'Departure Time',
                                value: departureTimeStr,
                                icon: Icons.schedule_rounded,
                                onTap: () async {
                                  final picked = await showTimePicker(context: context, initialTime: _departureTime);
                                  if (picked != null) setState(() => _departureTime = picked);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: DSSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTouchableInput(
                                label: 'Available Seats',
                                value: '$_availableSeats Seat${_availableSeats > 1 ? 's' : ''}',
                                icon: Icons.airline_seat_recline_normal_rounded,
                                onTap: () async {
                                  final picked = await PremiumPassengersBottomSheet.show(
                                    context,
                                    initialSeats: _availableSeats,
                                    maxSeats: 6,
                                    primaryColor: DSColors.primary,
                                    title: 'Available Seats',
                                    subtitle: 'Choose how many empty seats you have',
                                  );
                                  if (picked != null) {
                                    setState(() => _availableSeats = picked);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: DSSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Price per Seat', style: DSTypography.labelLarge.copyWith(color: DSColors.textSecondary, letterSpacing: 1.1)),
                                  const SizedBox(height: DSSpacing.xs),
                                  Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: DSColors.borderSubtle),
                                      borderRadius: BorderRadius.circular(DSRadius.md),
                                    ),
                                    child: TextField(
                                      controller: _priceController,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      style: DSTypography.headline.copyWith(fontSize: 20),
                                      onChanged: (_) => setState((){}), // trigger rebuild to update earnings
                                      decoration: InputDecoration(
                                        prefixIcon: const Padding(
                                          padding: EdgeInsets.only(left: 16.0, top: 14),
                                          child: Text('₹', style: TextStyle(fontSize: 18, color: DSColors.textSecondary)),
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.only(top: 10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: DSSpacing.lg),
                        const Divider(color: DSColors.borderSubtle),
                        const SizedBox(height: DSSpacing.lg),

                        // Vehicle Selection
                        Text('Your Vehicle', style: DSTypography.labelLarge.copyWith(color: DSColors.textSecondary, letterSpacing: 1.1)),
                        const SizedBox(height: DSSpacing.sm),
                        InkWell(
                          onTap: () async {
                            // Show vehicle selection logic, keeping it simple
                            Navigator.pushNamed(context, AppRoutes.vehicleManagement);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(DSSpacing.md),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: DSColors.borderSubtle),
                              borderRadius: BorderRadius.circular(DSRadius.md),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48, height: 48,
                                  decoration: BoxDecoration(color: DSColors.surface, borderRadius: BorderRadius.circular(DSRadius.sm)),
                                  child: const Icon(Icons.directions_car_rounded, color: DSColors.primary, size: 28),
                                ),
                                const SizedBox(width: DSSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ride.vehicles.firstWhere((v) => v.id == _selectedVehicleId, orElse: () => ride.vehicles.isNotEmpty ? ride.vehicles.first : spott.Vehicle(id: '', userId: '', vehicleModel: 'Add Vehicle', vehicleType: 'Car', vehicleNumber: '', verificationStatus: spott.VerificationStatus.pending)).vehicleModel,
                                        style: DSTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          _buildTag('AC'),
                                          const SizedBox(width: 4),
                                          _buildTag('Music'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right_rounded, color: DSColors.textSecondary),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: DSSpacing.xl),

                        // Trust Badges
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildTrustBadge(Icons.verified_user_rounded, 'Govt ID Verified'),
                              const SizedBox(width: DSSpacing.sm),
                              _buildTrustBadge(Icons.directions_car_rounded, 'Vehicle Verified'),
                              const SizedBox(width: DSSpacing.sm),
                              _buildTrustBadge(Icons.smartphone_rounded, 'Phone Verified'),
                            ],
                          ),
                        ),
                        const SizedBox(height: DSSpacing.xl),
                        
                        // Extra flutter toggles
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Parcels allowed', style: DSTypography.titleLarge.copyWith(fontWeight: FontWeight.bold)),
                            Switch(
                              value: _parcelAllowed,
                              onChanged: (v) => setState(() => _parcelAllowed = v),
                              activeThumbColor: DSColors.primary,
                            ),
                          ],
                        ),
                        const SizedBox(height: DSSpacing.lg),

                        // Earnings Preview
                        Container(
                          padding: const EdgeInsets.all(DSSpacing.lg),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [DSColors.primary.withValues(alpha:0.1), DSColors.surface],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(DSRadius.md),
                            border: Border.all(color: DSColors.primary.withValues(alpha:0.2)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Estimated Earnings', style: DSTypography.labelLarge.copyWith(color: DSColors.primary, letterSpacing: 1.1)),
                                  const SizedBox(height: 4),
                                  Text('₹$estimatedEarnings', style: DSTypography.headline.copyWith(fontSize: 28)),
                                ],
                              ),
                              Container(
                                width: 48, height: 48,
                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                child: const Icon(Icons.account_balance_wallet_rounded, color: DSColors.primary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Only verified travelers can publish (informative)
              const Center(
                child: Text('Only verified travelers can publish rides', style: TextStyle(color: DSColors.textSecondary, fontSize: 12)),
              ),
              const SizedBox(height: 20),
            ],
          ),
          
          // Publish CTA
          Positioned(
            bottom: DSSpacing.lg,
            left: DSSpacing.lg,
            right: DSSpacing.lg,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: DSColors.primary.withValues(alpha:0.2), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: SpottButton.primary(
                label: 'Publish Trip',
                onPressed: () => _publishTrip(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: DSTypography.labelLarge.copyWith(color: DSColors.textSecondary, letterSpacing: 1.1)),
        const SizedBox(height: DSSpacing.xs),
        TextField(
          controller: controller,
          style: DSTypography.body,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: DSSpacing.md),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DSRadius.md),
              borderSide: const BorderSide(color: DSColors.borderSubtle),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DSRadius.md),
              borderSide: const BorderSide(color: DSColors.borderSubtle),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DSRadius.md),
              borderSide: const BorderSide(color: DSColors.primary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTouchableInput({required String label, required String value, required IconData icon, required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: DSTypography.labelLarge.copyWith(color: DSColors.textSecondary, letterSpacing: 1.1)),
        const SizedBox(height: DSSpacing.xs),
        InkWell(
          onTap: onTap,
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: DSColors.borderSubtle),
              borderRadius: BorderRadius.circular(DSRadius.md),
            ),
            child: Row(
              children: [
                Icon(icon, color: DSColors.textSecondary, size: 20),
                const SizedBox(width: DSSpacing.sm),
                Text(value, style: DSTypography.body),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: DSColors.surface,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: DSColors.textSecondary)),
    );
  }

  Widget _buildTrustBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: 6),
      decoration: BoxDecoration(
        color: DSColors.surface,
        borderRadius: BorderRadius.circular(DSRadius.pill),
        border: Border.all(color: DSColors.borderSubtle),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: DSColors.primary),
          const SizedBox(width: 4),
          Text(label, style: DSTypography.caption.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
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

    final newTrip = spott.Trip(
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
      const SnackBar(content: Text('Trip published successfully!'), backgroundColor: DSColors.success),
    );

    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }
}
