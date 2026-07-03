// lib/features/dashboard/presentation/controllers/smart_suggestions_controller.dart
//
// Orynta 2.0 — Smart Suggestions Controller

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/smart_suggestion.dart';
import '../../domain/models/smart_suggestions_state.dart';
import '../../domain/repositories/smart_suggestions_repository.dart';

class SmartSuggestionsController
    extends StateNotifier<SmartSuggestionsState> {
  SmartSuggestionsController(this._repository)
      : super(const SmartSuggestionsState(isLoading: true)) {
    loadSuggestions();
  }

  final SmartSuggestionsRepository _repository;

  Future<void> loadSuggestions() async {
    state = state.copyWith(isLoading: true);
    final suggestions = await _repository.getSuggestions();
    state = state.copyWith(
      isLoading: false,
      suggestions: suggestions,
    );
  }

  void onSuggestionTap(SmartSuggestion suggestion, BuildContext context) {
    if (suggestion.actionRoute != null && suggestion.actionRoute!.isNotEmpty) {
      context.push(suggestion.actionRoute!);
    }
  }
}
