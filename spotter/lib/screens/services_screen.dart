import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../app/app_routes.dart';
import '../app/app_assets.dart';
import '../controllers/ride_controller.dart';


class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final isDark = ride.isDarkMode;
    final scaffoldBg = isDark ? const Color(0xFF0F1114) : const Color(0xFFFFFFFF);
    final textCol = isDark ? const Color(0xFFF1F3F4) : const Color(0xFF1A1D21);
    final descCol = isDark ? const Color(0xFFAEB6BD) : const Color(0xFF5F6368);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: scaffoldBg,
      body: Stack(
        children: [
          if (!isDark) ...[
            // Top-left soft cyan gradient (A3EEFF)
            Positioned(
              top: 0,
              left: -1,
              right: 0,
              height: 200,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.2,
                    colors: [
                      Color(0xFFA3EEFF),
                      Color(0x00A3EEFF),
                    ],
                  ),
                ),
              ),
            ),
            // Top-right soft blue gradient (79C3FE)
            Positioned(
              top: 0,
              left: -20,
              right: 0,
              height: 200,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 1.1,
                    colors: [
                      Color(0xFF4D9DDD),
                      Color(0x0079C3FE),
                    ],
                  ),
                ),
              ),
            ),
          ],
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Bar
                _buildHeader(context, isDark, textCol),
                
                // Content
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 110),
                    children: [
                      // H1 and H2
                      Text(
                        'Services',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: textCol,
                          letterSpacing: -1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Go anywhere, get anything',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: descCol,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Grid of 8 tiles in 2 rows of 4 columns
                      _buildServicesGrid(context, isDark),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, Color textCol) {
    final borderCol = isDark ? const Color(0xFF2D3239) : const Color(0xFFE8EAED);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: isDark
            ? Border(
                bottom: BorderSide(color: borderCol, width: 1.0),
              )
            : null, // Remove divider line in Light Mode
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SPOTT',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: textCol,
                  letterSpacing: -1.0,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
            child: Container(
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: textCol,
                  width: 1.5,
                ),
              ),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: isDark ? const Color(0xFF24282D) : const Color(0xFFF0F2F5),
                child: Text(
                  'R',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: textCol,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesGrid(BuildContext context, bool isDark) {
    final services = [
      _ServiceItem(title: 'Trip', assetPath: AppAssets.car, routeName: AppRoutes.destination, tag: '50%'),
      _ServiceItem(title: 'Bus tickets', icon: CupertinoIcons.bus, routeName: AppRoutes.searchResults, tag: 'Promo'),
      _ServiceItem(title: 'Intercity', assetPath: AppAssets.carClock, routeName: AppRoutes.searchResults, tag: '50%'),
      _ServiceItem(title: 'Teens', icon: CupertinoIcons.person_2_fill, routeName: AppRoutes.destination),
      _ServiceItem(title: 'Rentals', assetPath: AppAssets.bike, routeName: AppRoutes.destination),
      _ServiceItem(title: 'Reserve', assetPath: AppAssets.calendar, routeName: AppRoutes.destination, tag: 'Promo'),
      _ServiceItem(title: 'Metro', icon: Icons.directions_subway, routeName: AppRoutes.destination),
      _ServiceItem(title: 'Seniors', icon: CupertinoIcons.person_crop_circle_fill, routeName: AppRoutes.destination),
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 32 - 8) / 2;
    final cardHeight = 72.0;
    final double aspectRatio = cardWidth / cardHeight;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: aspectRatio,
      ),
      itemBuilder: (context, index) {
        final s = services[index];
        return _buildServiceTile(
          context,
          title: s.title,
          assetPath: s.assetPath,
          icon: s.icon,
          routeName: s.routeName,
          isDark: isDark,
          tag: s.tag,
        );
      },
    );
  }

  Widget _buildServiceTile(
    BuildContext context, {
    required String title,
    String? assetPath,
    IconData? icon,
    required String routeName,
    required bool isDark,
    String? tag,
  }) {
    // final bg = isDark ? const Color(0xFF1E2125) : const Color(0xFFF8F6F6);
    // final textCol = isDark ? const Color(0xFFE0E0E0) : const Color(0xFF444444);
    // final iconBg = isDark ? const Color(0xFF2C2F34) : Colors.white;

    final bg = isDark ? const Color(0xFF1B1B1B) : const Color(0xFFF3F3F3);
    final textCol = isDark ? Colors.white : Colors.black;
    final iconBg = isDark ? const Color(0xFF2C2F34) : Colors.white;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, routeName),
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Icon Container (44x44)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: assetPath != null
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: Image.asset(
                        assetPath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          CupertinoIcons.car_detailed,
                          color: textCol,
                          size: 18,
                        ),
                      ),
                    )
                  : Icon(
                      icon,
                      color: textCol,
                      size: 20,
                    ),
            ),
            const SizedBox(width: 16),
            // Label
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w500, // Medium (500)
                        height: 20 / 14, // Line height: 20px
                        color: textCol,
                      ),
                    ),
                  ),
                  if (tag != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF14262A),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag.toLowerCase(),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Chevron
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Icon(
                Icons.chevron_right_rounded,
                size: 14,
                color: const Color(0xFF8E8E93),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceItem {
  final String title;
  final String? assetPath;
  final IconData? icon;
  final String routeName;
  final String? tag;

  _ServiceItem({
    required this.title,
    this.assetPath,
    this.icon,
    required this.routeName,
    this.tag,
  });
}
