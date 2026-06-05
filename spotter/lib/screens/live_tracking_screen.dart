import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/ride_controller.dart';
import '../core/components/glass_card.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/spott_avatar.dart';
import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';
import '../core/theme/radius.dart';
import '../core/theme/gradients.dart';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  final int _currentStep = 1; // 0=Pending, 1=Pickup, 2=EnRoute, 3=Arrived

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ride = RideScope.of(context);
    final driver = ride.selectedDriver;

    return GlassScaffold(
      body: Column(
        children: [
          // ── Top Bar ──────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SpottSpacing.pageHorizontal,
                vertical: SpottSpacing.sm,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: SpottColors.glassSurface,
                        shape: BoxShape.circle,
                        border: Border.all(color: SpottColors.borderSubtle),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: SpottColors.textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: SpottSpacing.md),
                  Expanded(
                    child: Text('Live Tracking', style: SpottTextStyles.titleSmall),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: SpottColors.successSoft,
                      borderRadius: BorderRadius.circular(SpottRadius.pill),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, _) {
                            return Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: SpottColors.success.withValues(
                                  alpha: 0.5 + 0.5 * _pulseController.value,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'LIVE',
                          style: SpottTextStyles.overline.copyWith(
                            color: SpottColors.success,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Map Area ─────────────────────────────────────────
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: SpottSpacing.pageHorizontal,
                vertical: SpottSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: SpottColors.surface2,
                borderRadius: BorderRadius.circular(SpottRadius.card),
                border: Border.all(color: SpottColors.border),
              ),
              child: Stack(
                children: [
                  // Decorative grid pattern
                  Positioned.fill(
                    child: CustomPaint(painter: _MapGridPainter()),
                  ),
                  // Route path
                  Center(
                    child: CustomPaint(
                      size: const Size(200, 200),
                      painter: _RoutePathPainter(progress: _currentStep / 3),
                    ),
                  ),
                  // Origin marker
                  Positioned(
                    left: 60,
                    top: 80,
                    child: _buildMapMarker(
                      icon: Icons.my_location_rounded,
                      color: SpottColors.accentPurple,
                      label: 'Pickup',
                    ),
                  ),
                  // Destination marker
                  Positioned(
                    right: 60,
                    bottom: 80,
                    child: _buildMapMarker(
                      icon: Icons.flag_rounded,
                      color: SpottColors.primary,
                      label: 'Drop',
                    ),
                  ),
                  // ETA Floating Card
                  Positioned(
                    top: SpottSpacing.md,
                    right: SpottSpacing.md,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SpottSpacing.md,
                        vertical: SpottSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: SpottColors.surface1.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(SpottRadius.md),
                        border: Border.all(color: SpottColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '18 min',
                            style: SpottTextStyles.title.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '6.4 km',
                            style: SpottTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom Panel ─────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(
              SpottSpacing.pageHorizontal,
              SpottSpacing.lg,
              SpottSpacing.pageHorizontal,
              SpottSpacing.xl,
            ),
            decoration: BoxDecoration(
              gradient: SpottGradients.surfaceElevated,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(SpottRadius.xxl),
                topRight: Radius.circular(SpottRadius.xxl),
              ),
              border: Border(top: BorderSide(color: SpottColors.border)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Trip Progress Steps
                  _buildProgressSteps(),

                  const SizedBox(height: SpottSpacing.lg),

                  // ── Driver Info ─────────────────────────────
                  GlassCard(
                    padding: const EdgeInsets.all(SpottSpacing.md),
                    child: Row(
                      children: [
                        SpottAvatar(
                          imageUrl: 'https://i.pravatar.cc/150?u=driver1',
                          radius: 24,
                          isVerified: true,
                          isOnline: true,
                        ),
                        const SizedBox(width: SpottSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                driver?.name ?? 'Amit Sharma',
                                style: SpottTextStyles.label,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Swift Dzire • MH 12 AB 1234',
                                style: SpottTextStyles.caption.copyWith(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        _buildActionButton(Icons.phone_rounded, SpottColors.success),
                        const SizedBox(width: SpottSpacing.sm),
                        _buildActionButton(Icons.chat_rounded, SpottColors.info),
                      ],
                    ),
                  ),

                  const SizedBox(height: SpottSpacing.md),

                  // ── Safety Quick Actions ────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('SOS triggered! Emergency contacts notified.'),
                                backgroundColor: SpottColors.danger,
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: SpottSpacing.md),
                            decoration: BoxDecoration(
                              color: SpottColors.dangerSoft,
                              borderRadius: BorderRadius.circular(SpottRadius.md),
                              border: Border.all(
                                color: SpottColors.danger.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.sos_rounded, color: SpottColors.danger, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  'SOS',
                                  style: SpottTextStyles.label.copyWith(
                                    color: SpottColors.danger,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: SpottSpacing.sm),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Trip link copied!')),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: SpottSpacing.md),
                            decoration: BoxDecoration(
                              color: SpottColors.glassSurface,
                              borderRadius: BorderRadius.circular(SpottRadius.md),
                              border: Border.all(color: SpottColors.borderSubtle),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.share_rounded, color: SpottColors.textSecondary, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  'Share Trip',
                                  style: SpottTextStyles.label.copyWith(
                                    color: SpottColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSteps() {
    final steps = ['Confirmed', 'Pickup', 'En Route', 'Arrived'];

    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          // Connector line
          final stepIndex = i ~/ 2;
          final isCompleted = stepIndex < _currentStep;
          return Expanded(
            child: Container(
              height: 2.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: isCompleted
                    ? const LinearGradient(
                        colors: [SpottColors.success, SpottColors.success],
                      )
                    : null,
                color: isCompleted ? null : SpottColors.surface3,
              ),
            ),
          );
        }
        // Step dot + label
        final stepIndex = i ~/ 2;
        final isActive = stepIndex == _currentStep;
        final isCompleted = stepIndex < _currentStep;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isActive ? 16 : 12,
              height: isActive ? 16 : 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? SpottColors.success
                    : isActive
                        ? SpottColors.primary
                        : SpottColors.surface3,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: SpottColors.primary.withValues(alpha: 0.4),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 8, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 6),
            Text(
              steps[stepIndex],
              style: TextStyle(
                fontSize: 9,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive
                    ? SpottColors.textPrimary
                    : isCompleted
                        ? SpottColors.success
                        : SpottColors.textTertiary,
                fontFamily: 'Inter',
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMapMarker({
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: SpottColors.surface1,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: color,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, Color color) {
    return GestureDetector(
      onTap: () => HapticFeedback.lightImpact(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}

// ── Map Grid Painter ──────────────────────────────────────────────────
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Land Background
    final landPaint = Paint()..color = const Color(0xFFF4F5F8);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), landPaint);

    // Green Parks
    final parkPaint = Paint()
      ..color = const Color(0xFFE2F3E7) // Soft light green
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(20, 40, 80, 60), const Radius.circular(8)), parkPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(180, 240, 90, 80), const Radius.circular(12)), parkPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(30, 320, 60, 50), const Radius.circular(8)), parkPaint);

    // Water Bodies (River)
    final waterPaint = Paint()
      ..color = const Color(0xFFC4E0E5) // Soft light blue water
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24.0
      ..strokeCap = StrokeCap.round;

    final riverPath = Path()
      ..moveTo(0, size.height * 0.9)
      ..cubicTo(size.width * 0.3, size.height * 0.8, size.width * 0.6, size.height * 0.95, size.width, size.height * 0.7);
    canvas.drawPath(riverPath, waterPaint);

    // Major Roads/Highways
    final roadPaint = Paint()
      ..color = const Color(0xFFFFFFFF) // White roads
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    final highwayPaint = Paint()
      ..color = const Color(0xFFE2E6EC) // Light grey highway
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;

    // Draw some horizontal and vertical roads representing streets
    final roadPath = Path()
      ..moveTo(0, size.height * 0.15)
      ..lineTo(size.width, size.height * 0.15)
      ..moveTo(0, size.height * 0.5)
      ..lineTo(size.width, size.height * 0.5)
      ..moveTo(size.width * 0.25, 0)
      ..lineTo(size.width * 0.25, size.height)
      ..moveTo(size.width * 0.75, 0)
      ..lineTo(size.width * 0.75, size.height);
    
    canvas.drawPath(roadPath, roadPaint);

    // Draw a major highway diagonal crossing
    final highwayPath = Path()
      ..moveTo(0, size.height * 0.8)
      ..lineTo(size.width, size.height * 0.2);
    canvas.drawPath(highwayPath, highwayPaint);

    // Traffic Layer indicators (slow traffic segments in orange/red)
    final trafficPaint = Paint()
      ..color = SpottColors.warning // Orange slow traffic
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    
    canvas.drawLine(
      Offset(size.width * 0.25, size.height * 0.2),
      Offset(size.width * 0.25, size.height * 0.4),
      trafficPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Route Path Painter ────────────────────────────────────────────────
class _RoutePathPainter extends CustomPainter {
  final double progress;
  _RoutePathPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height * 0.2)
      ..cubicTo(
        size.width * 0.3,
        size.height * 0.1,
        size.width * 0.7,
        size.height * 0.9,
        size.width,
        size.height * 0.8,
      );

    // Background road path representation (grey)
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    // Inner route background
    final bgInnerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = const Color(0xFFFFFFFF)
      ..strokeCap = StrokeCap.round;

    bgPaint.color = SpottColors.border;
    canvas.drawPath(path, bgPaint);
    canvas.drawPath(path, bgInnerPaint);

    // Solid Google Maps-style Blue Route Path
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    progressPaint.color = SpottColors.info; // Safe Maps Blue
    progressPaint.strokeCap = StrokeCap.round;

    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      final length = metric.length * progress;
      final extracted = metric.extractPath(0, length);
      canvas.drawPath(extracted, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RoutePathPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
