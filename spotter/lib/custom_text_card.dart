import 'package:flutter/material.dart';

class CustomTextCard extends StatelessWidget {
  final List<Widget> children;
  final double width;
  final double height;
  final double vertical;
  final double horizontal;

  const CustomTextCard({
    super.key,
    required this.children,
    this.width = double.infinity,
    this.height = 100,
    this.vertical = 10,
    this.horizontal = 12,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: height,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : const Color(0xFFE5E5E5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
