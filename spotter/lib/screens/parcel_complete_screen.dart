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
        leading: const BackButton(color: SpottColors.textPrimary),
        title: const Text('Delivery Receipt', style: SpottTextStyles.sectionTitle),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(SpottSpacing.lg),
            children: [
              Text('Package successfully delivered!', style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary)),
              const SizedBox(height: SpottSpacing.xl),

              // Success Avatar Glow
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: SpottColors.success.withValues(alpha: 0.1),
                  ),
                  child: Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: SpottColors.success,
                      ),
                      child: const Icon(Icons.done_all_rounded, color: Colors.white, size: 32),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: SpottSpacing.xl),

              // Receipt Summary Box
              GlassCard(
                padding: const EdgeInsets.all(SpottSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Transaction Summary', style: SpottTextStyles.sectionTitle),
                    const SizedBox(height: SpottSpacing.lg),
                    _buildInfoRow('Sender', package?.senderName ?? 'Ritesh M'),
                    const SizedBox(height: SpottSpacing.sm),
                    _buildInfoRow('Receiver', package?.receiverName ?? 'Rahul Sharma'),
                    const SizedBox(height: SpottSpacing.sm),
                    _buildInfoRow(
                      'Category',
                      package == null
                          ? 'Documents'
                          : package.category.name.replaceAll('documents', 'Documents / Keys').replaceAll('collegeItems', 'College Items'),
                    ),
                    const SizedBox(height: SpottSpacing.sm),
                    _buildInfoRow(
                      'Weight class',
                      package == null ? 'Light' : package.size.name.toUpperCase(),
                    ),
                    const SizedBox(height: SpottSpacing.sm),
                    _buildInfoRow('Vehicle type', driver.vehicle.split(' - ')[0]),
                    const SizedBox(height: SpottSpacing.md),
                    const Divider(color: SpottColors.border),
                    const SizedBox(height: SpottSpacing.md),
                    _buildInfoRow('Amount Charged', package?.fareLabel ?? '₹45', valueColor: SpottColors.success),
                  ],
                ),
              ),
              const SizedBox(height: SpottSpacing.md),

              // Photo Proof placeholder Box
              GlassCard(
                padding: const EdgeInsets.all(SpottSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Proof of Delivery (Photo)', style: SpottTextStyles.sectionTitle),
                    const SizedBox(height: SpottSpacing.md),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: SpottColors.surface1,
                        borderRadius: BorderRadius.circular(SpottRadius.md),
                        border: Border.all(color: SpottColors.border),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.photo_library_outlined, size: 32, color: SpottColors.textSecondary),
                          const SizedBox(height: SpottSpacing.xs),
                          Text(
                            'Verification Photo Uploaded by ${driver.name}',
                            style: SpottTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SpottSpacing.md),

              // Private Driver Partner rating Star selector
              GlassCard(
                padding: const EdgeInsets.all(SpottSpacing.xl),
                child: Column(
                  children: [
                    Text('Rate ${driver.name}', style: SpottTextStyles.sectionTitle),
                    const SizedBox(height: SpottSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starPos = index + 1;
                        return IconButton(
                          icon: Icon(
                            starPos <= _userRating ? Icons.star_rounded : Icons.star_border_rounded,
                            color: SpottColors.warning,
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
            bottom: SpottSpacing.lg,
            left: SpottSpacing.lg,
            right: SpottSpacing.lg,
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
        Text(label, style: SpottTextStyles.body),
        Text(
          value,
          style: SpottTextStyles.body.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor ?? SpottColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
