import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../helper.dart';
import '../spotter_widgets.dart';
import '../screens/rider_bottom_nav.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SpotterScreen(
      title: 'Spott Money',
      subtitle: 'Balance, payment methods, offers, and recent activity.',
      showBack: false,
      showMenu: true,
      bottomNavigationBar: const RiderBottomNav(activeTab: RiderBottomTab.profile),
      content: [
        SpotterCard(
          color: Helper.primary,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available balance',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Rs 220',
                        style: TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: PrimaryAction(
                    label: 'Add money',
                    onPressed: () =>
                        _showWalletMessage(context, 'Wallet top-up started'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        _showWalletMessage(context, 'Payment methods opened'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      minimumSize: const Size.fromHeight(56),
                    ),
                    child: const Text('Methods', style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SpotterCard(
          children: [
            StatusChip(label: 'Payment profile'),
            SizedBox(height: 12),
            InfoRow(label: 'Default card', value: 'Personal **** 4242'),
            InfoRow(label: 'Auto top-up', value: 'Enabled'),
            InfoRow(
              label: 'Reward credits',
              value: 'Rs 64',
            ),
          ],
        ),
        _WalletActionCard(
          icon: Icons.sell_rounded,
          title: 'Offers and coupons',
          subtitle: 'Ride, rental, and parking discounts',
          value: '3 active',
          onTap: () => Navigator.pushNamed(context, AppRoutes.offers),
        ),
        _WalletActionCard(
          icon: Icons.receipt_long_rounded,
          title: 'Receipts',
          subtitle: 'Download trip and parking invoices',
          value: 'View all',
          onTap: () => Navigator.pushNamed(context, AppRoutes.activity),
        ),
        const _WalletSectionTitle('Recent transactions'),
        const _TransactionTile(
          icon: Icons.directions_car_rounded,
          title: 'Downtown ride',
          time: 'Today, 2:15 PM',
          amount: '- Rs 49',
        ),
        const _TransactionTile(
          icon: Icons.account_balance_wallet_rounded,
          title: 'Wallet top-up',
          time: 'Yesterday, 9:00 AM',
          amount: '+ Rs 250',
          isCredit: true,
        ),
        const _TransactionTile(
          icon: Icons.local_parking_rounded,
          title: 'Central Station parking',
          time: 'Oct 24, 8:30 AM',
          amount: '- Rs 80',
        ),
      ],
    );
  }

  static void _showWalletMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _WalletActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final VoidCallback onTap;

  const _WalletActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SpotterCard(
      onTap: onTap,
      children: [
        Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: Helper.canvasSoftColor(context),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Helper.inkColor(context)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Helper.inkColor(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Helper.mutedColor(context), 
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: Helper.inkColor(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WalletSectionTitle extends StatelessWidget {
  final String title;

  const _WalletSectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18, 
          fontWeight: FontWeight.w700,
          color: Helper.inkColor(context),
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final String amount;
  final bool isCredit;

  const _TransactionTile({
    required this.icon,
    required this.title,
    required this.time,
    required this.amount,
    this.isCredit = false,
  });

  @override
  Widget build(BuildContext context) {
    return SpotterCard(
      height: 78,
      children: [
        Row(
          children: [
            Icon(icon, color: Helper.inkColor(context)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Helper.inkColor(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      color: Helper.mutedColor(context), 
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                color: isCredit ? Helper.success : Helper.inkColor(context),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
