import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PremiumSosAlertScreen extends StatefulWidget {
  const PremiumSosAlertScreen({super.key});

  @override
  State<PremiumSosAlertScreen> createState() => _PremiumSosAlertScreenState();
}

class _PremiumSosAlertScreenState extends State<PremiumSosAlertScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    // Creates a smooth, continuous pulsing effect
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0000), // Deepest red/black base
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color(0xFF8B0000), // Vibrant dark red center
              Color(0xFF1A0000), // Almost black edges
            ],
            radius: 1.2,
            center: Alignment.center,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final double screenHeight = constraints.maxHeight;
                  final bool isInsideShell = !Navigator.canPop(context);
                  
                  // Adjust bottom padding dynamically: if inside navigation shell, add 64 to clear the bottom navigation bar.
                  final double bottomPadding = 24.0 + (isInsideShell ? 64.0 : 0.0);
                  
                  // Responsive sizing to fit small screens (like iPhone SE/web preview inside tab shell)
                  final double shieldSize = screenHeight > 650 ? 160.0 : 120.0;
                  final double innerShieldCoreSize = screenHeight > 650 ? 100.0 : 80.0;
                  final double shieldIconSize = screenHeight > 650 ? 50.0 : 40.0;

                  final double topGap = screenHeight > 700 
                      ? 40.0 
                      : (screenHeight > 600 ? 20.0 : 10.0);
                  final double bottomGap = screenHeight > 700 
                      ? 40.0 
                      : (screenHeight > 600 ? 20.0 : 10.0);

                  return Padding(
                    padding: EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      top: 24.0,
                      bottom: bottomPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: topGap),
                            // Header
                            Text(
                              _isActive ? 'SOS ACTIVATED' : 'Slide to SOS',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 4.0,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _isActive
                                  ? 'Emergency response has been dispatched.\nYour live location and audio are being shared.'
                                  : 'Swipe the button to send an emergency alert.\nKeep your phone with you and stay calm.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),

                        // Pulsating Premium Shield/Icon
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Container(
                                width: shieldSize,
                                height: shieldSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFFF0000).withValues(alpha: 0.15),
                                  border: Border.all(
                                    color: const Color(0xFFFF0000).withValues(alpha: 0.5),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF0000).withValues(alpha: 0.4),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Container(
                                    width: innerShieldCoreSize,
                                    height: innerShieldCoreSize,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFCC0000), // Solid red core
                                    ),
                                    child: Icon(
                                      Icons.shield_rounded,
                                      color: Colors.white,
                                      size: shieldIconSize,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        Column(
                          children: [
                            // ETA / Status Card (Glassmorphism effect)
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.security_update_warning_rounded, color: Colors.white),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Connecting to authorities...',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Do not close the app.',
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.6),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: bottomGap),
                            if (!_isActive)
                              _SlideToActivate(
                                onActivated: () {
                                  HapticFeedback.mediumImpact();
                                  setState(() => _isActive = true);
                                },
                              )
                            else
                              _CancelSosButton(
                                onCancelled: () {
                                  HapticFeedback.lightImpact();
                                  Navigator.pop(context);
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
          if (Navigator.canPop(context))
            Positioned(
                  top: 8,
                  left: 8,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Custom Slide to Activate Widget ---
class _SlideToActivate extends StatefulWidget {
  final VoidCallback onActivated;

  const _SlideToActivate({required this.onActivated});

  @override
  State<_SlideToActivate> createState() => _SlideToActivateState();
}

class _SlideToActivateState extends State<_SlideToActivate> {
  double _dragValue = 0.0;
  bool _activated = false;

  @override
  Widget build(BuildContext context) {
    const double thumbSize = 64.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxDrag = constraints.maxWidth - thumbSize;
        final double progress = (_dragValue / maxDrag).clamp(0.0, 1.0);
        final Color trackColor = Color.lerp(
              const Color(0xFF8B0000),
              const Color(0xFF16A34A),
              progress,
            )!;

        return Container(
          height: thumbSize,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [trackColor.withValues(alpha: 0.22), Colors.white.withValues(alpha: 0.08)],
            ),
            borderRadius: BorderRadius.circular(thumbSize / 2),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Positioned.fill(
                left: 0,
                child: FractionallySizedBox(
                  widthFactor: progress,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: trackColor.withValues(alpha: 0.28),
                      borderRadius: BorderRadius.circular(thumbSize / 2),
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  _activated ? 'SOS SENT' : 'SLIDE TO SOS',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              Positioned(
                left: _dragValue,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (_activated) return;
                    setState(() {
                      _dragValue += details.delta.dx;
                      if (_dragValue < 0) _dragValue = 0;
                      if (_dragValue >= maxDrag) {
                        _dragValue = maxDrag;
                        _activated = true;
                        widget.onActivated();
                      }
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    if (!_activated) {
                      setState(() {
                        _dragValue = 0.0;
                      });
                    }
                  },
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      color: _activated ? const Color(0xFF16A34A) : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      _activated ? Icons.check_rounded : Icons.sos_rounded,
                      color: _activated ? Colors.white : const Color(0xFF8B0000),
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CancelSosButton extends StatelessWidget {
  final VoidCallback onCancelled;

  const _CancelSosButton({required this.onCancelled});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEF4444),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        ),
        onPressed: onCancelled,
        child: const Text(
          'CANCEL SOS',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
