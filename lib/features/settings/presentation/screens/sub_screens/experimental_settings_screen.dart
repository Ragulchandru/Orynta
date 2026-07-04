// lib/features/settings/presentation/screens/sub_screens/experimental_settings_screen.dart
//
// Orynta 2.0 — Experimental Settings Sub-Screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/design_system/design_system.dart';
import '../../widgets/settings_widgets.dart';

class ExperimentalSettingsScreen extends ConsumerWidget {
  const ExperimentalSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;

    return Scaffold(
      backgroundColor: theme.surfaceDim,
      appBar: AppBar(
        backgroundColor: theme.surface,
        title: Text(
          'Experimental Features',
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
              title: 'LABS & EXPERIMENTS',
              children: [
                PremiumListTile(
                  title: 'AI Suggestions Labs',
                  subtitle: 'Auto summaries and auto-tags generation (Coming Soon)',
                  icon: Icons.psychology_outlined,
                  iconColor: theme.isDark ? const Color(0xFF4E4E68) : const Color(0xFF8E8EA8),
                ),
                PremiumListTile(
                  title: 'Experimental Grid Layouts',
                  subtitle: 'Optimized masonry layouts for tablet (Coming Soon)',
                  icon: Icons.dashboard_customize_outlined,
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
