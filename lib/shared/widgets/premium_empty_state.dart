// lib/shared/widgets/premium_empty_state.dart
//
// Orynta 2.0 — Custom premium empty state card helper

import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';

class PremiumEmptyState extends StatelessWidget {
  const PremiumEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.action,
  });

  final String title;
  final String subtitle;
  final Widget icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: theme.surfaceContainer,
                shape: BoxShape.circle,
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  iconTheme: IconThemeData(
                    color: theme.primary.withValues(alpha: 0.6),
                    size: 48,
                  ),
                ),
                child: icon,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: context.typography.titleLarge.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: context.typography.bodyMedium.copyWith(
                color: theme.isDark ? const Color(0xFFC5C5D3) : const Color(0xFF4E4E68),
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
