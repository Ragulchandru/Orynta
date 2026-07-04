// lib/features/notes/data/repositories/note_attachment_repository_impl.dart
//
// Orynta 2.0 — Note Attachment Repository Implementation

import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/models/note_attachment.dart';
import '../../domain/repositories/note_attachment_repository.dart';
import '../models/note_attachment_model.dart';

class NoteAttachmentRepositoryImpl implements NoteAttachmentRepository {
  NoteAttachmentRepositoryImpl({Box<NoteAttachmentModel>? box})
      : _box = box ?? Hive.box<NoteAttachmentModel>(AppStrings.attachmentsBoxName);

  final Box<NoteAttachmentModel> _box;

  @override
  Future<List<NoteAttachment>> getAttachmentsForNote(String noteId) async {
    return _box.values
        .where((model) => model.noteId == noteId)
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<void> saveAttachment(NoteAttachment attachment) async {
    final model = NoteAttachmentModel.fromEntity(attachment);
    await _box.put(attachment.id, model);
  }

  @override
  Future<void> deleteAttachment(String attachmentId) async {
    await _box.delete(attachmentId);
  }
}
