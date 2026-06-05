import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app/app_routes.dart';
import '../core/components/spott_avatar.dart';
import '../core/theme/colors.dart';
import '../core/theme/radius.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';
import '../core/theme/shadows.dart';

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
                SpottSpacing.pageHorizontal,
                SpottSpacing.lg,
                SpottSpacing.pageHorizontal,
                SpottSpacing.pageBottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── 2. Trust Score Panel ───────────────────────────
                  _buildTrustScorePanel(),
                  const SizedBox(height: SpottSpacing.lg),

                  // ── 3. Verification Center ─────────────────────────
                  _buildVerificationCenter(context),
                  const SizedBox(height: SpottSpacing.lg),

                  // ── 4. Reputation Metrics ──────────────────────────
                  _buildReputationMetrics(),
                  const SizedBox(height: SpottSpacing.lg),

                  // ── 5. Vehicles Section ────────────────────────────
                  _buildVehiclesSection(),
                  const SizedBox(height: SpottSpacing.lg),

                  // ── 6. Achievements ────────────────────────────────
                  _buildAchievementsSection(),
                  const SizedBox(height: SpottSpacing.lg),

                  // ── 7. Monthly Earnings ────────────────────────────
                  _buildEarningsBanner(),
                  const SizedBox(height: SpottSpacing.lg),

                  // ── 8. Reviews & Feedback ──────────────────────────
                  _buildReviewsSection(),
                  const SizedBox(height: SpottSpacing.lg),

                  // ── 9. Spott Premium ───────────────────────────────
                  _buildPremiumSection(),
                  const SizedBox(height: SpottSpacing.lg),

                  // ── 10. Settings & Actions ─────────────────────────
                  _buildSettingsSection(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Profile Hero (Airbnb style) ────────────────────────────────────
  Widget _buildProfileHero(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 48, bottom: 24),
      decoration: const BoxDecoration(
        color: SpottColors.surface1,
        border: Border(bottom: BorderSide(color: SpottColors.border)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 104,
                height: 104,
                child: CircularProgressIndicator(
                  value: 0.92, // represents trust completeness
                  strokeWidth: 4.5,
                  color: SpottColors.success,
                  backgroundColor: SpottColors.border,
                ),
              ),
              const SpottAvatar(
                imageUrl:
                    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
                radius: 44,
                isVerified: true,
              ),
            ],
          ),
          const SizedBox(height: SpottSpacing.md),
          const Text('Arjun Sharma', style: SpottTextStyles.displayLarge),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Verified Traveler',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: SpottColors.success,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: SpottColors.textSecondary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Top 10% Community Host',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: SpottColors.accentPurple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Trust Score Panel (moat) ──────────────────────────────────────
  Widget _buildTrustScorePanel() {
    return Container(
      padding: const EdgeInsets.all(SpottSpacing.lg),
      decoration: BoxDecoration(
        color: SpottColors.surface1,
        borderRadius: BorderRadius.circular(SpottRadius.primaryCard), // 24px
        border: Border.all(color: SpottColors.border),
        boxShadow: SpottShadows.elevation1,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TRUST SCORE',
                  style: SpottTextStyles.overline.copyWith(
                    color: SpottColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '92 / 100',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: SpottColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Built from verified ID, clean trip history, and response rate.',
                  style: SpottTextStyles.caption.copyWith(
                    color: SpottColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: SpottColors.successSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: SpottColors.success,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  // ── Verification Center Checklist ─────────────────────────────────
  Widget _buildVerificationCenter(BuildContext context) {
    final verifications = [
      _VerificationItem('Government ID Verified', true),
      _VerificationItem('Mobile Number Verified', true),
      _VerificationItem('Email Address Verified', true),
      _VerificationItem('Background Check Passed', true),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Verification Center', style: SpottTextStyles.headline),
        const SizedBox(height: SpottSpacing.md),
        Container(
          padding: const EdgeInsets.all(SpottSpacing.md),
          decoration: BoxDecoration(
            color: SpottColors.surface1,
            borderRadius: BorderRadius.circular(
              SpottRadius.primaryCard,
            ), // 24px
            border: Border.all(color: SpottColors.border),
          ),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: verifications.length,
                itemBuilder: (context, index) {
                  final item = verifications[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: SpottColors.success,
                          size: 18,
                        ),
                        const SizedBox(width: SpottSpacing.md),
                        Text(
                          item.label,
                          style: SpottTextStyles.body.copyWith(
                            color: SpottColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Divider(height: 24, color: SpottColors.border),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.kyc),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: SpottColors.primary,
                    side: const BorderSide(color: SpottColors.primary),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        SpottRadius.button,
                      ), // 16px
                    ),
                  ),
                  child: const Text('Manage Verifications'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Reputation Metrics Grid ────────────────────────────────────────
  Widget _buildReputationMetrics() {
    final metrics = [
      _MetricData('92 Score', 'Trust Rating', SpottColors.success),
      _MetricData('143', 'Trips Done', SpottColors.accentPurple),
      _MetricData('98%', 'Response Rate', SpottColors.warning),
      _MetricData('0.8%', 'Cancel Rate', SpottColors.danger),
      _MetricData('96%', 'Punctuality', SpottColors.success),
      _MetricData('₹48K', 'Total Saved', SpottColors.accentPurple),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Reputation Metrics', style: SpottTextStyles.headline),
        const SizedBox(height: SpottSpacing.md),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.1,
          ),
          itemCount: metrics.length,
          itemBuilder: (context, index) {
            final metric = metrics[index];
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                color: SpottColors.surface1,
                borderRadius: BorderRadius.circular(
                  SpottRadius.secondaryCard,
                ), // 20px
                border: Border.all(color: SpottColors.border),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    metric.value,
                    style: SpottTextStyles.titleSmall.copyWith(
                      color: metric.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    metric.label,
                    textAlign: TextAlign.center,
                    style: SpottTextStyles.caption.copyWith(
                      fontSize: 10,
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

  // ── Registered Vehicles Section ────────────────────────────────────
  Widget _buildVehiclesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Registered Vehicles', style: SpottTextStyles.headline),
        const SizedBox(height: SpottSpacing.md),
        Container(
          padding: const EdgeInsets.all(SpottSpacing.md),
          decoration: BoxDecoration(
            color: SpottColors.surface1,
            borderRadius: BorderRadius.circular(
              SpottRadius.primaryCard,
            ), // 24px
            border: Border.all(color: SpottColors.border),
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.directions_car_rounded,
                      color: SpottColors.accentPurple,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: SpottSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hyundai i20 (AC)',
                          style: SpottTextStyles.titleSmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'MH-12-PQ-9876 • MH Registered',
                          style: SpottTextStyles.caption.copyWith(
                            color: SpottColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: SpottColors.successSoft,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'VERIFIED',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: SpottColors.success,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: SpottColors.border),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildVehicleFeatureChip('AC Fitted'),
                  _buildVehicleFeatureChip('Pet Friendly'),
                  _buildVehicleFeatureChip('Music Allowed'),
                  _buildVehicleFeatureChip('4 Seats Max'),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: SpottColors.surface2,
        borderRadius: BorderRadius.circular(SpottRadius.pill),
        border: Border.all(color: SpottColors.border),
      ),
      child: Text(
        label,
        style: SpottTextStyles.caption.copyWith(
          color: SpottColors.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ── Achievements Scroller ──────────────────────────────────────────
  Widget _buildAchievementsSection() {
    final achievements = [
      _Achievement(
        '🏆',
        'Top 10% Traveler',
        'Highly active on primary highway routes.',
        SpottColors.primary,
      ),
      _Achievement(
        '🛡️',
        'Safety Defender',
        'Maintained 95%+ trust score.',
        SpottColors.success,
      ),
      _Achievement(
        '⏰',
        'Punctual Rider',
        '98% departure times matching.',
        SpottColors.accentPurple,
      ),
      _Achievement(
        '📦',
        'Parcel Master',
        'Delivered 50+ packages.',
        SpottColors.warning,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Achievements & Badges', style: SpottTextStyles.headline),
        const SizedBox(height: SpottSpacing.md),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final ach = achievements[index];
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: SpottSpacing.md),
                padding: const EdgeInsets.all(SpottSpacing.md),
                decoration: BoxDecoration(
                  color: SpottColors.surface1,
                  borderRadius: BorderRadius.circular(
                    SpottRadius.primaryCard,
                  ), // 24px
                  border: Border.all(color: SpottColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ach.emoji, style: const TextStyle(fontSize: 24)),
                    const Spacer(),
                    Text(
                      ach.title,
                      style: SpottTextStyles.titleSmall.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ach.description,
                      style: SpottTextStyles.caption.copyWith(
                        color: SpottColors.textSecondary,
                        fontSize: 10,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Monthly Earnings ────────────────────────────────────────────────
  Widget _buildEarningsBanner() {
    return Container(
      padding: const EdgeInsets.all(SpottSpacing.lg),
      decoration: BoxDecoration(
        color: SpottColors.successSoft,
        borderRadius: BorderRadius.circular(SpottRadius.primaryCard), // 24px
        border: Border.all(color: SpottColors.success.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'THIS MONTH',
                  style: SpottTextStyles.overline.copyWith(
                    color: SpottColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '₹6,850 Saved',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: SpottColors.success,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Recovering fuel costs via co-travelers.',
                  style: SpottTextStyles.caption.copyWith(
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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            child: const Row(
              children: [
                Text(
                  'Details',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, size: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Reviews List ───────────────────────────────────────────────────
  Widget _buildReviewsSection() {
    final reviews = [
      _ReviewItem(
        'Rohan K.',
        'Very punctual, Hyundai vehicle was clean and air-conditioned. Highly recommended.',
        5,
      ),
      _ReviewItem(
        'Priya S.',
        'Smooth package delivery, kept update coordinates via SOS toolkit. Friendly traveler.',
        5,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Community Reviews', style: SpottTextStyles.headline),
        const SizedBox(height: SpottSpacing.md),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final rev = reviews[index];
            return Container(
              margin: const EdgeInsets.only(bottom: SpottSpacing.md),
              padding: const EdgeInsets.all(SpottSpacing.md),
              decoration: BoxDecoration(
                color: SpottColors.surface1,
                borderRadius: BorderRadius.circular(
                  SpottRadius.primaryCard,
                ), // 24px
                border: Border.all(color: SpottColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        rev.author,
                        style: SpottTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          rev.stars,
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
                    rev.comment,
                    style: SpottTextStyles.body.copyWith(fontSize: 13),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ── Spott Premium Promotion ────────────────────────────────────────
  Widget _buildPremiumSection() {
    return Container(
      padding: const EdgeInsets.all(SpottSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(SpottRadius.primaryCard), // 24px
        boxShadow: SpottShadows.elevation3,
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
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                  letterSpacing: 1.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(SpottRadius.pill),
                ),
                child: const Text(
                  'UPGRADE',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Maximize Your Share Economy',
            style: SpottTextStyles.titleSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Premium Trust Badge • High route visibility • Lower matching fees.',
            style: SpottTextStyles.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF4F46E5),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    SpottRadius.button,
                  ), // 18px
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Get Spott Premium',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Settings List ──────────────────────────────────────────────────
  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Settings & Actions', style: SpottTextStyles.headline),
        const SizedBox(height: SpottSpacing.md),
        _buildSettingsGroup(context, 'Account Settings', [
          _SettingItem(Icons.person_outline_rounded, 'Personal Info', () {}),
          _SettingItem(
            Icons.directions_car_filled_outlined,
            'Vehicle Setup',
            () => Navigator.pushNamed(context, AppRoutes.vehicleManagement),
          ),
          _SettingItem(
            Icons.description_outlined,
            'Verify Documents',
            () => Navigator.pushNamed(context, AppRoutes.kyc),
          ),
        ]),
        const SizedBox(height: SpottSpacing.md),
        _buildSettingsGroup(context, 'Preferences', [
          _SettingItem(
            Icons.notifications_none_rounded,
            'Notification Prefs',
            () {},
          ),
          _SettingItem(
            Icons.palette_outlined,
            'Display Theme',
            () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
          _SettingItem(
            Icons.help_outline_rounded,
            'Help & Resolutions Center',
            () => Navigator.pushNamed(context, AppRoutes.support),
          ),
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
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: SpottColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: SpottColors.surface1,
            borderRadius: BorderRadius.circular(
              SpottRadius.primaryCard,
            ), // 24px
            border: Border.all(color: SpottColors.border),
          ),
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                _buildMenuRow(
                  icon: items[i].icon,
                  title: items[i].title,
                  onTap: items[i].onTap,
                ),
                if (i < items.length - 1)
                  const Divider(height: 1, color: SpottColors.border),
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
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: SpottColors.textPrimary,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: SpottColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Models helpers ──────────────────────────────────────────────────
class _VerificationItem {
  final String label;
  final bool isVerified;

  const _VerificationItem(this.label, this.isVerified);
}

class _MetricData {
  final String value;
  final String label;
  final Color color;

  const _MetricData(this.value, this.label, this.color);
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
