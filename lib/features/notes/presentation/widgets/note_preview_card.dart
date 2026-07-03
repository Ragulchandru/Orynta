// lib/features/notes/presentation/widgets/note_preview_card.dart
//
// Orynta 2.0 — Note Preview Card Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../domain/models/note_summary.dart';

class NotePreviewCard extends StatefulWidget {
  const NotePreviewCard({
    super.key,
    required this.note,
    required this.onTap,
  });

  final NoteSummary note;
  final VoidCallback onTap;

  @override
  State<NotePreviewCard> createState() => _NotePreviewCardState();
}

class _NotePreviewCardState extends State<NotePreviewCard> {
  bool _isPressed = false;

  Color? _parseColor(String? hexString, BuildContext context) {
    if (hexString == null) return null;
    try {
      final hex = hexString.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final customColor = _parseColor(widget.note.colorHex, context);
    final cardBgColor = customColor ?? context.colors.surfaceContainerLow;
    final outlineColor = customColor != null
        ? customColor.withValues(alpha: 0.3)
        : context.colors.outlineVariant;

    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: AppDurations.fast,
      curve: AppCurves.easeOut,
      child: Container(
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: context.radius.borderRadiusLg,
          border: Border.all(color: outlineColor),
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
            hoverColor: context.colors.primary.withValues(alpha: 0.04),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Badges
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.note.title.isNotEmpty ? widget.note.title : 'Untitled',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.typography.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ),
                      if (widget.note.isPinned) ...[
                        const SizedBox(width: 6),
                        Icon(
                          Icons.push_pin_rounded,
                          size: 14,
                          color: context.colors.primary,
                        ),
                      ],
                      if (widget.note.isFavorite) ...[
                        const SizedBox(width: 6),
                        Icon(
                          Icons.favorite_rounded,
                          size: 14,
                          color: context.colors.error,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Preview Content
                  Expanded(
                    child: Text(
                      widget.note.previewText,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: context.typography.bodySmall.copyWith(
                        color: context.colors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Bottom relative time
                  Text(
                    widget.note.relativeTime,
                    style: context.typography.labelSmall.copyWith(
                      color: context.colors.textSecondary.withValues(alpha: 0.8),
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
