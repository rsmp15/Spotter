import 'package:flutter/material.dart';
import '../theme/animations.dart';

/// Reusable stagger-in entrance animation widget.
/// Wraps a child with a slide + fade transition that triggers on first build.
/// Use [delay] to stagger multiple items in a list.
class AnimatedEntrance extends StatefulWidget {
  final Widget child;
  final int delay;
  final Duration duration;
  final Offset slideOffset;

  const AnimatedEntrance({
    super.key,
    required this.child,
    this.delay = 0,
    this.duration = const Duration(milliseconds: 400),
    this.slideOffset = const Offset(0, 0.08),
  });

  @override
  State<AnimatedEntrance> createState() => _AnimatedEntranceState();
}

class _AnimatedEntranceState extends State<AnimatedEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: SpottCurves.emphasized,
    );
    _slideAnim = Tween<Offset>(
      begin: widget.slideOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: SpottCurves.emphasized,
    ));

    // Stagger delay
    Future.delayed(
      Duration(milliseconds: widget.delay * SpottAnimations.stagger.inMilliseconds),
      () {
        if (mounted) _controller.forward();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: widget.child,
      ),
    );
  }
}
