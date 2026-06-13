import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/app_routes.dart';
import '../controllers/ride_controller.dart';
import '../core/components/spott_avatar.dart';

import '../theme/spott_theme.dart';

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

    return Scaffold(
      backgroundColor: SpottTheme.background,
      appBar: AppBar(
        backgroundColor: SpottTheme.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text('Live Tracking', style: SpottTheme.textTheme.titleLarge),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, _) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: SpottTheme.success.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(SpottTheme.radiusMedium),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: SpottTheme.success.withValues(alpha: 
                            0.5 + 0.5 * _pulseController.value,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'LIVE',
                        style: SpottTheme.textTheme.labelLarge?.copyWith(
                          color: SpottTheme.success,
                          fontSize: 12,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: SpottTheme.spacingLarge),
              child: Container(
                margin: const EdgeInsets.only(top: SpottTheme.spacingLarge),
                decoration: BoxDecoration(
                  color: SpottTheme.surface,
                  borderRadius: BorderRadius.circular(SpottTheme.radiusXLarge),
                  boxShadow: SpottTheme.premiumShadow,
                ),
                child: Stack(
                  children: [
                    Positioned.fill(child: CustomPaint(painter: _MapGridPainter())),
                    Center(
                      child: CustomPaint(
                        size: const Size(220, 220),
                        painter: _RoutePathPainter(progress: _currentStep / 3),
                      ),
                    ),
                    Positioned(
                      left: 56,
                      top: 96,
                      child: _buildMapMarker(
                        icon: Icons.my_location_rounded,
                        color: SpottTheme.primary,
                        label: 'Pickup',
                      ),
                    ),
                    Positioned(
                      right: 56,
                      bottom: 96,
                      child: _buildMapMarker(
                        icon: Icons.flag_rounded,
                        color: SpottTheme.success,
                        label: 'Drop',
                      ),
                    ),
                    Positioned(
                      top: SpottTheme.spacingLarge,
                      right: SpottTheme.spacingLarge,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: SpottTheme.spacingMedium,
                          vertical: SpottTheme.spacingSmall,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(SpottTheme.radiusLarge),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '18 min',
                              style: SpottTheme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '6.4 km',
                              style: SpottTheme.textTheme.bodySmall?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: SpottTheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(SpottTheme.radiusXLarge),
                topRight: Radius.circular(SpottTheme.radiusXLarge),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 24,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(
              SpottTheme.spacingLarge,
              SpottTheme.spacingLarge,
              SpottTheme.spacingLarge,
              SpottTheme.spacingLarge,
            ),
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProgressSteps(),
                  const SizedBox(height: SpottTheme.spacingLarge),
                  Container(
                    decoration: BoxDecoration(
                      color: SpottTheme.background,
                      borderRadius: BorderRadius.circular(SpottTheme.radiusLarge),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    padding: const EdgeInsets.all(SpottTheme.spacingLarge),
                    child: Row(
                      children: [
                        SpottAvatar(
                          imageUrl: 'https://i.pravatar.cc/150?u=driver1',
                          radius: 26,
                          isVerified: true,
                          isOnline: true,
                        ),
                        const SizedBox(width: SpottTheme.spacingLarge),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                driver?.name ?? 'Amit Sharma',
                                style: SpottTheme.textTheme.titleLarge,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Swift Dzire • MH 12 AB 1234',
                                style: SpottTheme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildActionButton(Icons.phone_rounded, SpottTheme.success),
                        const SizedBox(width: SpottTheme.spacingSmall),
                        _buildActionButton(Icons.chat_rounded, SpottTheme.primary),
                      ],
                    ),
                  ),
                  const SizedBox(height: SpottTheme.spacingLarge),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            Navigator.pushNamed(context, AppRoutes.safetyToolkit);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: SpottTheme.spacingMedium),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(SpottTheme.radiusLarge),
                              border: Border.all(
                                color: const Color(0xFFEF4444).withValues(alpha: 0.24),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.sos_rounded, color: Color(0xFFEF4444), size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  'SOS',
                                  style: SpottTheme.textTheme.labelLarge?.copyWith(
                                    color: const Color(0xFFEF4444),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: SpottTheme.spacingSmall),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Trip link copied!')),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: SpottTheme.spacingMedium),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(SpottTheme.radiusLarge),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.share_rounded, color: Colors.white70, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  'Share Trip',
                                  style: SpottTheme.textTheme.labelLarge?.copyWith(
                                    color: Colors.white70,
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
          final stepIndex = i ~/ 2;
          final isCompleted = stepIndex < _currentStep;
          return Expanded(
            child: Container(
              height: 2.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: isCompleted
                    ? LinearGradient(
                        colors: [
                          SpottTheme.success,
                          SpottTheme.success.withValues(alpha: 0.8),
                        ],
                      )
                    : null,
                color: isCompleted ? null : Colors.white.withValues(alpha: 0.08),
              ),
            ),
          );
        }
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
                    ? SpottTheme.success
                    : isActive
                        ? SpottTheme.primary
                        : Colors.white.withValues(alpha: 0.08),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: SpottTheme.primary.withValues(alpha: 0.35),
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
                    ? Colors.white
                    : isCompleted
                        ? SpottTheme.success
                        : Colors.white54,
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
            color: color.withValues(alpha: 0.16),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.35), width: 1.5),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: SpottTheme.surface,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: SpottTheme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
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
          color: color.withValues(alpha: 0.14),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final landPaint = Paint()..color = const Color(0xFF0B0F16);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), landPaint);

    final parkPaint = Paint()
      ..color = const Color(0xFF1E2A3E)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(20, 40, 80, 60), const Radius.circular(8)), parkPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(180, 240, 90, 80), const Radius.circular(12)), parkPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(30, 320, 60, 50), const Radius.circular(8)), parkPaint);

    final waterPaint = Paint()
      ..color = const Color(0xFF1A2E40)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0
      ..strokeCap = StrokeCap.round;

    final riverPath = Path()
      ..moveTo(0, size.height * 0.9)
      ..cubicTo(size.width * 0.3, size.height * 0.8, size.width * 0.6, size.height * 0.95, size.width, size.height * 0.7);
    canvas.drawPath(riverPath, waterPaint);

    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    final highwayPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;

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
    final highwayPath = Path()
      ..moveTo(0, size.height * 0.8)
      ..lineTo(size.width, size.height * 0.2);
    canvas.drawPath(highwayPath, highwayPaint);

    final trafficPaint = Paint()
      ..color = DSColors.warning
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

    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.08);

    final bgInnerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.white.withValues(alpha: 0.18)
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, bgPaint);
    canvas.drawPath(path, bgInnerPaint);

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = SpottTheme.primary;

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
