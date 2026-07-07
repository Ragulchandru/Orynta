import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../planner/domain/entities/notification_status.dart';
import '../../../planner/domain/entities/task_entity.dart';
import '../../../planner/presentation/providers/tasks_notifier.dart';
import '../../../planner/domain/services/planner_notification_service.dart';


class NotificationCenterScreen extends ConsumerStatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  ConsumerState<NotificationCenterScreen> createState() => _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends ConsumerState<NotificationCenterScreen> {
  String _searchQuery = '';
  String _activeFilter = 'upcoming';


  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final colors = context.colors;
    final tasks = ref.watch(tasksProvider);

    final allCandidates = tasks.where((t) => !t.isArchived).toList();

    final upcoming = allCandidates
        .where((t) => t.computedNotificationStatus == NotificationStatus.upcoming)
        .toList();
    final missed = allCandidates
        .where((t) => t.computedNotificationStatus == NotificationStatus.missed)
        .toList();
    
    final today = allCandidates.where((t) {
      if (t.computedNotificationStatus == NotificationStatus.completed ||
          t.computedNotificationStatus == NotificationStatus.cancelled) {
        return false;
      }
      if (t.dueDate == null) return false;
      final now = DateTime.now();
      return t.dueDate!.year == now.year &&
          t.dueDate!.month == now.month &&
          t.dueDate!.day == now.day;
    }).toList();

    final completed = allCandidates
        .where((t) => t.computedNotificationStatus == NotificationStatus.completed)
        .toList();
    final cancelled = allCandidates
        .where((t) => t.computedNotificationStatus == NotificationStatus.cancelled)
        .toList();

    final allReminders = [...upcoming, ...missed, ...completed, ...cancelled];

    List<TaskEntity> filteredList = switch (_activeFilter) {
      'upcoming'  => upcoming,
      'missed'    => missed,
      'today'     => today,
      'completed' => completed,
      'cancelled' => cancelled,
      _           => allReminders,
    };

    if (_searchQuery.isNotEmpty) {
      filteredList = filteredList
          .where((t) => t.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    filteredList.sort((a, b) {
      if (_activeFilter == 'completed') {
        return b.updatedAt.compareTo(a.updatedAt);
      }
      final aMs = a.reminderMs ?? a.dueDate?.millisecondsSinceEpoch ?? 0;
      final bMs = b.reminderMs ?? b.dueDate?.millisecondsSinceEpoch ?? 0;
      return aMs.compareTo(bMs);
    });

    final now = DateTime.now();

    return Scaffold(
      backgroundColor: theme.surfaceDim,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: theme.surface,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Notification Center',
                style: context.typography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                onPressed: () => context.pop(),
              ),
              actions: [
                if (_activeFilter != 'completed' && filteredList.isNotEmpty)
                  TextButton.icon(
                    onPressed: () {
                      for (final task in filteredList) {
                        if (!task.isCompleted) {
                          ref.read(tasksNotifierProvider.notifier).toggleTaskCompletion(task.id);
                        }
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('All reminders marked as completed.')),
                      );
                    },
                    icon: const Icon(Icons.done_all_rounded, size: 16),
                    label: Text(
                      'Mark All',
                      style: context.typography.labelSmall.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyHeaderDelegate(
                child: Container(
                  color: theme.surfaceDim,
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                        child: PremiumSearchBar(
                          hintText: 'Search reminders...',
                          onChanged: (val) => setState(() => _searchQuery = val),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            _buildFilterChip('Upcoming', 'upcoming', upcoming.length),
                            _buildFilterChip('Today', 'today', today.length),
                            _buildFilterChip('Missed', 'missed', missed.length),
                            _buildFilterChip('Completed', 'completed', completed.length),
                            _buildFilterChip('Cancelled', 'cancelled', cancelled.length),
                            _buildFilterChip('All', 'all', allReminders.length),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                minHeight: 140,
                maxHeight: 140,
              ),
            ),
            if (filteredList.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off_outlined,
                        size: 64,
                        color: colors.textSecondary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No reminders found',
                        style: context.typography.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Everything is quiet here.',
                        style: context.typography.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final task = filteredList[index];
                      return _buildReminderCard(context, task, now);
                    },
                    childCount: filteredList.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String filterValue, int count) {
    final colors = context.colors;
    final isSelected = _activeFilter == filterValue;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Row(
          children: [
            Text(label),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? colors.primary.withValues(alpha: 0.2) : colors.outlineVariant.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? colors.primary : colors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        selected: isSelected,
        selectedColor: colors.primary.withValues(alpha: 0.15),
        backgroundColor: colors.surface,
        labelStyle: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? colors.primary : colors.textSecondary,
        ),
        onSelected: (val) {
          if (val) {
            setState(() => _activeFilter = filterValue);
          }
        },
      ),
    );
  }

  Widget _buildReminderCard(BuildContext context, TaskEntity task, DateTime now) {
    final theme = context.appTheme;
    final colors = context.colors;

    final isMissed    = task.computedNotificationStatus == NotificationStatus.missed;
    final isCompleted  = task.computedNotificationStatus == NotificationStatus.completed;
    final isCancelled  = task.computedNotificationStatus == NotificationStatus.cancelled;

    String dateStr = '';
    if (task.dueDate != null) {
      final diff = task.dueDate!.difference(now);
      final timeStr = DateFormat('h:mm a').format(task.dueDate!);
      if (diff.inDays == 0 && task.dueDate!.day == now.day) {
        dateStr = 'Today • $timeStr';
      } else if (diff.inDays == 1 || (diff.inDays == 0 && task.dueDate!.day == now.add(const Duration(days: 1)).day)) {
        dateStr = 'Tomorrow • $timeStr';
      } else {
        dateStr = '${DateFormat('MMM d').format(task.dueDate!)} • $timeStr';
      }
    }

    return Card(
      color: colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.3)),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.push('/tasks/${task.id}'),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🔔 ${task.title}',
                style: context.typography.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isCompleted
                    ? 'Completed'
                    : (isMissed
                        ? 'Missed • $dateStr'
                        : (isCancelled ? 'Alert cancelled' : dateStr)),
                style: context.typography.bodySmall.copyWith(
                  color: isCompleted
                      ? theme.success
                      : (isMissed ? theme.error : colors.textSecondary),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Divider(height: 1, color: colors.outlineVariant.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final btnOpen = OutlinedButton(
                    onPressed: () => context.push('/tasks/${task.id}'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: colors.outlineVariant),
                      foregroundColor: colors.textPrimary,
                    ),
                    child: const Text('Open'),
                  );

                  final btnComplete = OutlinedButton(
                    onPressed: () {
                      ref.read(tasksNotifierProvider.notifier).toggleTaskCompletion(task.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('"${task.title}" ${isCompleted ? "uncompleted" : "completed"}!')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: isCompleted ? colors.outlineVariant : theme.success),
                      foregroundColor: isCompleted ? colors.textPrimary : theme.success,
                    ),
                    child: Text(isCompleted ? 'Undo' : 'Complete'),
                  );

                  final btnSnooze = OutlinedButton(
                    onPressed: isCompleted || isCancelled
                        ? null
                        : () {
                            PlannerNotificationService.snoozeTaskReminder(
                              task.id,
                              const Duration(minutes: 10),
                              storedNotificationId: task.notificationId,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Snoozed for 10 minutes.')),
                            );
                          },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: colors.outlineVariant),
                      foregroundColor: colors.textPrimary,
                    ),
                    child: const Text('Snooze'),
                  );

                  final btnCancel = OutlinedButton(
                    onPressed: isCompleted || isCancelled
                        ? null
                        : () {
                            final updated = task.copyWith(reminderStatus: 'cancelled');
                            ref.read(tasksNotifierProvider.notifier).updateTask(updated);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Alert cancelled.')),
                            );
                          },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: isCompleted || isCancelled ? colors.outlineVariant : theme.error),
                      foregroundColor: isCompleted || isCancelled ? colors.textSecondary : theme.error,
                    ),
                    child: const Text('Cancel'),
                  );

                  if (constraints.maxWidth < 360) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: btnOpen),
                            const SizedBox(width: 8),
                            Expanded(child: btnComplete),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(child: btnSnooze),
                            const SizedBox(width: 8),
                            Expanded(child: btnCancel),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        Expanded(child: btnOpen),
                        const SizedBox(width: 6),
                        Expanded(child: btnComplete),
                        const SizedBox(width: 6),
                        Expanded(child: btnSnooze),
                        const SizedBox(width: 6),
                        Expanded(child: btnCancel),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  _StickyHeaderDelegate({
    required this.child,
    required this.minHeight,
    required this.maxHeight,
  });

  final Widget child;
  final double minHeight;
  final double maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight ||
        oldDelegate.child != child;
  }
}
