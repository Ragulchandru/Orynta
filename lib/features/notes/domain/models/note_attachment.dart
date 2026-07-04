// lib/features/notes/domain/models/note_attachment.dart
//
// Orynta 2.0 — Note Attachment Domain Model

import 'attachment_type.dart';

class NoteAttachment {
  const NoteAttachment({
    required this.id,
    required this.noteId,
    required this.type,
    required this.fileName,
    required this.localPath,
    required this.sizeBytes,
    required this.createdAt,
    this.thumbnailPath,
    this.duration,
    this.mimeType,
  });

  final String id;
  final String noteId;
  final AttachmentType type;
  final String fileName;
  final String localPath;
  final int sizeBytes;
  final DateTime createdAt;
  final String? thumbnailPath;
  final Duration? duration;
  final String? mimeType;

  String get formattedSize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  bool get isImage => type == AttachmentType.image || type == AttachmentType.camera;
  bool get isAudio => type == AttachmentType.audio;
  bool get isDocument => type == AttachmentType.pdf || type == AttachmentType.document;

  NoteAttachment copyWith({
    String? id,
    String? noteId,
    AttachmentType? type,
    String? fileName,
    String? localPath,
    int? sizeBytes,
    DateTime? createdAt,
    String? thumbnailPath,
    Duration? duration,
    String? mimeType,
  }) {
    return NoteAttachment(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      type: type ?? this.type,
      fileName: fileName ?? this.fileName,
      localPath: localPath ?? this.localPath,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      createdAt: createdAt ?? this.createdAt,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      duration: duration ?? this.duration,
      mimeType: mimeType ?? this.mimeType,
    );
  }
}
