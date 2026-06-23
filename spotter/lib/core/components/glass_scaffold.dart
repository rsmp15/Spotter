import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';
import '../../controllers/ride_controller.dart';

class GlassScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  const GlassScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = RideScope.of(context).isDarkMode;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;
    return Scaffold(
      backgroundColor: palette.background,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: SafeArea(child: body),
    );
  }
}

