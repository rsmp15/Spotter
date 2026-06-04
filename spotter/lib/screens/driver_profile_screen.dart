import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/glass_card.dart';
import '../core/components/spott_buttons.dart';
import '../core/components/trust_badge.dart';
import '../core/theme/colors.dart';
import '../core/theme/radius.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final driver =
        ride.selectedDriver ??
        (ride.drivers.isEmpty ? null : ride.drivers.first);

    if (driver == null) {
      return GlassScaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: SpottColors.textPrimary),
        ),
        body: Center(
          child: Text(
            'No driver selected',
            style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary),
          ),
        ),
      );
    }

    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: SpottColors.textPrimary),
        title: const Text('Traveler Profile', style: SpottTextStyles.titleSmall),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.pageHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: SpottSpacing.lg),

            // Profile Info Header Card
            GlassCard(
              padding: const EdgeInsets.all(SpottSpacing.md),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: SpottColors.surface1,
                          shape: BoxShape.circle,
                          border: Border.all(color: SpottColors.border, width: 1),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          driver.name[0],
                          style: SpottTextStyles.display.copyWith(fontSize: 22, color: SpottColors.textPrimary),
                        ),
                      ),
                      const SizedBox(width: SpottSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              driver.name,
                              style: SpottTextStyles.title.copyWith(fontSize: 18),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            // Stack of Level 1-4 icons
                            const VerificationStack(level: 3),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SpottSpacing.md),
                  const Divider(height: 1),
                  const SizedBox(height: SpottSpacing.md),

                  // Triple Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetric('Rating', '${driver.rating} ★', SpottColors.warning),
                      _buildMetric('Trips Done', '${driver.completedRides}', SpottColors.accentPurple),
                      _buildMetric('Response', '98%', SpottColors.success),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: SpottSpacing.xl),

            // Official Verifications Details Card
            Text('MARKETPLACE CREDENTIALS', style: SpottTextStyles.overline),
            const SizedBox(height: SpottSpacing.md),
            GlassCard(
              padding: const EdgeInsets.all(SpottSpacing.md),
              child: Column(
                children: [
                  _buildCredentialRow('Government ID', 'VERIFIED', SpottColors.success),
                  const Divider(height: 16),
                  _buildCredentialRow('Mobile Number', 'VERIFIED', SpottColors.success),
                  const Divider(height: 16),
                  _buildCredentialRow('Vehicle Registration', 'VERIFIED', SpottColors.success),
                  const Divider(height: 16),
                  _buildCredentialRow('Background Checked', 'PENDING', SpottColors.warning),
                ],
              ),
            ),

            const SizedBox(height: SpottSpacing.xl),

            // Vehicle Particulars Card
            Text('REGISTERED VEHICLE', style: SpottTextStyles.overline),
            const SizedBox(height: SpottSpacing.md),
            GlassCard(
              padding: const EdgeInsets.all(SpottSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: SpottColors.surface1,
                      borderRadius: BorderRadius.circular(SpottRadius.sm),
                    ),
                    child: const Icon(Icons.directions_car_rounded, color: SpottColors.textSecondary),
                  ),
                  const SizedBox(width: SpottSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(driver.vehicle, style: SpottTextStyles.label),
                        const SizedBox(height: 2),
                        const Text('Plate Verified • Active Insurance', style: SpottTextStyles.caption),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: SpottSpacing.xl),

            // Book Button
            SizedBox(
              width: double.infinity,
              child: SpottButton.primary(
                label: 'Choose This Traveler',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.confirmRide);
                },
              ),
            ),

            const SizedBox(height: SpottSpacing.pageBottom),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String lbl, String val, Color valColor) {
    return Column(
      children: [
        Text(val, style: SpottTextStyles.label.copyWith(fontSize: 16, color: valColor)),
        const SizedBox(height: 2),
        Text(lbl, style: SpottTextStyles.caption.copyWith(fontSize: 10, color: SpottColors.textTertiary)),
      ],
    );
  }

  Widget _buildCredentialRow(String key, String status, Color statusColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(key, style: SpottTextStyles.body.copyWith(fontSize: 14, color: SpottColors.textPrimary)),
        Text(
          status,
          style: SpottTextStyles.caption.copyWith(
            color: statusColor,
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
