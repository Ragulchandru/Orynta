// lib/features/notes/presentation/widgets/note_metadata_sheet.dart
//
// Orynta 2.0 — Note Metadata Bottom Sheet Component

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../../domain/models/note_color.dart';
import 'metadata_action_tile.dart';
import 'note_color_picker.dart';

class NoteMetadataSheet extends StatelessWidget {
  const NoteMetadataSheet({
    super.key,
    required this.isPinned,
    required this.isFavorite,
    required this.isArchived,
    required this.selectedColor,
    required this.onPinChanged,
    required this.onFavoriteChanged,
    required this.onArchiveChanged,
    required this.onColorChanged,
  });

  final bool isPinned;
  final bool isFavorite;
  final bool isArchived;
  final NoteColor selectedColor;
  final ValueChanged<bool> onPinChanged;
  final ValueChanged<bool> onFavoriteChanged;
  final ValueChanged<bool> onArchiveChanged;
  final ValueChanged<NoteColor> onColorChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.outlineVariant,
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),

          // Header Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Text(
              'Note Options',
              style: context.typography.titleLarge.copyWith(
                fontWeight: FontWeight.w800,
                color: context.colors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Action Items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                MetadataActionTile(
                  icon: Icons.push_pin_outlined,
                  title: 'Pin Note',
                  subtitle: 'Keep this note at the top of your list',
                  value: isPinned,
                  onChanged: onPinChanged,
                ),
                const SizedBox(height: 8),
                MetadataActionTile(
                  icon: Icons.star_border_rounded,
                  title: 'Favorite Note',
                  subtitle: 'Add to your collection of favorites',
                  value: isFavorite,
                  onChanged: onFavoriteChanged,
                ),
                const SizedBox(height: 8),
                MetadataActionTile(
                  icon: Icons.archive_outlined,
                  title: 'Archive Note',
                  subtitle: 'Hide from main feed but keep stored',
                  value: isArchived,
                  onChanged: onArchiveChanged,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(indent: 24, endIndent: 24),
          const SizedBox(height: 16),

          // Color Picker Section
          NoteColorPicker(
            selectedColor: selectedColor,
            onColorSelected: onColorChanged,
          ),
        ],
      ),
    );
  }
}
