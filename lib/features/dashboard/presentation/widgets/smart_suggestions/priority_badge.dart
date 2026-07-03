// lib/features/dashboard/presentation/widgets/smart_suggestions/priority_badge.dart
//
// Orynta 2.0 — Suggestion Priority Badge Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../../domain/models/suggestion_priority.dart';

class PriorityBadge extends StatelessWidget {
  const PriorityBadge({
    super.key,
    required this.priority,
  });

  final SuggestionPriority priority;

  @override
  Widget build(BuildContext context) {
    late final Color badgeColor;
    late final String label;

    switch (priority) {
      case SuggestionPriority.high:
        badgeColor = context.colors.error;
        label = 'High Priority';
      case SuggestionPriority.medium:
        badgeColor = context.colors.primary;
        label = 'Medium';
      case SuggestionPriority.low:
        badgeColor = context.colors.textSecondary;
        label = 'Low';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: context.radius.borderRadiusSm,
      ),
      child: Text(
        label,
        style: context.typography.labelSmall.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}
