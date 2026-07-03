// lib/features/dashboard/data/repositories/smart_suggestions_repository_impl.dart
//
// Orynta 2.0 — Smart Suggestions Repository Implementation

import 'package:flutter/material.dart';
import '../../domain/models/smart_suggestion.dart';
import '../../domain/models/smart_suggestion_type.dart';
import '../../domain/models/suggestion_priority.dart';
import '../../domain/repositories/smart_suggestions_repository.dart';

class SmartSuggestionsRepositoryImpl implements SmartSuggestionsRepository {
  const SmartSuggestionsRepositoryImpl();

  static final List<SmartSuggestion> _ruleBasedSuggestions = [
    const SmartSuggestion(
      id: 'sugg_review_planner',
      type: SmartSuggestionType.reviewPlanner,
      title: "Review Today's Planner",
      description: 'Check your upcoming agenda and organize your workflow.',
      actionLabel: 'Open Planner',
      priority: SuggestionPriority.medium,
      icon: Icons.today_rounded,
      actionRoute: '/planner',
    ),
    const SmartSuggestion(
      id: 'sugg_organize_notes',
      type: SmartSuggestionType.organizeNotes,
      title: 'Organize Quick Notes',
      description: 'Tag or group your recent documents to keep your workspace tidy.',
      actionLabel: 'Organize Notes',
      priority: SuggestionPriority.low,
      icon: Icons.folder_open_rounded,
      actionRoute: '/notes',
    ),
  ];

  @override
  Future<List<SmartSuggestion>> getSuggestions() async {
    return _ruleBasedSuggestions;
  }
}
