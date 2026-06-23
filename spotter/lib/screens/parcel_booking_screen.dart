import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../models/ride_models.dart';
import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_buttons.dart';





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
        leading: const BackButton(color: DSColors.textPrimary),
        title: Text('Send a Package', style: DSTypography.headline),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(DSSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text('Same-day delivery via verified travelers on their route.', style: DSTypography.body.copyWith(color: DSColors.textSecondary)),
                const SizedBox(height: DSSpacing.xl),

                // Sender Details Card
                GlassCard(
                  padding: const EdgeInsets.all(DSSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sender Details (You)', style: DSTypography.headline),
                      const SizedBox(height: DSSpacing.md),
                      _buildTextField(
                        controller: _senderNameController,
                        label: 'Sender Name',
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: DSSpacing.md),
                      _buildTextField(
                        controller: _senderPhoneController,
                        label: 'Sender Phone',
                        keyboardType: TextInputType.phone,
                        validator: (v) => v == null || v.length != 10 ? 'Enter valid 10 digit phone' : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DSSpacing.md),

                // Receiver Details Card
                GlassCard(
                  padding: const EdgeInsets.all(DSSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Receiver Details', style: DSTypography.headline),
                      const SizedBox(height: DSSpacing.md),
                      _buildTextField(
                        controller: _receiverNameController,
                        label: 'Receiver Name',
                        hint: 'e.g. Rahul Sharma',
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: DSSpacing.md),
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
                const SizedBox(height: DSSpacing.md),

                // Category Picker Card
                GlassCard(
                  padding: const EdgeInsets.all(DSSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Package Category', style: DSTypography.headline),
                      const SizedBox(height: DSSpacing.md),
                      Wrap(
                        spacing: DSSpacing.sm,
                        runSpacing: DSSpacing.sm,
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
                const SizedBox(height: DSSpacing.md),

                // Size Picker Card
                GlassCard(
                  padding: const EdgeInsets.all(DSSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Package Size & Weight', style: DSTypography.headline),
                      const SizedBox(height: DSSpacing.md),
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
                          const SizedBox(width: DSSpacing.sm),
                          Expanded(
                            child: _buildSelectorTile(
                              title: 'Medium',
                              subtitle: 'Up to 8 kg',
                              selected: _selectedSize == ParcelSizeClass.medium,
                              onTap: () => setState(() => _selectedSize = ParcelSizeClass.medium),
                            ),
                          ),
                          const SizedBox(width: DSSpacing.sm),
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
                const SizedBox(height: DSSpacing.md),

                // Safety Declaration and Photo Card
                GlassCard(
                  padding: const EdgeInsets.all(DSSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Package Verification & Safety', style: DSTypography.headline),
                      const SizedBox(height: DSSpacing.md),
                      GestureDetector(
                        onTap: () {
                          setState(() => _uploadedPhoto = true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Package photo uploaded successfully'), backgroundColor: DSColors.success),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: DSColors.surface,
                            borderRadius: BorderRadius.circular(DSRadius.md),
                            border: Border.all(color: DSColors.border),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _uploadedPhoto ? Icons.check_circle_rounded : Icons.camera_alt_rounded,
                                color: _uploadedPhoto ? DSColors.success : DSColors.textSecondary,
                                size: 28,
                              ),
                              const SizedBox(height: DSSpacing.xs),
                              Text(
                                _uploadedPhoto ? 'Package Photo Verified' : 'Upload Package Photo',
                                style: DSTypography.caption.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _uploadedPhoto ? DSColors.success : DSColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: DSSpacing.md),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: _declaredSafety,
                              activeColor: DSColors.primary,
                              checkColor: Colors.white,
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _declaredSafety = val);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: DSSpacing.sm),
                          Expanded(
                            child: Text(
                              'I declare that this package does not contain any illegal, dangerous, or restricted items as per local laws.',
                              style: DSTypography.caption,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DSSpacing.md),

                // Delivery Mode / Vehicle selection Card
                GlassCard(
                  padding: const EdgeInsets.all(DSSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Private Vehicle Partner Mode', style: DSTypography.headline),
                      const SizedBox(height: DSSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _selectedVehicleClass = 'Bike'),
                              borderRadius: BorderRadius.circular(DSRadius.md),
                              child: Container(
                                padding: const EdgeInsets.all(DSSpacing.md),
                                decoration: BoxDecoration(
                                  color: _selectedVehicleClass == 'Bike' ? DSColors.primary.withValues(alpha: 0.15) : DSColors.surface,
                                  borderRadius: BorderRadius.circular(DSRadius.md),
                                  border: Border.all(color: _selectedVehicleClass == 'Bike' ? DSColors.primary : DSColors.border),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.two_wheeler_rounded,
                                      color: _selectedVehicleClass == 'Bike' ? DSColors.primary : DSColors.textSecondary,
                                      size: 28,
                                    ),
                                    const SizedBox(height: DSSpacing.xs),
                                    Text(
                                      'Private Bike',
                                      style: DSTypography.body.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: _selectedVehicleClass == 'Bike' ? DSColors.primary : DSColors.textPrimary,
                                      ),
                                    ),
                                    Text('Fastest • Small items', style: DSTypography.caption),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: DSSpacing.md),
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _selectedVehicleClass = 'Car'),
                              borderRadius: BorderRadius.circular(DSRadius.md),
                              child: Container(
                                padding: const EdgeInsets.all(DSSpacing.md),
                                decoration: BoxDecoration(
                                  color: _selectedVehicleClass == 'Car' ? DSColors.primary.withValues(alpha: 0.15) : DSColors.surface,
                                  borderRadius: BorderRadius.circular(DSRadius.md),
                                  border: Border.all(color: _selectedVehicleClass == 'Car' ? DSColors.primary : DSColors.border),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.directions_car_filled_rounded,
                                      color: _selectedVehicleClass == 'Car' ? DSColors.primary : DSColors.textSecondary,
                                      size: 28,
                                    ),
                                    const SizedBox(height: DSSpacing.xs),
                                    Text(
                                      'Private Car',
                                      style: DSTypography.body.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: _selectedVehicleClass == 'Car' ? DSColors.primary : DSColors.textPrimary,
                                      ),
                                    ),
                                    Text('Best for large box', style: DSTypography.caption),
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
              padding: const EdgeInsets.all(DSSpacing.lg),
              decoration: BoxDecoration(
                color: DSColors.glass,
                border: const Border(top: BorderSide(color: DSColors.border)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Estimated Cost', style: DSTypography.body.copyWith(fontWeight: FontWeight.bold)),
                      Text('₹$_calculateFare', style: DSTypography.headline.copyWith(fontSize: 22)),
                    ],
                  ),
                  const SizedBox(height: DSSpacing.md),
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
      style: DSTypography.body.copyWith(color: DSColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: DSTypography.body.copyWith(color: DSColors.textSecondary),
        hintStyle: DSTypography.body.copyWith(color: DSColors.textSecondary),
        filled: true,
        fillColor: DSColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: DSSpacing.md),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(DSRadius.md), borderSide: BorderSide.none),
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
      borderRadius: BorderRadius.circular(DSRadius.pill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: DSSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? DSColors.primary.withValues(alpha: 0.15) : DSColors.surface,
          borderRadius: BorderRadius.circular(DSRadius.pill),
          border: Border.all(color: selected ? DSColors.primary : DSColors.border),
        ),
        child: Text(
          label,
          style: DSTypography.caption.copyWith(
            fontWeight: FontWeight.bold,
            color: selected ? DSColors.primary : DSColors.textSecondary,
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
      borderRadius: BorderRadius.circular(DSRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: DSSpacing.md, horizontal: DSSpacing.xs),
        decoration: BoxDecoration(
          color: selected ? DSColors.primary.withValues(alpha: 0.15) : DSColors.surface,
          borderRadius: BorderRadius.circular(DSRadius.md),
          border: Border.all(color: selected ? DSColors.primary : DSColors.border),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: DSTypography.body.copyWith(
                fontWeight: FontWeight.bold,
                color: selected ? DSColors.primary : DSColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: DSTypography.caption,
            ),
          ],
        ),
      ),
    );
  }
}

