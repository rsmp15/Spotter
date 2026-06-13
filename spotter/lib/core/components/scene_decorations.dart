import 'package:spotter/design_system/design_system.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';

// ── Route Pattern Painter ─────────────────────────────────────────────
/// Draws dotted curved route lines for hero search scene
class RoutePatternPainter extends CustomPainter {
  final Color color;

  RoutePatternPainter({this.color = const Color(0x0DFFFFFF)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Curved route path 1
    final path1 = Path()
      ..moveTo(size.width * 0.1, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.4, size.height * 0.1,
        size.width * 0.7, size.height * 0.4,
      )
      ..quadraticBezierTo(
        size.width * 0.9, size.height * 0.6,
        size.width * 0.95, size.height * 0.35,
      );

    // Curved route path 2
    final path2 = Path()
      ..moveTo(size.width * 0.05, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.3, size.height * 0.5,
        size.width * 0.6, size.height * 0.8,
      )
      ..quadraticBezierTo(
        size.width * 0.85, size.height * 1.0,
        size.width * 0.9, size.height * 0.65,
      );

    // Draw as dashed
    _drawDashedPath(canvas, path1, paint, 6, 4);
    _drawDashedPath(canvas, path2, paint, 6, 4);

    // Route dots along paths
    final dotPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    for (double t = 0.0; t <= 1.0; t += 0.2) {
      final metrics1 = path1.computeMetrics().first;
      final pos1 = metrics1.getTangentForOffset(metrics1.length * t)?.position;
      if (pos1 != null) {
        canvas.drawCircle(pos1, 2.5, dotPaint);
      }
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint, double dashLen, double gapLen) {
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = math.min(distance + dashLen, metric.length);
        final extracted = metric.extractPath(distance, end);
        canvas.drawPath(extracted, paint);
        distance += dashLen + gapLen;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Map Circles Painter ───────────────────────────────────────────────
/// Concentric location radar circles for Nearby bento card
class MapCirclesPainter extends CustomPainter {
  final Color color;

  MapCirclesPainter({this.color = const Color(0x1AFFFFFF)});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.75, size.height * 0.4);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, i * 18.0, paint);
    }

    // Center dot
    final dotPaint = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 3, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Highway Line Painter ──────────────────────────────────────────────
/// Subtle road-line texture for route cards
class HighwayLinePainter extends CustomPainter {
  final Color color;

  HighwayLinePainter({this.color = const Color(0x08FFFFFF)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Center highway dashes
    final centerX = size.width * 0.5;
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(
        Offset(centerX, y),
        Offset(centerX, y + 8),
        paint,
      );
      y += 16;
    }

    // Side lines
    final sidePaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(centerX - 20, 0), Offset(centerX - 20, size.height), sidePaint);
    canvas.drawLine(Offset(centerX + 20, 0), Offset(centerX + 20, size.height), sidePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Diagonal Split Clipper ────────────────────────────────────────────
/// Creates a diagonal clip for the traveler banner premium split effect
class DiagonalSplitClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(size.width * 0.55, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * 0.35, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// ── Shield Watermark ──────────────────────────────────────────────────
/// Large shield background element at very low opacity for trust module
class ShieldWatermark extends StatelessWidget {
  final double size;
  final double opacity;

  const ShieldWatermark({
    super.key,
    this.size = 160,
    this.opacity = 0.04,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.shield_rounded,
      size: size,
      color: DSColors.success.withValues(alpha: opacity),
    );
  }
}

// ── Decorative Dots ───────────────────────────────────────────────────
/// Floating ambient dots for hero scene background
class FloatingDotsPainter extends CustomPainter {
  final Color color;
  final int seed;

  FloatingDotsPainter({
    this.color = const Color(0x15FFFFFF),
    this.seed = 42,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(seed);
    final paint = Paint()
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 12; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final radius = 1.5 + rng.nextDouble() * 2.5;
      final alpha = 0.05 + rng.nextDouble() * 0.12;
      paint.color = color.withValues(alpha: alpha);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Parcel Route Dots Painter ─────────────────────────────────────────
/// Dotted delivery route line for parcel banner
class ParcelRoutePainter extends CustomPainter {
  final Color color;

  ParcelRoutePainter({this.color = const Color(0x33FFFFFF)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width * 0.1, size.height * 0.5)
      ..quadraticBezierTo(
        size.width * 0.5, size.height * 0.2,
        size.width * 0.9, size.height * 0.5,
      );

    // Draw dashed
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = math.min(distance + 5, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += 10;
      }
    }

    // Arrow at end
    final arrowPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final arrowPath = Path()
      ..moveTo(size.width * 0.88, size.height * 0.45)
      ..lineTo(size.width * 0.93, size.height * 0.5)
      ..lineTo(size.width * 0.88, size.height * 0.55)
      ..close();
    canvas.drawPath(arrowPath, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Shimmer Sweep Widget ──────────────────────────────────────────────
/// Animated gradient sweep for promotional banners
class ShimmerSweep extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const ShimmerSweep({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<ShimmerSweep> createState() => _ShimmerSweepState();
}

class _ShimmerSweepState extends State<ShimmerSweep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
              end: Alignment(-0.5 + 2.0 * _controller.value, 0),
              colors: const [
                Colors.transparent,
                Color(0x15FFFFFF),
                Colors.transparent,
              ],
            ).createShader(bounds);
          },
          child: child!,
        );
      },
      child: widget.child,
    );
  }
}
