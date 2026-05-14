import 'package:flutter/material.dart';

import 'helper.dart';

class CustomButton extends StatelessWidget {
  final Widget? targetScreen;
  final String? routeName;
  final VoidCallback? onPressed;
  final String label;
  final bool isDark;

  const CustomButton({
    super.key,
    this.targetScreen,
    this.routeName,
    this.onPressed,
    this.label = "Get Started",
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            if (onPressed != null) {
              onPressed!();
              return;
            }

            final route = routeName;
            if (route != null) {
              Navigator.pushNamed(context, route);
              return;
            }

            final screen = targetScreen;
            if (screen != null) {
              Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (context) => screen),
              );
            }
          },
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: isDark ? Helper.ink : Colors.white,
              border: Border.all(
                width: isDark ? 0 : 1,
                color: isDark ? Helper.ink : Helper.lineColor,
              ),
            ),
            height: 56,
            width: double.infinity,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.white : Helper.ink,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
