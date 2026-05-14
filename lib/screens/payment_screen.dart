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
    return SpotterCard(
      height: 72,
      onTap: onTap,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                method.label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              method.detail,
              style: TextStyle(
                color: selected ? Helper.success : Helper.muted,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
