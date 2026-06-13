import 'package:flutter/material.dart';
import 'package:spotter/design_system/design_system.dart';

class TokenVisualReference extends StatelessWidget {
  const TokenVisualReference({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DSColors.background,
      appBar: AppBar(
        title: Text('Design System Tokens', style: DSTypography.headline),
        backgroundColor: DSColors.surface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(DSSpacing.page),
        children: [
          Text('Typography', style: DSTypography.displayLarge),
          const SizedBox(height: DSSpacing.md),
          Text('displayXL', style: DSTypography.displayXL),
          Text('displayLarge', style: DSTypography.displayLarge),
          Text('headline', style: DSTypography.headline),
          Text('titleLarge', style: DSTypography.titleLarge),
          Text('bodyLarge', style: DSTypography.bodyLarge),
          Text('body', style: DSTypography.body),
          Text('labelLarge', style: DSTypography.labelLarge),
          Text('caption', style: DSTypography.caption),
          
          const SizedBox(height: DSSpacing.xl),
          Text('Colors', style: DSTypography.displayLarge),
          const SizedBox(height: DSSpacing.md),
          Wrap(
            spacing: DSSpacing.sm,
            runSpacing: DSSpacing.sm,
            children: [
              _ColorBox('primary', DSColors.primary),
              _ColorBox('primaryDark', DSColors.primaryDark),
              _ColorBox('surface', DSColors.surface),
              _ColorBox('surfaceVariant', DSColors.surfaceVariant),
              _ColorBox('success', DSColors.success),
              _ColorBox('warning', DSColors.warning),
              _ColorBox('danger', DSColors.danger),
              _ColorBox('info', DSColors.info),
            ],
          ),

          const SizedBox(height: DSSpacing.xl),
          Text('Radii & Shadows', style: DSTypography.displayLarge),
          const SizedBox(height: DSSpacing.md),
          Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: DSColors.surface,
                  borderRadius: BorderRadius.circular(DSRadius.card),
                  boxShadow: DSShadows.elevation2,
                ),
                alignment: Alignment.center,
                child: Text('Card\nElev 2', textAlign: TextAlign.center, style: DSTypography.caption),
              ),
              const SizedBox(width: DSSpacing.md),
              Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                  color: DSColors.primary,
                  borderRadius: BorderRadius.circular(DSRadius.button),
                  boxShadow: DSShadows.elevation1,
                ),
                alignment: Alignment.center,
                child: Text('Button', style: DSTypography.labelLarge.copyWith(color: DSColors.onPrimary)),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _ColorBox extends StatelessWidget {
  final String label;
  final Color color;

  const _ColorBox(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(DSRadius.md),
            border: Border.all(color: DSColors.border),
          ),
        ),
        const SizedBox(height: DSSpacing.xs),
        Text(label, style: DSTypography.caption),
      ],
    );
  }
}
