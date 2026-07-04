// lib/features/planner/domain/entities/task_attachment_entity.dart
//
// Orynta 2.0 — Task Attachment Entity

import 'package:flutter/foundation.dart';

@immutable
class TaskAttachmentEntity {
  const TaskAttachmentEntity({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.fileType,
    required this.sizeBytes,
  });

  final String id;
  final String filePath;
  final String fileName;
  final String fileType;
  final int sizeBytes;

  TaskAttachmentEntity copyWith({
    String? id,
    String? filePath,
    String? fileName,
    String? fileType,
    int? sizeBytes,
  }) {
    return TaskAttachmentEntity(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskAttachmentEntity &&
        other.id == id &&
        other.filePath == filePath &&
        other.fileName == fileName &&
        other.fileType == fileType &&
        other.sizeBytes == sizeBytes;
  }

  @override
  int get hashCode => Object.hash(id, filePath, fileName, fileType, sizeBytes);
}
