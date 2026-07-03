// lib/features/dashboard/presentation/widgets/today/today_card.dart
//
// Orynta 2.0 — Reusable Today Card Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';

class TodayCard extends StatelessWidget {
  const TodayCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.body,
    this.footer,
    this.isEmpty = false,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget body;
  final Widget? footer;
  final bool isEmpty;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.colors.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: context.radius.borderRadiusLg,
        border: Border.all(
          color: isEmpty
              ? context.colors.outlineVariant.withValues(alpha: 0.6)
              : context.colors.outlineVariant,
        ),
        boxShadow: context.shadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.08),
                  borderRadius: context.radius.borderRadiusMd,
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.typography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: context.typography.bodySmall.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Body Content
          Expanded(child: body),

          if (footer != null) ...[
            const SizedBox(height: 12),
            footer!,
          ],
        ],
      ),
    );
  }
}
