// lib/shared/widgets/premium_card.dart
//
// Orynta 2.0 — Premium M3 Card widget

import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';

class PremiumCard extends StatelessWidget {
  const PremiumCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.color,
    this.borderColor,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? borderColor;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final bg = color ?? theme.notes.card;
    final border = borderColor ?? theme.notes.cardBorder;
    final radius = borderRadius ?? BorderRadius.circular(16.0);

    return HoverCard(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: radius,
          border: Border.all(color: border, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: theme.isDark ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
