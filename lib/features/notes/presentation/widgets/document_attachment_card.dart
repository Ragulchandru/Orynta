// lib/features/notes/presentation/widgets/document_attachment_card.dart
//
// Orynta 2.0 — Document Attachment Card Component

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../../domain/models/attachment_type.dart';
import '../../domain/models/note_attachment.dart';
import '../providers/note_attachment_providers.dart';

class DocumentAttachmentCard extends ConsumerWidget {
  const DocumentAttachmentCard({super.key, required this.attachment});

  final NoteAttachment attachment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPdf = attachment.type == AttachmentType.pdf;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _DocumentViewerPage(attachment: attachment),
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
                Icon(
                  isPdf ? Icons.picture_as_pdf_rounded : Icons.description_rounded,
                  size: 32,
                  color: isPdf ? Colors.redAccent : context.colors.primary,
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
                  attachment.formattedSize,
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

class _DocumentViewerPage extends StatelessWidget {
  const _DocumentViewerPage({required this.attachment});
  final NoteAttachment attachment;

  @override
  Widget build(BuildContext context) {
    final isPdf = attachment.type == AttachmentType.pdf;

    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        elevation: 0,
        title: Text(
          attachment.fileName,
          style: context.typography.titleMedium.copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Icon(
                isPdf ? Icons.picture_as_pdf_rounded : Icons.description_rounded,
                size: 96,
                color: isPdf ? Colors.redAccent : context.colors.primary,
              ),
              const SizedBox(height: 24),
              Text(
                attachment.fileName,
                textAlign: TextAlign.center,
                style: context.typography.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Size: ${attachment.formattedSize}  •  Offline File',
                style: context.typography.bodyMedium.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              const SizedBox(height: 40),
              Divider(color: context.colors.outlineVariant),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: context.colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: context.colors.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Document Preview',
                          style: context.typography.titleSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colors.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'This is a local secure document offline preview.\n\n'
                          'File Path:\n${attachment.localPath}\n\n'
                          'Content Extract:\n'
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                          style: context.typography.bodyMedium.copyWith(
                            color: context.colors.textPrimary,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
