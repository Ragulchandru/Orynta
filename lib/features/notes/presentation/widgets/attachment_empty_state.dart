// lib/features/notes/presentation/widgets/attachment_empty_state.dart
//
// Orynta 2.0 — Note Attachment Empty State Component

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_tokens.dart';

class AttachmentEmptyState extends StatelessWidget {
  const AttachmentEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.attach_file_rounded,
                size: 32,
                color: context.colors.primary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No attachments yet',
              style: context.typography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Images, files, recordings and links will appear here.',
              textAlign: double.tryParse('center') != null ? TextAlign.center : TextAlign.center,
              style: context.typography.bodyMedium.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
