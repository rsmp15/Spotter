import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../design_system/design_system.dart';
import '../app/app_routes.dart';

class AccessibilityDetailScreen extends StatelessWidget {
  final String title;
  final String assetPath;
  final String headline;
  final List<String> paragraphs;
  final String buttonText;
  final bool isDarkTheme;
  final String? actionType; // e.g. 'sos', 'route', 'invite'

  const AccessibilityDetailScreen({
    super.key,
    required this.title,
    required this.assetPath,
    required this.headline,
    required this.paragraphs,
    required this.buttonText,
    this.isDarkTheme = false,
    this.actionType,
  });

  @override
  Widget build(BuildContext context) {
    final themeBg = isDarkTheme ? const Color(0xFF0F1114) : const Color(0xFFEDE6EA); // Ice blue in light theme
    final textPrimaryColor = isDarkTheme ? Colors.white : const Color(0xFF14262A);
    final textSecondaryColor = isDarkTheme ? Colors.white.withValues(alpha: 0.8) : const Color(0xFF666666);
    final buttonBgColor = isDarkTheme ? const Color(0xFFE2E8F0) : const Color(0xFF14262A); // Dark obsidian button in light theme
    final buttonTextColor = isDarkTheme ? const Color(0xFF14262A) : Colors.white;
    final closeButtonBg = isDarkTheme ? Colors.black.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.8);
    final closeIconColor = isDarkTheme ? Colors.white : const Color(0xFF14262A);

    return Scaffold(
      backgroundColor: themeBg,
      body: Stack(
        children: [
          // Scrollable content
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Top Image Banner
                  Stack(
                    children: [
                      Container(
                        height: 260,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isDarkTheme ? const Color(0xFF1E293B) : const Color(0xFFEDE6EA),
                        ),
                        child: Image.asset(
                          assetPath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: isDarkTheme ? const Color(0xFF1E293B) : const Color(0xFFEDE6EA),
                              child: Icon(
                                CupertinoIcons.photo,
                                size: 50,
                                color: isDarkTheme ? Colors.white30 : Colors.black26,
                              ),
                            );
                          },
                        ),
                      ),
                      // Soft gradient overlay at bottom of image for dark theme
                      if (isDarkTheme)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 80,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  themeBg,
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  // 2. Text Content Area
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 120), // Bottom padding for sticky button clearance
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Type Tag or Title Category
                        Text(
                          title.toUpperCase(),
                          style: DSTypography.caption.copyWith(
                            color: isDarkTheme ? const Color(0xFF38BDF8) : const Color(0xFF14262A),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Headline
                        Text(
                          headline,
                          style: DSTypography.displayLarge.copyWith(
                            color: textPrimaryColor,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Paragraphs
                        ...paragraphs.map((p) => Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Text(
                                p,
                                style: DSTypography.bodyLarge.copyWith(
                                  color: textSecondaryColor,
                                  fontSize: 16,
                                  height: 1.6,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Floating Back / Close Button in Top Left
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: closeButtonBg,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  CupertinoIcons.xmark,
                  size: 18,
                  color: closeIconColor,
                ),
              ),
            ),
          ),

          // 4. Sticky Bottom Action Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                24,
                16,
                24,
                MediaQuery.of(context).padding.bottom + 16,
              ),
              decoration: BoxDecoration(
                color: themeBg,
                border: Border(
                  top: BorderSide(
                    color: isDarkTheme ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFEAEAEA),
                    width: 1.0,
                  ),
                ),
              ),
              child: GestureDetector(
                onTap: () => _handleButtonTap(context),
                child: Container(
                  height: 54,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: buttonBgColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      if (!isDarkTheme)
                        BoxShadow(
                          color: const Color(0xFF0F1114).withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      buttonText,
                      style: DSTypography.bodyLarge.copyWith(
                        color: buttonTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleButtonTap(BuildContext context) {
    if (actionType == 'sos') {
      // Navigate to the SOS Alert Slider screen
      Navigator.pushReplacementNamed(context, AppRoutes.sosAlert);
    } else if (actionType == 'route') {
      // Navigate to destination search
      Navigator.pushReplacementNamed(context, AppRoutes.destination);
    } else if (actionType == 'invite') {
      // Show snackbar feedback
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invite link copied to clipboard!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: const Color(0xFF14262A),
        ),
      );
    } else {
      // General pop/dismiss feedback
      Navigator.pop(context);
    }
  }
}
