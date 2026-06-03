import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../helper.dart';
import '../models/ride_models.dart';
import '../spotter_widgets.dart';

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
    final isDark = ride.isDarkMode;

    final contentColor = isDark ? Colors.white : Helper.ink;
    final hintColor = isDark ? Colors.grey[400] : Helper.muted;

    return SpotterScreen(
      title: 'Send a Package',
      subtitle: 'Same-day delivery via verified travelers on their route.',
      content: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sender Details Card
              SpotterCard(
                color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : Colors.white,
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Sender Details (You)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: contentColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _senderNameController,
                    label: 'Sender Name',
                    isDark: isDark,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _senderPhoneController,
                    label: 'Sender Phone',
                    isDark: isDark,
                    keyboardType: TextInputType.phone,
                    validator: (v) => v == null || v.length != 10 ? 'Enter valid 10 digit phone' : null,
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Receiver Details Card
              SpotterCard(
                color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : Colors.white,
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Receiver Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: contentColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _receiverNameController,
                    label: 'Receiver Name',
                    hint: 'e.g. Rahul Sharma',
                    isDark: isDark,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _receiverPhoneController,
                    label: 'Receiver Phone',
                    hint: '10-digit mobile number',
                    isDark: isDark,
                    keyboardType: TextInputType.phone,
                    validator: (v) => v == null || v.length != 10 ? 'Enter valid 10 digit phone' : null,
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Category Picker Card
              SpotterCard(
                color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : Colors.white,
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Package Category',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: contentColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildChip(
                        label: 'Documents / Keys',
                        selected: _selectedCategory == ParcelCategory.documents,
                        onTap: () => setState(() => _selectedCategory = ParcelCategory.documents),
                        isDark: isDark,
                      ),
                      _buildChip(
                        label: 'College Items',
                        selected: _selectedCategory == ParcelCategory.collegeItems,
                        onTap: () => setState(() => _selectedCategory = ParcelCategory.collegeItems),
                        isDark: isDark,
                      ),
                      _buildChip(
                        label: 'Laundry / Clothes',
                        selected: _selectedCategory == ParcelCategory.laundry,
                        onTap: () => setState(() => _selectedCategory = ParcelCategory.laundry),
                        isDark: isDark,
                      ),
                      _buildChip(
                        label: 'Box Package',
                        selected: _selectedCategory == ParcelCategory.boxPackage,
                        onTap: () => setState(() => _selectedCategory = ParcelCategory.boxPackage),
                        isDark: isDark,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Size Picker Card
              SpotterCard(
                color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : Colors.white,
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Package Size & Weight',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: contentColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSelectorTile(
                          title: 'Light',
                          subtitle: 'Up to 2 kg',
                          selected: _selectedSize == ParcelSizeClass.light,
                          onTap: () => setState(() => _selectedSize = ParcelSizeClass.light),
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildSelectorTile(
                          title: 'Medium',
                          subtitle: 'Up to 8 kg',
                          selected: _selectedSize == ParcelSizeClass.medium,
                          onTap: () => setState(() => _selectedSize = ParcelSizeClass.medium),
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildSelectorTile(
                          title: 'Heavy',
                          subtitle: 'Up to 20 kg',
                          selected: _selectedSize == ParcelSizeClass.heavy,
                          onTap: () => setState(() => _selectedSize = ParcelSizeClass.heavy),
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Safety Declaration and Photo Card
              SpotterCard(
                color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : Colors.white,
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Package Verification & Safety',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: contentColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() => _uploadedPhoto = true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Package photo uploaded successfully')),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Helper.line(context)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _uploadedPhoto ? Icons.check_circle_rounded : Icons.camera_alt_rounded, 
                            color: _uploadedPhoto ? Helper.success : hintColor, 
                            size: 28,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _uploadedPhoto ? 'Package Photo Verified' : 'Upload Package Photo',
                            style: TextStyle(
                              fontSize: 12, 
                              fontWeight: FontWeight.bold, 
                              color: _uploadedPhoto ? Helper.success : hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _declaredSafety,
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _declaredSafety = val);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'I declare that this package does not contain any illegal, dangerous, or restricted items as per local laws.',
                          style: TextStyle(
                            fontSize: 12,
                            color: hintColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Delivery Mode / Vehicle selection Card
              SpotterCard(
                color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.5) : Colors.white,
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Private Vehicle Partner Mode',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: contentColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _selectedVehicleClass = 'Bike'),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _selectedVehicleClass == 'Bike'
                                  ? (isDark ? Colors.white : Colors.black)
                                  : (isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF3F4F6)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.two_wheeler_rounded,
                                  color: _selectedVehicleClass == 'Bike'
                                      ? (isDark ? Colors.black : Colors.white)
                                      : contentColor,
                                  size: 28,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Private Bike',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _selectedVehicleClass == 'Bike'
                                        ? (isDark ? Colors.black : Colors.white)
                                        : contentColor,
                                  ),
                                ),
                                Text(
                                  'Fastest • Small items',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: _selectedVehicleClass == 'Bike'
                                        ? (isDark ? Colors.grey[800] : Colors.grey[300])
                                        : hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _selectedVehicleClass = 'Car'),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _selectedVehicleClass == 'Car'
                                  ? (isDark ? Colors.white : Colors.black)
                                  : (isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF3F4F6)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.directions_car_filled_rounded,
                                  color: _selectedVehicleClass == 'Car'
                                      ? (isDark ? Colors.black : Colors.white)
                                      : contentColor,
                                  size: 28,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Private Car',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _selectedVehicleClass == 'Car'
                                        ? (isDark ? Colors.black : Colors.white)
                                        : contentColor,
                                  ),
                                ),
                                Text(
                                  'Best for large box',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: _selectedVehicleClass == 'Car'
                                        ? (isDark ? Colors.grey[800] : Colors.grey[300])
                                        : hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF121212) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Estimated Cost',
                  style: TextStyle(fontWeight: FontWeight.bold, color: contentColor),
                ),
                Text(
                  'Rs $_calculateFare',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: contentColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          PrimaryAction(
            label: 'Assign Delivery Partner',
            onPressed: () {
              if (!_uploadedPhoto) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please upload a package photo to proceed.')),
                );
                return;
              }
              if (!_declaredSafety) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please accept the safety declaration to proceed.')),
                );
                return;
              }
              if (_formKey.currentState?.validate() ?? false) {
                // Find best matching private driver partner
                final driver = _selectedVehicleClass == 'Bike'
                    ? ride.drivers.firstWhere(
                        (d) => d.id == 'tvl_bike_03' || d.id == 'drv_pvt_karan',
                        orElse: () => ride.drivers.firstWhere(
                          (d) => d.vehicle.toLowerCase().contains('bike'),
                          orElse: () => ride.drivers.first,
                        ),
                      )
                    : ride.drivers.firstWhere(
                        (d) => d.id == 'tvl_sedan_01' || d.id == 'drv_pvt_neha',
                        orElse: () => ride.drivers.firstWhere(
                          (d) => !d.vehicle.toLowerCase().contains('bike'),
                          orElse: () => ride.drivers.first,
                        ),
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool isDark,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: isDark ? Colors.grey[400] : Helper.muted, fontSize: 13),
        hintStyle: TextStyle(color: isDark ? Colors.grey[600] : Colors.grey[400], fontSize: 13),
        filled: true,
        fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(99),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? (isDark ? Colors.white : Colors.black)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6)),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: selected
                ? (isDark ? Colors.black : Colors.white)
                : (isDark ? Colors.white : Colors.black),
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
    required bool isDark,
  }) {
    final titleColor = isDark ? Colors.white : Colors.black;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: selected
              ? (isDark ? Colors.white : Colors.black)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: selected ? (isDark ? Colors.black : Colors.white) : titleColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: selected
                    ? (isDark ? Colors.grey[800] : Colors.grey[300])
                    : (isDark ? Colors.grey[400] : Helper.muted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
