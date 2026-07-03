// lib/features/dashboard/presentation/widgets/planner_snapshot/next_event_card.dart
//
// Orynta 2.0 — Next Event Card Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../../domain/models/planner_event_summary.dart';

class NextEventCard extends StatefulWidget {
  const NextEventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  final PlannerEventSummary event;
  final VoidCallback onTap;

  @override
  State<NextEventCard> createState() => _NextEventCardState();
}

class _NextEventCardState extends State<NextEventCard> {
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
                children: [
                  // Top Row: Relative Day Badge + Duration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: context.radius.borderRadiusSm,
                        ),
                        child: Text(
                          widget.event.relativeDay,
                          style: context.typography.labelSmall.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        widget.event.durationString,
                        style: context.typography.bodySmall.copyWith(
                          color: context.colors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Event Title
                  Text(
                    widget.event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.typography.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.colors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Time Range & Location Row
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: context.colors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.event.timeRange,
                        style: context.typography.bodySmall.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                      if (widget.event.location != null && widget.event.location!.isNotEmpty) ...[
                        const SizedBox(width: 12),
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: context.colors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.event.location!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.typography.bodySmall.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ),
                      ],
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
