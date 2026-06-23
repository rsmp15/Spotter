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
    final scaffoldBg = isDark ? const Color(0xFF0F1114) : const Color(0xFFFAFBFC);
    final textCol = isDark ? const Color(0xFFF1F3F4) : const Color(0xFF1A1D21);
    final descCol = isDark ? const Color(0xFFAEB6BD) : const Color(0xFF5F6368);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: scaffoldBg,
      body: SafeArea(
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
                  const SizedBox(height: 24),

                  // Grid of 8 tiles in 2 rows of 4 columns
                  _buildServicesGrid(context, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, Color textCol) {
    final borderCol = isDark ? const Color(0xFF2D3239) : const Color(0xFFE8EAED);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: borderCol, width: 1.0),
        ),
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

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.9, // Strict equal sizes, slightly taller than wide to prevent text overflow
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
    final bg = isDark ? const Color(0xFF1B1B1B) : const Color(0xFFF3F3F3);
    final textCol = isDark ? Colors.white : Colors.black;
    final tagBg = isDark ? const Color(0xFFFFCA28) : const Color(0xFFFFB300);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, routeName),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (assetPath != null)
                  SizedBox(
                    height: 36,
                    width: 36,
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        CupertinoIcons.car_detailed,
                        color: textCol,
                        size: 24,
                      ),
                    ),
                  )
                else if (icon != null)
                  Icon(
                    icon,
                    color: textCol,
                    size: 32,
                  ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: textCol,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (tag != null)
            Positioned(
              top: -6,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: tagBg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
        ],
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
