import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../models/production_readiness_models.dart';
import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_buttons.dart';
import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';
import '../core/theme/radius.dart';

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
            ? const BackButton(color: SpottColors.textPrimary)
            : null,
        title: const Text('Help center', style: SpottTextStyles.sectionTitle),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.lg, vertical: SpottSpacing.md),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Header Search
                const SizedBox(height: SpottSpacing.lg),
                Text(
                  'How can we help?',
                  textAlign: TextAlign.center,
                  style: SpottTextStyles.display.copyWith(fontSize: 40),
                ),
                const SizedBox(height: SpottSpacing.xl),
                GlassCard(
                  padding: const EdgeInsets.all(SpottSpacing.sm),
                  child: Row(
                    children: [
                      const SizedBox(width: SpottSpacing.sm),
                      const Icon(Icons.search_rounded, color: SpottColors.textSecondary),
                      const SizedBox(width: SpottSpacing.md),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search for articles, topics...',
                            border: InputBorder.none,
                            hintStyle: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary),
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
                const SizedBox(height: SpottSpacing.xl),
                
                // Recent Case Details Card
                GlassCard(
                  padding: const EdgeInsets.all(SpottSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: SpottColors.surface1,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Recent case',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: SpottColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _CaseInfoRow(
                        label: 'Ride reference',
                        value: supportCase.rideReference,
                      ),
                      const Divider(height: 20, color: SpottColors.border),
                      _CaseInfoRow(label: 'Role', value: supportCase.roleLabel),
                      const Divider(height: 20, color: SpottColors.border),
                      _CaseInfoRow(
                        label: 'Issue category',
                        value: supportCase.categoryLabel,
                      ),
                      const Divider(height: 20, color: SpottColors.border),
                      _CaseInfoRow(
                        label: 'Status',
                        value: supportCase.statusLabel,
                        valueColor: SpottColors.textPrimary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SpottSpacing.xxl),

                // Popular Topics
                Text('Popular Topics', style: SpottTextStyles.headline.copyWith(fontSize: 24)),
                const SizedBox(height: SpottSpacing.lg),
              ]),
            ),
          ),
          
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.lg),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: SpottSpacing.md,
              crossAxisSpacing: SpottSpacing.md,
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
            padding: const EdgeInsets.symmetric(horizontal: SpottSpacing.lg, vertical: SpottSpacing.md),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: SpottSpacing.xxl),

                // FAQ
                Text('Frequently Asked', style: SpottTextStyles.headline.copyWith(fontSize: 24)),
                const SizedBox(height: SpottSpacing.lg),
                GlassCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      const _FAQTile(
                        question: 'How do I book a trip in advance?',
                        answer: 'To schedule a trip for later, simply open the app, enter your destination, and tap the calendar icon next to the "Book Now" button.',
                      ),
                      const Divider(height: 1, color: SpottColors.borderSubtle),
                      const _FAQTile(
                        question: 'What is covered by Parcel Insurance?',
                        answer: 'Basic parcel insurance covers up to ₹5,000 in loss or damage during transit.',
                      ),
                      const Divider(height: 1, color: SpottColors.borderSubtle),
                      const _FAQTile(
                        question: 'How do I become a verified driver?',
                        answer: 'Navigate to Profile > Driver Dashboard and follow the onboarding steps.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SpottSpacing.xxl),

                // Need More Help
                Text('Need More Help?', style: SpottTextStyles.headline.copyWith(fontSize: 24)),
                const SizedBox(height: SpottSpacing.lg),

                // Recent Ticket
                GlassCard(
                  padding: const EdgeInsets.all(SpottSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('RECENT TICKET', style: SpottTextStyles.label.copyWith(color: SpottColors.textSecondary, letterSpacing: 1.2)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: SpottColors.surface1,
                              borderRadius: BorderRadius.circular(SpottRadius.pill),
                              border: Border.all(color: SpottColors.borderSubtle),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 6, height: 6,
                                  decoration: const BoxDecoration(color: SpottColors.primary, shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 6),
                                Text('In Progress', style: SpottTextStyles.label.copyWith(color: SpottColors.primary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: SpottSpacing.md),
                      Text('${supportCase.categoryLabel} #${supportCase.rideReference}', style: SpottTextStyles.titleSmall.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Updated 2 hours ago', style: SpottTextStyles.caption.copyWith(color: SpottColors.textSecondary)),
                      const SizedBox(height: SpottSpacing.md),
                      InkWell(
                        onTap: () {},
                        child: Text('View Updates →', style: SpottTextStyles.label.copyWith(color: SpottColors.primary, fontWeight: FontWeight.bold)),
                      ),
                      if (supportCase.isReviewable) ...[
                        const SizedBox(height: SpottSpacing.md),
                        const Divider(color: SpottColors.borderSubtle),
                        const SizedBox(height: SpottSpacing.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Ride reference', style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary)),
                            Text(supportCase.rideReference, style: SpottTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: SpottSpacing.xs),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Role', style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary)),
                            Text(supportCase.roleLabel, style: SpottTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: SpottSpacing.xs),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Status', style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary)),
                            Text(supportCase.statusLabel, style: SpottTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: SpottColors.success)),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: SpottSpacing.md),

                // Live Support
                GlassCard(
                  padding: const EdgeInsets.all(SpottSpacing.xl),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 80, height: 80,
                            decoration: BoxDecoration(
                              color: SpottColors.surface1,
                              shape: BoxShape.circle,
                              border: Border.all(color: SpottColors.borderSubtle),
                            ),
                            child: const Icon(Icons.support_agent_rounded, color: SpottColors.primary, size: 40),
                          ),
                          Container(
                            width: 20, height: 20,
                            decoration: BoxDecoration(
                              color: SpottColors.success,
                              shape: BoxShape.circle,
                              border: Border.all(color: SpottColors.surface1, width: 3),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: SpottSpacing.lg),
                      Text('Live Support', style: SpottTextStyles.headline.copyWith(fontSize: 20)),
                      const SizedBox(height: SpottSpacing.sm),
                      Text(
                        'Our team is online and ready to assist you instantly.',
                        textAlign: TextAlign.center,
                        style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary),
                      ),
                      const SizedBox(height: SpottSpacing.lg),
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
                const SizedBox(height: SpottSpacing.xxl),
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
      padding: const EdgeInsets.all(SpottSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: SpottColors.surface1,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: SpottColors.borderSubtle),
            ),
            child: Icon(icon, color: SpottColors.primary, size: 28),
          ),
          const Spacer(),
          Text(title, style: SpottTextStyles.titleSmall.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: SpottTextStyles.caption.copyWith(color: SpottColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
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
        title: Text(question, style: SpottTextStyles.titleSmall.copyWith(fontWeight: FontWeight.bold)),
        iconColor: SpottColors.primary,
        collapsedIconColor: SpottColors.primary,
        childrenPadding: const EdgeInsets.only(left: SpottSpacing.md, right: SpottSpacing.md, bottom: SpottSpacing.md),
        children: [
          Text(answer, style: SpottTextStyles.body.copyWith(color: SpottColors.textSecondary)),
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
            color: SpottColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? SpottColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
