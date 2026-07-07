// lib/features/analytics/domain/services/report_exporter.dart
//
// Orynta 2.0 — Professional Offline Report Exporter Service

import 'package:flutter/services.dart';
import '../../presentation/providers/focus_analytics_provider.dart';
import '../../presentation/providers/analytics_provider.dart';
import '../../../planner/presentation/providers/planner_stats_provider.dart';

class ReportExporter {
  static String _getScoreLevel(double scoreVal) {
    final score = scoreVal.round();
    if (score >= 90) return 'Excellent';
    if (score >= 70) return 'Good';
    if (score >= 50) return 'Average';
    return 'Needs Improvement';
  }

  static String _getScoreMessage(double scoreVal) {
    final score = scoreVal.round();
    if (score >= 90) return 'Incredible! Peak performance today.';
    if (score >= 70) return 'Great focus and productivity today!';
    if (score >= 50) return 'Steady progress. Keep it up!';
    return 'Log some focus time to build momentum.';
  }

  static String generateMarkdownReport({
    required DailyStats scoreData,
    required FocusAnalyticsData focusData,
    required PlannerStatsData statsData,
    required int totalNotes,
    required int favoriteNotes,
    required int archivedNotes,
  }) {
    final now = DateTime.now();
    return '''
# ORYNTA PROFESSIONAL PRODUCTIVITY REPORT
**Generated:** ${now.toLocal().toString().split('.')[0]}
**Format:** Markdown (.md)

---

## 1. PRODUCTIVITY SUMMARY
- **Productivity Score:** ${scoreData.productivityScore.round()}/100 (${_getScoreLevel(scoreData.productivityScore)})
- **Daily Performance Status:** ${_getScoreMessage(scoreData.productivityScore)}
- **Current Completion Rate:** ${(statsData.todayCompletionRate * 100).toStringAsFixed(1)}%

## 2. PLANNER ANALYTICS
- **Tasks Created Today:** ${statsData.todayTotal}
- **Tasks Completed Today:** ${statsData.todayCompleted}
- **Weekly Progress:** ${statsData.weeklyCompleted} completed of ${statsData.weeklyTotal} total
- **Monthly Progress:** ${statsData.monthlyCompleted} completed of ${statsData.monthlyTotal} total
- **Current Active Streak:** ${statsData.currentStreak} Days
- **Longest Active Streak:** ${statsData.longestStreak} Days
- **Average Tasks Completed Daily:** ${statsData.averageDailyTasks.toStringAsFixed(1)}

## 3. FOCUS ANALYTICS
- **Total Productive Focus Duration:** ${focusData.totalFocusMinutes} minutes
- **Average Focus Session Duration:** ${focusData.averageFocusMinutes.toStringAsFixed(1)} minutes
- **Longest Focus Session:** ${focusData.longestFocusMinutes} minutes
- **Most Productive Hour Peak:** ${focusData.mostProductiveHour}
- **Most Productive Day Peak:** ${focusData.mostProductiveDay}
- **Average Daily Productivity Index:** ${focusData.averageDailyProductivity.toStringAsFixed(1)}%

## 4. NOTES ANALYTICS
- **Total Notes Captured:** \$totalNotes
- **Favorite High-priority Notes:** \$favoriteNotes
- **Archived Inactive Notes:** \$archivedNotes
- **Notes Captured Today:** ${scoreData.notesCreated}

---
*Orynta 2.0 — Private Offline Productivity Vault.*
''';
  }

  static String generateCSVReport({
    required DailyStats scoreData,
    required FocusAnalyticsData focusData,
    required PlannerStatsData statsData,
    required int totalNotes,
  }) {
    final now = DateTime.now();
    final List<List<String>> rows = [
      ['Orynta Productivity Report', now.toLocal().toString()],
      [],
      ['Metric Category', 'Metric Name', 'Metric Value'],
      ['Productivity', 'Score', '${scoreData.productivityScore.round()}/100'],
      ['Productivity', 'Level', _getScoreLevel(scoreData.productivityScore)],
      ['Planner', 'Tasks Completed Today', '${statsData.todayCompleted}'],
      ['Planner', 'Tasks Created Today', '${statsData.todayTotal}'],
      ['Planner', 'Weekly Completed', '${statsData.weeklyCompleted}'],
      ['Planner', 'Monthly Completed', '${statsData.monthlyCompleted}'],
      ['Planner', 'Current Streak', '${statsData.currentStreak} Days'],
      ['Planner', 'Longest Streak', '${statsData.longestStreak} Days'],
      ['Focus', 'Total Focus Minutes', '${focusData.totalFocusMinutes}'],
      ['Focus', 'Average Focus Minutes', focusData.averageFocusMinutes.toStringAsFixed(1)],
      ['Focus', 'Longest Focus Minutes', '${focusData.longestFocusMinutes}'],
      ['Focus', 'Most Productive Hour', focusData.mostProductiveHour],
      ['Focus', 'Most Productive Day', focusData.mostProductiveDay],
      ['Notes', 'Total Notes', '\$totalNotes'],
    ];

    return rows.map((row) => row.map((cell) => '"${cell.replaceAll('"', '""')}"').join(',')).join('\n');
  }

  static String generatePDFPlainReport({
    required DailyStats scoreData,
    required FocusAnalyticsData focusData,
    required PlannerStatsData statsData,
    required int totalNotes,
    required int favoriteNotes,
    required int archivedNotes,
  }) {
    final now = DateTime.now();
    final line = '=' * 60;
    final thinLine = '-' * 60;
    return '''
$line
                  ORYNTA INSIGHTS REPORT (PDF FORMAT)
$line
Generated On: ${now.toLocal().toString().split('.')[0]}
Platform: Orynta Desktop/Mobile offline database

PRODUCTIVITY INDEX SUMMARY
$thinLine
* Productivity Score      : ${scoreData.productivityScore.round()}/100
* Performance Rating      : ${_getScoreLevel(scoreData.productivityScore)}
* Streak Record           : ${statsData.currentStreak} Days (Max: ${statsData.longestStreak} Days)
* Rate of Completion      : ${(statsData.todayCompletionRate * 100).toStringAsFixed(1)}%

PLANNER SUMMARY
$thinLine
* Today's Tasks Completed : ${statsData.todayCompleted} of ${statsData.todayTotal}
* Weekly Completion       : ${statsData.weeklyCompleted}/${statsData.weeklyTotal}
* Monthly Completion      : ${statsData.monthlyCompleted}/${statsData.monthlyTotal}
* Avg Tasks / Day         : ${statsData.averageDailyTasks.toStringAsFixed(1)}

FOCUS & PRODUCTIVITY PEAKS
$thinLine
* Total Focus Minutes     : ${focusData.totalFocusMinutes} mins
* Avg Session Length      : ${focusData.averageFocusMinutes.toStringAsFixed(1)} mins
* Peak Output Hour        : ${focusData.mostProductiveHour}
* Peak Output Day         : ${focusData.mostProductiveDay}

NOTES VAULT STATUS
$thinLine
* Total Active Notes      : \$totalNotes
* Starred/Favorites       : \$favoriteNotes
* Archived Notes          : \$archivedNotes
* Captured Today          : ${scoreData.notesCreated}

$line
                 End of Orynta Insights PDF Report
$line
''';
  }

  static Future<void> copyToClipboard(String content) async {
    await Clipboard.setData(ClipboardData(text: content));
  }
}
