// lib/features/settings/presentation/screens/sub_screens/notifications_settings_screen.dart
//
// Orynta 2.0 — Notifications Settings Sub-Screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/design_system/design_system.dart';
import '../../../../planner/domain/services/planner_notification_service.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/settings_widgets.dart';

class NotificationsSettingsScreen extends ConsumerWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsStateProvider);
    final notifier = ref.read(settingsStateProvider.notifier);
    final theme = context.appTheme;

    String hourLabel(int h) {
      final period = h < 12 ? 'AM' : 'PM';
      final h12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
      return '$h12:00 $period';
    }

    return Scaffold(
      backgroundColor: theme.surfaceDim,
      appBar: AppBar(
        backgroundColor: theme.surface,
        title: Text(
          'Notifications',
          style: context.typography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          physics: const BouncingScrollPhysics(),
          children: [
            // ── Daily Reminders ─────────────────────────────────────────────
            PremiumSection(
              title: 'DAILY REMINDERS',
              children: [
                PremiumListTile(
                  title: 'Daily Reminders',
                  subtitle: 'Send a daily notification to organize tasks',
                  icon: Icons.notifications_rounded,
                  iconColor: Colors.deepOrange,
                  trailing: PremiumSwitch(
                    value: settings.dailyReminderEnabled,
                    onChanged: (val) => notifier.updateDailyReminderEnabled(val),
                  ),
                ),
                if (settings.dailyReminderEnabled)
                  PremiumListTile(
                    title: 'Reminder Time',
                    subtitle: settings.dailyReminderTime,
                    icon: Icons.timer_outlined,
                    iconColor: Colors.blue,
                    onTap: () async {
                      final tod = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 9, minute: 0),
                      );
                      if (tod != null && context.mounted) {
                        final formatted =
                            '${tod.hour.toString().padLeft(2, '0')}:${tod.minute.toString().padLeft(2, '0')}';
                        notifier.updateDailyReminderTime(formatted);
                      }
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Quiet Hours ──────────────────────────────────────────────────
            PremiumSection(
              title: 'QUIET HOURS',
              children: [
                PremiumListTile(
                  title: 'Enable Quiet Hours',
                  subtitle: 'Suppress non-critical reminders at night',
                  icon: Icons.do_not_disturb_on_rounded,
                  iconColor: Colors.deepPurple,
                  trailing: PremiumSwitch(
                    value: settings.quietHoursEnabled,
                    onChanged: (val) => notifier.updateQuietHoursEnabled(val),
                  ),
                ),
                if (settings.quietHoursEnabled) ...[
                  PremiumListTile(
                    title: 'Quiet From',
                    subtitle: hourLabel(settings.quietHoursStart),
                    icon: Icons.bedtime_rounded,
                    iconColor: Colors.indigo,
                    onTap: () async {
                      final tod = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(hour: settings.quietHoursStart, minute: 0),
                      );
                      if (tod != null && context.mounted) {
                        notifier.updateQuietHoursStart(tod.hour);
                      }
                    },
                  ),
                  PremiumListTile(
                    title: 'Quiet Until',
                    subtitle: hourLabel(settings.quietHoursEnd),
                    icon: Icons.wb_sunny_rounded,
                    iconColor: Colors.amber,
                    onTap: () async {
                      final tod = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(hour: settings.quietHoursEnd, minute: 0),
                      );
                      if (tod != null && context.mounted) {
                        notifier.updateQuietHoursEnd(tod.hour);
                      }
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),

            // ── Notification History ─────────────────────────────────────────
            PremiumSection(
              title: 'NOTIFICATION HISTORY',
              children: [
                PremiumListTile(
                  title: 'Pending Notifications',
                  subtitle: 'View all scheduled reminders',
                  icon: Icons.history_rounded,
                  iconColor: Colors.teal,
                  onTap: () => _showNotificationHistory(context),
                ),
                PremiumListTile(
                  title: 'Cancel All Reminders',
                  subtitle: 'Clear every scheduled notification',
                  icon: Icons.notifications_off_rounded,
                  iconColor: Colors.red,
                  onTap: () async {
                    await PlannerNotificationService.cancelAllReminders();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All reminders cancelled')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showNotificationHistory(BuildContext context) async {
    final pending = await PlannerNotificationService.getPendingNotifications();

    if (!context.mounted) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          maxChildSize: 0.85,
          builder: (_, controller) {
            return Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Scheduled Notifications',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Divider(),
                Expanded(
                  child: pending.isEmpty
                      ? const Center(
                          child: Text('No pending notifications.'),
                        )
                      : ListView.builder(
                          controller: controller,
                          itemCount: pending.length,
                          itemBuilder: (_, i) {
                            final n = pending[i];
                            return ListTile(
                              leading: const Icon(Icons.notifications_active_outlined),
                              title: Text(n['title'] as String),
                              subtitle: Text(n['body'] as String),
                              trailing: Text(
                                '#${n['id']}',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
