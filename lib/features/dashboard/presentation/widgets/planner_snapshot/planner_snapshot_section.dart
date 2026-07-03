// lib/features/dashboard/presentation/widgets/planner_snapshot/planner_snapshot_section.dart
//
// Orynta 2.0 — Planner Snapshot Section Component

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/design_system/design_tokens.dart';
import '../../providers/planner_snapshot_providers.dart';
import 'next_event_card.dart';
import 'planner_snapshot_empty_state.dart';
import 'planner_snapshot_loading.dart';
import 'planner_summary_row.dart';

class PlannerSnapshotSection extends ConsumerWidget {
  const PlannerSnapshotSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(plannerSnapshotControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Section Header Row
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, left: 4.0, right: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.event_note_outlined,
                    size: 20,
                    color: context.colors.primary,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Planner',
                        style: context.typography.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      Text(
                        'Your schedule at a glance',
                        style: context.typography.bodySmall.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: () => context.push('/planner'),
                borderRadius: context.radius.borderRadiusSm,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        'View Calendar',
                        style: context.typography.labelMedium.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: context.colors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Body Content
        if (state.isLoading)
          const PlannerSnapshotLoading()
        else if (!state.hasEvent)
          const PlannerSnapshotEmptyState()
        else ...[
          NextEventCard(
            event: state.nextEvent!,
            onTap: () => context.push('/planner/event/${state.nextEvent!.id}'),
          ),
          const SizedBox(height: 16),
          PlannerSummaryRow(state: state),
        ],
      ],
    );
  }
}
