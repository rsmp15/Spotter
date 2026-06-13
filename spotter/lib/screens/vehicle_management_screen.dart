import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../controllers/ride_controller.dart';
import '../models/spott_models.dart';
import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/status_chip.dart';
import '../core/components/spott_buttons.dart';





class VehicleManagementScreen extends StatefulWidget {
  const VehicleManagementScreen({super.key});

  @override
  State<VehicleManagementScreen> createState() => _VehicleManagementScreenState();
}

class _VehicleManagementScreenState extends State<VehicleManagementScreen> {
  IconData _getVehicleIcon(String type) {
    switch (type.toLowerCase()) {
      case 'car':
      case 'suv':
        return Icons.directions_car_rounded;
      case 'bike':
        return Icons.motorcycle_rounded;
      case 'auto':
        return Icons.electric_rickshaw_rounded;
      default:
        return Icons.directions_car_rounded;
    }
  }

  String _getVerificationLabel(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.verified:
        return 'Verified';
      case VerificationStatus.pending:
        return 'Pending Review';
      case VerificationStatus.submitted:
        return 'Submitted';
      case VerificationStatus.rejected:
        return 'Rejected';
    }
  }

  ChipStatus _getVerificationStatusType(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.verified:
        return ChipStatus.verified;
      case VerificationStatus.pending:
        return ChipStatus.pending;
      case VerificationStatus.submitted:
        return ChipStatus.neutral;
      case VerificationStatus.rejected:
        return ChipStatus.rejected;
    }
  }

  void _openVehicleFormSheet(BuildContext context, [Vehicle? vehicle]) {
    final ride = RideScope.of(context);
    final isEdit = vehicle != null;

    final modelController = TextEditingController(text: vehicle?.vehicleModel ?? '');
    final numberController = TextEditingController(text: vehicle?.vehicleNumber ?? '');
    String selectedType = vehicle?.vehicleType ?? 'Car';

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: DSColors.surfaceVariant,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                DSSpacing.lg,
                0,
                DSSpacing.lg,
                DSSpacing.lg + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isEdit ? 'Edit Vehicle' : 'Add Vehicle', style: DSTypography.headline),
                  const SizedBox(height: DSSpacing.lg),

                  Text('Vehicle Type', style: DSTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: DSSpacing.xs),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md),
                    decoration: BoxDecoration(
                      color: DSColors.surface,
                      borderRadius: BorderRadius.circular(DSRadius.md),
                      border: Border.all(color: DSColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedType,
                        isExpanded: true,
                        dropdownColor: DSColors.surfaceVariant,
                        style: DSTypography.body.copyWith(color: DSColors.textPrimary),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: DSColors.textSecondary),
                        items: ['Car', 'Bike', 'SUV', 'Auto'].map((type) {
                          return DropdownMenuItem(value: type, child: Text(type));
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) setSheetState(() => selectedType = value);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: DSSpacing.md),

                  Text('Vehicle Model Name', style: DSTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: DSSpacing.xs),
                  TextField(
                    controller: modelController,
                    style: DSTypography.body.copyWith(color: DSColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'e.g. Honda City / Activa 6G',
                      filled: true,
                      fillColor: DSColors.surface,
                      hintStyle: DSTypography.body.copyWith(color: DSColors.textSecondary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(DSRadius.md),
                        borderSide: const BorderSide(color: DSColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(DSRadius.md),
                        borderSide: const BorderSide(color: DSColors.border),
                      ),
                    ),
                  ),
                  const SizedBox(height: DSSpacing.md),

                  Text('Registration Number', style: DSTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: DSSpacing.xs),
                  TextField(
                    controller: numberController,
                    style: DSTypography.body.copyWith(color: DSColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'e.g. MH-12-PQ-9876',
                      filled: true,
                      fillColor: DSColors.surface,
                      hintStyle: DSTypography.body.copyWith(color: DSColors.textSecondary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(DSRadius.md),
                        borderSide: const BorderSide(color: DSColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(DSRadius.md),
                        borderSide: const BorderSide(color: DSColors.border),
                      ),
                    ),
                  ),
                  const SizedBox(height: DSSpacing.xl),

                  Row(
                    children: [
                      if (isEdit) ...[
                        Expanded(
                          child: SpottButton.ghost(
                            label: 'Delete',
                            onPressed: () {
                              ride.deleteVehicle(vehicle.id);
                              Navigator.pop(sheetContext);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vehicle deleted')));
                            },
                          ),
                        ),
                        const SizedBox(width: DSSpacing.md),
                      ],
                      Expanded(
                        flex: 2,
                        child: SpottButton.primary(
                          label: isEdit ? 'Save Changes' : 'Add Vehicle',
                          onPressed: () {
                            if (modelController.text.trim().isEmpty || numberController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all details')));
                              return;
                            }

                            if (isEdit) {
                              ride.updateVehicle(
                                Vehicle(
                                  id: vehicle.id,
                                  userId: vehicle.userId,
                                  vehicleType: selectedType,
                                  vehicleNumber: numberController.text.trim(),
                                  vehicleModel: modelController.text.trim(),
                                  verificationStatus: vehicle.verificationStatus,
                                ),
                              );
                            } else {
                              ride.addVehicle(
                                Vehicle(
                                  id: 'veh_${DateTime.now().millisecondsSinceEpoch}',
                                  userId: 'current_user',
                                  vehicleType: selectedType,
                                  vehicleNumber: numberController.text.trim(),
                                  vehicleModel: modelController.text.trim(),
                                  verificationStatus: VerificationStatus.verified,
                                ),
                              );
                            }

                            Navigator.pop(sheetContext);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(isEdit ? 'Vehicle updated' : 'Vehicle added')),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);

    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: DSColors.textPrimary),
        title: Text('My Vehicles', style: DSTypography.headline),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(DSSpacing.lg),
            children: [
              Text('Add, edit, or select your active vehicle for traveler offerings.', style: DSTypography.body.copyWith(color: DSColors.textSecondary)),
              const SizedBox(height: DSSpacing.xl),
              
              if (ride.vehicles.isEmpty)
                GlassCard(
                  padding: const EdgeInsets.all(DSSpacing.xl),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.directions_car_filled_outlined, size: 48, color: DSColors.textSecondary),
                        const SizedBox(height: DSSpacing.md),
                        Text('No vehicles added yet', style: DSTypography.headline),
                        const SizedBox(height: DSSpacing.sm),
                        Text('Add a vehicle below to start offering trips.', style: DSTypography.caption),
                      ],
                    ),
                  ),
                )
              else
                ...ride.vehicles.map((vehicle) {
                  final isSelected = ride.selectedVehicleId == vehicle.id;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: DSSpacing.md),
                    child: GlassCard(
                      onTap: () => _openVehicleFormSheet(context, vehicle),
                      padding: const EdgeInsets.all(DSSpacing.md),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: DSColors.surface,
                              borderRadius: BorderRadius.circular(DSRadius.sm),
                            ),
                            child: Icon(_getVehicleIcon(vehicle.vehicleType), color: DSColors.primaryDark, size: 24),
                          ),
                          const SizedBox(width: DSSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(vehicle.vehicleModel, style: DSTypography.body.copyWith(fontWeight: FontWeight.bold, color: DSColors.textPrimary)),
                                const SizedBox(height: 2),
                                Text(vehicle.vehicleNumber, style: DSTypography.caption),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              StatusChip(
                                label: _getVerificationLabel(vehicle.verificationStatus),
                                status: _getVerificationStatusType(vehicle.verificationStatus),
                              ),
                              const SizedBox(height: DSSpacing.sm),
                              if (isSelected)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.check_circle_rounded, color: DSColors.success, size: 16),
                                    const SizedBox(width: 4),
                                    Text('Active', style: DSTypography.caption.copyWith(color: DSColors.success, fontWeight: FontWeight.bold)),
                                  ],
                                )
                              else
                                InkWell(
                                  onTap: () {
                                    ride.setSelectedVehicle(vehicle.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${vehicle.vehicleModel} set as active vehicle.')),
                                    );
                                  },
                                  child: Text('Set Active', style: DSTypography.caption.copyWith(color: DSColors.primaryDark, fontWeight: FontWeight.bold)),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              const SizedBox(height: 100),
            ],
          ),
          Positioned(
            bottom: DSSpacing.lg,
            left: DSSpacing.lg,
            right: DSSpacing.lg,
            child: SpottButton.primary(
              label: 'Add Vehicle',
              onPressed: () => _openVehicleFormSheet(context),
            ),
          ),
        ],
      ),
    );
  }
}
