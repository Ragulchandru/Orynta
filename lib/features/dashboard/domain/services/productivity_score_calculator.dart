// lib/features/dashboard/domain/services/productivity_score_calculator.dart
//
// Orynta 2.0 — Productivity Score Calculator Service
//
// Independent service calculating productivity metrics.
// Returns ProductivityScore with value: null when no feature data exists yet.

import '../models/productivity_score.dart';

class ProductivityScoreCalculator {
  const ProductivityScoreCalculator();

  /// Calculates current productivity score based on workspace activity.
  Future<ProductivityScore> calculateScore() async {
    // No productivity data available yet in Phase 3.1/3.2
    return const ProductivityScore(
      value: null,
      hasData: false,
      label: '--',
      subtitle: 'No productivity data yet',
    );
  }
}
