import 'package:flutter/material.dart';
import 'package:spotter/helper.dart';

class CustomCard extends StatelessWidget {
  final List<Widget> children;
  final double vertical;
  final double horizontal;
  final double height;
  final bool hasShadow;

  const CustomCard({
    super.key,
    required this.children,
    this.vertical = 12.0,
    this.horizontal = 12.0,
    this.height = 148,
    this.hasShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Helper.line(context)),
        boxShadow: hasShadow ? Helper.premiumShadows : null,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: vertical,
          horizontal: horizontal,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: children,
        ),
      ),
    );
  }
}
