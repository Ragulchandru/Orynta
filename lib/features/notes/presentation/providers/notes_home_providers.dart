// lib/features/notes/presentation/providers/notes_home_providers.dart
//
// Orynta 2.0 — Notes Home Riverpod Providers

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/notes_home_repository_impl.dart';
import '../../di/notes_data_providers.dart';
import '../../domain/models/notes_home_state.dart';
import '../../domain/repositories/notes_home_repository.dart';
import '../controllers/notes_home_controller.dart';

final notesHomeRepositoryProvider = Provider<NotesHomeRepository>((ref) {
  final noteRepository = ref.watch(noteRepositoryProvider);
  return NotesHomeRepositoryImpl(noteRepository: noteRepository);
});

final notesHomeControllerProvider = StateNotifierProvider.autoDispose<
    NotesHomeController, NotesHomeState>((ref) {
  final repository = ref.watch(notesHomeRepositoryProvider);
  return NotesHomeController(repository, ref);
});
