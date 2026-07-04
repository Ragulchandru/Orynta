// lib/features/notes/presentation/widgets/link_attachment_card.dart
//
// Orynta 2.0 — Link Attachment Card Component

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../../domain/models/note_attachment.dart';
import '../providers/note_attachment_providers.dart';

class LinkAttachmentCard extends ConsumerWidget {
  const LinkAttachmentCard({super.key, required this.attachment});

  final NoteAttachment attachment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _MockBrowserPage(attachment: attachment),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20.0),
      child: Ink(
        height: 120,
        decoration: BoxDecoration(
          color: context.colors.surfaceContainer,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: context.colors.outlineVariant.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.public_rounded,
                    size: 20,
                    color: context.colors.primary,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ref.read(noteAttachmentsProvider(attachment.noteId).notifier).removeAttachment(attachment.id);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: context.colors.outlineVariant.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close_rounded, size: 14, color: context.colors.textPrimary),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  attachment.fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.typography.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  attachment.localPath,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.typography.labelSmall.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MockBrowserPage extends StatelessWidget {
  const _MockBrowserPage({required this.attachment});
  final NoteAttachment attachment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        backgroundColor: context.colors.surfaceContainerLow,
        elevation: 1.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Row(
            children: [
              Icon(Icons.lock_rounded, size: 14, color: context.colors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  attachment.localPath,
                  overflow: TextOverflow.ellipsis,
                  style: context.typography.labelMedium.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
              Icon(Icons.refresh_rounded, size: 16, color: context.colors.textSecondary),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  attachment.fileName,
                  style: context.typography.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: context.colors.primary.withValues(alpha: 0.1),
                      child: Icon(Icons.public, size: 14, color: context.colors.primary),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Secured Web Connection',
                      style: context.typography.labelMedium.copyWith(color: context.colors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  attachment.thumbnailPath ?? 'No description available.',
                  style: context.typography.bodyMedium.copyWith(
                    color: context.colors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: context.colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Article Summary',
                        style: context.typography.titleSmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'This is a read-only reader view of the webpage. Orynta automatically parses web links to make them readable offline and conserve data.',
                        style: context.typography.bodyMedium.copyWith(
                          color: context.colors.textPrimary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
