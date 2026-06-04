import 'package:flutter/material.dart';
import '../core/components/glass_scaffold.dart';
import '../core/components/branded_empty_state.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';

class NoResultsScreen extends StatelessWidget {
  const NoResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: SpottColors.textPrimary),
        title: const Text('Search Results', style: SpottTextStyles.titleSmall),
        centerTitle: true,
      ),
      body: BrandedEmptyState.noResults(
        onAction: () => Navigator.pop(context),
      ),
    );
  }
}
