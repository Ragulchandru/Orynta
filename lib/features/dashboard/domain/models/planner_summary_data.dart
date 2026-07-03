// lib/features/dashboard/domain/models/planner_summary_data.dart
//
// Orynta 2.0 — Planner Summary Data Model

import 'package:flutter/foundation.dart';

@immutable
class PlannerSummaryData {
  const PlannerSummaryData({
    this.eventsTodayCount = 0,
    this.upcomingEventsCount = 0,
  });

  final int eventsTodayCount;
  final int upcomingEventsCount;

  bool get hasEvents => eventsTodayCount > 0 || upcomingEventsCount > 0;
}
