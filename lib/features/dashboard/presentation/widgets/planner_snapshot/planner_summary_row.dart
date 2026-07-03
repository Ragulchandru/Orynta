// lib/features/dashboard/presentation/widgets/planner_snapshot/planner_summary_row.dart
//
// Orynta 2.0 — Planner Summary Row Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../../domain/models/planner_snapshot_state.dart';

class PlannerSummaryRow extends StatelessWidget {
  const PlannerSummaryRow({
    super.key,
    required this.state,
  });

  final PlannerSnapshotState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: context.radius.borderRadiusMd,
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryMetricItem(
            label: 'Events Today',
            value: '${state.eventsTodayCount}',
          ),
          Container(
            height: 24,
            width: 1,
            color: context.colors.outlineVariant,
          ),
          _SummaryMetricItem(
            label: 'Upcoming',
            value: '${state.upcomingThisWeekCount}',
          ),
          if (state.freeTimeRemaining != null && state.freeTimeRemaining!.isNotEmpty) ...[
            Container(
              height: 24,
              width: 1,
              color: context.colors.outlineVariant,
            ),
            _SummaryMetricItem(
              label: 'Free Time',
              value: state.freeTimeRemaining!,
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryMetricItem extends StatelessWidget {
  const _SummaryMetricItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: context.typography.titleMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: context.colors.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: context.typography.labelSmall.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
