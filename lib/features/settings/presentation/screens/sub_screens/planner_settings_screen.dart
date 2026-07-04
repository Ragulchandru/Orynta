// lib/features/settings/presentation/screens/sub_screens/planner_settings_screen.dart
//
// Orynta 2.0 — Planner Settings Sub-Screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/design_system/design_system.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/settings_widgets.dart';

class PlannerSettingsScreen extends ConsumerWidget {
  const PlannerSettingsScreen({super.key});

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
          'Planner Settings',
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
              title: 'CALENDAR & DISPLAY',
              children: [
                PremiumListTile(
                  title: 'Week Starts On',
                  subtitle: settings.weekStartsOn,
                  icon: Icons.calendar_view_week_rounded,
                  iconColor: Colors.amber,
                  trailing: DropdownButton<String>(
                    value: settings.weekStartsOn,
                    onChanged: (val) {
                      if (val != null) settingsNotifier.updateWeekStartsOn(val);
                    },
                    underline: const SizedBox(),
                    items: ['Monday', 'Sunday']
                        .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                        .toList(),
                  ),
                ),
                PremiumListTile(
                  title: 'Calendar View Default',
                  subtitle: settings.calendarView,
                  icon: Icons.calendar_view_month_rounded,
                  iconColor: Colors.indigo,
                  trailing: DropdownButton<String>(
                    value: settings.calendarView,
                    onChanged: (val) {
                      if (val != null) settingsNotifier.updateCalendarView(val);
                    },
                    underline: const SizedBox(),
                    items: ['Month', 'Week']
                        .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                        .toList(),
                  ),
                ),
                PremiumListTile(
                  title: '24-Hour Time Format',
                  subtitle: settings.timeFormat24h ? '14:00 (Active)' : '2:00 PM (Active)',
                  icon: Icons.access_time_rounded,
                  iconColor: Colors.teal,
                  trailing: PremiumSwitch(
                    value: settings.timeFormat24h,
                    onChanged: (val) => settingsNotifier.updateTimeFormat24h(val),
                  ),
                ),
                PremiumListTile(
                  title: 'Planner Priority Colors',
                  subtitle: 'Coming Soon',
                  icon: Icons.color_lens_outlined,
                  iconColor: theme.isDark ? const Color(0xFF4E4E68) : const Color(0xFF8E8EA8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
