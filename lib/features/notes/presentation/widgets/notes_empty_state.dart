// lib/features/notes/presentation/widgets/notes_empty_state.dart
//
// Orynta 2.0 — Notes Empty State Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';

class NotesEmptyState extends StatelessWidget {
  const NotesEmptyState({
    super.key,
    required this.onCreateNote,
  });

  final VoidCallback onCreateNote;

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.colors.primary;

    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
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
            // Minimal geometric artwork
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.08),
                borderRadius: context.radius.borderRadiusLg,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor, width: 2),
                        borderRadius: context.radius.borderRadiusSm,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.note_add_rounded,
                    size: 32,
                    color: primaryColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Your ideas belong here.',
              textAlign: TextAlign.center,
              style: context.typography.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Create your first note to begin.',
              textAlign: TextAlign.center,
              style: context.typography.bodySmall.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Primary Button: Create Note
            ElevatedButton.icon(
              onPressed: onCreateNote,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Note'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: context.colors.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: context.radius.borderRadiusMd,
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
