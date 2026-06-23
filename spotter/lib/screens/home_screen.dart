import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../app/app_assets.dart';
import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../design_system/design_system.dart';
import 'rider_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  late final AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.8).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _spinController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;
    final scaffoldBg = isDark ? palette.background : const Color(0xFFE4DCDF); // Tan scaffold background in light mode

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: scaffoldBg, // Canvas
      body: Stack(
        children: [
          // Top sky-blue-to-white gradient background that blends smoothly into Tan
          if (!isDark)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 380, // Height to cover Safe Area + App Bar + Search Bar + Hero Banner
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFD2E5EA), // Sky Blue at top
                      Color(0xFFFFFFFF), // Fades to white
                      Color(0xFFE4DCDF), // Smoothly blends into Tan screen background
                    ],
                    stops: [0.0, 0.6, 1.0],
                  ),
                ),
              ),
            ),
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. Unified App Bar (Scrolls up)
                SliverToBoxAdapter(
                  child: _buildAppBar(context, ride, palette),
                ),

                if (!ride.isRiderMode) ...[
                  // 2. Sticky "Where to?" search bar (Passenger Mode)
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverHeaderDelegate(
                      height: 72.0, // Reduced sticky height matching 48px + paddings
                      palette: palette,
                      scaffoldBg: scaffoldBg,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: _buildSearchTriggerButton(context, ride, palette),
                      ),
                    ),
                  ),

                  // 3. Feed Content (Promo Banner, Suggestions Grid, Accessibility)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      20,           // Screen Padding horizontal: 20px
                      12.0,         // space below search bar
                      20,           // Screen Padding horizontal: 20px
                      110.0,        // bottom padding for floating bottom bar clearance
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        _buildRideFeedWidgets(context, ride, palette),
                      ),
                    ),
                  ),
                ] else ...[
                  // Rider mode: Publish Route form
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      16.0,
                      16,
                      110.0,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: RiderPublishForm(ride: ride, palette: palette),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // APP BAR WITH TABS
  // ══════════════════════════════════════════════════════════════════
  Widget _buildAppBar(BuildContext context, RideController ride, DSColorPalette palette) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: palette.divider.withValues(alpha: 0.1), width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Current Location Stack (Left Column)
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.location_solid,
                  color: palette.primary,
                  size: 14, // Location icon: 14px
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Your location',
                        style: DSTypography.caption.copyWith(
                          color: palette.textSecondary,
                          fontSize: 11, // Small label text: 11px
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2), // Gap between label and city
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              'Current Location',
                              overflow: TextOverflow.ellipsis,
                              style: DSTypography.bodyMDStrong.copyWith(
                                color: palette.textPrimary,
                                fontSize: 18, // City text: 18px
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            CupertinoIcons.chevron_down,
                            color: palette.textPrimary,
                            size: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating Role Toggle Button
          _buildRoleToggle(ride),
          const SizedBox(width: 12),

          // Profile avatar (circular notification/profile button style)
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
            child: Container(
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: palette.border,
                  width: 1.5,
                ),
              ),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: palette.surface,
                child: Text(
                  'R',
                  style: DSTypography.bodySMStrong.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleToggle(RideController ride) {
    final isRider = ride.isRiderMode;
    return Container(
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFD2E5EA), // Sky blue
            Colors.white,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRoleToggleButton(
            label: 'Passenger',
            isSelected: !isRider,
            onTap: () {
              if (isRider) ride.toggleRiderMode();
            },
          ),
          _buildRoleToggleButton(
            label: 'Rider',
            isSelected: isRider,
            onTap: () {
              if (!isRider) ride.toggleRiderMode();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRoleToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF14262A) : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF14262A),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchTriggerButton(
    BuildContext context,
    RideController ride,
    DSColorPalette palette,
  ) {
    final isDark = ride.isDarkMode;
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.destination),
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseController, _spinController]),
        builder: (context, child) {
          final pulseVal = (_pulseAnimation.value - 1.0) / 0.8;
          final spinVal = _spinController.value;
          
          final pulseGlowShadow = isDark
              ? BoxShadow(
                  color: palette.primary.withValues(alpha: 0.15 * pulseVal),
                  blurRadius: 4.0 + 8.0 * pulseVal,
                  spreadRadius: 0.5 + 2.0 * pulseVal,
                )
              : BoxShadow(
                  color: const Color(0xFFD2E5EA).withValues(alpha: 0.4 * (1.0 - pulseVal)),
                  blurRadius: 6.0 + 10.0 * pulseVal,
                  spreadRadius: 1.0 + 3.0 * pulseVal,
                );

          return Container(
            height: 48, // Height: 48px
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24), // Border radius: 24px (Pill shape)
              boxShadow: [
                pulseGlowShadow,
                BoxShadow(
                  color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
              gradient: SweepGradient(
                colors: const [
                  Color(0xFF14262A), // Brand Teal
                  Color(0xFFD2E5EA), // Sky Blue
                  Color(0xFFEDE2E6), // Lavender
                  Color(0xFF14262A), // Brand Teal (loop back to start color)
                ],
                transform: GradientRotation(spinVal * 2 * 3.141592653589793),
              ),
            ),
            padding: const EdgeInsets.all(1.5), // Border thickness
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E352F) : Colors.white, // White fill in light mode
                borderRadius: BorderRadius.circular(22.5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16), // Horizontal padding: 16px
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.search,
                    color: palette.iconPrimary,
                    size: 18, // Left search icon: 18px
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Where to?',
                      style: DSTypography.bodyMDStrong.copyWith(
                        color: palette.textPrimary,
                        fontSize: 14, // Placeholder: 14px Medium
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? palette.surface : const Color(0xFFEDE2E6), // Use lavender/surface for time pill
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.clock_fill,
                          color: palette.iconPrimary,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Now',
                          style: DSTypography.bodySMStrong.copyWith(
                            color: palette.textPrimary,
                            fontSize: 11,
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
        },
      ),
    );
  }

  List<Widget> _buildRideFeedWidgets(
    BuildContext context,
    RideController ride,
    DSColorPalette palette,
  ) {
    return [
      // 1. Promo Banner Card (Placed above suggestions section)
      Container(
        width: double.infinity,
        height: 160, // Height: 160px (Increased height)
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: palette.isDark
                ? [const Color(0xFF1E352F), const Color(0xFF25413A)]
                : [const Color(0xFF14262A), const Color(0xFF244147)], // Dark teal gradient
          ),
          borderRadius: BorderRadius.circular(18.0), // Border radius: 18px
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18.0), // Internal padding: 18px
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ready? Then let\'s roll.',
                      style: DSTypography.displayMD.copyWith(
                        color: Colors.white,
                        fontSize: 24, // Headline: 24px ExtraBold
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // CTA Button: Height: 36px, Border radius: 10px, Horizontal padding: 16px, Font: 14px SemiBold
                    Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Explore',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            CupertinoIcons.arrow_right,
                            color: Colors.white,
                            size: 12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: SizedBox(
                width: 70,
                height: 70,
                child: Image.asset(
                  AppAssets.car,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24), // Spacing: 24px below banner

      // 2. Suggestions Header ("Services Categories")
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Services Categories',
            style: DSTypography.displaySM.copyWith(
              color: palette.textPrimary,
              fontSize: 20, // H2: 20px SemiBold
              fontWeight: FontWeight.w500, // Reduced font weight: Medium
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              'View all',
              style: DSTypography.bodySMStrong.copyWith(
                color: palette.textSecondary,
                fontSize: 14, // Action: 14px Medium
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16), // Spacing: 16px below section title

      // 3. Category Cards Grid (3 columns)
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3, // Grid: 3 columns
        crossAxisSpacing: 8, // Minimal spacing: 8px horizontal
        mainAxisSpacing: 8, // Minimal spacing: 8px vertical
        childAspectRatio: 1.05, // Aspect ratio matching Width: 105px by Height: 100px
        children: [
          _buildServiceCard(
            context,
            'Trip',
            AppAssets.car,
            AppRoutes.destination,
            palette,
            promoBadge: 'Promo',
          ),
          _buildServiceCard(
            context,
            'Intercity',
            AppAssets.carClock,
            AppRoutes.searchResults,
            palette,
          ),
          _buildServiceCard(
            context,
            'Rentals',
            AppAssets.bike,
            AppRoutes.destination,
            palette,
          ),
        ],
      ),
      const SizedBox(height: 16), // Reduced spacing above Accessibility section

      // 4. Scroll Section: Accessibility
      Text(
        'Accessibility',
        style: DSTypography.displaySM.copyWith(
          color: palette.textPrimary,
          fontSize: 20, // H2: 20px SemiBold
          fontWeight: FontWeight.w500, // Reduced font weight: Medium
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 195,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = MediaQuery.of(context).size.width;
            return OverflowBox(
              minWidth: screenWidth,
              maxWidth: screenWidth,
              minHeight: 195,
              maxHeight: 195,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildAccessibilityCard(AppAssets.route, palette),
                  const SizedBox(width: DSSpacing.md),
                  _buildAccessibilityCard(AppAssets.safety, palette),
                  const SizedBox(width: DSSpacing.md),
                  _buildAccessibilityCard(AppAssets.headOut, palette),
                  const SizedBox(width: DSSpacing.md),
                  _buildAccessibilityCard(AppAssets.addMemberCard, palette),
                ],
              ),
            );
          },
        ),
      ),
      const SizedBox(height: DSSpacing.xxxl),
    ];
  }

  Widget _buildAccessibilityCard(String assetPath, DSColorPalette palette) {
    String title = 'Accessibility';
    String description = 'Seamless transit features designed for everyone.';

    if (assetPath == AppAssets.route) {
      title = 'Flexible Route';
      description = 'Customizable routes and stops for your journey.';
    } else if (assetPath == AppAssets.safety) {
      title = 'Safety First';
      description = 'Emergency support and ride sharing verification.';
    } else if (assetPath == AppAssets.headOut) {
      title = 'Ready to Roll';
      description = 'Instantly book nearby rides and head out today.';
    } else if (assetPath == AppAssets.addMemberCard) {
      title = 'Add Members';
      description = 'Split fares and invite friends to share your pool.';
    }

    final cardBgColor = palette.isDark ? Colors.transparent : const Color(0xFFEDE6EA);

    return Container(
      width: 230,
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 130,
              width: 230,
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: DSTypography.bodyMDStrong.copyWith(
                    color: palette.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: DSTypography.caption.copyWith(
                    color: palette.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String title,
    String assetPath,
    String routeName,
    DSColorPalette palette, {
    String? promoBadge,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, routeName),
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand, // Forces children to match constraints and be responsive
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEDE6EA), // Lavender background
              borderRadius: BorderRadius.circular(16), // Border radius: 16px
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24, // Icon size: 24px
                  height: 24,
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        CupertinoIcons.car_detailed,
                        color: palette.iconPrimary,
                        size: 20,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12), // Label top spacing: 12px
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DSTypography.bodySMStrong.copyWith(
                    color: palette.textPrimary,
                    fontSize: 14, // Typography: 14px Medium
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (promoBadge != null)
            Positioned(
              top: -6,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF14262A), // Dark teal badge background
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    promoBadge.toLowerCase(),
                    style: DSTypography.caption.copyWith(
                      fontSize: 8,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;
  final DSColorPalette palette;
  final Color scaffoldBg;

  _SliverHeaderDelegate({
    required this.height,
    required this.child,
    required this.palette,
    required this.scaffoldBg,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: overlapsContent ? scaffoldBg : Colors.transparent, // Background transparent when aligned in header
        boxShadow: overlapsContent ? DSShadows.level1 : null,
        border: overlapsContent
            ? Border(
                bottom: BorderSide(
                  color: palette.divider.withValues(alpha: 0.2),
                  width: 1.0,
                ),
              )
            : null,
      ),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _SliverHeaderDelegate oldDelegate) {
    return oldDelegate.height != height ||
        oldDelegate.child != child ||
        oldDelegate.palette != palette ||
        oldDelegate.scaffoldBg != scaffoldBg;
  }
}