// lib/features/dashboard/presentation/widgets/recent_notes/recent_notes_empty_state.dart
//
// Orynta 2.0 — Recent Notes Empty State Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';

class RecentNotesEmptyState extends StatelessWidget {
  const RecentNotesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.colors.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: context.radius.borderRadiusLg,
        border: Border.all(
          color: context.colors.outlineVariant.withValues(alpha: 0.6),
        ),
        boxShadow: context.shadows.small,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.note_alt_outlined,
              size: 28,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No recent notes.',
            style: context.typography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your next idea is waiting.',
            style: context.typography.bodySmall.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
