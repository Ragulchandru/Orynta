// lib/features/analytics/presentation/providers/insights_time_filter_provider.dart
//
// Orynta 2.0 — Global Insights Time Range Filter Provider

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum InsightsTimeRange {
  today,
  week,
  month,
  year,
  all,
}

final insightsTimeRangeProvider = StateProvider<InsightsTimeRange>((ref) => InsightsTimeRange.week);
