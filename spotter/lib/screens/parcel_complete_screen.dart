import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotter/design_system/design_system.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../core/components/spott_buttons.dart';
import '../core/components/glass_scaffold.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;

    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            CupertinoIcons.arrow_left,
            color: palette.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Delivery Receipt',
          style: DSTypography.headline.copyWith(
            color: palette.textPrimary,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(DSSpacing.lg),
            children: [
              Text(
                'Package successfully delivered!',
                style: DSTypography.body.copyWith(
                  color: palette.textSecondary,
                ),
              ),
              const SizedBox(height: DSSpacing.xl),

              // Success Avatar Glow (Monochromatic)
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: palette.border,
                  ),
                  child: Center(
                    child: Icon(
                      CupertinoIcons.checkmark_alt,
                      color: palette.textPrimary,
                      size: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: DSSpacing.xl),

              // Receipt Summary Box
              Container(
                padding: const EdgeInsets.all(DSSpacing.xl),
                decoration: BoxDecoration(
                  color: palette.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: palette.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction Summary',
                      style: DSTypography.headline.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: DSSpacing.lg),
                    _buildInfoRow('Sender', package?.senderName ?? 'Ritesh M', palette),
                    const SizedBox(height: DSSpacing.sm),
                    _buildInfoRow('Receiver', package?.receiverName ?? 'Rahul Sharma', palette),
                    const SizedBox(height: DSSpacing.sm),
                    _buildInfoRow(
                      'Category',
                      package == null
                          ? 'Documents'
                          : package.category.name.replaceAll('documents', 'Documents / Keys').replaceAll('collegeItems', 'College Items'),
                      palette,
                    ),
                    const SizedBox(height: DSSpacing.sm),
                    _buildInfoRow(
                      'Weight class',
                      package == null ? 'Light' : package.size.name.toUpperCase(),
                      palette,
                    ),
                    const SizedBox(height: DSSpacing.sm),
                    _buildInfoRow('Vehicle type', driver.vehicle.split(' - ')[0], palette),
                    const SizedBox(height: DSSpacing.md),
                    Divider(color: palette.border),
                    const SizedBox(height: DSSpacing.md),
                    _buildInfoRow('Amount Charged', package?.fareLabel ?? '₹45', palette, valueColor: palette.textPrimary),
                  ],
                ),
              ),
              const SizedBox(height: DSSpacing.md),

              // Photo Proof placeholder Box
              Container(
                padding: const EdgeInsets.all(DSSpacing.xl),
                decoration: BoxDecoration(
                  color: palette.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: palette.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Proof of Delivery (Photo)',
                      style: DSTypography.headline.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: DSSpacing.md),
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: palette.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: palette.border),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.photo_on_rectangle, size: 32, color: palette.textSecondary),
                          const SizedBox(height: DSSpacing.xs),
                          Text(
                            'Verification Photo Uploaded by ${driver.name}',
                            style: DSTypography.caption.copyWith(
                              fontWeight: FontWeight.bold,
                              color: palette.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: DSSpacing.md),

              // Private Driver Partner rating Star selector
              Container(
                padding: const EdgeInsets.all(DSSpacing.xl),
                decoration: BoxDecoration(
                  color: palette.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: palette.border),
                ),
                child: Column(
                  children: [
                    Text(
                      'Rate ${driver.name}',
                      style: DSTypography.headline.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: DSSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starPos = index + 1;
                        final isSelected = starPos <= _userRating;
                        return CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Icon(
                            isSelected ? CupertinoIcons.star_fill : CupertinoIcons.star,
                            color: isSelected ? palette.textPrimary : palette.textSecondary.withValues(alpha: 0.4),
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

  Widget _buildInfoRow(String label, String value, DSColorPalette palette, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: DSTypography.body.copyWith(
            color: palette.textSecondary,
          ),
        ),
        Text(
          value,
          style: DSTypography.body.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor ?? palette.textPrimary,
          ),
        ),
      ],
    );
  }
}


