import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_buttons.dart';





class JobRequestsScreen extends StatelessWidget {
  const JobRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: DSColors.textPrimary),
        title: Text('Route jobs', style: DSTypography.headline),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(DSSpacing.lg),
            children: [
              Text('Accept what fits your route.', style: DSTypography.body.copyWith(color: DSColors.textSecondary)),
              const SizedBox(height: DSSpacing.xl),

              _RequestCard(
                title: 'Baner to Koregaon Park',
                deviation: '1.2 km',
                payout: '₹ 390',
                onTap: () => Navigator.pushNamed(context, AppRoutes.jobDetail),
              ),
              const SizedBox(height: DSSpacing.md),
              _RequestCard(
                title: 'Aundh to Camp',
                deviation: '5.1 km',
                payout: '₹ 620',
                onTap: () => Navigator.pushNamed(context, AppRoutes.jobDetail),
              ),
              const SizedBox(height: DSSpacing.md),
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
            bottom: DSSpacing.lg,
            left: DSSpacing.lg,
            right: DSSpacing.lg,
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
      padding: const EdgeInsets.all(DSSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: DSTypography.headline),
          const SizedBox(height: DSSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Deviation', style: DSTypography.body.copyWith(color: DSColors.textSecondary)),
              Text(deviation, style: DSTypography.body.copyWith(fontWeight: FontWeight.bold, color: DSColors.textPrimary)),
            ],
          ),
          const SizedBox(height: DSSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Payout', style: DSTypography.body.copyWith(color: DSColors.textSecondary)),
              Text(payout, style: DSTypography.body.copyWith(fontWeight: FontWeight.bold, color: DSColors.success)),
            ],
          ),
        ],
      ),
    );
  }
}
