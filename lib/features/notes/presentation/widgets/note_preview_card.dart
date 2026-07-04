// lib/features/notes/presentation/widgets/note_preview_card.dart
//
// Orynta 2.0 — Note Preview Card Component with Search Query Highlights

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../domain/models/note_summary.dart';
import 'search_highlight_text.dart';

class NotePreviewCard extends StatefulWidget {
  const NotePreviewCard({
    super.key,
    required this.note,
    required this.onTap,
    this.searchQuery = '',
  });

  final NoteSummary note;
  final VoidCallback onTap;
  final String searchQuery;

  @override
  State<NotePreviewCard> createState() => _NotePreviewCardState();
}

class _NotePreviewCardState extends State<NotePreviewCard> {
  bool _isPressed = false;

  Color? _parseColor(String? hexString, BuildContext context) {
    if (hexString == null) return null;
    try {
      var hex = hexString.replaceAll('#', '');
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse(hex, radix: 16));
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

    final primaryContainerColor = context.colors.primaryContainer.withValues(alpha: 0.3);

    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
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
                        child: SearchHighlightText(
                          text: widget.note.title.isNotEmpty ? widget.note.title : 'Untitled',
                          highlight: widget.searchQuery,
                          style: context.typography.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.colors.textPrimary,
                          ),
                          highlightStyle: context.typography.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.colors.primary,
                            backgroundColor: primaryContainerColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                    child: SearchHighlightText(
                      text: widget.note.previewText,
                      highlight: widget.searchQuery,
                      style: context.typography.bodySmall.copyWith(
                        color: context.colors.textSecondary,
                        height: 1.4,
                      ),
                      highlightStyle: context.typography.bodySmall.copyWith(
                        color: context.colors.primary,
                        backgroundColor: primaryContainerColor,
                        height: 1.4,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Tag Chips list inside note card
                  if (widget.note.tagIds.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: widget.note.tagIds.map((tag) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: RawChip(
                              label: SearchHighlightText(
                                text: '#$tag',
                                highlight: widget.searchQuery,
                                style: context.typography.labelSmall.copyWith(
                                  color: context.colors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                highlightStyle: context.typography.labelSmall.copyWith(
                                  color: context.colors.primary,
                                  fontWeight: FontWeight.bold,
                                  backgroundColor: primaryContainerColor,
                                ),
                              ),
                              backgroundColor: context.colors.primary.withValues(alpha: 0.08),
                              side: BorderSide(
                                color: context.colors.primary.withValues(alpha: 0.15),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],

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
