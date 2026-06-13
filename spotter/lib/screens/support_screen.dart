import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../models/production_readiness_models.dart';
import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_buttons.dart';





class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final supportCase = SupportCase.forRide(
      rideReference: ride.shareLink.split('/').last.isNotEmpty
          ? ride.shareLink.split('/').last
          : 'SPT2049',
      role: UserRole.rider,
      category: SupportCaseCategory.technical,
      description: 'Help request from ride flow',
    );

    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? const BackButton(color: DSColors.textPrimary)
            : null,
        title: Text('Help center', style: DSTypography.headline),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: DSSpacing.lg, vertical: DSSpacing.md),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Header Search
                const SizedBox(height: DSSpacing.lg),
                Text(
                  'How can we help?',
                  textAlign: TextAlign.center,
                  style: DSTypography.headline.copyWith(fontSize: 40),
                ),
                const SizedBox(height: DSSpacing.xl),
                GlassCard(
                  padding: const EdgeInsets.all(DSSpacing.sm),
                  child: Row(
                    children: [
                      const SizedBox(width: DSSpacing.sm),
                      const Icon(Icons.search_rounded, color: DSColors.textSecondary),
                      const SizedBox(width: DSSpacing.md),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search for articles, topics...',
                            border: InputBorder.none,
                            hintStyle: DSTypography.body.copyWith(color: DSColors.textSecondary),
                          ),
                        ),
                      ),
                      SpottButton.primary(
                        label: 'Search',
                        size: SpottButtonSize.small,
                        isFullWidth: false,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DSSpacing.xl),
                
                // Recent Case Details Card
                GlassCard(
                  padding: const EdgeInsets.all(DSSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: DSColors.surface,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Recent case',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: DSColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _CaseInfoRow(
                        label: 'Ride reference',
                        value: supportCase.rideReference,
                      ),
                      const Divider(height: 20, color: DSColors.border),
                      _CaseInfoRow(label: 'Role', value: supportCase.roleLabel),
                      const Divider(height: 20, color: DSColors.border),
                      _CaseInfoRow(
                        label: 'Issue category',
                        value: supportCase.categoryLabel,
                      ),
                      const Divider(height: 20, color: DSColors.border),
                      _CaseInfoRow(
                        label: 'Status',
                        value: supportCase.statusLabel,
                        valueColor: DSColors.textPrimary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DSSpacing.xxl),

                // Popular Topics
                Text('Popular Topics', style: DSTypography.headline.copyWith(fontSize: 24)),
                const SizedBox(height: DSSpacing.lg),
              ]),
            ),
          ),
          
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: DSSpacing.lg),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: DSSpacing.md,
              crossAxisSpacing: DSSpacing.md,
              childAspectRatio: 1.1,
              children: [
                _TopicCard(
                  icon: Icons.directions_car_rounded,
                  title: 'Trips & Rides',
                  subtitle: 'Booking and tracking.',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.dispute),
                ),
                _TopicCard(
                  icon: Icons.local_shipping_rounded,
                  title: 'Parcels',
                  subtitle: 'Delivery status & insurance.',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.dispute),
                ),
                _TopicCard(
                  icon: Icons.payments_rounded,
                  title: 'Payments',
                  subtitle: 'Billing and refunds.',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.dispute),
                ),
                _TopicCard(
                  icon: Icons.security_rounded,
                  title: 'Safety',
                  subtitle: 'Emergency contacts.',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.safetyToolkit),
                ),
                _TopicCard(
                  icon: Icons.account_circle_rounded,
                  title: 'Account',
                  subtitle: 'Profile settings.',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                ),
                _TopicCard(
                  icon: Icons.verified_rounded,
                  title: 'Verification',
                  subtitle: 'ID checks.',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.kyc),
                ),
              ],
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: DSSpacing.lg, vertical: DSSpacing.md),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: DSSpacing.xxl),

                // FAQ
                Text('Frequently Asked', style: DSTypography.headline.copyWith(fontSize: 24)),
                const SizedBox(height: DSSpacing.lg),
                GlassCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      const _FAQTile(
                        question: 'How do I book a trip in advance?',
                        answer: 'To schedule a trip for later, simply open the app, enter your destination, and tap the calendar icon next to the "Book Now" button.',
                      ),
                      const Divider(height: 1, color: DSColors.borderSubtle),
                      const _FAQTile(
                        question: 'What is covered by Parcel Insurance?',
                        answer: 'Basic parcel insurance covers up to ₹5,000 in loss or damage during transit.',
                      ),
                      const Divider(height: 1, color: DSColors.borderSubtle),
                      const _FAQTile(
                        question: 'How do I become a verified driver?',
                        answer: 'Navigate to Profile > Driver Dashboard and follow the onboarding steps.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DSSpacing.xxl),

                // Need More Help
                Text('Need More Help?', style: DSTypography.headline.copyWith(fontSize: 24)),
                const SizedBox(height: DSSpacing.lg),

                // Recent Ticket
                GlassCard(
                  padding: const EdgeInsets.all(DSSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('RECENT TICKET', style: DSTypography.labelLarge.copyWith(color: DSColors.textSecondary, letterSpacing: 1.2)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: DSColors.surface,
                              borderRadius: BorderRadius.circular(DSRadius.pill),
                              border: Border.all(color: DSColors.borderSubtle),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 6, height: 6,
                                  decoration: const BoxDecoration(color: DSColors.primary, shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 6),
                                Text('In Progress', style: DSTypography.labelLarge.copyWith(color: DSColors.primary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: DSSpacing.md),
                      Text('${supportCase.categoryLabel} #${supportCase.rideReference}', style: DSTypography.titleLarge.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Updated 2 hours ago', style: DSTypography.caption.copyWith(color: DSColors.textSecondary)),
                      const SizedBox(height: DSSpacing.md),
                      InkWell(
                        onTap: () {},
                        child: Text('View Updates →', style: DSTypography.labelLarge.copyWith(color: DSColors.primary, fontWeight: FontWeight.bold)),
                      ),
                      if (supportCase.isReviewable) ...[
                        const SizedBox(height: DSSpacing.md),
                        const Divider(color: DSColors.borderSubtle),
                        const SizedBox(height: DSSpacing.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Ride reference', style: DSTypography.body.copyWith(color: DSColors.textSecondary)),
                            Text(supportCase.rideReference, style: DSTypography.body.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: DSSpacing.xs),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Role', style: DSTypography.body.copyWith(color: DSColors.textSecondary)),
                            Text(supportCase.roleLabel, style: DSTypography.body.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: DSSpacing.xs),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Status', style: DSTypography.body.copyWith(color: DSColors.textSecondary)),
                            Text(supportCase.statusLabel, style: DSTypography.body.copyWith(fontWeight: FontWeight.bold, color: DSColors.success)),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: DSSpacing.md),

                // Live Support
                GlassCard(
                  padding: const EdgeInsets.all(DSSpacing.xl),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 80, height: 80,
                            decoration: BoxDecoration(
                              color: DSColors.surface,
                              shape: BoxShape.circle,
                              border: Border.all(color: DSColors.borderSubtle),
                            ),
                            child: const Icon(Icons.support_agent_rounded, color: DSColors.primary, size: 40),
                          ),
                          Container(
                            width: 20, height: 20,
                            decoration: BoxDecoration(
                              color: DSColors.success,
                              shape: BoxShape.circle,
                              border: Border.all(color: DSColors.surface, width: 3),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: DSSpacing.lg),
                      Text('Live Support', style: DSTypography.headline.copyWith(fontSize: 20)),
                      const SizedBox(height: DSSpacing.sm),
                      Text(
                        'Our team is online and ready to assist you instantly.',
                        textAlign: TextAlign.center,
                        style: DSTypography.body.copyWith(color: DSColors.textSecondary),
                      ),
                      const SizedBox(height: DSSpacing.lg),
                      SizedBox(
                        width: double.infinity,
                        child: SpottButton.primary(
                          label: 'Contact Support',
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DSSpacing.xxl),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _TopicCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(DSSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: DSColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: DSColors.borderSubtle),
            ),
            child: Icon(icon, color: DSColors.primary, size: 28),
          ),
          const Spacer(),
          Text(title, style: DSTypography.titleLarge.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: DSTypography.caption.copyWith(color: DSColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _FAQTile extends StatelessWidget {
  final String question;
  final String answer;

  const _FAQTile({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(question, style: DSTypography.titleLarge.copyWith(fontWeight: FontWeight.bold)),
        iconColor: DSColors.primary,
        collapsedIconColor: DSColors.primary,
        childrenPadding: const EdgeInsets.only(left: DSSpacing.md, right: DSSpacing.md, bottom: DSSpacing.md),
        children: [
          Text(answer, style: DSTypography.body.copyWith(color: DSColors.textSecondary)),
        ],
      ),
    );
  }
}

class _CaseInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _CaseInfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: DSColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? DSColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
