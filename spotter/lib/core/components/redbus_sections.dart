import 'package:flutter/material.dart';
import 'package:spotter/design_system/design_system.dart';

/// Enum to represent different visual styles of RedBus sections
enum RBSectionStyle {
  brandHero,
  white,
  rewards,
  community,
  marketplace,
  wallet,
  floating,
}

/// A container representing a RedBus-style Content Zone / Section
class RBSectionContainer extends StatelessWidget {
  final Widget child;
  final RBSectionStyle style;
  final double? topRadius;
  final double? bottomRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool showBorder;

  const RBSectionContainer({
    super.key,
    required this.child,
    this.style = RBSectionStyle.white,
    this.topRadius,
    this.bottomRadius,
    this.padding,
    this.margin,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;

    BoxDecoration decoration;
    EdgeInsetsGeometry defaultPadding = const EdgeInsets.symmetric(
      horizontal: 12.0,
      vertical: 24,
    );
    EdgeInsetsGeometry defaultMargin = EdgeInsets.zero;

    final double tRadius = topRadius ?? 0.0;
    final double bRadius = bottomRadius ?? 0.0;

    switch (style) {
      case RBSectionStyle.brandHero:
        decoration = BoxDecoration(
          color: isDark ? const Color(0xFF1C1C1C) : const Color(0xFF000000),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(tRadius),
            topRight: Radius.circular(tRadius),
            bottomLeft: Radius.circular(bRadius),
            bottomRight: Radius.circular(bRadius),
          ),
        );
        break;
      case RBSectionStyle.white:
        decoration = BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(tRadius),
            topRight: Radius.circular(tRadius),
            bottomLeft: Radius.circular(bRadius),
            bottomRight: Radius.circular(bRadius),
          ),
          border: showBorder ? Border.all(color: palette.border) : null,
        );
        break;
      case RBSectionStyle.rewards:
        decoration = BoxDecoration(
          color: palette.surfaceVariant,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(tRadius),
            topRight: Radius.circular(tRadius),
            bottomLeft: Radius.circular(bRadius),
            bottomRight: Radius.circular(bRadius),
          ),
          border: Border.all(color: palette.border, width: 1),
        );
        break;
      case RBSectionStyle.community:
        decoration = BoxDecoration(
          color: palette.surfaceVariant,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(tRadius),
            topRight: Radius.circular(tRadius),
            bottomLeft: Radius.circular(bRadius),
            bottomRight: Radius.circular(bRadius),
          ),
          border: Border.all(color: palette.border, width: 1),
        );
        break;
      case RBSectionStyle.marketplace:
        decoration = BoxDecoration(
          color: palette.surfaceVariant,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(tRadius),
            topRight: Radius.circular(tRadius),
            bottomLeft: Radius.circular(bRadius),
            bottomRight: Radius.circular(bRadius),
          ),
        );
        break;
      case RBSectionStyle.wallet:
        decoration = BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(tRadius),
            topRight: Radius.circular(tRadius),
            bottomLeft: Radius.circular(bRadius),
            bottomRight: Radius.circular(bRadius),
          ),
        );
        break;
      case RBSectionStyle.floating:
        decoration = BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: palette.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        );
        defaultPadding = const EdgeInsets.all(16);
        defaultMargin = const EdgeInsets.symmetric(horizontal: 12, vertical: 12);
        break;
    }

    return Container(
      width: double.infinity,
      padding: padding ?? defaultPadding,
      margin: margin ?? defaultMargin,
      decoration: decoration,
      child: child,
    );
  }
}

/// A premium header for RedBus-style sections
class RBSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color titleColor;
  final Color subtitleColor;

  const RBSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.titleColor = DSColors.textPrimary,
    this.subtitleColor = DSColors.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                    letterSpacing: -0.3,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: DSColors.primary,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionLabel!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.chevron_right_rounded, size: 16),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// A clipper that creates a RedBus-style wave curve at the bottom or top of a container
class RBWaveClipper extends CustomClipper<Path> {
  final bool waveAtTop;

  RBWaveClipper({this.waveAtTop = false});

  @override
  Path getClip(Size size) {
    final path = Path();
    if (waveAtTop) {
      path.moveTo(0, 16);
      path.quadraticBezierTo(size.width / 4, 0, size.width / 2, 16);
      path.quadraticBezierTo(size.width * 3 / 4, 32, size.width, 16);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height - 16);
      path.quadraticBezierTo(size.width * 3 / 4, size.height, size.width / 2, size.height - 16);
      path.quadraticBezierTo(size.width / 4, size.height - 32, 0, size.height - 16);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// A widget that draws a wavy color transition between sections
class RBWaveSeparator extends StatelessWidget {
  final Color topColor;
  final Color bottomColor;
  final double height;

  const RBWaveSeparator({
    super.key,
    required this.topColor,
    required this.bottomColor,
    this.height = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bottomColor,
      child: ClipPath(
        clipper: RBWaveClipper(waveAtTop: false),
        child: Container(
          height: height,
          color: topColor,
        ),
      ),
    );
  }
}

/// A carousel container displaying horizontal cards with dot pagination indicators
class RBCarouselSection extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final List<Widget> items;
  final double itemHeight;

  const RBCarouselSection({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    required this.items,
    required this.itemHeight,
  });

  @override
  State<RBCarouselSection> createState() => _RBCarouselSectionState();
}

class _RBCarouselSectionState extends State<RBCarouselSection> {
  int _currentIndex = 0;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        final double offset = _scrollController.offset;
        final double maxScrollExtent = _scrollController.position.maxScrollExtent;
        final int index = ((offset / (maxScrollExtent > 0 ? maxScrollExtent : 1.0)) * (widget.items.length - 1)).round();
        if (index != _currentIndex && index >= 0 && index < widget.items.length) {
          setState(() {
            _currentIndex = index;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: RBSectionHeader(
            title: widget.title,
            subtitle: widget.subtitle,
            actionLabel: widget.actionLabel,
            onAction: widget.onAction,
          ),
        ),
        SizedBox(
          height: widget.itemHeight,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: widget.items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) => widget.items[index],
          ),
        ),
        if (widget.items.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.items.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentIndex == index ? 16 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentIndex == index ? DSColors.primary : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

