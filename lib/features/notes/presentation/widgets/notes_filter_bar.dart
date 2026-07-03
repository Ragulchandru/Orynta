// lib/features/notes/presentation/widgets/notes_filter_bar.dart
//
// Orynta 2.0 — Notes Filter Bar Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../domain/models/notes_filter.dart';

class NotesFilterBar extends StatelessWidget {
  const NotesFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final NotesFilter selectedFilter;
  final ValueChanged<NotesFilter> onFilterChanged;

  String _getFilterLabel(NotesFilter filter) {
    switch (filter) {
      case NotesFilter.all:
        return 'All';
      case NotesFilter.recent:
        return 'Recent';
      case NotesFilter.favorites:
        return 'Favorites';
      case NotesFilter.pinned:
        return 'Pinned';
      case NotesFilter.archived:
        return 'Archived';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: NotesFilter.values.map((filter) {
          final isSelected = selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(_getFilterLabel(filter)),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onFilterChanged(filter);
                }
              },
              labelStyle: context.typography.labelMedium.copyWith(
                color: isSelected
                    ? context.colors.onPrimary
                    : context.colors.textSecondary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
              selectedColor: context.colors.primary,
              backgroundColor: context.colors.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: context.radius.borderRadiusMd,
                side: BorderSide(
                  color: isSelected
                      ? Colors.transparent
                      : context.colors.outlineVariant,
                ),
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }
}
