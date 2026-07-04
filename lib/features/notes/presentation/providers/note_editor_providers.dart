// lib/features/notes/presentation/providers/note_editor_providers.dart
//
// Orynta 2.0 — Note Editor Providers

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/note_editor_repository_impl.dart';
import '../../di/notes_data_providers.dart';
import '../../domain/models/note_editor_state.dart';
import '../../domain/repositories/note_editor_repository.dart';
import '../controllers/note_editor_controller.dart';

final noteEditorRepositoryProvider = Provider<NoteEditorRepository>((ref) {
  final noteRepository = ref.watch(noteRepositoryProvider);
  return NoteEditorRepositoryImpl(noteRepository: noteRepository);
});

final noteEditorControllerProvider = StateNotifierProvider.autoDispose
    .family<NoteEditorController, NoteEditorState, String?>((ref, noteId) {
  final repository = ref.watch(noteEditorRepositoryProvider);
  return NoteEditorController(repository, ref, noteId: noteId);
});
