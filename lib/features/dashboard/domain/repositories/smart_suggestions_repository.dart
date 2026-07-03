// lib/features/dashboard/domain/repositories/smart_suggestions_repository.dart
//
// Orynta 2.0 — Smart Suggestions Repository Interface

import '../models/smart_suggestion.dart';

abstract interface class SmartSuggestionsRepository {
  /// Evaluates deterministic rules and returns proactive recommendations.
  Future<List<SmartSuggestion>> getSuggestions();
}
