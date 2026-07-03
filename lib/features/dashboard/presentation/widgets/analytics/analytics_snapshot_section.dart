// lib/features/dashboard/presentation/widgets/analytics/analytics_snapshot_section.dart
//
// Orynta 2.0 — Analytics Snapshot Section Component

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/design_system/design_tokens.dart';
import '../../providers/analytics_snapshot_providers.dart';
import 'analytics_empty_state.dart';
import 'analytics_loading.dart';
import 'metric_card.dart';
import 'weekly_activity_chart.dart';

class AnalyticsSnapshotSection extends ConsumerWidget {
  const AnalyticsSnapshotSection({super.key});

  int _calculateCrossAxisCount(double screenWidth) {
    if (screenWidth < 600) return 2;
    if (screenWidth < 1000) return 2;
    return 2;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(analyticsSnapshotControllerProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = _calculateCrossAxisCount(screenWidth);

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
                    Icons.insights_rounded,
                    size: 20,
                    color: context.colors.primary,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Analytics',
                        style: context.typography.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      Text(
                        'Your productivity at a glance',
                        style: context.typography.bodySmall.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: () => context.push('/analytics'),
                borderRadius: context.radius.borderRadiusSm,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        'View Insights',
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
        if (snapshot.isLoading)
          const AnalyticsLoading()
        else if (!snapshot.hasAnalytics)
          const AnalyticsEmptyState()
        else ...[
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
            childAspectRatio: screenWidth < 400 ? 1.05 : 1.3,
            children: [
              MetricCard(
                title: 'Focus Time',
                value: snapshot.formattedFocusTime,
                emptySubtitle: 'No focus sessions yet.',
                icon: Icons.timer_outlined,
                hasValue: snapshot.focusMinutesToday != null && snapshot.focusMinutesToday! > 0,
                onTap: () => context.push('/analytics'),
              ),
              MetricCard(
                title: 'Completion Rate',
                value: snapshot.formattedCompletionRate,
                emptySubtitle: 'Complete your first task today.',
                icon: Icons.donut_large_rounded,
                hasValue: snapshot.completionRate != null && snapshot.completionRate! > 0,
                onTap: () => context.push('/analytics'),
              ),
              MetricCard(
                title: 'Current Streak',
                value: snapshot.formattedStreak,
                emptySubtitle: 'Start your productivity streak.',
                icon: Icons.local_fire_department_outlined,
                hasValue: snapshot.productiveStreak != null && snapshot.productiveStreak! > 0,
                onTap: () => context.push('/analytics'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          WeeklyActivityChart(activities: snapshot.weeklyActivity),
        ],
      ],
    );
  }
}
