// lib/shared/widgets/premium_header.dart
//
// Orynta 2.0 — Premium layout section header

import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';

class PremiumHeader extends StatelessWidget {
  const PremiumHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.typography.headlineSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: context.typography.bodySmall.copyWith(
                      color: theme.isDark ? const Color(0xFFC5C5D3) : const Color(0xFF4E4E68),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (actions.isNotEmpty)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
        ],
      ),
    );
  }
}
