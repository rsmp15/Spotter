import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';

import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_buttons.dart';





class ParcelCompleteScreen extends StatefulWidget {
  const ParcelCompleteScreen({super.key});

  @override
  State<ParcelCompleteScreen> createState() => _ParcelCompleteScreenState();
}

class _ParcelCompleteScreenState extends State<ParcelCompleteScreen> {
  int _userRating = 5;

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final package = ride.activeParcel;
    final driver = ride.assignedParcelDriver ?? ride.drivers.first;

    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: DSColors.textPrimary),
        title: Text('Delivery Receipt', style: DSTypography.headline),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(DSSpacing.lg),
            children: [
              Text('Package successfully delivered!', style: DSTypography.body.copyWith(color: DSColors.textSecondary)),
              const SizedBox(height: DSSpacing.xl),

              // Success Avatar Glow
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: DSColors.success.withValues(alpha: 0.1),
                  ),
                  child: Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: DSColors.success,
                      ),
                      child: const Icon(Icons.done_all_rounded, color: Colors.white, size: 32),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: DSSpacing.xl),

              // Receipt Summary Box
              GlassCard(
                padding: const EdgeInsets.all(DSSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Transaction Summary', style: DSTypography.headline),
                    const SizedBox(height: DSSpacing.lg),
                    _buildInfoRow('Sender', package?.senderName ?? 'Ritesh M'),
                    const SizedBox(height: DSSpacing.sm),
                    _buildInfoRow('Receiver', package?.receiverName ?? 'Rahul Sharma'),
                    const SizedBox(height: DSSpacing.sm),
                    _buildInfoRow(
                      'Category',
                      package == null
                          ? 'Documents'
                          : package.category.name.replaceAll('documents', 'Documents / Keys').replaceAll('collegeItems', 'College Items'),
                    ),
                    const SizedBox(height: DSSpacing.sm),
                    _buildInfoRow(
                      'Weight class',
                      package == null ? 'Light' : package.size.name.toUpperCase(),
                    ),
                    const SizedBox(height: DSSpacing.sm),
                    _buildInfoRow('Vehicle type', driver.vehicle.split(' - ')[0]),
                    const SizedBox(height: DSSpacing.md),
                    const Divider(color: DSColors.border),
                    const SizedBox(height: DSSpacing.md),
                    _buildInfoRow('Amount Charged', package?.fareLabel ?? '₹45', valueColor: DSColors.success),
                  ],
                ),
              ),
              const SizedBox(height: DSSpacing.md),

              // Photo Proof placeholder Box
              GlassCard(
                padding: const EdgeInsets.all(DSSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Proof of Delivery (Photo)', style: DSTypography.headline),
                    const SizedBox(height: DSSpacing.md),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: DSColors.surface,
                        borderRadius: BorderRadius.circular(DSRadius.md),
                        border: Border.all(color: DSColors.border),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.photo_library_outlined, size: 32, color: DSColors.textSecondary),
                          const SizedBox(height: DSSpacing.xs),
                          Text(
                            'Verification Photo Uploaded by ${driver.name}',
                            style: DSTypography.caption.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: DSSpacing.md),

              // Private Driver Partner rating Star selector
              GlassCard(
                padding: const EdgeInsets.all(DSSpacing.xl),
                child: Column(
                  children: [
                    Text('Rate ${driver.name}', style: DSTypography.headline),
                    const SizedBox(height: DSSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starPos = index + 1;
                        return IconButton(
                          icon: Icon(
                            starPos <= _userRating ? Icons.star_rounded : Icons.star_border_rounded,
                            color: DSColors.warning,
                            size: 36,
                          ),
                          onPressed: () {
                            setState(() {
                              _userRating = starPos;
                            });
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
          Positioned(
            bottom: DSSpacing.lg,
            left: DSSpacing.lg,
            right: DSSpacing.lg,
            child: SpottButton.primary(
              label: 'Return to Home',
              onPressed: () {
                ride.clearParcelBooking();
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: DSTypography.body),
        Text(
          value,
          style: DSTypography.body.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor ?? DSColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
