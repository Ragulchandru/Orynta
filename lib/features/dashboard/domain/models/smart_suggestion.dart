// lib/features/dashboard/domain/models/smart_suggestion.dart
//
// Orynta 2.0 — Smart Suggestion Domain Entity

import 'package:flutter/material.dart';
import 'smart_suggestion_type.dart';
import 'suggestion_priority.dart';

@immutable
class SmartSuggestion {
  const SmartSuggestion({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.actionLabel,
    this.priority = SuggestionPriority.medium,
    required this.icon,
    this.category,
    this.badge,
    this.actionRoute,
    this.score,
    this.aiContext,
    this.featureFlag,
  });

  final String id;
  final SmartSuggestionType type;
  final String title;
  final String description;
  final String actionLabel;
  final SuggestionPriority priority;
  final IconData icon;
  final String? category;
  final String? badge;
  final String? actionRoute;
  final double? score;
  final String? aiContext;
  final String? featureFlag;

  SmartSuggestion copyWith({
    String? id,
    SmartSuggestionType? type,
    String? title,
    String? description,
    String? actionLabel,
    SuggestionPriority? priority,
    IconData? icon,
    String? category,
    String? badge,
    String? actionRoute,
    double? score,
    String? aiContext,
    String? featureFlag,
  }) {
    return SmartSuggestion(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      actionLabel: actionLabel ?? this.actionLabel,
      priority: priority ?? this.priority,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      badge: badge ?? this.badge,
      actionRoute: actionRoute ?? this.actionRoute,
      score: score ?? this.score,
      aiContext: aiContext ?? this.aiContext,
      featureFlag: featureFlag ?? this.featureFlag,
    );
  }
}
