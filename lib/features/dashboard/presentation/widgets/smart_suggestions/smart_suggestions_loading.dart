// lib/features/dashboard/presentation/widgets/smart_suggestions/smart_suggestions_loading.dart
//
// Orynta 2.0 — Smart Suggestions Loading Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';

class SmartSuggestionsLoading extends StatelessWidget {
  const SmartSuggestionsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = context.colors.outlineVariant.withValues(alpha: 0.3);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: context.radius.borderRadiusLg,
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 140,
                height: 18,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: context.radius.borderRadiusSm,
                ),
              ),
              Container(
                width: 50,
                height: 14,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: context.radius.borderRadiusSm,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 14,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: context.radius.borderRadiusSm,
            ),
          ),
        ],
      ),
    );
  }
}
