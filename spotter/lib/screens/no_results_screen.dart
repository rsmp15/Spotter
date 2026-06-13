import 'package:spotter/design_system/design_system.dart';
import 'package:flutter/material.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/branded_empty_state.dart';



class NoResultsScreen extends StatelessWidget {
  const NoResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: DSColors.textPrimary),
        title: Text('Search Results', style: DSTypography.titleLarge),
        centerTitle: true,
      ),
      body: BrandedEmptyState.noResults(
        onAction: () => Navigator.pop(context),
      ),
    );
  }
}
