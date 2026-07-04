// lib/features/notes/presentation/widgets/attachment_grid.dart
//
// Orynta 2.0 — Responsive Attachment Grid Component

import 'package:flutter/material.dart';
import '../../domain/models/attachment_type.dart';
import '../../domain/models/note_attachment.dart';
import 'image_attachment_card.dart';
import 'document_attachment_card.dart';
import 'audio_attachment_card.dart';
import 'link_attachment_card.dart';

class AttachmentGrid extends StatelessWidget {
  const AttachmentGrid({super.key, required this.attachments});

  final List<NoteAttachment> attachments;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    if (width >= 900) {
      crossAxisCount = 4;
    } else if (width >= 600) {
      crossAxisCount = 3;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
        childAspectRatio: 1.3,
      ),
      itemCount: attachments.length,
      itemBuilder: (context, index) {
        final attachment = attachments[index];
        if (attachment.isImage) {
          return ImageAttachmentCard(attachment: attachment);
        } else if (attachment.isAudio) {
          return AudioAttachmentCard(attachment: attachment);
        } else if (attachment.type == AttachmentType.link) {
          return LinkAttachmentCard(attachment: attachment);
        } else {
          return DocumentAttachmentCard(attachment: attachment);
        }
      },
    );
  }
}
