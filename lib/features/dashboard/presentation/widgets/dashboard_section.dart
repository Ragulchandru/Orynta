// lib/features/dashboard/presentation/widgets/dashboard_section.dart
//
// Orynta 2.0 — Reusable Dashboard Section Component
//
// Provides section headers (title, subtitle, icon, action, badge) and animation delays.

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_tokens.dart';

class DashboardSection extends StatelessWidget {
  const DashboardSection({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.action,
    this.badge,
    this.animationDelay = Duration.zero,
    required this.child,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? action;
  final Widget? badge;
  final Duration animationDelay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 4.0, right: 4.0),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 20,
                  color: context.colors.primary,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: context.typography.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.colors.textPrimary,
                          ),
                        ),
                        if (badge != null) ...[
                          const SizedBox(width: 8),
                          badge!,
                        ],
                      ],
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
              if (action != null) action!,
            ],
          ),
        ),

        // Section Content
        child,
      ],
    );
  }
}
