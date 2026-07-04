// lib/features/settings/presentation/screens/sub_screens/notifications_settings_screen.dart
//
// Orynta 2.0 — Notifications Settings Sub-Screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/design_system/design_system.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/settings_widgets.dart';

class NotificationsSettingsScreen extends ConsumerWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsStateProvider);
    final settingsNotifier = ref.read(settingsStateProvider.notifier);
    final theme = context.appTheme;

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
            PremiumSection(
              title: 'DAILY REMINDERS',
              children: [
                PremiumListTile(
                  title: 'Daily Reminders',
                  subtitle: 'Send a quick notification to organize tasks',
                  icon: Icons.notifications_rounded,
                  iconColor: Colors.deepOrange,
                  trailing: PremiumSwitch(
                    value: settings.dailyReminderEnabled,
                    onChanged: (val) => settingsNotifier.updateDailyReminderEnabled(val),
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
                      if (tod != null) {
                        final formatted =
                            '${tod.hour.toString().padLeft(2, '0')}:${tod.minute.toString().padLeft(2, '0')}';
                        settingsNotifier.updateDailyReminderTime(formatted);
                      }
                    },
                  ),
                PremiumListTile(
                  title: 'Quiet Hours',
                  subtitle: 'Suppress planner reminders at night',
                  icon: Icons.do_not_disturb_on_rounded,
                  iconColor: Colors.deepPurple,
                  trailing: PremiumSwitch(
                    value: settings.quietHoursEnabled,
                    onChanged: (val) => settingsNotifier.updateQuietHoursEnabled(val),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
