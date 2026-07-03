// lib/features/dashboard/domain/models/reminder_summary_data.dart
//
// Orynta 2.0 — Reminder Summary Data Model

import 'package:flutter/foundation.dart';

@immutable
class ReminderSummaryData {
  const ReminderSummaryData({
    this.title,
    this.time,
    this.priority,
  });

  final String? title;
  final String? time;
  final String? priority;

  bool get hasReminder => title != null && title!.isNotEmpty;
}
