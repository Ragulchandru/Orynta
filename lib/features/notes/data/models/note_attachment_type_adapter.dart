// lib/features/notes/data/models/note_attachment_type_adapter.dart
//
// Orynta 2.0 — Note Attachment Hive TypeAdapter

import 'package:hive_flutter/hive_flutter.dart';
import 'note_attachment_model.dart';

class NoteAttachmentTypeAdapter extends TypeAdapter<NoteAttachmentModel> {
  @override
  final int typeId = 1; // Under Notes feature, unique type ID 1

  @override
  NoteAttachmentModel read(BinaryReader reader) {
    final id = reader.readString();
    final noteId = reader.readString();
    final typeIndex = reader.readInt();
    final fileName = reader.readString();
    final localPath = reader.readString();
    final sizeBytes = reader.readInt();
    final createdAtMs = reader.readInt();

    final hasThumbnail = reader.readBool();
    final thumbnailPath = hasThumbnail ? reader.readString() : null;

    final hasDuration = reader.readBool();
    final durationMs = hasDuration ? reader.readInt() : null;

    final hasMimeType = reader.readBool();
    final mimeType = hasMimeType ? reader.readString() : null;

    return NoteAttachmentModel(
      id: id,
      noteId: noteId,
      typeIndex: typeIndex,
      fileName: fileName,
      localPath: localPath,
      sizeBytes: sizeBytes,
      createdAtMs: createdAtMs,
      thumbnailPath: thumbnailPath,
      durationMs: durationMs,
      mimeType: mimeType,
    );
  }

  @override
  void write(BinaryWriter writer, NoteAttachmentModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.noteId);
    writer.writeInt(obj.typeIndex);
    writer.writeString(obj.fileName);
    writer.writeString(obj.localPath);
    writer.writeInt(obj.sizeBytes);
    writer.writeInt(obj.createdAtMs);

    writer.writeBool(obj.thumbnailPath != null);
    if (obj.thumbnailPath != null) {
      writer.writeString(obj.thumbnailPath!);
    }

    writer.writeBool(obj.durationMs != null);
    if (obj.durationMs != null) {
      writer.writeInt(obj.durationMs!);
    }

    writer.writeBool(obj.mimeType != null);
    if (obj.mimeType != null) {
      writer.writeString(obj.mimeType!);
    }
  }
}
