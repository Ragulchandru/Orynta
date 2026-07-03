// lib/features/dashboard/presentation/providers/recent_notes_providers.dart
//
// Orynta 2.0 — Recent Notes Riverpod Providers

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/recent_notes_repository_impl.dart';
import '../../domain/models/recent_notes_state.dart';
import '../../domain/repositories/recent_notes_repository.dart';
import '../controllers/recent_notes_controller.dart';

final recentNotesRepositoryProvider = Provider<RecentNotesRepository>((ref) {
  return const RecentNotesRepositoryImpl();
});

final recentNotesControllerProvider =
    StateNotifierProvider.autoDispose<RecentNotesController, RecentNotesState>((ref) {
  final repository = ref.watch(recentNotesRepositoryProvider);
  return RecentNotesController(repository);
});
