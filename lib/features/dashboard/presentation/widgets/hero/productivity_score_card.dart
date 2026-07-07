// lib/features/dashboard/presentation/widgets/hero/productivity_score_card.dart
//
// Orynta 2.0 — Productivity Score Card Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../../domain/models/productivity_score.dart';
import 'circular_score_painter.dart';

class ProductivityScoreCard extends StatelessWidget {
  const ProductivityScoreCard({
    super.key,
    required this.score,
  });

  final ProductivityScore score;

  @override
  Widget build(BuildContext context) {
    final trackColor = context.colors.outlineVariant.withValues(alpha: 0.5);
    final progressColor = context.colors.primary;
    final progress = score.hasData && score.value != null
        ? (score.value! / 100.0)
        : 0.0;

    return Row(
      children: [
        // Large Circular Score Indicator
        SizedBox(
          width: 64,
          height: 64,
          child: CustomPaint(
            painter: CircularScorePainter(
              trackColor: trackColor,
              progressColor: progressColor,
              progress: progress,
              strokeWidth: 6.0,
            ),
            child: Center(
              child: Text(
                score.label,
                style: context.typography.titleLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: context.colors.primary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Score Subtitle & Meta
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Productivity Score',
                style: context.typography.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                score.subtitle,
                style: context.typography.bodySmall.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
