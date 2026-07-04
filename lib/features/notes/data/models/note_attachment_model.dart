// lib/features/notes/data/models/note_attachment_model.dart
//
// Orynta 2.0 — Note Attachment Data Model

import '../../domain/models/attachment_type.dart';
import '../../domain/models/note_attachment.dart';

class NoteAttachmentModel {
  NoteAttachmentModel({
    required this.id,
    required this.noteId,
    required this.typeIndex,
    required this.fileName,
    required this.localPath,
    required this.sizeBytes,
    required this.createdAtMs,
    this.thumbnailPath,
    this.durationMs,
    this.mimeType,
  });

  final String id;
  final String noteId;
  final int typeIndex;
  final String fileName;
  final String localPath;
  final int sizeBytes;
  final int createdAtMs;
  final String? thumbnailPath;
  final int? durationMs;
  final String? mimeType;

  NoteAttachment toEntity() {
    return NoteAttachment(
      id: id,
      noteId: noteId,
      type: AttachmentType.values[typeIndex],
      fileName: fileName,
      localPath: localPath,
      sizeBytes: sizeBytes,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
      thumbnailPath: thumbnailPath,
      duration: durationMs != null ? Duration(milliseconds: durationMs!) : null,
      mimeType: mimeType,
    );
  }

  factory NoteAttachmentModel.fromEntity(NoteAttachment entity) {
    return NoteAttachmentModel(
      id: entity.id,
      noteId: entity.noteId,
      typeIndex: entity.type.index,
      fileName: entity.fileName,
      localPath: entity.localPath,
      sizeBytes: entity.sizeBytes,
      createdAtMs: entity.createdAt.millisecondsSinceEpoch,
      thumbnailPath: entity.thumbnailPath,
      durationMs: entity.duration?.inMilliseconds,
      mimeType: entity.mimeType,
    );
  }
}
