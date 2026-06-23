import 'package:flutter/material.dart';
import '../theme/animations.dart';

/// Wraps a list of children with staggered fade+slide entry animations.
/// Each child enters 50ms after the previous one for a cascading effect.
class StaggeredList extends StatefulWidget {
  final List<Widget> children;
  final Duration staggerDelay;
  final Duration itemDuration;
  final Axis axis;
  final CrossAxisAlignment crossAxisAlignment;

  const StaggeredList({
    super.key,
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 50),
    this.itemDuration = const Duration(milliseconds: 300),
    this.axis = Axis.vertical,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  State<StaggeredList> createState() => _StaggeredListState();
}

class _StaggeredListState extends State<StaggeredList>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _fadeAnimations;
  late final List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.children.length,
      (i) => AnimationController(
        vsync: this,
        duration: widget.itemDuration,
      ),
    );

    _fadeAnimations = _controllers.map((c) {
      return CurvedAnimation(
        parent: c,
        curve: SpottCurves.emphasized,
      );
    }).toList();

    _slideAnimations = _controllers.map((c) {
      return Tween<Offset>(
        begin: widget.axis == Axis.vertical
            ? const Offset(0, 0.08)
            : const Offset(0.08, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: c,
        curve: SpottCurves.emphasized,
      ));
    }).toList();

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      if (!mounted) return;
      await Future.delayed(widget.staggerDelay);
      if (mounted) _controllers[i].forward();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final children = List.generate(widget.children.length, (i) {
      return FadeTransition(
        opacity: _fadeAnimations[i],
        child: SlideTransition(
          position: _slideAnimations[i],
          child: widget.children[i],
        ),
      );
    });

    if (widget.axis == Axis.horizontal) {
      return Row(
        crossAxisAlignment: widget.crossAxisAlignment,
        children: children,
      );
    }

    return Column(
      crossAxisAlignment: widget.crossAxisAlignment,
      children: children,
    );
  }
}

