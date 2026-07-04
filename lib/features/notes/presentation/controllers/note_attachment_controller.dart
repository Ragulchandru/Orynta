// lib/features/notes/presentation/controllers/note_attachment_controller.dart
//
// Orynta 2.0 — Note Attachment Controller

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/attachment_type.dart';
import '../../domain/models/note_attachment.dart';
import '../../domain/repositories/note_attachment_repository.dart';

class NoteAttachmentController extends StateNotifier<List<NoteAttachment>> {
  NoteAttachmentController(this._repository, this.noteId) : super([]) {
    _loadAttachments();
  }

  final NoteAttachmentRepository _repository;
  final String noteId;

  // Tiny 1x1 transparent PNG bytes to write real mock image files to disk
  static const List<int> _tinyPngBytes = [
    137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 0, 1, 0, 0, 0, 1, 8, 6, 0, 0, 0, 31, 21, 196, 137, 0, 0, 0, 11, 73, 68, 65, 84, 120, 156, 99, 98, 0, 1, 0, 0, 12, 0, 1, 226, 30, 227, 50, 0, 0, 0, 0, 73, 69, 78, 68, 174, 66, 96, 130,
  ];

  Future<void> _loadAttachments() async {
    final attachments = await _repository.getAttachmentsForNote(noteId);
    state = attachments;
  }

  Future<Directory> _getAttachmentsDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${appDir.path}/attachments');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<void> addAttachment({
    required AttachmentType type,
    required String fileName,
    required String localPath,
    required int sizeBytes,
    String? thumbnailPath,
    Duration? duration,
    String? mimeType,
  }) async {
    final attachment = NoteAttachment(
      id: const Uuid().v4(),
      noteId: noteId,
      type: type,
      fileName: fileName,
      localPath: localPath,
      sizeBytes: sizeBytes,
      createdAt: DateTime.now(),
      thumbnailPath: thumbnailPath,
      duration: duration,
      mimeType: mimeType,
    );

    await _repository.saveAttachment(attachment);
    await _loadAttachments();
  }

  Future<void> removeAttachment(String attachmentId) async {
    final attachment = state.firstWhere((a) => a.id == attachmentId);
    try {
      final file = File(attachment.localPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Ignore file delete errors
    }
    await _repository.deleteAttachment(attachmentId);
    await _loadAttachments();
  }

  // Pickers simulating file picking and camera capture offline-first
  Future<void> simulateAddImage(bool fromCamera) async {
    final dir = await _getAttachmentsDir();
    final name = '${fromCamera ? 'camera' : 'gallery'}_${DateTime.now().millisecondsSinceEpoch}.png';
    final path = '${dir.path}/$name';
    
    // Write actual tiny PNG bytes so Image.file loads it successfully
    final file = File(path);
    await file.writeAsBytes(_tinyPngBytes);

    await addAttachment(
      type: fromCamera ? AttachmentType.camera : AttachmentType.image,
      fileName: name,
      localPath: path,
      sizeBytes: 1048576, // 1 MB
      thumbnailPath: path,
      mimeType: 'image/png',
    );
  }

  Future<void> simulateAddPdf() async {
    final dir = await _getAttachmentsDir();
    final name = 'document_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final path = '${dir.path}/$name';
    
    final file = File(path);
    await file.writeAsString('%PDF-1.4 Mock Document');

    await addAttachment(
      type: AttachmentType.pdf,
      fileName: name,
      localPath: path,
      sizeBytes: 2548576, // 2.4 MB
      mimeType: 'application/pdf',
    );
  }

  Future<void> simulateAddFile() async {
    final dir = await _getAttachmentsDir();
    final name = 'notes_${DateTime.now().millisecondsSinceEpoch}.docx';
    final path = '${dir.path}/$name';
    
    final file = File(path);
    await file.writeAsString('Mock DOCX File content');

    await addAttachment(
      type: AttachmentType.document,
      fileName: name,
      localPath: path,
      sizeBytes: 450560, // 440 KB
      mimeType: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    );
  }

  Future<void> simulateAddAudio(Duration duration) async {
    final dir = await _getAttachmentsDir();
    final name = 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
    final path = '${dir.path}/$name';
    
    final file = File(path);
    await file.writeAsString('Mock Audio bytes');

    await addAttachment(
      type: AttachmentType.audio,
      fileName: name,
      localPath: path,
      sizeBytes: 85000,
      duration: duration,
      mimeType: 'audio/m4a',
    );
  }

  Future<void> simulateAddLink(String url, String title, String description) async {
    await addAttachment(
      type: AttachmentType.link,
      fileName: title,
      localPath: url,
      sizeBytes: url.length + title.length + description.length,
      mimeType: 'text/html',
      thumbnailPath: description, // Storing description in thumbnailPath for link cards
    );
  }
}
