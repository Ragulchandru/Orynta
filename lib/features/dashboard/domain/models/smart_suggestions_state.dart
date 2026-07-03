// lib/features/dashboard/domain/models/smart_suggestions_state.dart
//
// Orynta 2.0 — Smart Suggestions Domain State

import 'package:flutter/foundation.dart';
import 'smart_suggestion.dart';

@immutable
class SmartSuggestionsState {
  const SmartSuggestionsState({
    this.isLoading = false,
    this.suggestions = const [],
  });

  final bool isLoading;
  final List<SmartSuggestion> suggestions;

  SmartSuggestionsState copyWith({
    bool? isLoading,
    List<SmartSuggestion>? suggestions,
  }) {
    return SmartSuggestionsState(
      isLoading: isLoading ?? this.isLoading,
      suggestions: suggestions ?? this.suggestions,
    );
  }
}
