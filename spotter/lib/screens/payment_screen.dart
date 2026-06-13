import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../helper.dart';
import '../models/ride_models.dart';
import '../spotter_widgets.dart';





class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);

    return SpotterScreen(
      title: 'Payment',
      subtitle: 'Choose a secure online method.',
      content: [
        RecoveryBanner(state: ride.actionState, onRetry: ride.retryInitialize),
        RideContextCard(
          route: ride.routeLabel,
          fare: ride.fareLabel,
          driver: ride.selectedDriver?.name ?? 'Matching',
          status: ride.status.name,
        ),
        for (final method in ride.paymentMethods)
          _PaymentTile(
            method: method,
            selected: method.id == ride.selectedPaymentMethod?.id,
            onTap: () => ride.selectPaymentMethod(method),
          ),
        const SpotterCard(
          children: [
            Text(
              'Payment protection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Your driver details and receipt stay available after the ride.',
              style: TextStyle(color: Helper.muted),
            ),
          ],
        ),
      ],
      bottom: PrimaryAction(
        label: 'Pay ${ride.fareLabel}',
        onPressed: () {
          ride.markArriving();
          Navigator.pushNamed(context, AppRoutes.tracking);
        },
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final PaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentTile({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DSRadius.card),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: selected
                  ? DSColors.primary.withValues(alpha: 0.04)
                  : DSColors.surface,
              borderRadius: BorderRadius.circular(DSRadius.card),
              border: Border.all(
                color: selected ? DSColors.primary : DSColors.border,
                width: selected ? 2.0 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        method.label,
                        style: DSTypography.titleLarge.copyWith(
                          color: DSColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        method.detail,
                        style: DSTypography.caption.copyWith(
                          color: DSColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedSwitcher(
                  duration: DSMotion.instant,
                  child: selected
                      ? const Icon(
                          Icons.check_circle_rounded,
                          color: DSColors.primary,
                          size: 22,
                          key: ValueKey('selected'),
                        )
                      : const Icon(
                          Icons.radio_button_off_rounded,
                          color: DSColors.textMuted,
                          size: 22,
                          key: ValueKey('unselected'),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
