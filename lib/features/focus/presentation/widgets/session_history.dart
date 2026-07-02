import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../domain/entities/focus_session_entity.dart';

class SessionHistory extends StatelessWidget {
  const SessionHistory({
    super.key,
    required this.sessions,
    required this.onDelete,
  });

  final List<FocusSessionEntity> sessions;
  final Function(String) onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (sessions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.xl),
          child: Column(
            children: [
              Icon(Icons.history_toggle_off_rounded, size: 36, color: colorScheme.outline),
              const SizedBox(height: AppSizes.sm),
              Text(
                'No sessions logged yet.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: sessions.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
      itemBuilder: (context, index) {
        final session = sessions[index];
        final isBreak = session.sessionType != 'focus';
        final duration = '${session.actualDurationMinutes}m';
        final timeStr = DateFormat('h:mm a').format(session.endTime);

        final icon = isBreak ? Icons.coffee_rounded : Icons.timer_outlined;
        final iconColor = isBreak ? Colors.green : colorScheme.primary;

        final title = isBreak
            ? (session.sessionType == 'shortBreak' ? 'Short Break' : 'Long Break')
            : 'Focus Session';

        return Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.md),
            side: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          color: colorScheme.surfaceContainerLow,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: 4),
            leading: CircleAvatar(
              backgroundColor: iconColor.withValues(alpha: 0.1),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            title: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              '${DateFormat('MMM d').format(session.endTime)} • $timeStr',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  duration,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: AppSizes.xs),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  onPressed: () => onDelete(session.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
