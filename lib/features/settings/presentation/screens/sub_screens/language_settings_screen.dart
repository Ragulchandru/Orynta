// lib/features/settings/presentation/screens/sub_screens/language_settings_screen.dart
//
// Orynta 2.0 — Language & Region Settings Sub-Screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/design_system/design_system.dart';

class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;

    return Scaffold(
      backgroundColor: theme.surfaceDim,
      appBar: AppBar(
        backgroundColor: theme.surface,
        title: Text(
          'Language & Region',
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.outlineVariant,
                  width: 1.0,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.language_rounded,
                    size: 48,
                    color: theme.primary.withValues(alpha: 0.8),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Language & Region',
                    style: context.typography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'App localization, language translations, and regional format customisations are coming soon in a future update.',
                    textAlign: TextAlign.center,
                    style: context.typography.bodySmall.copyWith(
                      color: theme.isDark ? const Color(0xFF8E8EA8) : const Color(0xFF7E7E9A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
