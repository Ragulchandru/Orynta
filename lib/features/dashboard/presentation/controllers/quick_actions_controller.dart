// lib/features/dashboard/presentation/controllers/quick_actions_controller.dart
//
// Orynta 2.0 — Quick Actions Controller

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../domain/models/quick_action.dart';
import '../../domain/models/quick_action_type.dart';
import '../../domain/models/quick_actions_state.dart';
import '../../domain/repositories/quick_actions_repository.dart';

class QuickActionsController extends StateNotifier<QuickActionsState> {
  QuickActionsController(this._repository)
      : super(const QuickActionsState(isLoading: true)) {
    loadQuickActions();
  }

  final QuickActionsRepository _repository;

  Future<void> loadQuickActions() async {
    state = state.copyWith(isLoading: true);
    final actions = await _repository.getQuickActions();
    state = state.copyWith(
      isLoading: false,
      actions: actions,
    );
  }

  void onActionTap(QuickAction action, BuildContext context) {
    if (!action.enabled) return;

    if (action.type == QuickActionType.newNote) {
      context.pushNamed(RouteNames.noteEditor);
    } else if (action.type == QuickActionType.newTask) {
      context.pushNamed(RouteNames.createTask);
    } else if (action.route != null && action.route!.isNotEmpty) {
      context.push(action.route!);
    }
  }
}
