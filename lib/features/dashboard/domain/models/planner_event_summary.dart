// lib/features/dashboard/domain/models/planner_event_summary.dart
//
// Orynta 2.0 — Planner Event Summary Domain Entity

import 'package:flutter/foundation.dart';

@immutable
class PlannerEventSummary {
  const PlannerEventSummary({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    this.location,
    this.categoryColorHex,
    this.hasReminder = false,
    this.isRecurring = false,
    this.participants = const [],
    this.meetingUrl,
    this.weatherHint,
    this.aiSuggestion,
  });

  final String id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final String? categoryColorHex;
  final bool hasReminder;
  final bool isRecurring;
  final List<String> participants;
  final String? meetingUrl;
  final String? weatherHint;
  final String? aiSuggestion;

  /// Time range string (e.g. "09:00 – 10:30").
  String get timeRange {
    final start = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    final end = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$start – $end';
  }

  /// Duration string (e.g. "1h 30m").
  String get durationString {
    final duration = endTime.difference(startTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  /// Relative day string ("Today", "Tomorrow", "In 2 days").
  String get relativeDay {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDay = DateTime(startTime.year, startTime.month, startTime.day);

    final diff = eventDay.difference(today).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff > 1 && diff <= 7) return 'In $diff days';
    return 'This Week';
  }
}
