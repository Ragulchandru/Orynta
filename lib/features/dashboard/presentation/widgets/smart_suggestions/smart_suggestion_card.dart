// lib/features/dashboard/presentation/widgets/smart_suggestions/smart_suggestion_card.dart
//
// Orynta 2.0 — Smart Suggestion Card Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../../domain/models/smart_suggestion.dart';
import 'priority_badge.dart';

class SmartSuggestionCard extends StatefulWidget {
  const SmartSuggestionCard({
    super.key,
    required this.suggestion,
    required this.onTap,
  });

  final SmartSuggestion suggestion;
  final VoidCallback onTap;

  @override
  State<SmartSuggestionCard> createState() => _SmartSuggestionCardState();
}

class _SmartSuggestionCardState extends State<SmartSuggestionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.colors.primary;

    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: AppDurations.fast,
      curve: AppCurves.easeOut,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLow,
          borderRadius: context.radius.borderRadiusLg,
          border: Border.all(color: context.colors.outlineVariant),
          boxShadow: context.shadows.small,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: context.radius.borderRadiusLg,
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            borderRadius: context.radius.borderRadiusLg,
            hoverColor: primaryColor.withValues(alpha: 0.04),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Row: Icon + Title + Priority Badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.08),
                          borderRadius: context.radius.borderRadiusMd,
                        ),
                        child: Icon(
                          widget.suggestion.icon,
                          size: 20,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.suggestion.title,
                              style: context.typography.titleMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: context.colors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.suggestion.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.typography.bodySmall.copyWith(
                                color: context.colors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      PriorityBadge(priority: widget.suggestion.priority),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Bottom Row: Action Label
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        widget.suggestion.actionLabel,
                        style: context.typography.labelMedium.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
