import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../models/ride_models.dart';
import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_buttons.dart';
import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';
import '../core/theme/radius.dart';

class ParcelBookingScreen extends StatefulWidget {
  const ParcelBookingScreen({super.key});

  @override
  State<ParcelBookingScreen> createState() => _ParcelBookingScreenState();
}

class _ParcelBookingScreenState extends State<ParcelBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _senderNameController = TextEditingController(text: 'Ritesh Mahatme');
  final _senderPhoneController = TextEditingController(text: '9876543210');
  final _receiverNameController = TextEditingController();
  final _receiverPhoneController = TextEditingController();

  ParcelCategory _selectedCategory = ParcelCategory.documents;
  ParcelSizeClass _selectedSize = ParcelSizeClass.light;
  String _selectedVehicleClass = 'Bike'; // 'Bike' or 'Car'
  bool _declaredSafety = false;
  bool _uploadedPhoto = false;

  @override
  void dispose() {
    _senderNameController.dispose();
    _senderPhoneController.dispose();
    _receiverNameController.dispose();
    _receiverPhoneController.dispose();
    super.dispose();
  }

  int get _calculateFare {
    int base = 20;
    if (_selectedSize == ParcelSizeClass.medium) base = 40;
    if (_selectedSize == ParcelSizeClass.heavy) base = 60;

    int vehicleFlat = _selectedVehicleClass == 'Bike' ? 25 : 60;
    return base + vehicleFlat;
  }

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);

    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: SpottColors.textPrimary),
        title: const Text('Send a Package', style: SpottTextStyles.sectionTitle),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(SpottSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text('Same-day delivery via verified travelers on their route.', style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary)),
                const SizedBox(height: SpottSpacing.xl),

                // Sender Details Card
                GlassCard(
                  padding: const EdgeInsets.all(SpottSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sender Details (You)', style: SpottTextStyles.sectionTitle),
                      const SizedBox(height: SpottSpacing.md),
                      _buildTextField(
                        controller: _senderNameController,
                        label: 'Sender Name',
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: SpottSpacing.md),
                      _buildTextField(
                        controller: _senderPhoneController,
                        label: 'Sender Phone',
                        keyboardType: TextInputType.phone,
                        validator: (v) => v == null || v.length != 10 ? 'Enter valid 10 digit phone' : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SpottSpacing.md),

                // Receiver Details Card
                GlassCard(
                  padding: const EdgeInsets.all(SpottSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Receiver Details', style: SpottTextStyles.sectionTitle),
                      const SizedBox(height: SpottSpacing.md),
                      _buildTextField(
                        controller: _receiverNameController,
                        label: 'Receiver Name',
                        hint: 'e.g. Rahul Sharma',
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: SpottSpacing.md),
                      _buildTextField(
                        controller: _receiverPhoneController,
                        label: 'Receiver Phone',
                        hint: '10-digit mobile number',
                        keyboardType: TextInputType.phone,
                        validator: (v) => v == null || v.length != 10 ? 'Enter valid 10 digit phone' : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SpottSpacing.md),

                // Category Picker Card
                GlassCard(
                  padding: const EdgeInsets.all(SpottSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Package Category', style: SpottTextStyles.sectionTitle),
                      const SizedBox(height: SpottSpacing.md),
                      Wrap(
                        spacing: SpottSpacing.sm,
                        runSpacing: SpottSpacing.sm,
                        children: [
                          _buildChip(
                            label: 'Documents / Keys',
                            selected: _selectedCategory == ParcelCategory.documents,
                            onTap: () => setState(() => _selectedCategory = ParcelCategory.documents),
                          ),
                          _buildChip(
                            label: 'College Items',
                            selected: _selectedCategory == ParcelCategory.collegeItems,
                            onTap: () => setState(() => _selectedCategory = ParcelCategory.collegeItems),
                          ),
                          _buildChip(
                            label: 'Laundry / Clothes',
                            selected: _selectedCategory == ParcelCategory.laundry,
                            onTap: () => setState(() => _selectedCategory = ParcelCategory.laundry),
                          ),
                          _buildChip(
                            label: 'Box Package',
                            selected: _selectedCategory == ParcelCategory.boxPackage,
                            onTap: () => setState(() => _selectedCategory = ParcelCategory.boxPackage),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SpottSpacing.md),

                // Size Picker Card
                GlassCard(
                  padding: const EdgeInsets.all(SpottSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Package Size & Weight', style: SpottTextStyles.sectionTitle),
                      const SizedBox(height: SpottSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSelectorTile(
                              title: 'Light',
                              subtitle: 'Up to 2 kg',
                              selected: _selectedSize == ParcelSizeClass.light,
                              onTap: () => setState(() => _selectedSize = ParcelSizeClass.light),
                            ),
                          ),
                          const SizedBox(width: SpottSpacing.sm),
                          Expanded(
                            child: _buildSelectorTile(
                              title: 'Medium',
                              subtitle: 'Up to 8 kg',
                              selected: _selectedSize == ParcelSizeClass.medium,
                              onTap: () => setState(() => _selectedSize = ParcelSizeClass.medium),
                            ),
                          ),
                          const SizedBox(width: SpottSpacing.sm),
                          Expanded(
                            child: _buildSelectorTile(
                              title: 'Heavy',
                              subtitle: 'Up to 20 kg',
                              selected: _selectedSize == ParcelSizeClass.heavy,
                              onTap: () => setState(() => _selectedSize = ParcelSizeClass.heavy),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SpottSpacing.md),

                // Safety Declaration and Photo Card
                GlassCard(
                  padding: const EdgeInsets.all(SpottSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Package Verification & Safety', style: SpottTextStyles.sectionTitle),
                      const SizedBox(height: SpottSpacing.md),
                      GestureDetector(
                        onTap: () {
                          setState(() => _uploadedPhoto = true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Package photo uploaded successfully'), backgroundColor: SpottColors.success),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: SpottColors.surface1,
                            borderRadius: BorderRadius.circular(SpottRadius.md),
                            border: Border.all(color: SpottColors.border),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _uploadedPhoto ? Icons.check_circle_rounded : Icons.camera_alt_rounded,
                                color: _uploadedPhoto ? SpottColors.success : SpottColors.textSecondary,
                                size: 28,
                              ),
                              const SizedBox(height: SpottSpacing.xs),
                              Text(
                                _uploadedPhoto ? 'Package Photo Verified' : 'Upload Package Photo',
                                style: SpottTextStyles.caption.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _uploadedPhoto ? SpottColors.success : SpottColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: SpottSpacing.md),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: _declaredSafety,
                              activeColor: SpottColors.primary,
                              checkColor: Colors.white,
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _declaredSafety = val);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: SpottSpacing.sm),
                          Expanded(
                            child: Text(
                              'I declare that this package does not contain any illegal, dangerous, or restricted items as per local laws.',
                              style: SpottTextStyles.caption,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SpottSpacing.md),

                // Delivery Mode / Vehicle selection Card
                GlassCard(
                  padding: const EdgeInsets.all(SpottSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Private Vehicle Partner Mode', style: SpottTextStyles.sectionTitle),
                      const SizedBox(height: SpottSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _selectedVehicleClass = 'Bike'),
                              borderRadius: BorderRadius.circular(SpottRadius.md),
                              child: Container(
                                padding: const EdgeInsets.all(SpottSpacing.md),
                                decoration: BoxDecoration(
                                  color: _selectedVehicleClass == 'Bike' ? SpottColors.primary.withValues(alpha: 0.15) : SpottColors.surface1,
                                  borderRadius: BorderRadius.circular(SpottRadius.md),
                                  border: Border.all(color: _selectedVehicleClass == 'Bike' ? SpottColors.primary : SpottColors.border),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.two_wheeler_rounded,
                                      color: _selectedVehicleClass == 'Bike' ? SpottColors.primary : SpottColors.textSecondary,
                                      size: 28,
                                    ),
                                    const SizedBox(height: SpottSpacing.xs),
                                    Text(
                                      'Private Bike',
                                      style: SpottTextStyles.body.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: _selectedVehicleClass == 'Bike' ? SpottColors.primary : SpottColors.textPrimary,
                                      ),
                                    ),
                                    Text('Fastest • Small items', style: SpottTextStyles.caption),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: SpottSpacing.md),
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _selectedVehicleClass = 'Car'),
                              borderRadius: BorderRadius.circular(SpottRadius.md),
                              child: Container(
                                padding: const EdgeInsets.all(SpottSpacing.md),
                                decoration: BoxDecoration(
                                  color: _selectedVehicleClass == 'Car' ? SpottColors.primary.withValues(alpha: 0.15) : SpottColors.surface1,
                                  borderRadius: BorderRadius.circular(SpottRadius.md),
                                  border: Border.all(color: _selectedVehicleClass == 'Car' ? SpottColors.primary : SpottColors.border),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.directions_car_filled_rounded,
                                      color: _selectedVehicleClass == 'Car' ? SpottColors.primary : SpottColors.textSecondary,
                                      size: 28,
                                    ),
                                    const SizedBox(height: SpottSpacing.xs),
                                    Text(
                                      'Private Car',
                                      style: SpottTextStyles.body.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: _selectedVehicleClass == 'Car' ? SpottColors.primary : SpottColors.textPrimary,
                                      ),
                                    ),
                                    Text('Best for large box', style: SpottTextStyles.caption),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 150), // Padding for bottom container
              ],
            ),
          ),
        ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(SpottSpacing.lg),
              decoration: BoxDecoration(
                color: SpottColors.glassSurface,
                border: const Border(top: BorderSide(color: SpottColors.border)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Estimated Cost', style: SpottTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                      Text('₹$_calculateFare', style: SpottTextStyles.display.copyWith(fontSize: 22)),
                    ],
                  ),
                  const SizedBox(height: SpottSpacing.md),
                  SpottButton.primary(
                    label: 'Assign Delivery Partner',
                    onPressed: () {
                      if (!_uploadedPhoto) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please upload a package photo to proceed.')));
                        return;
                      }
                      if (!_declaredSafety) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please accept the safety declaration to proceed.')));
                        return;
                      }
                      if (_formKey.currentState?.validate() ?? false) {
                        final driver = _selectedVehicleClass == 'Bike'
                            ? ride.drivers.firstWhere(
                                (d) => d.id == 'tvl_bike_03' || d.id == 'drv_pvt_karan',
                                orElse: () => ride.drivers.firstWhere((d) => d.vehicle.toLowerCase().contains('bike'), orElse: () => ride.drivers.first),
                              )
                            : ride.drivers.firstWhere(
                                (d) => d.id == 'tvl_sedan_01' || d.id == 'drv_pvt_neha',
                                orElse: () => ride.drivers.firstWhere((d) => !d.vehicle.toLowerCase().contains('bike'), orElse: () => ride.drivers.first),
                              );

                        ride.createParcelBooking(
                          senderName: _senderNameController.text,
                          senderPhone: _senderPhoneController.text,
                          receiverName: _receiverNameController.text,
                          receiverPhone: _receiverPhoneController.text,
                          category: _selectedCategory,
                          size: _selectedSize,
                          pickup: ride.pickup,
                          destination: ride.destination,
                          fare: _calculateFare,
                          driver: driver,
                        );

                        Navigator.pushNamed(context, AppRoutes.parcelTracking);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: SpottTextStyles.body.copyWith(color: SpottColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary),
        hintStyle: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary),
        filled: true,
        fillColor: SpottColors.surface1,
        contentPadding: const EdgeInsets.symmetric(horizontal: SpottSpacing.md, vertical: SpottSpacing.md),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(SpottRadius.md), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SpottRadius.pill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.md, vertical: SpottSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? SpottColors.primary.withValues(alpha: 0.15) : SpottColors.surface1,
          borderRadius: BorderRadius.circular(SpottRadius.pill),
          border: Border.all(color: selected ? SpottColors.primary : SpottColors.border),
        ),
        child: Text(
          label,
          style: SpottTextStyles.caption.copyWith(
            fontWeight: FontWeight.bold,
            color: selected ? SpottColors.primary : SpottColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectorTile({
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SpottRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: SpottSpacing.md, horizontal: SpottSpacing.xs),
        decoration: BoxDecoration(
          color: selected ? SpottColors.primary.withValues(alpha: 0.15) : SpottColors.surface1,
          borderRadius: BorderRadius.circular(SpottRadius.md),
          border: Border.all(color: selected ? SpottColors.primary : SpottColors.border),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: SpottTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
                color: selected ? SpottColors.primary : SpottColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: SpottTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}
