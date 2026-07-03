// lib/features/dashboard/presentation/widgets/habits/habit_list_item.dart
//
// Orynta 2.0 — Habit List Item Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../../domain/models/habit_summary.dart';

class HabitListItem extends StatefulWidget {
  const HabitListItem({
    super.key,
    required this.habit,
    required this.onTap,
  });

  final HabitSummary habit;
  final VoidCallback onTap;

  @override
  State<HabitListItem> createState() => _HabitListItemState();
}

class _HabitListItemState extends State<HabitListItem> {
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
          borderRadius: context.radius.borderRadiusMd,
          border: Border.all(color: context.colors.outlineVariant),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: context.radius.borderRadiusMd,
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            borderRadius: context.radius.borderRadiusMd,
            hoverColor: primaryColor.withValues(alpha: 0.04),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.08),
                      borderRadius: context.radius.borderRadiusSm,
                    ),
                    child: Icon(
                      widget.habit.icon,
                      size: 18,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.habit.title,
                          style: context.typography.titleSmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.habit.streakLabel,
                          style: context.typography.labelSmall.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (widget.habit.hasReminder) ...[
                    Icon(
                      Icons.alarm_outlined,
                      size: 16,
                      color: context.colors.textSecondary,
                    ),
                    const SizedBox(width: 10),
                  ],

                  Icon(
                    widget.habit.isCompletedToday
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 22,
                    color: widget.habit.isCompletedToday
                        ? primaryColor
                        : context.colors.outlineVariant,
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
