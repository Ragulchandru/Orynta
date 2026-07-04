// lib/features/settings/presentation/screens/sub_screens/analytics_settings_screen.dart
//
// Orynta 2.0 — Analytics Settings Sub-Screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/design_system/design_system.dart';
import '../../widgets/settings_widgets.dart';

class AnalyticsSettingsScreen extends ConsumerWidget {
  const AnalyticsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;

    return Scaffold(
      backgroundColor: theme.surfaceDim,
      appBar: AppBar(
        backgroundColor: theme.surface,
        title: Text(
          'Analytics & Insights',
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
              title: 'PRODUCTIVITY GOALS',
              children: [
                const PremiumListTile(
                  title: 'Daily Focus Target',
                  subtitle: '2 Hours / Day',
                  icon: Icons.timer_rounded,
                  iconColor: Colors.deepPurple,
                ),
                const PremiumListTile(
                  title: 'Weekly Task Target',
                  subtitle: '20 Tasks / Week',
                  icon: Icons.check_circle_outline_rounded,
                  iconColor: Colors.green,
                ),
                PremiumListTile(
                  title: 'Custom Metric Gauges',
                  subtitle: 'Coming Soon',
                  icon: Icons.speed_rounded,
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
