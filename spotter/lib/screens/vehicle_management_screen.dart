import 'package:flutter/material.dart';
import '../spotter_widgets.dart';
import '../helper.dart';

class VehicleManagementScreen extends StatefulWidget {
  const VehicleManagementScreen({super.key});

  @override
  State<VehicleManagementScreen> createState() => _VehicleManagementScreenState();
}

class _VehicleManagementScreenState extends State<VehicleManagementScreen> {
  String _selectedType = 'Car';
  final _numberController = TextEditingController();
  final _modelController = TextEditingController();

  static const _vehicleTypes = ['Car', 'Bike', 'SUV', 'Auto'];

  @override
  void dispose() {
    _numberController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpotterScreen(
      title: 'My Vehicles',
      subtitle: 'Add and manage your vehicles for trips.',
      content: [
        SpotterCard(
          children: [
            const StatusChip(label: 'Vehicle details'),
            const SizedBox(height: 16),
            Text(
              'Vehicle type',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Helper.mutedColor(context),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Helper.cardBg(context),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Helper.line(context)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedType,
                  isExpanded: true,
                  dropdownColor: Helper.cardBg(context),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Helper.inkColor(context),
                  ),
                  icon: Icon(Icons.keyboard_arrow_down_rounded, color: Helper.inkColor(context)),
                  items: _vehicleTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedType = value);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Vehicle number',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Helper.mutedColor(context),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _numberController,
              style: TextStyle(color: Helper.inkColor(context)),
              decoration: const InputDecoration(
                hintText: 'e.g. MH 12 AB 1234',
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Vehicle model',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Helper.mutedColor(context),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _modelController,
              style: TextStyle(color: Helper.inkColor(context)),
              decoration: const InputDecoration(
                hintText: 'e.g. Maruti Swift Dzire',
              ),
            ),
          ],
        ),
        SpotterCard(
          children: [
            const StatusChip(label: 'RC Document'),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('RC document upload coming soon')),
                );
              },
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: Helper.canvasSoftColor(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Helper.line(context),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_rounded,
                      size: 36,
                      color: Helper.mutedColor(context),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Upload RC',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Helper.mutedColor(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
      bottom: PrimaryAction(
        label: 'Save Vehicle',
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vehicle saved successfully')),
          );
          Navigator.maybePop(context);
        },
      ),
    );
  }
}
