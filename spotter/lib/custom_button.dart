import 'package:spotter/design_system/design_system.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'helper.dart';


class CustomButton extends StatelessWidget {
  final Widget? targetScreen;
  final String? routeName;
  final VoidCallback? onPressed;
  final String label;
  final bool isDark;
  final bool isGhost;

  const CustomButton({
    super.key,
    this.targetScreen,
    this.routeName,
    this.onPressed,
    this.label = "Get Started",
    this.isDark = true,
    this.isGhost = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeDark = Theme.of(context).brightness == Brightness.dark;

    Widget buttonContent;

    if (isGhost) {
      if (themeDark) {
        buttonContent = ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
            child: Container(
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05), // T.glass
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.14), // T.glassEdge
                  width: 1.0,
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Helper.textHi,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        buttonContent = Container(
          height: 56,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: DSColors.border, width: 1.5),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: DSColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    } else {
      final List<Color> gradientColors = themeDark
          ? [
              Helper.primary,
              const Color(0xFFA51229),
            ] // Premium coral-red gradient
          : [Helper.primary, const Color(0xFFC42538)];

      buttonContent = Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          boxShadow: themeDark
              ? [
                  BoxShadow(
                    color: Helper.primary.withValues(alpha: 0.28), // T.priGlow
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Helper.primary.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1.0,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.1,
            ),
          ),
        ),
      );
    }

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
          child: buttonContent,
        ),
      ),
    );
  }
}

