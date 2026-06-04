import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/app_routes.dart';
import '../core/components/spott_avatar.dart';
import '../core/theme/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SpottColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── 1. Profile Hero Section ─────────────────────────────
            _buildProfileHero(context),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                24,
                16,
                112,
              ), // bottom padding to clear nav bar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── 2. Reputation Grid ─────────────────────────────
                  _buildReputationGrid(),
                  const SizedBox(height: 24),

                  // ── 3. Trust & Verifications ───────────────────────
                  _buildTrustCenter(context),
                  const SizedBox(height: 24),

                  // ── 4. Vehicles ────────────────────────────────────
                  _buildVehiclesSection(),
                  const SizedBox(height: 24),

                  // ── 5. Achievements ────────────────────────────────
                  _buildAchievementsSection(),
                  const SizedBox(height: 24),

                  // ── 6. Marketplace Stats ───────────────────────────
                  _buildMarketplacePerformance(),
                  const SizedBox(height: 24),

                  // ── 7. Earnings Banner ─────────────────────────────
                  _buildEarningsBanner(),
                  const SizedBox(height: 24),

                  // ── 8. Reviews & Feedback ──────────────────────────
                  _buildReviewsSection(),
                  const SizedBox(height: 24),

                  // ── 9. Spott Premium ───────────────────────────────
                  _buildPremiumSection(),
                  const SizedBox(height: 24),

                  // ── 10. Account Settings ───────────────────────────
                  _buildSettingsSection(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHero(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 270,
      decoration: const BoxDecoration(
        color: SpottColors.surface2,
        border: Border(bottom: BorderSide(color: SpottColors.border)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 104,
                height: 104,
                child: CircularProgressIndicator(
                  value: 0.98,
                  strokeWidth: 4.5,
                  color: SpottColors.success,
                  backgroundColor: SpottColors.border,
                ),
              ),
              const SpottAvatar(
                imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704d',
                radius: 44,
                isVerified: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Arjun Sharma',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: SpottColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Verified Traveler',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: SpottColors.success,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: SpottColors.textMuted,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Top 10% Traveler',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: SpottColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star_rounded,
                color: SpottColors.warning,
                size: 18,
              ),
              const SizedBox(width: 4),
              const Text(
                '4.9',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: SpottColors.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: SpottColors.textMuted,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Trust Level 4',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: SpottColors.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: SpottColors.textMuted,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '542 Trips Completed',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: SpottColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReputationGrid() {
    final metrics = [
      _MetricData('4.9 ★', 'Rating', SpottColors.warning),
      _MetricData('542', 'Trips', SpottColors.accentPurple),
      _MetricData('98%', 'Response', SpottColors.success),
      _MetricData('0.4%', 'Cancel Rate', SpottColors.danger),
      _MetricData('98', 'Safety Score', SpottColors.info),
      _MetricData('₹48K', 'Lifetime Earnings', SpottColors.success),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reputation Dashboard',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: SpottColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: metrics.length,
          itemBuilder: (context, index) {
            final metric = metrics[index];
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: SpottColors.surface1,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: SpottColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    metric.value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: metric.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    metric.label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: SpottColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTrustCenter(BuildContext context) {
    final verifications = [
      _VerificationItem('Mobile Verified', true),
      _VerificationItem('Email Verified', true),
      _VerificationItem('Govt ID Verified', true),
      _VerificationItem('Vehicle Verified', true),
      _VerificationItem('Background Checked', true),
      _VerificationItem('Emergency Contact Added', true),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Trust & Verifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: SpottColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: SpottColors.surface1,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: SpottColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3.5,
                ),
                itemCount: verifications.length,
                itemBuilder: (context, index) {
                  final item = verifications[index];
                  return Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: SpottColors.success,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.label,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: SpottColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVehiclesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Registered Vehicles',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: SpottColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: SpottColors.surface1,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: SpottColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: SpottColors.surface2,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: SpottColors.border),
                    ),
                    child: const Icon(
                      Icons.directions_car_rounded,
                      color: SpottColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hyundai i20',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: SpottColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'MH12AB1234 • 324 Trips Completed',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: SpottColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: SpottColors.successSoft,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'VERIFIED',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: SpottColors.success,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: SpottColors.divider),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildVehicleFeatureChip('AC'),
                  _buildVehicleFeatureChip('Pet Friendly'),
                  _buildVehicleFeatureChip('Music'),
                  _buildVehicleFeatureChip('4 Seats Available'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleFeatureChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: SpottColors.surface2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: SpottColors.border),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: SpottColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildAchievementsSection() {
    final achievements = [
      _Achievement(
        '🏆',
        'Top 10% Traveler',
        'Top tier host on active routes',
        SpottColors.primary,
      ),
      _Achievement(
        '🛡️',
        'Safety Defender',
        'Maintained 95%+ Safety Score',
        SpottColors.success,
      ),
      _Achievement(
        '⏰',
        'Always On Time',
        '98%+ punctuality rate',
        SpottColors.accentPurple,
      ),
      _Achievement(
        '🚗',
        '500+ Trips',
        'Completed over 500 shared journeys',
        SpottColors.warning,
      ),
      _Achievement(
        '⭐',
        '4.9+ Rating',
        'Consistent positive feedback',
        SpottColors.info,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Achievements & Badges',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: SpottColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (final achievement in achievements) ...[
                Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: SpottColors.surface1,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: SpottColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        achievement.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        achievement.title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: SpottColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        achievement.description,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: SpottColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMarketplacePerformance() {
    final performanceMetrics = [
      _PerformanceMetric(
        '₹48,200',
        'Earned Sharing Trips',
        Icons.monetization_on_rounded,
        SpottColors.success,
      ),
      _PerformanceMetric(
        '₹12,800',
        'Saved On Travel',
        Icons.savings_rounded,
        SpottColors.primary,
      ),
      _PerformanceMetric(
        '1,124',
        'Passengers Hosted',
        Icons.people_rounded,
        SpottColors.accentPurple,
      ),
      _PerformanceMetric(
        '98%',
        'Positive Reviews',
        Icons.thumb_up_rounded,
        SpottColors.info,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Marketplace Performance',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: SpottColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
          ),
          itemCount: performanceMetrics.length,
          itemBuilder: (context, index) {
            final metric = performanceMetrics[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: SpottColors.surface1,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: SpottColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(metric.icon, color: metric.color, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        metric.value,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: SpottColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    metric.label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: SpottColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEarningsBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SpottColors.successSoft,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: SpottColors.success.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'THIS MONTH',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: SpottColors.success,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '₹6,850 Earned',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: SpottColors.success,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Recovering Fuel Costs',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: SpottColors.success.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: SpottColors.success,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: const Row(
              children: [
                Text(
                  'View Earnings',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    final reviews = [
      _ReviewItem('Rohan', 'Very punctual and friendly.', 5),
      _ReviewItem('Priya', 'Smooth journey.', 5),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Reviews',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: SpottColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: SpottColors.surface1,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: SpottColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        review.author,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: SpottColors.textPrimary,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          review.stars,
                          (i) => const Icon(
                            Icons.star_rounded,
                            color: SpottColors.warning,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    review.comment,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: SpottColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPremiumSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SPOTT PREMIUM',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Colors.white70,
                  letterSpacing: 1.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text(
                  'UPGRADE',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Maximize Your Share Economy',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          _buildPremiumFeature('Priority Visibility'),
          _buildPremiumFeature('Premium Badge'),
          _buildPremiumFeature('Advanced Analytics'),
          _buildPremiumFeature('Lower Service Fees'),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF4F46E5),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Get Spott Premium',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumFeature(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Colors.white70,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings & Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: SpottColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingsGroup(context, 'Account', [
          _SettingItem(Icons.person_outline_rounded, 'Personal Info', () {}),
          _SettingItem(Icons.directions_car_filled_outlined, 'Vehicles', () {}),
          _SettingItem(Icons.description_outlined, 'Documents', () {}),
        ]),
        const SizedBox(height: 16),
        _buildSettingsGroup(context, 'Safety', [
          _SettingItem(
            Icons.shield_outlined,
            'Verification',
            () => Navigator.pushNamed(context, AppRoutes.kyc),
          ),
          _SettingItem(
            Icons.contact_phone_outlined,
            'Emergency Contacts',
            () {},
          ),
        ]),
        const SizedBox(height: 16),
        _buildSettingsGroup(context, 'Preferences', [
          _SettingItem(
            Icons.notifications_none_rounded,
            'Notifications',
            () {},
          ),
          _SettingItem(
            Icons.palette_outlined,
            'Theme',
            () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ]),
        const SizedBox(height: 16),
        _buildSettingsGroup(context, 'Support', [
          _SettingItem(Icons.help_outline_rounded, 'Help Center', () {}),
          _SettingItem(Icons.bug_report_outlined, 'Report Issue', () {}),
        ]),
      ],
    );
  }

  Widget _buildSettingsGroup(
    BuildContext context,
    String title,
    List<_SettingItem> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: SpottColors.textSecondary,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: SpottColors.surface1,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: SpottColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                _buildMenuRow(
                  icon: items[i].icon,
                  title: items[i].title,
                  onTap: items[i].onTap,
                ),
                if (i < items.length - 1) _buildDivider(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuRow({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: SpottColors.textSecondary, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: SpottColors.textPrimary,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: SpottColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 1, color: SpottColors.border);
  }
}

class _MetricData {
  final String value;
  final String label;
  final Color color;

  const _MetricData(this.value, this.label, this.color);
}

class _VerificationItem {
  final String label;
  final bool isVerified;

  const _VerificationItem(this.label, this.isVerified);
}

class _PerformanceMetric {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _PerformanceMetric(this.value, this.label, this.icon, this.color);
}

class _ReviewItem {
  final String author;
  final String comment;
  final int stars;

  const _ReviewItem(this.author, this.comment, this.stars);
}

class _Achievement {
  final String emoji;
  final String title;
  final String description;
  final Color color;

  const _Achievement(this.emoji, this.title, this.description, this.color);
}

class _SettingItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingItem(this.icon, this.title, this.onTap);
}
