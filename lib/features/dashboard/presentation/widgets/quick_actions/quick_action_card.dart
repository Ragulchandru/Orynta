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
    final theme = context.appTheme;
    final colors = context.colors;
    final primaryColor = theme.primary;
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
            color: theme.notes.card,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: isEnabled
                  ? theme.notes.cardBorder
                  : theme.notes.cardBorder.withValues(alpha: 0.5),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: InkWell(
              onTap: isEnabled ? widget.onTap : null,
              onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
              onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
              onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
              borderRadius: BorderRadius.circular(AppRadius.lg),
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
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Icon(
                            widget.action.icon,
                            size: 22,
                            color: isEnabled ? primaryColor : colors.textSecondary,
                          ),
                        ),
                        if (widget.action.badge != null)
                          Flexible(
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                widget.action.badge!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.typography.labelSmall.copyWith(
                                  color: theme.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      widget.action.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.typography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isEnabled ? colors.textPrimary : colors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    if (widget.action.subtitle != null && widget.action.subtitle!.isNotEmpty)
                      Expanded(
                        child: Text(
                          widget.action.subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.typography.bodySmall.copyWith(
                            color: colors.textSecondary,
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
