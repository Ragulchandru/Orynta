// lib/features/dashboard/presentation/providers/smart_suggestions_providers.dart
//
// Orynta 2.0 — Smart Suggestions Riverpod Providers

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/smart_suggestions_repository_impl.dart';
import '../../domain/models/smart_suggestions_state.dart';
import '../../domain/repositories/smart_suggestions_repository.dart';
import '../controllers/smart_suggestions_controller.dart';

final smartSuggestionsRepositoryProvider =
    Provider<SmartSuggestionsRepository>((ref) {
  return const SmartSuggestionsRepositoryImpl();
});

final smartSuggestionsControllerProvider = StateNotifierProvider.autoDispose<
    SmartSuggestionsController, SmartSuggestionsState>((ref) {
  final repository = ref.watch(smartSuggestionsRepositoryProvider);
  return SmartSuggestionsController(repository);
});
