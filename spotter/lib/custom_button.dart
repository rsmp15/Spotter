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
    final themeDark = Theme.of(context).brightness == Brightness.dark;
    
    final Color buttonBg = themeDark
        ? (isDark ? Colors.white : const Color(0xFF1E1E24))
        : (isDark ? Helper.ink : Colors.white);
        
    final Color borderColor = themeDark
        ? (isDark ? Colors.white : const Color(0xFF2C2C2C))
        : (isDark ? Helper.ink : Helper.lineColor);
        
    final Color textColor = themeDark
        ? (isDark ? Colors.black : Colors.white)
        : (isDark ? Colors.white : Helper.ink);

    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
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
              borderRadius: BorderRadius.circular(999),
              color: buttonBg,
              border: Border.all(color: borderColor),
            ),
            height: 56,
            width: double.infinity,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
