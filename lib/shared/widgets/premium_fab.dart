// lib/shared/widgets/premium_fab.dart
//
// Orynta 2.0 — Custom animated Floating Action Button

import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';

class PremiumFAB extends StatelessWidget {
  const PremiumFAB({
    super.key,
    required this.onPressed,
    required this.icon,
    this.label,
    this.backgroundColor,
  });

  final VoidCallback onPressed;
  final Widget icon;
  final String? label;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final bg = backgroundColor ?? theme.primary;
    final fg = theme.isDark ? const Color(0xFF0F0F17) : const Color(0xFFFFFFFF);

    return ScaleOnPress(
      onTap: onPressed,
      child: Container(
        height: 56.0,
        padding: EdgeInsets.symmetric(horizontal: label != null ? 20.0 : 16.0),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: bg.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                iconTheme: IconThemeData(color: fg),
              ),
              child: icon,
            ),
            if (label != null) ...[
              const SizedBox(width: 8),
              Text(
                label!,
                style: context.typography.labelLarge.copyWith(
                  color: fg,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
