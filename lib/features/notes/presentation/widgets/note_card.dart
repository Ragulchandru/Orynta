// lib/features/notes/presentation/widgets/note_card.dart
//
// NoteCard — Domain-aware note card for InkFlow's list views.
//
// This widget knows about NoteEntity and renders all its visual fields.
// It lives in the PRESENTATION layer of the notes feature — not in
// shared/widgets — because it depends on the domain model.
//
// Visual anatomy:
//
//   ┌─────────────────────────────────────┐  ← color tint background
//   │ 📌  [pin indicator, if pinned]      │
//   │ Note title (titleSmall, 2-line max) │
//   │ Body preview  (bodySmall, 2-line)   │
//   │                                     │
//   │ [chip]    Jun 28      ♥             │  ← footer row
//   └─────────────────────────────────────┘
//
// Color tinting:
//   Uses NoteEntity.color (stored as ARGB int). If null or equal to
//   AppColors.noteColorDefault (0xFFFFFFFF), the card uses the theme's
//   default surface color so it blends naturally in both light and dark mode.
//
// Timestamp display:
//   < 7 days ago: relative ("2 hours ago", "Yesterday")
//   ≥ 7 days ago: absolute ("Jun 28", "Dec 3, 2024")
//   Computed with a lightweight local helper — no intl package dependency.
//
// Long-press menu:
//   Opens a modal bottom sheet (NoteActionsSheet) with all context actions.
//   The caller passes callbacks for each action — NoteCard has zero logic.
//
// Why feature-scoped instead of shared?
//   NoteCard depends on NoteEntity (domain model). Putting it in shared/widgets
//   would create an import from shared → features, breaking the layering.
//   Feature-specific widgets stay in features/notes/presentation/widgets/.

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../domain/entities/note_entity.dart';
import '../../../../shared/widgets/ink_card.dart';

/// A domain-aware card widget for a single [NoteEntity].
///
/// Renders color tinting, title, body preview, pin indicator, favorite
/// indicator, and a relative/absolute timestamp. Tapping calls [onTap];
/// long-pressing opens the [NoteActionsSheet] bottom sheet.
class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    this.onArchive,
    this.onDelete,
    this.onTogglePin,
    this.onToggleFavorite,
    this.animationDelay = Duration.zero,
  });

  /// The note to render.
  final NoteEntity note;

  /// Called when the card is tapped (navigate to editor).
  final VoidCallback onTap;

  /// Called when the user selects "Archive" from the bottom sheet.
  /// Pass `null` on Archive/Trash screens where archiving is not applicable.
  final VoidCallback? onArchive;

  /// Called when the user selects "Delete" from the bottom sheet.
  final VoidCallback? onDelete;

  /// Called when the user selects "Pin / Unpin" from the bottom sheet.
  final VoidCallback? onTogglePin;

  /// Called when the user taps the favorite heart icon.
  final VoidCallback? onToggleFavorite;

  /// Stagger delay for list entrance animations. Pass `Duration(milliseconds: index * 40)`.
  final Duration animationDelay;

  // ─── Color Tinting ─────────────────────────────────────────────────────────

  /// Returns the card background color.
  ///
  /// If [NoteEntity.color] is null or the default white sentinel, returns null
  /// so [InkCard] falls back to the theme's surfaceContainerLow.
  Color? _cardColor(BuildContext context) {
    final raw = note.color;
    if (raw == null || raw == AppColors.noteColorDefault) return null;

    // In dark mode, soften the pastel tones to avoid harsh brightness.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = Color(raw);
    return isDark ? Color.alphaBlend(Colors.black.withValues(alpha: 0.35), base) : base;
  }

  // ─── Timestamp ─────────────────────────────────────────────────────────────

  /// Returns a human-readable timestamp string.
  ///
  /// - < 1 minute ago: "Just now"
  /// - < 1 hour ago:   "42 minutes ago"
  /// - < 24 hours ago: "3 hours ago"
  /// - < 7 days ago:   "Yesterday" / "3 days ago"
  /// - ≥ 7 days ago:   "Jun 28" or "Jun 28, 2023" (if different year)
  String _timestamp() {
    final now = DateTime.now();
    final diff = now.difference(note.updatedAt);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';

    // Absolute date for older notes.
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final month = months[note.updatedAt.month - 1];
    final day = note.updatedAt.day;
    final year = note.updatedAt.year;

    return year == now.year
        ? '$month $day'
        : '$month $day, $year';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasTitle = note.title.isNotEmpty;
    final hasBody = note.body.isNotEmpty;

    return InkCard(
      backgroundColor: _cardColor(context),
      onTap: onTap,
      onLongPress: () => _showActionsSheet(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Pin Indicator ──────────────────────────────────────────────
          if (note.isPinned) ...[
            Row(
              children: [
                Icon(
                  Icons.push_pin,
                  size: AppSizes.iconSm,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.xs),
          ],

          // ── Title ──────────────────────────────────────────────────────
          if (hasTitle) ...[
            Text(
              note.title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (hasBody) const SizedBox(height: AppSizes.xs),
          ],

          // ── Body Preview ───────────────────────────────────────────────
          if (hasBody)
            Text(
              note.body,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

          const SizedBox(height: AppSizes.sm),

          // ── Footer Row ─────────────────────────────────────────────────
          Row(
            children: [
              // Timestamp
              Text(
                _timestamp(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.7),
                ),
              ),

              const Spacer(),

              // Favorite toggle
              GestureDetector(
                onTap: onToggleFavorite,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.xs),
                  child: Icon(
                    note.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: AppSizes.iconSm,
                    color: note.isFavorite
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    )
        // Staggered entrance animation for list items.
        .animate(delay: animationDelay)
        .fadeIn(duration: AppSizes.durationNormal)
        .slideY(
          begin: 0.08,
          end: 0,
          duration: AppSizes.durationNormal,
          curve: Curves.easeOutCubic,
        );
  }

  // ─── Long-press Bottom Sheet ───────────────────────────────────────────────

  /// Opens the context actions modal bottom sheet for this note.
  void _showActionsSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => _NoteActionsSheet(
        note: note,
        onTogglePin: onTogglePin,
        onArchive: onArchive,
        onDelete: onDelete,
      ),
    );
  }
}

// ─── Context Actions Bottom Sheet ─────────────────────────────────────────────

/// Private modal bottom sheet listing context actions for a note.
///
/// Called by [NoteCard] on long-press. Kept private — callers interact
/// with [NoteCard] via callbacks, not with this widget directly.
class _NoteActionsSheet extends StatelessWidget {
  const _NoteActionsSheet({
    required this.note,
    this.onTogglePin,
    this.onArchive,
    this.onDelete,
  });

  final NoteEntity note;
  final VoidCallback? onTogglePin;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 32,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSizes.sm),
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
            ),

            // ── Pin / Unpin ──────────────────────────────────────────────
            if (onTogglePin != null)
              _ActionTile(
                icon: note.isPinned
                    ? Icons.push_pin_outlined
                    : Icons.push_pin_rounded,
                label: note.isPinned ? 'Unpin' : 'Pin',
                onTap: () {
                  Navigator.of(context).pop();
                  onTogglePin!();
                },
              ),

            // ── Archive ──────────────────────────────────────────────────
            if (onArchive != null)
              _ActionTile(
                icon: Icons.archive_outlined,
                label: 'Archive',
                onTap: () {
                  Navigator.of(context).pop();
                  onArchive!();
                },
              ),

            // ── Delete ───────────────────────────────────────────────────
            if (onDelete != null)
              _ActionTile(
                icon: Icons.delete_outline_rounded,
                label: 'Move to trash',
                color: theme.colorScheme.error,
                onTap: () {
                  Navigator.of(context).pop();
                  onDelete!();
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// A single row action tile inside the bottom sheet.
class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedColor = color ?? theme.colorScheme.onSurface;

    return ListTile(
      leading: Icon(icon, color: resolvedColor),
      title: Text(
        label,
        style: theme.textTheme.bodyLarge?.copyWith(color: resolvedColor),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.xs,
      ),
    );
  }
}
