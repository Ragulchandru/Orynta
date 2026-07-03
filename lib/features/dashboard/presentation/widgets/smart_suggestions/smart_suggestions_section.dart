// lib/features/dashboard/presentation/widgets/smart_suggestions/smart_suggestions_section.dart
//
// Orynta 2.0 — Smart Suggestions Section Component

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/design_system/design_tokens.dart';
import '../../providers/smart_suggestions_providers.dart';
import 'smart_suggestion_card.dart';
import 'smart_suggestions_empty_state.dart';
import 'smart_suggestions_loading.dart';

class SmartSuggestionsSection extends ConsumerWidget {
  const SmartSuggestionsSection({super.key});

  int _calculateCrossAxisCount(double screenWidth) {
    if (screenWidth < 600) return 1;
    if (screenWidth < 1000) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(smartSuggestionsControllerProvider);
    final controller = ref.read(smartSuggestionsControllerProvider.notifier);
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = _calculateCrossAxisCount(screenWidth);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Section Header Row
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, left: 4.0, right: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome_outlined,
                    size: 20,
                    color: context.colors.primary,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Smart Suggestions',
                        style: context.typography.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      Text(
                        'Helpful recommendations for today',
                        style: context.typography.bodySmall.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: () {},
                borderRadius: context.radius.borderRadiusSm,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        'View All',
                        style: context.typography.labelMedium.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: context.colors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Body Grid / Empty State / Loading
        if (state.isLoading)
          const SmartSuggestionsLoading()
        else if (state.suggestions.isEmpty)
          const SmartSuggestionsEmptyState()
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 20.0,
              childAspectRatio: screenWidth < 600 ? 2.2 : 1.6,
            ),
            itemCount: state.suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = state.suggestions[index];
              return SmartSuggestionCard(
                suggestion: suggestion,
                onTap: () => controller.onSuggestionTap(suggestion, context),
              );
            },
          ),
      ],
    );
  }
}
