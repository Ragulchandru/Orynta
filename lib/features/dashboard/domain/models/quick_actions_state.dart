// lib/features/dashboard/domain/models/quick_actions_state.dart
//
// Orynta 2.0 — Quick Actions Domain State

import 'package:flutter/foundation.dart';
import 'quick_action.dart';

@immutable
class QuickActionsState {
  const QuickActionsState({
    this.isLoading = false,
    this.actions = const [],
  });

  final bool isLoading;
  final List<QuickAction> actions;

  QuickActionsState copyWith({
    bool? isLoading,
    List<QuickAction>? actions,
  }) {
    return QuickActionsState(
      isLoading: isLoading ?? this.isLoading,
      actions: actions ?? this.actions,
    );
  }
}
