// lib/features/analytics/presentation/widgets/analytics_axis_formatter.dart

import 'package:intl/intl.dart';
import '../providers/insights_time_filter_provider.dart';

class AnalyticsAxisFormatter {
  static List<String> getLabels({
    required List<DateTime> dates,
    required InsightsTimeRange range,
    required double availableWidth,
  }) {
    if (dates.isEmpty) return [];

    switch (range) {
      case InsightsTimeRange.today:
        return dates.map((d) => DateFormat('h a').format(d)).toList();
      case InsightsTimeRange.week:
        return dates.map((d) => DateFormat('E').format(d).substring(0, 1)).toList();
      case InsightsTimeRange.month:
        final maxLabels = (availableWidth / 40).floor().clamp(3, 8);
        final step = (dates.length / maxLabels).ceil().clamp(1, dates.length);
        return List.generate(dates.length, (i) {
          if (i == 0 || i == dates.length - 1 || i % step == 0) {
            return DateFormat('d').format(dates[i]);
          }
          return '';
        });
      case InsightsTimeRange.year:
        return dates.map((d) => DateFormat('MMM').format(d)).toList();
      case InsightsTimeRange.all:
        if (dates.length > 365) {
          final List<String> years = dates.map((d) => d.year.toString()).toSet().toList()..sort();
          return years;
        } else {
          final List<String> months = [];
          final Set<String> seen = {};
          for (final d in dates) {
            final monthStr = DateFormat('MMM').format(d);
            if (seen.add(monthStr)) {
              months.add(monthStr);
            }
          }
          return months;
        }
    }
  }
}
