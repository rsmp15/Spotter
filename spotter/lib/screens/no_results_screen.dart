import 'package:flutter/cupertino.dart';
import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/branded_empty_state.dart';



class NoResultsScreen extends StatelessWidget {
  const NoResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = isDark ? DSPalettes.dark : DSPalettes.light;
    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            CupertinoIcons.arrow_left,
            color: palette.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Search Results',
          style: DSTypography.titleLarge.copyWith(
            color: palette.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: BrandedEmptyState.noResults(
        onAction: () => Navigator.pop(context),
      ),
    );
  }
}


