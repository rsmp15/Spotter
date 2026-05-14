import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final List<Widget> children;
  final double vertical;
  final double horizontal;
  final double height;

  const CustomCard({
    super.key,
    required this.children,
    this.vertical = 12.0,
    this.horizontal = 12.0,
    this.height = 148,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40111111),
            offset: Offset(0, 3),
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
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
