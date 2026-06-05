import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_buttons.dart';
import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';


class JobRequestsScreen extends StatelessWidget {
  const JobRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: SpottColors.textPrimary),
        title: const Text('Route jobs', style: SpottTextStyles.sectionTitle),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(SpottSpacing.lg),
            children: [
              Text('Accept what fits your route.', style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary)),
              const SizedBox(height: SpottSpacing.xl),

              _RequestCard(
                title: 'Baner to Koregaon Park',
                deviation: '1.2 km',
                payout: '₹ 390',
                onTap: () => Navigator.pushNamed(context, AppRoutes.jobDetail),
              ),
              const SizedBox(height: SpottSpacing.md),
              _RequestCard(
                title: 'Aundh to Camp',
                deviation: '5.1 km',
                payout: '₹ 620',
                onTap: () => Navigator.pushNamed(context, AppRoutes.jobDetail),
              ),
              const SizedBox(height: SpottSpacing.md),
              _RequestCard(
                title: 'Viman Nagar to Kalyani Nagar',
                deviation: '2.4 km',
                payout: '₹ 260',
                onTap: () => Navigator.pushNamed(context, AppRoutes.jobDetail),
              ),
              const SizedBox(height: 100),
            ],
          ),
          Positioned(
            bottom: SpottSpacing.lg,
            left: SpottSpacing.lg,
            right: SpottSpacing.lg,
            child: SpottButton.primary(
              label: 'View best request',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.jobDetail),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final String title;
  final String deviation;
  final String payout;
  final VoidCallback? onTap;

  const _RequestCard({
    required this.title,
    required this.deviation,
    required this.payout,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(SpottSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: SpottTextStyles.sectionTitle),
          const SizedBox(height: SpottSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Deviation', style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary)),
              Text(deviation, style: SpottTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: SpottColors.textPrimary)),
            ],
          ),
          const SizedBox(height: SpottSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Payout', style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary)),
              Text(payout, style: SpottTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: SpottColors.success)),
            ],
          ),
        ],
      ),
    );
  }
}
