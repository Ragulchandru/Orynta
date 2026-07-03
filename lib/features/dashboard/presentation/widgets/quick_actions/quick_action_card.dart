// lib/features/dashboard/presentation/widgets/quick_actions/quick_action_card.dart
//
// Orynta 2.0 — Quick Action Card Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../../domain/models/quick_action.dart';

class QuickActionCard extends StatefulWidget {
  const QuickActionCard({
    super.key,
    required this.action,
    required this.onTap,
  });

  final QuickAction action;
  final VoidCallback onTap;

  @override
  State<QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<QuickActionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.colors.primary;
    final isEnabled = widget.action.enabled;

    return AnimatedScale(
      scale: _isPressed && isEnabled ? 0.97 : 1.0,
      duration: AppDurations.fast,
      curve: AppCurves.easeOut,
      child: AnimatedOpacity(
        opacity: isEnabled ? 1.0 : 0.5,
        duration: AppDurations.fast,
        child: Container(
          constraints: const BoxConstraints(minHeight: 56.0),
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerLow,
            borderRadius: context.radius.borderRadiusLg,
            border: Border.all(
              color: isEnabled
                  ? context.colors.outlineVariant
                  : context.colors.outlineVariant.withValues(alpha: 0.5),
            ),
            boxShadow: isEnabled ? context.shadows.small : null,
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: context.radius.borderRadiusLg,
            child: InkWell(
              onTap: isEnabled ? widget.onTap : null,
              onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
              onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
              onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
              borderRadius: context.radius.borderRadiusLg,
              hoverColor: primaryColor.withValues(alpha: 0.04),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Icon + Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: isEnabled ? 0.08 : 0.04),
                            borderRadius: context.radius.borderRadiusMd,
                          ),
                          child: Icon(
                            widget.action.icon,
                            size: 22,
                            color: isEnabled ? primaryColor : context.colors.textSecondary,
                          ),
                        ),
                        if (widget.action.badge != null)
                          Flexible(
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: context.colors.primary.withValues(alpha: 0.1),
                                borderRadius: context.radius.borderRadiusSm,
                              ),
                              child: Text(
                                widget.action.badge!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.typography.labelSmall.copyWith(
                                  color: context.colors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Title
                    Text(
                      widget.action.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.typography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isEnabled ? context.colors.textPrimary : context.colors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Subtitle / Content (Flexible)
                    if (widget.action.subtitle != null && widget.action.subtitle!.isNotEmpty)
                      Expanded(
                        child: Text(
                          widget.action.subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.typography.bodySmall.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
