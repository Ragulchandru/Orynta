// lib/features/dashboard/data/repositories/quick_actions_repository_impl.dart
//
// Orynta 2.0 — Quick Actions Repository Implementation

import 'package:flutter/material.dart';
import '../../domain/models/quick_action.dart';
import '../../domain/models/quick_action_type.dart';
import '../../domain/repositories/quick_actions_repository.dart';

class QuickActionsRepositoryImpl implements QuickActionsRepository {
  const QuickActionsRepositoryImpl();

  static final List<QuickAction> _defaultActions = [
    const QuickAction(
      id: 'new_note',
      type: QuickActionType.newNote,
      title: 'New Note',
      subtitle: 'Create document',
      icon: Icons.edit_note_rounded,
      route: '/notes/new',
      enabled: true,
      analyticsKey: 'quick_action_new_note',
      displayOrder: 0,
    ),
    const QuickAction(
      id: 'new_task',
      type: QuickActionType.newTask,
      title: 'New Task',
      subtitle: 'Add priority item',
      icon: Icons.add_task_rounded,
      route: '/planner/new-task',
      enabled: true,
      analyticsKey: 'quick_action_new_task',
      displayOrder: 1,
    ),
    const QuickAction(
      id: 'voice_note',
      type: QuickActionType.voiceNote,
      title: 'Voice Note',
      subtitle: 'Record audio idea',
      icon: Icons.mic_none_rounded,
      enabled: false,
      badge: 'Coming Soon',
      analyticsKey: 'quick_action_voice_note',
      displayOrder: 2,
    ),
    const QuickAction(
      id: 'scan_doc',
      type: QuickActionType.scanDocument,
      title: 'Scan Document',
      subtitle: 'Capture paper note',
      icon: Icons.document_scanner_rounded,
      enabled: false,
      badge: 'Coming Soon',
      analyticsKey: 'quick_action_scan_doc',
      displayOrder: 3,
    ),
  ];

  @override
  Future<List<QuickAction>> getQuickActions() async {
    return _defaultActions;
  }
}
