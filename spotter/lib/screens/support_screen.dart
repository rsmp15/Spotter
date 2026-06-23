import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotter/design_system/design_system.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../models/production_readiness_models.dart';
import '../core/components/spott_buttons.dart';
import '../core/components/glass_scaffold.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;
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
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(
                  CupertinoIcons.arrow_left,
                  color: palette.textPrimary,
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: Text(
          'Help center',
          style: DSTypography.headline.copyWith(
            color: palette.textPrimary,
            letterSpacing: 1.2,
          ),
        ),
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
                  style: DSTypography.headline.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: DSSpacing.xl),
                Container(
                  padding: const EdgeInsets.all(DSSpacing.xs),
                  decoration: BoxDecoration(
                    color: palette.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: palette.border),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: DSSpacing.sm),
                      Icon(CupertinoIcons.search, color: palette.textSecondary),
                      const SizedBox(width: DSSpacing.md),
                      Expanded(
                        child: TextField(
                          style: TextStyle(color: palette.textPrimary, fontFamily: 'Inter'),
                          decoration: InputDecoration(
                            hintText: 'Search for articles, topics...',
                            border: InputBorder.none,
                            hintStyle: DSTypography.body.copyWith(
                              color: palette.textSecondary,
                            ),
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
                Container(
                  padding: const EdgeInsets.all(DSSpacing.md),
                  decoration: BoxDecoration(
                    color: palette.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: palette.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: palette.textPrimary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Recent case',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: palette.background,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _CaseInfoRow(
                        label: 'Ride reference',
                        value: supportCase.rideReference,
                      ),
                      Divider(height: 20, color: palette.border),
                      _CaseInfoRow(label: 'Role', value: supportCase.roleLabel),
                      Divider(height: 20, color: palette.border),
                      _CaseInfoRow(
                        label: 'Issue category',
                        value: supportCase.categoryLabel,
                      ),
                      Divider(height: 20, color: palette.border),
                      _CaseInfoRow(
                        label: 'Status',
                        value: supportCase.statusLabel,
                        valueColor: palette.textPrimary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DSSpacing.xxl),

                // Popular Topics
                Text(
                  'Popular Topics',
                  style: DSTypography.headline.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: palette.textPrimary,
                  ),
                ),
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
                  icon: CupertinoIcons.car_detailed,
                  title: 'Trips & Rides',
                  subtitle: 'Booking and tracking.',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.dispute),
                ),
                _TopicCard(
                  icon: CupertinoIcons.cube_box,
                  title: 'Parcels',
                  subtitle: 'Delivery status & insurance.',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.dispute),
                ),
                _TopicCard(
                  icon: CupertinoIcons.creditcard,
                  title: 'Payments',
                  subtitle: 'Billing and refunds.',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.dispute),
                ),
                _TopicCard(
                  icon: CupertinoIcons.shield,
                  title: 'Safety',
                  subtitle: 'Emergency contacts.',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.safetyToolkit),
                ),
                _TopicCard(
                  icon: CupertinoIcons.person,
                  title: 'Account',
                  subtitle: 'Profile settings.',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                ),
                _TopicCard(
                  icon: CupertinoIcons.doc_checkmark,
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
                Text(
                  'Frequently Asked',
                  style: DSTypography.headline.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: DSSpacing.lg),
                Container(
                  decoration: BoxDecoration(
                    color: palette.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: palette.border),
                  ),
                  child: Column(
                    children: [
                      const _FAQTile(
                        question: 'How do I book a trip in advance?',
                        answer: 'To schedule a trip for later, simply open the app, enter your destination, and tap the calendar icon next to the "Book Now" button.',
                      ),
                      Divider(height: 1, color: palette.border),
                      const _FAQTile(
                        question: 'What is covered by Parcel Insurance?',
                        answer: 'Basic parcel insurance covers up to ₹5,000 in loss or damage during transit.',
                      ),
                      Divider(height: 1, color: palette.border),
                      const _FAQTile(
                        question: 'How do I become a verified driver?',
                        answer: 'Navigate to Profile > Driver Dashboard and follow the onboarding steps.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DSSpacing.xxl),

                // Need More Help
                Text(
                  'Need More Help?',
                  style: DSTypography.headline.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: DSSpacing.lg),

                // Recent Ticket
                Container(
                  padding: const EdgeInsets.all(DSSpacing.lg),
                  decoration: BoxDecoration(
                    color: palette.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: palette.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'RECENT TICKET',
                            style: DSTypography.labelLarge.copyWith(
                              color: palette.textSecondary,
                              letterSpacing: 1.2,
                              fontFamily: 'Inter',
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: palette.textPrimary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 6, height: 6,
                                  decoration: BoxDecoration(
                                    color: palette.background,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'In Progress',
                                  style: DSTypography.labelLarge.copyWith(
                                    color: palette.background,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: DSSpacing.md),
                      Text(
                        '${supportCase.categoryLabel} #${supportCase.rideReference}',
                        style: DSTypography.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Updated 2 hours ago',
                        style: DSTypography.caption.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                      const SizedBox(height: DSSpacing.md),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'View Updates →',
                          style: DSTypography.labelLarge.copyWith(
                            color: palette.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      if (supportCase.isReviewable) ...[
                        const SizedBox(height: DSSpacing.md),
                        Divider(color: palette.border),
                        const SizedBox(height: DSSpacing.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ride reference',
                              style: DSTypography.body.copyWith(
                                color: palette.textSecondary,
                              ),
                            ),
                            Text(
                              supportCase.rideReference,
                              style: DSTypography.body.copyWith(
                                fontWeight: FontWeight.bold,
                                color: palette.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: DSSpacing.xs),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Role',
                              style: DSTypography.body.copyWith(
                                color: palette.textSecondary,
                              ),
                            ),
                            Text(
                              supportCase.roleLabel,
                              style: DSTypography.body.copyWith(
                                fontWeight: FontWeight.bold,
                                color: palette.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: DSSpacing.xs),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Status',
                              style: DSTypography.body.copyWith(
                                color: palette.textSecondary,
                              ),
                            ),
                            Text(
                              supportCase.statusLabel,
                              style: DSTypography.body.copyWith(
                                fontWeight: FontWeight.bold,
                                color: palette.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: DSSpacing.md),

                // Live Support
                Container(
                  padding: const EdgeInsets.all(DSSpacing.xl),
                  decoration: BoxDecoration(
                    color: palette.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: palette.border),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 80, height: 80,
                            decoration: BoxDecoration(
                              color: palette.border,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              CupertinoIcons.person_2_fill,
                              color: palette.textPrimary,
                              size: 40,
                            ),
                          ),
                          Container(
                            width: 20, height: 20,
                            decoration: BoxDecoration(
                              color: palette.textPrimary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: palette.surfaceVariant,
                                width: 3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: DSSpacing.lg),
                      Text(
                        'Live Support',
                        style: DSTypography.headline.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: DSSpacing.sm),
                      Text(
                        'Our team is online and ready to assist you instantly.',
                        textAlign: TextAlign.center,
                        style: DSTypography.body.copyWith(
                          color: palette.textSecondary,
                        ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(DSSpacing.md),
        decoration: BoxDecoration(
          color: palette.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: palette.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: palette.border,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: palette.textPrimary, size: 24),
            ),
            const Spacer(),
            Text(
              title,
              style: DSTypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: DSTypography.caption.copyWith(
                color: palette.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          question,
          style: DSTypography.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: palette.textPrimary,
          ),
        ),
        iconColor: palette.textPrimary,
        collapsedIconColor: palette.textPrimary,
        childrenPadding: const EdgeInsets.only(left: DSSpacing.md, right: DSSpacing.md, bottom: DSSpacing.md),
        children: [
          Text(
            answer,
            style: DSTypography.body.copyWith(
              color: palette.textSecondary,
              height: 1.4,
            ),
          ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: palette.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? palette.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}


