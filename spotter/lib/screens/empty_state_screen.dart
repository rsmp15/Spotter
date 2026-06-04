import 'package:flutter/material.dart';

import '../core/components/glass_scaffold.dart';
import '../core/components/branded_empty_state.dart';

class EmptyStateScreen extends StatelessWidget {
  const EmptyStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GlassScaffold(
      body: BrandedEmptyState.noTrips(),
    );
  }
}
