// lib/features/dashboard/presentation/widgets/dashboard_module_card.dart
//
// Orynta 2.0 — Reusable Dashboard Module Container Card

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_tokens.dart';

class DashboardModuleCard extends StatelessWidget {
  const DashboardModuleCard({
    super.key,
    required this.child,
    this.isGlass = false,
    this.gradient,
    this.heroTag,
    this.isPremium = false,
    this.isLocked = false,
    this.isCollapsed = false,
    this.padding,
    this.onTap,
  });

  final Widget child;
  final bool isGlass;
  final Gradient? gradient;
  final String? heroTag;
  final bool isPremium;
  final bool isLocked;
  final bool isCollapsed;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    Widget cardContent = PremiumCard(
      padding: padding ?? const EdgeInsets.all(16.0),
      color: gradient == null ? theme.notes.card : null,
      borderColor: theme.notes.cardBorder,
      onTap: onTap,
      child: Stack(
        children: [
          child,
          if (isLocked)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.surfaceDim.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Center(
                  child: Icon(
                    Icons.lock_outline_rounded,
                    color: theme.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (heroTag != null) {
      cardContent = Hero(tag: heroTag!, child: cardContent);
    }

    return cardContent;
  }
}
