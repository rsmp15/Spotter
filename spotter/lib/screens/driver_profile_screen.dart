import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/glass_card.dart';
import '../core/components/spott_buttons.dart';
import '../core/components/trust_badge.dart';





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
          leading: const BackButton(color: DSColors.textPrimary),
        ),
        body: Center(
          child: Text(
            'No driver selected',
            style: DSTypography.body.copyWith(color: DSColors.textSecondary),
          ),
        ),
      );
    }

    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: DSColors.textPrimary),
        title: Text('Traveler Profile', style: DSTypography.titleLarge),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: DSSpacing.lg),

            // Profile Info Header Card
            GlassCard(
              padding: const EdgeInsets.all(DSSpacing.md),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: DSColors.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: DSColors.border, width: 1),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          driver.name[0],
                          style: DSTypography.headline.copyWith(fontSize: 22, color: DSColors.textPrimary),
                        ),
                      ),
                      const SizedBox(width: DSSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              driver.name,
                              style: DSTypography.titleLarge.copyWith(fontSize: 18),
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
                  const SizedBox(height: DSSpacing.md),
                  const Divider(height: 1),
                  const SizedBox(height: DSSpacing.md),

                  // Triple Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetric('Rating', '${driver.rating} ★', DSColors.warning),
                      _buildMetric('Trips Done', '${driver.completedRides}', DSColors.primaryDark),
                      _buildMetric('Response', '98%', DSColors.success),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: DSSpacing.xl),

            // Official Verifications Details Card
            Text('MARKETPLACE CREDENTIALS', style: DSTypography.caption),
            const SizedBox(height: DSSpacing.md),
            GlassCard(
              padding: const EdgeInsets.all(DSSpacing.md),
              child: Column(
                children: [
                  _buildCredentialRow('Government ID', 'VERIFIED', DSColors.success),
                  const Divider(height: 16),
                  _buildCredentialRow('Mobile Number', 'VERIFIED', DSColors.success),
                  const Divider(height: 16),
                  _buildCredentialRow('Vehicle Registration', 'VERIFIED', DSColors.success),
                  const Divider(height: 16),
                  _buildCredentialRow('Background Checked', 'PENDING', DSColors.warning),
                ],
              ),
            ),

            const SizedBox(height: DSSpacing.xl),

            // Vehicle Particulars Card
            Text('REGISTERED VEHICLE', style: DSTypography.caption),
            const SizedBox(height: DSSpacing.md),
            GlassCard(
              padding: const EdgeInsets.all(DSSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: DSColors.surface,
                      borderRadius: BorderRadius.circular(DSRadius.sm),
                    ),
                    child: const Icon(Icons.directions_car_rounded, color: DSColors.textSecondary),
                  ),
                  const SizedBox(width: DSSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(driver.vehicle, style: DSTypography.labelLarge),
                        const SizedBox(height: 2),
                        Text('Plate Verified • Active Insurance', style: DSTypography.caption),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: DSSpacing.xl),

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

            const SizedBox(height: 120.0),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String lbl, String val, Color valColor) {
    return Column(
      children: [
        Text(val, style: DSTypography.labelLarge.copyWith(fontSize: 16, color: valColor)),
        const SizedBox(height: 2),
        Text(lbl, style: DSTypography.caption.copyWith(fontSize: 10, color: DSColors.textTertiary)),
      ],
    );
  }

  Widget _buildCredentialRow(String key, String status, Color statusColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(key, style: DSTypography.body.copyWith(fontSize: 14, color: DSColors.textPrimary)),
        Text(
          status,
          style: DSTypography.caption.copyWith(
            color: statusColor,
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

