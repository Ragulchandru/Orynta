// lib/features/notes/presentation/widgets/note_preview_card.dart
//
// Orynta 2.0 — Note Preview Card Component with Selection States, Context Menus, and Gestures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../domain/models/note_summary.dart';
import '../../domain/models/notes_view_mode.dart';
import '../providers/note_selection_provider.dart';
import '../providers/notes_notifier.dart';
import '../providers/notes_home_providers.dart';
import 'note_context_menu.dart';
import 'search_highlight_text.dart';
import 'archive_helper.dart';

class NotePreviewCard extends ConsumerStatefulWidget {
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
  ConsumerState<NotePreviewCard> createState() => _NotePreviewCardState();
}

class _NotePreviewCardState extends ConsumerState<NotePreviewCard> {
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

  void _handleTap(BuildContext context, WidgetRef ref) {
    final selectionState = ref.read(noteSelectionProvider);

    final isCtrlPressed = HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.controlLeft) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.controlRight) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.metaLeft) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.metaRight);

    final isShiftPressed = HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.shiftLeft) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.shiftRight);

    if (selectionState.inSelectionMode || isCtrlPressed || isShiftPressed) {
      HapticFeedback.lightImpact();
      if (isShiftPressed) {
        // Range Selection
        final allIds = ref.read(notesHomeControllerProvider).filteredNotes.map((n) => n.id).toList();
        ref.read(noteSelectionProvider.notifier).selectRange(allIds, widget.note.id);
      } else {
        ref.read(noteSelectionProvider.notifier).toggleSelection(widget.note.id);
      }
    } else {
      widget.onTap();
    }
  }

  void _handleLongPress(WidgetRef ref) {
    HapticFeedback.mediumImpact();
    ref.read(noteSelectionProvider.notifier).enterSelectionMode(widget.note.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final isSelected = ref.watch(noteSelectionProvider.select((s) => s.selectedIds.contains(widget.note.id)));
    final inSelectionMode = ref.watch(noteSelectionProvider.select((s) => s.inSelectionMode));
    
    final viewMode = ref.watch(notesHomeControllerProvider).viewMode;
    final isCompact = viewMode == NotesViewMode.compactGrid;
    final isComfortable = viewMode == NotesViewMode.comfortableList;

    final customColor = _parseColor(widget.note.colorHex, context);
    
    // Selection visual overrides
    final cardBgColor = isSelected
        ? theme.primary.withValues(alpha: 0.12)
        : (customColor ?? theme.notes.card);

    final outlineColor = isSelected
        ? theme.primary
        : (customColor != null
            ? customColor.withValues(alpha: 0.3)
            : theme.notes.cardBorder);

    final primaryContainerColor = context.colors.primaryContainer.withValues(alpha: 0.3);

    final cardBorderWidth = isSelected ? 2.0 : 1.0;
    final cardElevation = isSelected ? context.shadows.medium : context.shadows.small;

    // Card Core Content
    Widget cardContent = AnimatedScale(
      scale: _isPressed ? 0.97 : (isSelected ? 1.02 : 1.0),
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: context.radius.borderRadiusLg,
          border: Border.all(color: outlineColor, width: cardBorderWidth),
          boxShadow: cardElevation,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: context.radius.borderRadiusLg,
          child: InkWell(
            onTap: () => _handleTap(context, ref),
            onLongPress: () => _handleLongPress(ref),
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            borderRadius: context.radius.borderRadiusLg,
            hoverColor: context.colors.primary.withValues(alpha: 0.04),
            child: Padding(
              padding: isCompact
                  ? const EdgeInsets.all(12.0)
                  : (isComfortable
                      ? const EdgeInsets.all(24.0)
                      : const EdgeInsets.all(18.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title + Selection indicator + Badges
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (inSelectionMode) ...[
                        AnimatedScale(
                          scale: isSelected ? 1.0 : 0.95,
                          duration: const Duration(milliseconds: 150),
                          child: Icon(
                            isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                            color: isSelected ? theme.primary : context.colors.textSecondary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: SearchHighlightText(
                          text: widget.note.title.isNotEmpty ? widget.note.title : 'Untitled',
                          highlight: widget.searchQuery,
                          style: (isComfortable
                                  ? context.typography.titleLarge
                                  : context.typography.titleMedium)
                              .copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.colors.textPrimary,
                          ),
                          highlightStyle: (isComfortable
                                  ? context.typography.titleLarge
                                  : context.typography.titleMedium)
                              .copyWith(
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
                  if (!isCompact) ...[
                    const SizedBox(height: 8),
                    SearchHighlightText(
                      text: widget.note.previewText,
                      highlight: widget.searchQuery,
                      style: (isComfortable
                              ? context.typography.bodyMedium
                              : context.typography.bodySmall)
                          .copyWith(
                        color: context.colors.textSecondary,
                        height: 1.4,
                      ),
                      highlightStyle: (isComfortable
                              ? context.typography.bodyMedium
                              : context.typography.bodySmall)
                          .copyWith(
                        color: context.colors.primary,
                        backgroundColor: primaryContainerColor,
                        height: 1.4,
                      ),
                      maxLines: isComfortable ? 5 : 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  // Tag Chips list
                  if (widget.note.tagIds.isNotEmpty && !isCompact) ...[
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

    // Desktop Context Menu trigger (Right Click)
    cardContent = GestureDetector(
      onSecondaryTapDown: (details) {
        showNoteContextMenu(
          context: context,
          ref: ref,
          position: details.globalPosition,
          note: widget.note,
        );
      },
      child: cardContent,
    );

    // Gestures configuration: Swipe Right to Favorite, Swipe Left to Archive
    if (!inSelectionMode) {
      cardContent = Dismissible(
        key: ValueKey('dismiss_${widget.note.id}'),
        direction: DismissDirection.horizontal,
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20.0),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.8),
            borderRadius: context.radius.borderRadiusLg,
          ),
          child: const Icon(Icons.star_rounded, color: Colors.white, size: 28),
        ),
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.8),
            borderRadius: context.radius.borderRadiusLg,
          ),
          child: const Icon(Icons.archive_rounded, color: Colors.white, size: 28),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            // Swipe Right -> Favorite
            HapticFeedback.lightImpact();
            ref.read(notesProvider.notifier).toggleFavorite(widget.note.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  widget.note.isFavorite ? 'Removed from favorites' : 'Added to favorites',
                ),
                duration: const Duration(seconds: 2),
              ),
            );
            return false; // Do not dismiss note card visually from list
          } else if (direction == DismissDirection.endToStart) {
            // Swipe Left -> Archive
            HapticFeedback.lightImpact();
            ArchiveHelper.archiveWithUndo(
              context: context,
              ref: ref,
              ids: {widget.note.id},
            );
            return true; // Dismiss note card visually
          }
          return false;
        },
        child: cardContent,
      );
    }

    return cardContent;
  }
}
