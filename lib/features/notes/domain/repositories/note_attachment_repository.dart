// lib/features/notes/domain/repositories/note_attachment_repository.dart
//
// Orynta 2.0 — Note Attachment Repository Interface

import '../models/note_attachment.dart';

abstract class NoteAttachmentRepository {
  Future<List<NoteAttachment>> getAttachmentsForNote(String noteId);
  Future<void> saveAttachment(NoteAttachment attachment);
  Future<void> deleteAttachment(String attachmentId);
}
