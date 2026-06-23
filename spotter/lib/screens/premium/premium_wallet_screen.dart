import 'package:flutter/material.dart';
import '../../theme/spott_theme.dart';
import '../../widgets/premium/glassmorphism.dart';
import '../../widgets/premium/premium_button.dart';

class PremiumWalletScreen extends StatelessWidget {
  const PremiumWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SpottTheme.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: SpottTheme.spacingLarge,
            right: SpottTheme.spacingLarge,
            top: SpottTheme.spacingLarge,
            bottom: 120, // space for nav bar
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: SpottTheme.spacingLarge),
              _buildBalanceCard(),
              const SizedBox(height: SpottTheme.spacingXLarge),
              _buildQuickActions(),
              const SizedBox(height: SpottTheme.spacingXLarge),
              Text(
                "Recent Transactions",
                style: SpottTheme.textTheme.titleLarge,
              ),
              const SizedBox(height: SpottTheme.spacingMedium),
              _buildTransactionsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Wallet", style: SpottTheme.textTheme.displayMedium),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: SpottTheme.surface,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.qr_code_scanner, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SpottTheme.spacingLarge),
      decoration: BoxDecoration(
        gradient: SpottTheme.primaryGradient,
        borderRadius: SpottTheme.borderRadiusLarge,
        boxShadow: SpottTheme.glowingShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Balance",
                style: SpottTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              Glassmorphism(
                borderRadius: 20,
                color: Colors.white.withValues(alpha: 0.2),
                border: Border.all(color: Colors.transparent),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Colors.yellow,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "250 Points",
                      style: SpottTheme.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "₹ 4,250.00",
            style: SpottTheme.textTheme.displayLarge?.copyWith(fontSize: 40),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: PremiumButton(
                  text: "Add Money",
                  onPressed: () {},
                  isPrimary: false,
                ),
              ),
              const SizedBox(width: SpottTheme.spacingMedium),
              Expanded(
                child: PremiumButton(
                  text: "Withdraw",
                  onPressed: () {},
                  isPrimary: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionItem(Icons.arrow_upward, "Send"),
        _buildActionItem(Icons.arrow_downward, "Receive"),
        _buildActionItem(Icons.card_giftcard, "Rewards"),
        _buildActionItem(Icons.receipt_long, "Bills"),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String label) {
    return Column(
      children: [
        Glassmorphism(
          borderRadius: 24,
          padding: const EdgeInsets.all(16),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: SpottTheme.textTheme.labelMedium),
      ],
    );
  }

  Widget _buildTransactionsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      separatorBuilder: (context, index) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Divider(color: SpottTheme.card),
      ),
      itemBuilder: (context, index) {
        final isCredit = index % 2 != 0;
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCredit
                    ? SpottTheme.success.withValues(alpha: 0.1)
                    : SpottTheme.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCredit ? Icons.arrow_downward : Icons.directions_car,
                color: isCredit ? SpottTheme.success : Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCredit ? "Added to Wallet" : "Trip to Pune",
                    style: SpottTheme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Today, 10:30 AM",
                    style: SpottTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Text(
              "${isCredit ? '+' : '-'} ₹ ${isCredit ? '500' : '450'}",
              style: SpottTheme.textTheme.titleMedium?.copyWith(
                color: isCredit ? SpottTheme.success : Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}

