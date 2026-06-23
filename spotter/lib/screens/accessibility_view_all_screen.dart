import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../design_system/design_system.dart';
import '../app/app_assets.dart';
import '../app/app_routes.dart';

class AccessibilityViewAllScreen extends StatelessWidget {
  const AccessibilityViewAllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;
    final scaffoldBg = isDark ? palette.background : const Color(0xFFE4DCDF); // Tan scaffold background matching home screen

    final cardBgColor = isDark ? palette.surface : const Color(0xFFEDE6EA); // Ice blue/lavender background
    final shadowColor = isDark ? Colors.black54 : Colors.black.withValues(alpha: 0.06);

    final List<Map<String, dynamic>> features = [
      {
        'title': 'Flexible Route',
        'assetPath': AppAssets.route,
        'description': 'Customizable routes and stops for your journey.',
        'headline': 'Customizable Routes & Quick Stops',
        'paragraphs': [
          'Tailor your journey to match your exact routine. With Spotter\'s Flexible Route, you can customize your start points, add multiple passenger stops, and dynamically adjust paths to avoid high-traffic corridors.',
          'Our route planning features help drivers and co-riders coordinate pickup zones smoothly without causing delays or adding extra miles.'
        ],
        'buttonText': 'Configure route',
        'actionType': 'route',
      },
      {
        'title': 'Safety First',
        'assetPath': AppAssets.safety,
        'description': 'Emergency support and ride sharing verification.',
        'headline': 'Your one-stop shop for safety tools',
        'paragraphs': [
          'Our Safety Toolkit is available on every ride you take with Spotter. Just tap the safety shield on the map to access a variety of safety features.',
          'Wherever you are, you can always contact emergency services and report a safety concern directly through the app. You can also add one or more loved ones as trusted contacts and receive automatic prompts to share your trip information with them in real time.'
        ],
        'buttonText': 'Add a trusted contact',
        'actionType': 'sos',
      },
      {
        'title': 'Ready to Roll',
        'assetPath': AppAssets.headOut,
        'description': 'Instantly book nearby rides and head out today.',
        'headline': 'Instantly Book Nearby Rides',
        'paragraphs': [
          'Ready to head out? Spotter matches you with top-rated nearby drivers instantly. Safe, reliable, and convenient commutes are just a tap away.',
          'Check vehicle details, driver ratings, and real-time ETAs directly from your home feed before confirming your booking.'
        ],
        'buttonText': 'Book a ride now',
        'actionType': 'route',
      },
      {
        'title': 'Add Members',
        'assetPath': AppAssets.addMemberCard,
        'description': 'Split fares and invite friends to share your pool.',
        'headline': 'Share the Ride, Split the Fare',
        'paragraphs': [
          'Carpooling is more fun with friends and family. Invite members to your Spotter pool to split fares automatically and travel together.',
          'Manage trusted members, set up payment splitting preferences, and keep track of group ride history with ease.'
        ],
        'buttonText': 'Invite a member',
        'actionType': 'invite',
      },
    ];

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: isDark ? palette.surface : const Color(0xFFEDE6EA), // Match banner style background
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            CupertinoIcons.left_chevron,
            color: palette.iconPrimary,
          ),
        ),
        title: Text(
          'Accessibility Features',
          style: DSTypography.bodyMDStrong.copyWith(
            color: palette.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: palette.divider.withValues(alpha: 0.1),
            height: 1.0,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: features.length,
        itemBuilder: (context, index) {
          final item = features[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: isDark ? Border.all(color: palette.border, width: 1) : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.accessibilityDetail,
                      arguments: {
                        'title': item['title'],
                        'assetPath': item['assetPath'],
                        'headline': item['headline'],
                        'paragraphs': item['paragraphs'],
                        'buttonText': item['buttonText'],
                        'isDarkTheme': isDark, // Dynamically matches app theme status
                        'actionType': item['actionType'],
                      },
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card Image
                      SizedBox(
                        height: 160,
                        width: double.infinity,
                        child: Image.asset(
                          item['assetPath'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: isDark ? Colors.white10 : Colors.black12,
                              child: Icon(
                                CupertinoIcons.photo,
                                size: 40,
                                color: palette.iconSecondary,
                              ),
                            );
                          },
                        ),
                      ),
                      // Card Title & Description
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'],
                              style: DSTypography.bodyMDStrong.copyWith(
                                color: palette.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['description'],
                              style: DSTypography.caption.copyWith(
                                color: palette.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
