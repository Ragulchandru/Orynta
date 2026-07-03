// lib/features/dashboard/domain/models/tasks_summary_data.dart
//
// Orynta 2.0 — Tasks Summary Data Model

import 'package:flutter/foundation.dart';

@immutable
class TasksSummaryData {
  const TasksSummaryData({
    this.totalTasks = 0,
    this.completedTasks = 0,
    this.remainingTasks = 0,
  });

  final int totalTasks;
  final int completedTasks;
  final int remainingTasks;

  bool get hasTasks => totalTasks > 0;
}
