import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../app/app_assets.dart';
import '../../app/app_config.dart';
import '../../app/app_routes.dart';
import '../../controllers/ride_controller.dart';
import '../../helper.dart';
import '../../models/ride_models.dart';
import '../../design_system/design_system.dart';

class SpotterHomePanel extends StatefulWidget {
  const SpotterHomePanel({super.key});

  @override
  State<SpotterHomePanel> createState() => _SpotterHomePanelState();
}

class _SpotterHomePanelState extends State<SpotterHomePanel> {
  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;

    final sheetDecoration = BoxDecoration(
      color: isDark
          ? palette.surface.withValues(alpha: 0.96)
          : Colors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      boxShadow: Helper.premiumShadows,
    );

    Widget sheet = DraggableScrollableSheet(
      initialChildSize: 0.38,
      minChildSize: 0.38,
      maxChildSize: 0.88,
      snap: true,
      snapSizes: const [0.38, 0.88],
      builder: (context, scrollController) {
        Widget content = Container(
          decoration: sheetDecoration,
          child: Column(
            children: [
              // Drag handle
              _DragHandle(palette: palette),

              // Scrollable content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  children: [
                    // ── WHERE TO search bar ─────────────────────────
                    _WhereToBar(palette: palette),
                    const SizedBox(height: 24),

                    // ── Service grid (Ride, Package, Moto, Auto) ────
                    _SectionHeader(title: 'Suggestions', palette: palette),
                    const SizedBox(height: 12),
                    _ServiceGrid(palette: palette),
                    const SizedBox(height: 24),

                    // ── Recent / Saved Places ───────────────────────
                    _SectionHeader(title: 'Recent Places', palette: palette),
                    const SizedBox(height: 8),
                    _RecentPlace(
                      icon: CupertinoIcons.house_fill,
                      title: 'Home',
                      subtitle: 'Koregaon Park, Pune',
                      palette: palette,
                      onTap: () {
                        ride.updateDestination(const LocationPoint(
                          title: 'Home',
                          detail: 'Koregaon Park, Pune, Maharashtra',
                        ));
                        Navigator.pushNamed(context, AppRoutes.destination);
                      },
                    ),
                    _RecentPlace(
                      icon: CupertinoIcons.building_2_fill,
                      title: 'Office',
                      subtitle: 'Viman Nagar, Pune',
                      palette: palette,
                      onTap: () {
                        ride.updateDestination(const LocationPoint(
                          title: 'Office',
                          detail: 'Viman Nagar, Pune, Maharashtra',
                        ));
                        Navigator.pushNamed(context, AppRoutes.destination);
                      },
                    ),
                    _RecentPlace(
                      icon: CupertinoIcons.clock_fill,
                      title: 'Decathlon Wagholi',
                      subtitle: 'Wagholi, Pune',
                      palette: palette,
                      onTap: () {
                        ride.updateDestination(const LocationPoint(
                          title: 'Decathlon Wagholi',
                          detail: 'Wagholi, Pune, Maharashtra',
                        ));
                        Navigator.pushNamed(context, AppRoutes.destination);
                      },
                    ),
                    const SizedBox(height: 28),

                    // ── Ways to plan with Spott ──────────────────────
                    _SectionHeader(
                      title: 'Plan with ${AppConfig.appName}',
                      palette: palette,
                    ),
                    const SizedBox(height: 14),
                    _PlanCardRow(palette: palette),
                    const SizedBox(height: 28),

                    // ── Around You map preview ───────────────────────
                    _AroundYouCard(palette: palette),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ],
          ),
        );

        // Glass-blur for dark mode
        if (isDark) {
          content = ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: content,
            ),
          );
        }

        return content;
      },
    );

    return sheet;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-Widgets
// ─────────────────────────────────────────────────────────────────────────────

class _DragHandle extends StatelessWidget {
  final DSColorPalette palette;
  const _DragHandle({required this.palette});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 16),
        width: 44,
        height: 4,
        decoration: BoxDecoration(
          color: palette.border,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

// ── "Where to?" search bar ────────────────────────────────────────────────────
class _WhereToBar extends StatelessWidget {
  final DSColorPalette palette;
  const _WhereToBar({required this.palette});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.destination),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: palette.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.search,
              color: palette.iconPrimary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Where to?',
                style: DSTypography.labelLarge.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: palette.textSecondary,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius: BorderRadius.circular(999),
                boxShadow: palette.isDark
                    ? []
                    : [
                        const BoxShadow(
                          color: Color(0x12000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.clock,
                    color: palette.iconPrimary,
                    size: 13,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Now',
                    style: DSTypography.labelLarge.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: palette.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    CupertinoIcons.chevron_down,
                    color: palette.iconPrimary,
                    size: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 2×2 Service Grid ──────────────────────────────────────────────────────────
class _ServiceGrid extends StatelessWidget {
  final DSColorPalette palette;
  const _ServiceGrid({required this.palette});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 12,
      mainAxisSpacing: 0,
      childAspectRatio: 0.78,
      children: [
        _ServiceTile(
          label: 'Ride',
          asset: AppAssets.car,
          fallback: CupertinoIcons.car_detailed,
          palette: palette,
          onTap: () => Navigator.pushNamed(context, AppRoutes.destination),
        ),
        _ServiceTile(
          label: 'Package',
          asset: AppAssets.parcel,
          fallback: CupertinoIcons.cube_box_fill,
          palette: palette,
          onTap: () => Navigator.pushNamed(context, AppRoutes.parcelBooking),
        ),
        _ServiceTile(
          label: 'Moto',
          asset: AppAssets.bike,
          fallback: CupertinoIcons.arrow_right_circle_fill,
          palette: palette,
          onTap: () => Navigator.pushNamed(context, AppRoutes.destination),
        ),
        _ServiceTile(
          label: 'Auto',
          asset: AppAssets.rikshaw,
          fallback: CupertinoIcons.map_fill,
          palette: palette,
          onTap: () => Navigator.pushNamed(context, AppRoutes.destination),
        ),
      ],
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final String label;
  final String asset;
  final IconData fallback;
  final DSColorPalette palette;
  final VoidCallback onTap;

  const _ServiceTile({
    required this.label,
    required this.asset,
    required this.fallback,
    required this.palette,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: palette.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              asset,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Icon(
                fallback,
                size: 28,
                color: palette.iconPrimary,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: DSTypography.labelLarge.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section header ─────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final DSColorPalette palette;

  const _SectionHeader({required this.title, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: DSTypography.titleLarge.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: palette.textPrimary,
        letterSpacing: -0.3,
      ),
    );
  }
}

// ── Recent Place Row ───────────────────────────────────────────────────────────
class _RecentPlace extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final DSColorPalette palette;
  final VoidCallback onTap;

  const _RecentPlace({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.palette,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: palette.iconPrimary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: DSTypography.labelLarge.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: DSTypography.caption.copyWith(
                      fontSize: 12,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              size: 14,
              color: palette.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Plan with Spott cards row ─────────────────────────────────────────────────
class _PlanCardRow extends StatelessWidget {
  final DSColorPalette palette;
  const _PlanCardRow({required this.palette});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 108,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = MediaQuery.of(context).size.width;
          return OverflowBox(
            minWidth: screenWidth,
            maxWidth: screenWidth,
            minHeight: 108,
            maxHeight: 108,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _PlanCard(
                  title: 'Safety Toolkit',
                  subtitle: 'Share your trip status',
                  icon: CupertinoIcons.shield_fill,
                  palette: palette,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.safetyToolkit),
                ),
                const SizedBox(width: 12),
                _PlanCard(
                  title: 'Send a Package',
                  subtitle: 'Deliver locally, fast',
                  icon: CupertinoIcons.cube_box_fill,
                  palette: palette,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.parcelBooking),
                ),
                const SizedBox(width: 12),
                _PlanCard(
                  title: 'Intercity Rides',
                  subtitle: 'Travel beyond the city',
                  icon: CupertinoIcons.map_fill,
                  palette: palette,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.destination),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final DSColorPalette palette;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.palette,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: palette.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 22, color: palette.iconPrimary),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: DSTypography.labelLarge.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: palette.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: DSTypography.caption.copyWith(
                    fontSize: 11,
                    color: palette.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Around You card ────────────────────────────────────────────────────────────
class _AroundYouCard extends StatelessWidget {
  final DSColorPalette palette;
  const _AroundYouCard({required this.palette});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Around You', palette: palette),
        const SizedBox(height: 14),
        Container(
          height: 130,
          decoration: BoxDecoration(
            color: palette.surfaceVariant,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Stack(
            children: [
              // Decorative concentric circles
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: palette.iconPrimary.withValues(alpha: 0.06),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: palette.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: palette.background,
                      width: 3,
                    ),
                  ),
                ),
              ),
              // Info chips
              Positioned(
                top: 24,
                left: 60,
                child: _MapChip(
                  icon: CupertinoIcons.car_detailed,
                  label: '3 min',
                  palette: palette,
                ),
              ),
              Positioned(
                bottom: 20,
                right: 48,
                child: _MapChip(
                  icon: CupertinoIcons.cube_box,
                  label: 'Nearby',
                  palette: palette,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MapChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final DSColorPalette palette;

  const _MapChip({
    required this.icon,
    required this.label,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: palette.iconPrimary),
          const SizedBox(width: 5),
          Text(
            label,
            style: DSTypography.labelLarge.copyWith(
              color: palette.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
