// lib/features/dashboard/presentation/widgets/today/reminder_summary_card.dart
//
// Orynta 2.0 — Reminder Summary Card Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../../domain/models/reminder_summary_data.dart';
import 'today_card.dart';
import 'today_empty_state.dart';

class ReminderSummaryCard extends StatelessWidget {
  const ReminderSummaryCard({
    super.key,
    required this.data,
  });

  final ReminderSummaryData data;

  @override
  Widget build(BuildContext context) {
    return TodayCard(
      title: 'Reminder',
      subtitle: 'Next event',
      icon: Icons.alarm_outlined,
      isEmpty: !data.hasReminder,
      body: !data.hasReminder
          ? const TodayEmptyState(
              title: 'Nothing coming up.',
              subtitle: 'Relax for now.',
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        data.title!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.typography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ),
                    if (data.priority != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: context.colors.primary.withValues(alpha: 0.1),
                          borderRadius: context.radius.borderRadiusSm,
                        ),
                        child: Text(
                          data.priority!,
                          style: context.typography.labelSmall.copyWith(
                            color: context.colors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (data.time != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    data.time!,
                    style: context.typography.bodySmall.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}
