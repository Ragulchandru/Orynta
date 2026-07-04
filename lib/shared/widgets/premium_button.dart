// lib/shared/widgets/premium_button.dart
//
// Orynta 2.0 — Premium scaling button

import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';

class PremiumButton extends StatelessWidget {
  const PremiumButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final VoidCallback onTap;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final bg = backgroundColor ?? theme.primary;
    final fg = foregroundColor ?? (theme.isDark ? const Color(0xFF0F0F17) : const Color(0xFFFFFFFF));

    return ScaleOnPress(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: context.typography.labelLarge.copyWith(
                color: fg,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
