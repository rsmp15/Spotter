import 'package:flutter/material.dart';

import 'custom_button.dart';
import 'helper.dart';

class SpotterScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> content;
  final Widget? bottom;
  final bool showBack;

  const SpotterScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.content,
    this.bottom,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = this.bottom;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            24 + MediaQuery.viewPaddingOf(context).bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showBack)
                IconButton(
                  onPressed: () => Navigator.maybePop(context),
                  icon: const Icon(Icons.arrow_back),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Helper.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Helper.muted,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: ListView(
                  children: [
                    ...content,
                    if (bottom != null) const SizedBox(height: 20),
                    ?bottom,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SpotterCard extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets padding;
  final Color color;
  final double? height;
  final VoidCallback? onTap;

  const SpotterCard({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(18),
    this.color = Helper.cardColor,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Ink(
      height: height,
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Helper.lineColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14111827),
            offset: Offset(0, 8),
            blurRadius: 18,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: card,
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = Helper.ink,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Helper.muted, fontSize: 14),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const StatusChip({
    super.key,
    required this.label,
    this.color = Helper.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class MapPlaceholder extends StatelessWidget {
  final double height;

  const MapPlaceholder({super.key, this.height = 170});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Helper.mapFill,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 45,
            right: 45,
            top: height / 2,
            child: Container(height: 8, color: const Color(0xFFB5CEFF)),
          ),
          Positioned(
            left: 66,
            top: height / 2 - 15,
            child: _MapDot(color: Helper.success, label: 'Pickup'),
          ),
          Positioned(
            right: 66,
            top: height / 2 - 15,
            child: _MapDot(color: Helper.danger, label: 'Drop'),
          ),
        ],
      ),
    );
  }
}

class _MapDot extends StatelessWidget {
  final Color color;
  final String label;

  const _MapDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class RideTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;
  final String price;
  final VoidCallback? onTap;

  const RideTile({
    super.key,
    required this.icon,
    required this.title,
    required this.detail,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SpotterCard(
      height: 92,
      onTap: onTap,
      children: [
        Row(
          children: [
            Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                color: Helper.mapFill,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 30),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    detail,
                    style: const TextStyle(
                      color: Helper.muted,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}

class PrimaryAction extends StatelessWidget {
  final String label;
  final Widget? targetScreen;
  final String? routeName;
  final VoidCallback? onPressed;

  const PrimaryAction({
    super.key,
    required this.label,
    this.targetScreen,
    this.routeName,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      label: label,
      targetScreen: targetScreen,
      routeName: routeName,
      onPressed: onPressed,
    );
  }
}
