import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_buttons.dart';
import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';
import '../core/theme/radius.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(SpottSpacing.pageHorizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Animated Success Icon
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: SpottColors.successSoft,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: SpottColors.success.withValues(alpha: 0.2),
                      blurRadius: 32,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 64,
                  color: SpottColors.success,
                ),
              ),
              const SizedBox(height: SpottSpacing.xl),
              
              Text('Booking Confirmed!', style: SpottTextStyles.display),
              const SizedBox(height: SpottSpacing.sm),
              Text(
                'You are all set for your trip.',
                style: SpottTextStyles.body,
              ),
              const SizedBox(height: SpottSpacing.section),
              
              GlassCard(
                padding: const EdgeInsets.all(SpottSpacing.cardInner),
                child: Column(
                  children: [
                    _buildInfoRow('Route', 'Pune → Mumbai'),
                    const SizedBox(height: SpottSpacing.md),
                    _buildInfoRow('Date', '5 Jun 2026'),
                    const SizedBox(height: SpottSpacing.md),
                    _buildInfoRow('Departure', '7:30 AM'),
                    const SizedBox(height: SpottSpacing.md),
                    _buildInfoRow('Seats booked', '2'),
                    const SizedBox(height: SpottSpacing.md),
                    _buildInfoRow('Cost share', '₹700', valueColor: SpottColors.primary),
                  ],
                ),
              ),
              
              const Spacer(),
              
              SpottButton.primary(
                label: 'View Trip Details',
                onPressed: () => Navigator.pushNamed(context, AppRoutes.tracking),
              ),
              const SizedBox(height: SpottSpacing.md),
              SpottButton.ghost(
                label: 'Back to Home',
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (route) => false,
                ),
              ),
            ],
          ),
        ),
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
          style: SpottTextStyles.label.copyWith(color: valueColor ?? SpottColors.textPrimary),
        ),
      ],
    );
  }
}
