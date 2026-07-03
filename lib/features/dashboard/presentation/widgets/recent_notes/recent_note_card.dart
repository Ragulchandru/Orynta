// lib/features/dashboard/presentation/widgets/recent_notes/recent_note_card.dart
//
// Orynta 2.0 — Recent Note Card Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../../domain/models/recent_note_summary.dart';

class RecentNoteCard extends StatefulWidget {
  const RecentNoteCard({
    super.key,
    required this.note,
    required this.onTap,
  });

  final RecentNoteSummary note;
  final VoidCallback onTap;

  @override
  State<RecentNoteCard> createState() => _RecentNoteCardState();
}

class _RecentNoteCardState extends State<RecentNoteCard> {
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
                  // Title & Pinned Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.note.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.typography.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ),
                      if (widget.note.isPinned) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.push_pin_rounded,
                          size: 16,
                          color: primaryColor,
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Preview Snippet (Max 2 lines)
                  Text(
                    widget.note.preview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.typography.bodySmall.copyWith(
                      color: context.colors.textSecondary,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Footer: Relative timestamp
                  Text(
                    widget.note.relativeTime,
                    style: context.typography.labelSmall.copyWith(
                      color: context.colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
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
