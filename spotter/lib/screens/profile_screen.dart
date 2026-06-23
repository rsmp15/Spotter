import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:spotter/design_system/design_system.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;

    return Scaffold(
      backgroundColor: palette.background,
      body: Stack(
        children: [
          if (!isDark) ...[
            // Top-left soft cyan gradient (A3EEFF)
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topLeft,
                    radius: 1.1,
                    colors: [
                      Color(0xFFA3EEFF),
                      Color(0x00A3EEFF),
                    ],
                  ),
                ),
              ),
            ),
            // Top-right soft blue gradient (79C3FE)
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 0.8,
                    colors: [
                      Color(0xFF79C3FE),
                      Color(0x0079C3FE),
                    ],
                  ),
                ),
              ),
            ),
          ],
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Sleek Profile Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ride.userName,
                              style: DSTypography.displayLarge.copyWith(
                                color: palette.textPrimary,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.8,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Rating Pill
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: palette.surfaceVariant,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    CupertinoIcons.star_fill,
                                    size: 12,
                                    color: Color(0xFFFFCA28), // Golden star accent
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '4.92',
                                    style: DSTypography.caption.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: palette.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: 36,
                        backgroundImage: const NetworkImage(
                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
                        ),
                        onBackgroundImageError: (exception, stackTrace) {},
                        backgroundColor: palette.surfaceVariant,
                        child: Icon(CupertinoIcons.person, size: 36, color: palette.iconPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // 2. Horizontal Options Grid (Help, Payment, Trips)
                  Row(
                    children: [
                      Expanded(
                        child: _buildUberGridCard(
                          context: context,
                          label: 'Help',
                          icon: CupertinoIcons.question_circle_fill,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.support),
                          palette: palette,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildUberGridCard(
                          context: context,
                          label: 'Payment',
                          icon: CupertinoIcons.creditcard_fill,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                          palette: palette,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildUberGridCard(
                          context: context,
                          label: 'Trips',
                          icon: CupertinoIcons.clock_fill,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.activity),
                          palette: palette,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 3. Spott Premium Banner (Uber One equivalent)
                  _buildPremiumBanner(palette),
                  const SizedBox(height: 32),

                  // 4. Menu Options List (Sleek layout: Only Icon space Name, no dividers)
                  _buildUberListTile(
                    icon: CupertinoIcons.person_fill,
                    title: 'Personal Info',
                    onTap: () => showProfileEditSheet(context, ride, isDark),
                    palette: palette,
                  ),
                  _buildUberListTile(
                    icon: CupertinoIcons.car_detailed,
                    title: 'Vehicles',
                    subtitle: 'Manage registered vehicles',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.vehicleManagement),
                    palette: palette,
                  ),
                  _buildUberListTile(
                    icon: CupertinoIcons.doc_plaintext,
                    title: 'Verify Documents',
                    subtitle: 'KYC & Background verification',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.kyc),
                    palette: palette,
                  ),
                  _buildUberListTile(
                    icon: CupertinoIcons.bell_fill,
                    title: 'Notifications',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
                    palette: palette,
                  ),
                  _buildUberListTile(
                    icon: CupertinoIcons.gear_solid,
                    title: 'Settings',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                    palette: palette,
                  ),
                  _buildUberListTile(
                    icon: CupertinoIcons.info_circle_fill,
                    title: 'Legal',
                    onTap: () {},
                    palette: palette,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUberGridCard({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required DSColorPalette palette,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: palette.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: palette.iconPrimary,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: DSTypography.labelLarge.copyWith(
                fontSize: 13,
                color: palette.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumBanner(DSColorPalette palette) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Spott Premium',
                  style: DSTypography.titleLarge.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Get 0 matching fees and priority matching on all shared trips.',
                  style: DSTypography.body.copyWith(
                    fontSize: 12,
                    color: palette.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Icon(
            CupertinoIcons.chevron_right,
            color: palette.iconPrimary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildUberListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    required DSColorPalette palette,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              color: palette.iconPrimary,
              size: 20,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: DSTypography.labelLarge.copyWith(
                      fontSize: 15,
                      color: palette.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: DSTypography.caption.copyWith(
                        fontSize: 12,
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              color: palette.textMuted,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

void showProfileEditSheet(BuildContext context, RideController ride, bool isDark) {
  final nameController = TextEditingController(text: ride.userName);
  final phoneController = TextEditingController(text: ride.userPhone);
  final emailController = TextEditingController(text: ride.userEmail);

  final palette = isDark ? DSPalettes.dark : DSPalettes.light;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: palette.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Text(
                'Edit Profile',
                style: DSTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              
              // Name Field
              Text(
                'Name',
                style: DSTypography.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: palette.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: palette.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: nameController,
                  cursorColor: palette.textPrimary,
                  style: DSTypography.body.copyWith(color: palette.textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                    hintText: 'Enter name',
                    hintStyle: DSTypography.body.copyWith(color: palette.textMuted),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Phone Field
              Text(
                'Phone',
                style: DSTypography.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: palette.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: palette.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  cursorColor: palette.textPrimary,
                  style: DSTypography.body.copyWith(color: palette.textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                    hintText: 'Enter phone number',
                    hintStyle: DSTypography.body.copyWith(color: palette.textMuted),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Email Field
              Text(
                'Email',
                style: DSTypography.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: palette.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: palette.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: palette.textPrimary,
                  style: DSTypography.body.copyWith(color: palette.textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                    hintText: 'Enter email address',
                    hintStyle: DSTypography.body.copyWith(color: palette.textMuted),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: CupertinoButton(
                  color: palette.primary,
                  borderRadius: BorderRadius.circular(26),
                  onPressed: () {
                    final name = nameController.text.trim();
                    final phone = phoneController.text.trim();
                    final email = emailController.text.trim();
                    if (name.isNotEmpty && phone.isNotEmpty && email.isNotEmpty) {
                      ride.updateProfile(name: name, phone: phone, email: email);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Profile updated successfully',
                            style: DSTypography.body.copyWith(color: palette.onPrimary, fontWeight: FontWeight.w600),
                          ),
                          backgroundColor: palette.primary,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Save Changes',
                    style: DSTypography.labelLarge.copyWith(
                      fontWeight: FontWeight.w800,
                      color: palette.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
