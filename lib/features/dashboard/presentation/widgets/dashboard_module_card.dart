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
    Widget cardContent = Container(
      width: double.infinity,
      padding: padding ?? context.spacing.paddingCard,
      decoration: BoxDecoration(
        color: gradient == null ? context.colors.surfaceContainerLow : null,
        gradient: gradient,
        borderRadius: context.radius.borderRadiusLg,
        border: Border.all(color: context.colors.outlineVariant),
        boxShadow: context.shadows.small,
      ),
      child: Stack(
        children: [
          child,
          if (isLocked)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: context.colors.background.withValues(alpha: 0.7),
                  borderRadius: context.radius.borderRadiusLg,
                ),
                child: Center(
                  child: Icon(
                    Icons.lock_outline_rounded,
                    color: context.colors.primary,
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

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: context.radius.borderRadiusLg,
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}
