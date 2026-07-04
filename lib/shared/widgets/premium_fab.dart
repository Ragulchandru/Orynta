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
    
    // Dynamically compute high contrast foreground color based on background luminance
    final isLightBg = bg.computeLuminance() > 0.5;
    final fg = isLightBg ? const Color(0xFF11111C) : const Color(0xFFFFFFFF);

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
              color: bg.withValues(alpha: theme.isDark ? 0.4 : 0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconTheme(
              data: IconThemeData(color: fg, size: 24),
              child: icon,
            ),
            if (label != null) ...[
              const SizedBox(width: 8),
              Text(
                label!,
                style: context.typography.labelLarge.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
