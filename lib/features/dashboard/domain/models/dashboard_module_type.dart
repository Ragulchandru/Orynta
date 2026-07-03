// lib/features/dashboard/domain/models/dashboard_module_type.dart
//
// Orynta 2.0 — Dashboard Module Type Enum
//
// Strongly-typed identifier for all dashboard modules.

enum DashboardModuleType {
  hero,
  quickActions,
  today,
  recentNotes,
  planner,
  analytics,
  suggestions,
  calendar,
  habits,
  weather,
  pinnedNotes,
  custom,
  future;

  String get id => name;

  String get displayName => switch (this) {
        hero => 'Overview',
        quickActions => 'Quick Actions',
        today => "Today's Focus",
        recentNotes => 'Recent Notes',
        planner => 'Planner & Tasks',
        analytics => 'Analytics',
        suggestions => 'Smart Suggestions',
        calendar => 'Calendar',
        habits => 'Habit Tracker',
        weather => 'Weather Widget',
        pinnedNotes => 'Pinned Notes',
        custom => 'Custom Section',
        future => 'Upcoming Module',
      };
}
