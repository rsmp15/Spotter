import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../controllers/ride_controller.dart';
import '../app/app_routes.dart';
import '../models/ride_models.dart';
import 'profile_screen.dart';







class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        backgroundColor: palette.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: BackButton(color: palette.textPrimary),
        title: Text(
          'Settings',
          style: DSTypography.titleLarge.copyWith(color: palette.textPrimary),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 28),

            // ── GENERAL ──
            _sectionLabel('GENERAL', palette),
            const SizedBox(height: 10),
            _SettingsRow(
              icon: Icons.person_rounded,
              title: 'Personal information',
              palette: palette,
              onTap: () => showProfileEditSheet(context, ride, isDark),
            ),
            _SettingsRow(
              icon: Icons.directions_car_rounded,
              title: 'Vehicles',
              palette: palette,
              onTap: () => Navigator.pushNamed(context, AppRoutes.vehicleManagement),
            ),
            _SettingsRow(
              icon: Icons.verified_user_rounded,
              title: 'Verification status',
              palette: palette,
              onTap: () => Navigator.pushNamed(context, AppRoutes.kyc),
            ),

            const SizedBox(height: 28),

            // ── APP SETTINGS ──
            _sectionLabel('APP SETTINGS', palette),
            const SizedBox(height: 10),
            _SettingsRow(
              icon: Icons.bookmark_rounded,
              title: 'Saved places',
              palette: palette,
              onTap: () => _showSavedPlacesSheet(context, ride, isDark),
            ),
            _SettingsRow(
              icon: Icons.notifications_rounded,
              title: 'Notifications',
              palette: palette,
              onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
            ),
            _SettingsRow(
              icon: Icons.privacy_tip_rounded,
              title: 'Privacy',
              palette: palette,
              onTap: () => _showPrivacySheet(context, ride, isDark),
            ),

            const SizedBox(height: 28),

            // ── PREFERENCES ──
            _sectionLabel('PREFERENCES', palette),
            const SizedBox(height: 10),
            _SettingsRow(
              icon: Icons.palette_rounded,
              title: 'Theme',
              subtitle: 'Appearance',
              palette: palette,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) {
                    return _ThemeSelectionSheet(
                      ride: ride,
                      palette: palette,
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 48),

            // ── LOG OUT ──
            Center(
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: const Text('Log Out'),
                        content: const Text('Are you sure you want to log out of Spott?'),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            child: const Text('Log Out'),
                            onPressed: () {
                              Navigator.pop(context);
                              ride.switchTab(0);
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.login,
                                (route) => false,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  'Log out',
                  style: DSTypography.labelLarge.copyWith(color: palette.danger),
                ),
              ),
            ),
            const SizedBox(height: 120.0),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String label, DSColorPalette palette) {
    return Text(
      label,
      style: DSTypography.caption.copyWith(
        color: palette.textMuted,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final DSColorPalette palette;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.palette,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        if (onTap != null) onTap!();
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: palette.iconPrimary, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: DSTypography.labelLarge.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: DSTypography.caption.copyWith(
                        color: palette.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: palette.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}


void _showSavedPlacesSheet(BuildContext context, RideController ride, bool isDark) {
  final homeTitleController = TextEditingController(text: ride.homeLocation.title);
  final homeDetailController = TextEditingController(text: ride.homeLocation.detail);
  final workTitleController = TextEditingController(text: ride.workLocation.title);
  final workDetailController = TextEditingController(text: ride.workLocation.detail);

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
                'Saved Places',
                style: DSTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              
              // Home Label & Address
              Text(
                'Home Label',
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
                  controller: homeTitleController,
                  cursorColor: palette.textPrimary,
                  style: DSTypography.body.copyWith(color: palette.textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                    hintText: 'e.g. Home',
                    hintStyle: DSTypography.body.copyWith(color: palette.textMuted),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Home Address',
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
                  controller: homeDetailController,
                  cursorColor: palette.textPrimary,
                  style: DSTypography.body.copyWith(color: palette.textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                    hintText: 'Enter address',
                    hintStyle: DSTypography.body.copyWith(color: palette.textMuted),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Work Label & Address
              Text(
                'Work Label',
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
                  controller: workTitleController,
                  cursorColor: palette.textPrimary,
                  style: DSTypography.body.copyWith(color: palette.textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                    hintText: 'e.g. Work',
                    hintStyle: DSTypography.body.copyWith(color: palette.textMuted),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Work Address',
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
                  controller: workDetailController,
                  cursorColor: palette.textPrimary,
                  style: DSTypography.body.copyWith(color: palette.textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                    hintText: 'Enter address',
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
                    final hTitle = homeTitleController.text.trim();
                    final hDetail = homeDetailController.text.trim();
                    final wTitle = workTitleController.text.trim();
                    final wDetail = workDetailController.text.trim();
                    if (hTitle.isNotEmpty && hDetail.isNotEmpty && wTitle.isNotEmpty && wDetail.isNotEmpty) {
                      ride.updateHomeLocation(LocationPoint(title: hTitle, detail: hDetail));
                      ride.updateWorkLocation(LocationPoint(title: wTitle, detail: wDetail));
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Saved places updated',
                            style: DSTypography.body.copyWith(color: palette.onPrimary, fontWeight: FontWeight.w600),
                          ),
                          backgroundColor: palette.primary,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Save Places',
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

void _showPrivacySheet(BuildContext context, RideController ride, bool isDark) {
  final palette = isDark ? DSPalettes.dark : DSPalettes.light;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
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
                  'Privacy Center',
                  style: DSTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.w800,
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),

                // Location toggle
                Container(
                  padding: const EdgeInsets.all(12),
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
                              'Share Live Location',
                              style: DSTypography.labelLarge.copyWith(
                                fontWeight: FontWeight.w700,
                                color: palette.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Share your location with drivers to ensure accurate pickups.',
                              style: DSTypography.caption.copyWith(
                                fontSize: 11,
                                color: palette.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: ride.shareLocation,
                        activeThumbColor: palette.onPrimary,
                        activeTrackColor: palette.primary,
                        inactiveThumbColor: palette.textMuted,
                        inactiveTrackColor: palette.border,
                        onChanged: (val) {
                          setModalState(() {
                            ride.toggleShareLocation(val);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Personalized ads toggle
                Container(
                  padding: const EdgeInsets.all(12),
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
                              'Personalized Ads',
                              style: DSTypography.labelLarge.copyWith(
                                fontWeight: FontWeight.w700,
                                color: palette.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Receive targeted ads based on your trip destinations.',
                              style: DSTypography.caption.copyWith(
                                fontSize: 11,
                                color: palette.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: ride.personalizedAds,
                        activeThumbColor: palette.onPrimary,
                        activeTrackColor: palette.primary,
                        inactiveThumbColor: palette.textMuted,
                        inactiveTrackColor: palette.border,
                        onChanged: (val) {
                          setModalState(() {
                            ride.togglePersonalizedAds(val);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'Account Controls',
                  style: DSTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.w800,
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),

                // Download archive
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Download personal data',
                    style: DSTypography.body.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: palette.textPrimary,
                    ),
                  ),
                  trailing: Icon(CupertinoIcons.chevron_right, size: 14, color: palette.textMuted),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Data download requested. We will email you your archive shortly.',
                          style: DSTypography.body.copyWith(color: palette.onPrimary, fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: palette.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Delete account
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Delete Account',
                    style: DSTypography.body.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: palette.danger,
                    ),
                  ),
                  trailing: Icon(CupertinoIcons.chevron_right, size: 14, color: palette.danger),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: const Text('Delete Account?'),
                          content: const Text(
                            'Are you sure you want to delete your Spott account? This action is permanent and cannot be undone.',
                          ),
                          actions: [
                            CupertinoDialogAction(
                              child: const Text('Cancel'),
                              onPressed: () => Navigator.pop(context),
                            ),
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              child: const Text('Delete'),
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Account deletion request submitted. Process will complete in 30 days.',
                                      style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600),
                                    ),
                                    backgroundColor: palette.danger,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class _ThemeSelectionSheet extends StatefulWidget {
  final RideController ride;
  final DSColorPalette palette;

  const _ThemeSelectionSheet({
    required this.ride,
    required this.palette,
  });

  @override
  State<_ThemeSelectionSheet> createState() => _ThemeSelectionSheetState();
}

class _ThemeSelectionSheetState extends State<_ThemeSelectionSheet> {
  late ThemeMode _tempThemeMode;

  @override
  void initState() {
    super.initState();
    _tempThemeMode = widget.ride.themeMode;
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;
    final isDark = widget.ride.isDarkMode;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      decoration: BoxDecoration(
        color: isDark ? palette.surface : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: palette.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Appearance',
              style: DSTypography.displaySM.copyWith(
                color: palette.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _buildThemeOption(ThemeMode.light, 'Light'),
            const SizedBox(height: 4),

            _buildThemeOption(ThemeMode.dark, 'Dark'),
            const SizedBox(height: 4),

            _buildThemeOption(ThemeMode.system, 'System'),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF14262A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  widget.ride.updateThemeMode(_tempThemeMode);
                  Navigator.pop(context);
                },
                child: Text(
                  'Select',
                  style: DSTypography.bodyMDStrong.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(ThemeMode mode, String label) {
    final isSelected = _tempThemeMode == mode;
    final isDark = widget.ride.isDarkMode;
    final Color optionColor = isDark ? Colors.white : const Color(0xFF14262A);

    return InkWell(
      onTap: () {
        setState(() {
          _tempThemeMode = mode;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: DSTypography.labelLarge.copyWith(
                color: optionColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Theme(
              data: ThemeData(
                unselectedWidgetColor: optionColor.withValues(alpha: 0.5),
              ),
              child: Radio<ThemeMode>(
                value: mode,
                groupValue: _tempThemeMode,
                activeColor: optionColor,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    setState(() {
                      _tempThemeMode = value;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

