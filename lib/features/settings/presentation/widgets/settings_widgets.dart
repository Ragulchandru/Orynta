// lib/features/settings/presentation/widgets/settings_widgets.dart
//
// Orynta 2.0 — Shared Premium Settings Components (Switch, ListTile, Section, BottomSheet)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/design_system/design_system.dart';

class PremiumSection extends StatelessWidget {
  const PremiumSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
            child: Text(
              title,
              style: context.typography.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          PremiumCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: theme.outlineVariant,
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PremiumListTile extends StatelessWidget {
  const PremiumListTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.iconColor,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final titleColor = theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C);
    final subtitleColor = theme.isDark ? const Color(0xFF8E8EA8) : const Color(0xFF8E8EA8);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.typography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: context.typography.bodySmall.copyWith(
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else if (onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                color: theme.isDark ? const Color(0xFF4E4E68) : const Color(0xFF8E8EA8),
              ),
          ],
        ),
      ),
    );
  }
}

class PremiumSwitch extends StatelessWidget {
  const PremiumSwitch({
    super.key,
    required this.value,
    this.onChanged,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return Switch.adaptive(
      value: value,
      onChanged: onChanged != null ? (val) {
        HapticFeedback.lightImpact();
        onChanged!(val);
      } : null,
      activeThumbColor: theme.primary,
      activeTrackColor: theme.primary.withValues(alpha: 0.2),
      inactiveThumbColor: theme.isDark ? const Color(0xFF8E8EA8) : const Color(0xFF8E8EA8),
      inactiveTrackColor: theme.surfaceContainer,
    );
  }
}

class PremiumBottomSheet extends StatelessWidget {
  const PremiumBottomSheet({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
        border: Border.all(color: theme.outlineVariant, width: 1.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: theme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: context.typography.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
            ),
          ),
          const SizedBox(height: 16),
          Flexible(child: child),
        ],
      ),
    );
  }
}
