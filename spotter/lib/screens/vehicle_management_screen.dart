import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../controllers/ride_controller.dart';
import '../models/spott_models.dart';
import '../core/components/status_chip.dart';

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
        return CupertinoIcons.car_detailed;
      case 'bike':
        return CupertinoIcons.location;
      case 'auto':
        return CupertinoIcons.car;
      default:
        return CupertinoIcons.car_detailed;
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;
    final isEdit = vehicle != null;

    final modelController = TextEditingController(text: vehicle?.vehicleModel ?? '');
    final numberController = TextEditingController(text: vehicle?.vehicleNumber ?? '');
    String selectedType = vehicle?.vehicleType ?? 'Car';

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: palette.surface,
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
                  Text(
                    isEdit ? 'Edit Vehicle' : 'Add Vehicle',
                    style: DSTypography.headline.copyWith(color: palette.textPrimary),
                  ),
                  const SizedBox(height: DSSpacing.lg),

                  Text(
                    'Vehicle Type',
                    style: DSTypography.caption.copyWith(fontWeight: FontWeight.bold, color: palette.textSecondary),
                  ),
                  const SizedBox(height: DSSpacing.xs),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md),
                    decoration: BoxDecoration(
                      color: palette.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: palette.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedType,
                        isExpanded: true,
                        dropdownColor: palette.surface,
                        style: DSTypography.body.copyWith(color: palette.textPrimary),
                        icon: Icon(CupertinoIcons.chevron_down, color: palette.textSecondary, size: 18),
                        items: ['Car', 'Bike', 'SUV', 'Auto'].map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type, style: TextStyle(color: palette.textPrimary)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) setSheetState(() => selectedType = value);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: DSSpacing.md),

                  Text(
                    'Vehicle Model Name',
                    style: DSTypography.caption.copyWith(fontWeight: FontWeight.bold, color: palette.textSecondary),
                  ),
                  const SizedBox(height: DSSpacing.xs),
                  TextField(
                    controller: modelController,
                    style: DSTypography.body.copyWith(color: palette.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'e.g. Honda City / Activa 6G',
                      filled: true,
                      fillColor: palette.surfaceVariant,
                      hintStyle: DSTypography.body.copyWith(color: palette.textTertiary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: palette.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: palette.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: palette.primary, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: DSSpacing.md),

                  Text(
                    'Registration Number',
                    style: DSTypography.caption.copyWith(fontWeight: FontWeight.bold, color: palette.textSecondary),
                  ),
                  const SizedBox(height: DSSpacing.xs),
                  TextField(
                    controller: numberController,
                    style: DSTypography.body.copyWith(color: palette.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'e.g. MH-12-PQ-9876',
                      filled: true,
                      fillColor: palette.surfaceVariant,
                      hintStyle: DSTypography.body.copyWith(color: palette.textTertiary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: palette.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: palette.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: palette.primary, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: DSSpacing.xl),

                  Row(
                    children: [
                      if (isEdit) ...[
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: OutlinedButton(
                              onPressed: () {
                                ride.deleteVehicle(vehicle.id);
                                Navigator.pop(sheetContext);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Vehicle deleted')),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: palette.danger,
                                side: BorderSide(color: palette.danger),
                                shape: const StadiumBorder(),
                              ),
                              child: const Text('Delete', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        const SizedBox(width: DSSpacing.md),
                      ],
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 56,
                          child: FilledButton(
                            onPressed: () {
                              if (modelController.text.trim().isEmpty || numberController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please complete all details')),
                                );
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
                            style: FilledButton.styleFrom(
                              backgroundColor: palette.primary,
                              foregroundColor: palette.onPrimary,
                              shape: const StadiumBorder(),
                            ),
                            child: Text(
                              isEdit ? 'Save Changes' : 'Add Vehicle',
                              style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                            ),
                          ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        leading: BackButton(color: palette.textPrimary),
        title: Text('My Vehicles', style: DSTypography.headline.copyWith(color: palette.textPrimary)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(DSSpacing.lg),
            children: [
              Text(
                'Add, edit, or select your active vehicle.',
                style: DSTypography.body.copyWith(color: palette.textSecondary),
              ),
              const SizedBox(height: DSSpacing.xl),

              if (ride.vehicles.isEmpty)
                Container(
                  padding: const EdgeInsets.all(DSSpacing.xl),
                  decoration: BoxDecoration(
                    color: palette.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: palette.border),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(CupertinoIcons.car_detailed, size: 48, color: palette.textSecondary),
                        const SizedBox(height: DSSpacing.md),
                        Text(
                          'No vehicles added yet',
                          style: DSTypography.headline.copyWith(color: palette.textPrimary),
                        ),
                        const SizedBox(height: DSSpacing.sm),
                        Text(
                          'Add a vehicle below to start offering trips.',
                          style: DSTypography.caption.copyWith(color: palette.textSecondary),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...ride.vehicles.map((vehicle) {
                  final isSelected = ride.selectedVehicleId == vehicle.id;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: DSSpacing.md),
                    child: InkWell(
                      onTap: () => _openVehicleFormSheet(context, vehicle),
                      child: Container(
                        padding: const EdgeInsets.all(DSSpacing.md),
                        decoration: BoxDecoration(
                          color: palette.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? palette.primary : palette.border,
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: palette.surfaceVariant,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getVehicleIcon(vehicle.vehicleType),
                                color: palette.textPrimary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: DSSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    vehicle.vehicleModel,
                                    style: DSTypography.body.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: palette.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    vehicle.vehicleNumber,
                                    style: DSTypography.caption.copyWith(color: palette.textSecondary),
                                  ),
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
                                      Icon(CupertinoIcons.checkmark_circle_fill, color: palette.primary, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Active',
                                        style: DSTypography.caption.copyWith(
                                          color: palette.textPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  InkWell(
                                    onTap: () {
                                      ride.setSelectedVehicle(vehicle.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${vehicle.vehicleModel} set as active vehicle.',
                                            style: TextStyle(color: palette.onPrimary),
                                          ),
                                          backgroundColor: palette.primary,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Set Active',
                                      style: DSTypography.caption.copyWith(
                                        color: palette.textSecondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
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
            child: SizedBox(
              height: 56,
              child: FilledButton(
                onPressed: () => _openVehicleFormSheet(context),
                style: FilledButton.styleFrom(
                  backgroundColor: palette.primary,
                  foregroundColor: palette.onPrimary,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  'Add Vehicle',
                  style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
