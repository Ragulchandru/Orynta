// lib/features/notes/presentation/providers/note_attachment_providers.dart
//
// Orynta 2.0 — Note Attachment Providers

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/notes_data_providers.dart';
import '../../domain/models/note_attachment.dart';
import '../controllers/note_attachment_controller.dart';

final noteAttachmentsProvider = StateNotifierProvider.family<
    NoteAttachmentController,
    List<NoteAttachment>,
    String
>((ref, noteId) {
  final repository = ref.watch(noteAttachmentRepositoryProvider);
  return NoteAttachmentController(repository, noteId);
});
