// lib/features/notes/presentation/widgets/image_attachment_card.dart
//
// Orynta 2.0 — Image Attachment Card Component

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../../domain/models/note_attachment.dart';
import '../providers/note_attachment_providers.dart';

class ImageAttachmentCard extends ConsumerWidget {
  const ImageAttachmentCard({super.key, required this.attachment});

  final NoteAttachment attachment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (context, _, __) => _ImageFullscreenPreview(attachment: attachment),
          ),
        );
      },
      child: Hero(
        tag: 'attachment_image_${attachment.id}',
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: context.colors.surfaceContainer,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: context.colors.outlineVariant.withValues(alpha: 0.3)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                File(attachment.localPath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: context.colors.surfaceContainerHigh,
                  child: Icon(Icons.broken_image_rounded, color: context.colors.textSecondary),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.65),
                      ],
                    ),
                  ),
                ),
              ),
              // Delete Button
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    ref.read(noteAttachmentsProvider(attachment.noteId).notifier).removeAttachment(attachment.id);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
                  ),
                ),
              ),
              // Details
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        attachment.fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.typography.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        attachment.formattedSize,
                        style: context.typography.labelSmall.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
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

class _ImageFullscreenPreview extends StatefulWidget {
  const _ImageFullscreenPreview({required this.attachment});
  final NoteAttachment attachment;

  @override
  State<_ImageFullscreenPreview> createState() => _ImageFullscreenPreviewState();
}

class _ImageFullscreenPreviewState extends State<_ImageFullscreenPreview> {
  double _dragOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          _dragOffset += details.delta.dy;
        });
      },
      onVerticalDragEnd: (details) {
        if (_dragOffset.abs() > 100) {
          Navigator.pop(context);
        } else {
          setState(() {
            _dragOffset = 0.0;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black.withValues(alpha: (1.0 - (_dragOffset.abs() / 300)).clamp(0.0, 1.0)),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Transform.translate(
              offset: Offset(0.0, _dragOffset),
              child: InteractiveViewer(
                minScale: 1.0,
                maxScale: 4.0,
                child: Center(
                  child: Hero(
                    tag: 'attachment_image_${widget.attachment.id}',
                    child: Image.file(
                      File(widget.attachment.localPath),
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image_rounded,
                        size: 64,
                        color: Colors.white24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 16,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black38,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
