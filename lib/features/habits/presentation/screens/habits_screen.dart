import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/design_system/design_system.dart';
import '../../domain/entities/habit_entity.dart';
import '../providers/habits_notifier.dart';
import '../widgets/habit_card.dart';
import '../widgets/habit_empty_state.dart';
import '../widgets/habit_progress.dart';
import '../widgets/habit_statistics.dart';
import '../widgets/streak_card.dart';

class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final habits = ref.watch(habitsProvider);
    final completedHabits = ref.watch(completedHabitsProvider);
    final currentStreak = ref.watch(activeStreakProvider);
    final longestStreak = ref.watch(longestStreakProvider);
    final consistency = ref.watch(habitConsistencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Habits',
          style: TextStyle(fontFamily: 'Playfair Display', fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(habitsProvider.notifier).loadHabits();
          },
          child: habits.isEmpty
              ? const HabitEmptyState()
              : ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg, vertical: AppSizes.md),
                  children: [
                    // 1. Streak Overview Card
                    StreakCard(
                      currentStreak: currentStreak,
                      longestStreak: longestStreak,
                    ),
                    const SizedBox(height: AppSizes.md),

                    // 2. Linear Progress Bar
                    HabitProgress(
                      completedCount: completedHabits.length,
                      totalCount: habits.length,
                    ),
                    const SizedBox(height: AppSizes.lg),

                    // 3. Habits List Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Routines',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          'Swipe to delete • Long press to manage',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.sm),

                    // 4. Habits List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: habits.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
                      itemBuilder: (context, index) {
                        final habit = habits[index];

                        return Dismissible(
                          key: Key(habit.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) {
                            ref.read(habitsProvider.notifier).deleteHabit(habit.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${habit.title} deleted')),
                            );
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: AppSizes.lg),
                            decoration: BoxDecoration(
                              color: colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(AppSizes.lg),
                            ),
                            child: Icon(
                              Icons.delete_outline_rounded,
                              color: colorScheme.onErrorContainer,
                            ),
                          ),
                          child: HabitCard(
                            habit: habit,
                            onTap: () {
                              context.push('/habits/${habit.id}/edit');
                            },
                            onIncrement: () {
                              ref.read(habitsProvider.notifier).incrementHabit(habit.id);
                            },
                            onLongPress: () {
                              _showManageOptions(context, ref, habit);
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSizes.xl),

                    // 5. Grid Statistics Summary
                    Text(
                      'Routines Performance',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    HabitStatistics(
                      consistencyRate: consistency,
                      completedToday: completedHabits.length,
                      activeStreak: currentStreak,
                      longestStreak: longestStreak,
                    ),
                    const SizedBox(height: AppSizes.xxl),
                  ],
                ),
        ),
      ),
      floatingActionButton: PremiumFAB(
        onPressed: () => context.push('/habits/new'),
        icon: const Icon(Icons.add_rounded),
      ),
    );
  }

  void _showManageOptions(BuildContext context, WidgetRef ref, HabitEntity habit) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.lg)),
      ),
      builder: (BuildContext ctx) {
        final theme = Theme.of(context);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Text(
                  'Manage: ${habit.title}',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.exposure_minus_1_rounded, color: Colors.orange),
                title: const Text('Decrement Progress Count'),
                onTap: () {
                  ref.read(habitsProvider.notifier).decrementHabit(habit.id);
                  Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit_rounded),
                title: const Text('Edit Habit Details'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  context.push('/habits/${habit.id}/edit');
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                title: const Text('Delete Habit'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _confirmDelete(context, ref, habit);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, HabitEntity habit) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Delete Habit'),
          content: Text('Are you sure you want to delete "${habit.title}"? Streak history will be lost.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ref.read(habitsProvider.notifier).deleteHabit(habit.id);
                Navigator.of(ctx).pop();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }
}
