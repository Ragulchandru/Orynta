// lib/features/notes/presentation/widgets/notes_search_overlay.dart
//
// Orynta 2.0 — Premium Search Suggestions, Tags & Filter Panel Overlay

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../domain/models/note_summary.dart';
import '../../domain/models/smart_filter.dart';
import '../../domain/models/sort_option.dart';
import '../controllers/notes_home_controller.dart';
import '../providers/notes_home_providers.dart';
import 'notes_grid.dart';

class NotesSearchOverlay extends ConsumerWidget {
  const NotesSearchOverlay({
    super.key,
    required this.onNoteTap,
    required this.searchController,
  });

  final Function(BuildContext, NoteSummary) onNoteTap;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notesHomeControllerProvider);
    final controller = ref.read(notesHomeControllerProvider.notifier);

    // Compute all tags and frequency counts safely
    final tagCounts = <String, int>{};
    final nonNullNotes = state.notes.whereType<NoteSummary>().toList();
    for (final note in nonNullNotes) {
      final tags = note.tagIds;
      for (final tag in tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }
    final sortedTags = tagCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Compute recently edited notes safely
    final recentlyEdited = List<NoteSummary>.from(nonNullNotes)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    final displayRecentNotes = recentlyEdited.take(4).toList();

    final isSearching = state.searchQuery.trim().isNotEmpty;

    return Container(
      color: context.colors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Smart Filters & Sorting Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: SmartFilter.values.map((filter) {
                      final isSelected = state.activeFilters.contains(filter);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(filter.label),
                          selected: isSelected,
                          onSelected: (_) {
                            controller.toggleSmartFilter(filter);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelStyle: context.typography.labelSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : context.colors.textSecondary,
                          ),
                          selectedColor: context.colors.primary,
                          backgroundColor: context.colors.surfaceContainerLow,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sort Options',
                      style: context.typography.labelSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colors.textSecondary,
                      ),
                    ),
                    PopupMenuButton<SortOption>(
                      initialValue: state.sortOption,
                      onSelected: controller.setSortOption,
                      itemBuilder: (context) => SortOption.values.map((option) {
                        return PopupMenuItem<SortOption>(
                          value: option,
                          child: Text(
                            option.label,
                            style: context.typography.bodyMedium,
                          ),
                        );
                      }).toList(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          color: context.colors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: context.colors.outlineVariant),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.sortOption.label,
                              style: context.typography.labelSmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.colors.primary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_drop_down_rounded,
                              size: 18,
                              color: context.colors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Search content area
          Expanded(
            child: isSearching
                ? _SearchResultsArea(
                    onNoteTap: onNoteTap,
                    searchQuery: state.searchQuery,
                    filteredNotes: state.filteredNotes.whereType<NoteSummary>().toList(),
                  )
                : _SuggestionsArea(
                    recentSearches: state.recentSearches.whereType<String>().toList(),
                    sortedTags: sortedTags,
                    displayRecentNotes: displayRecentNotes,
                    searchController: searchController,
                    onNoteTap: onNoteTap,
                    controller: controller,
                    selectedTag: state.selectedTag,
                  ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionsArea extends StatelessWidget {
  const _SuggestionsArea({
    required this.recentSearches,
    required this.sortedTags,
    required this.displayRecentNotes,
    required this.searchController,
    required this.onNoteTap,
    required this.controller,
    this.selectedTag,
  });

  final List<String> recentSearches;
  final List<MapEntry<String, int>> sortedTags;
  final List<NoteSummary> displayRecentNotes;
  final TextEditingController searchController;
  final Function(BuildContext, NoteSummary) onNoteTap;
  final NotesHomeController controller;
  final String? selectedTag;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tag Browser Header
          if (sortedTags.isNotEmpty) ...[
            Text(
              'TAG BROWSER',
              style: context.typography.labelSmall.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: context.colors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: sortedTags.map((entry) {
                final isSelected = selectedTag == entry.key;
                return ChoiceChip(
                  label: Text('${entry.key} (${entry.value})'),
                  selected: isSelected,
                  onSelected: (selected) {
                    controller.setSelectedTag(selected ? entry.key : null);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  labelStyle: context.typography.labelSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : context.colors.textPrimary,
                  ),
                  selectedColor: const Color(0xFF7C7CFF),
                  backgroundColor: context.colors.surfaceContainerLow,
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
          ],

          // Recent Searches Section
          if (recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RECENT SEARCHES',
                  style: context.typography.labelSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: context.colors.primary,
                  ),
                ),
                TextButton(
                  onPressed: controller.clearRecentSearches,
                  child: Text(
                    'Clear History',
                    style: context.typography.labelSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colors.error,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentSearches.length,
              itemBuilder: (context, index) {
                final searchItem = recentSearches[index];
                return ListTile(
                  leading: Icon(Icons.history_rounded, color: context.colors.textSecondary),
                  title: Text(
                    searchItem,
                    style: context.typography.bodyMedium.copyWith(color: context.colors.textPrimary),
                  ),
                  contentPadding: EdgeInsets.zero,
                  trailing: Icon(Icons.arrow_outward_rounded, size: 16, color: context.colors.textSecondary),
                  onTap: () {
                    searchController.text = searchItem;
                    controller.search(searchItem);
                  },
                );
              },
            ),
            const SizedBox(height: 28),
          ],

          // Recently Edited Notes Section
          if (displayRecentNotes.isNotEmpty) ...[
            Text(
              'RECENTLY EDITED',
              style: context.typography.labelSmall.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: context.colors.primary,
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayRecentNotes.length,
              itemBuilder: (context, index) {
                final note = displayRecentNotes[index];
                return ListTile(
                  leading: Icon(Icons.edit_note_rounded, color: context.colors.primary),
                  title: Text(
                    note.title.isNotEmpty ? note.title : 'Untitled',
                    style: context.typography.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    note.previewText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.typography.labelMedium.copyWith(color: context.colors.textSecondary),
                  ),
                  contentPadding: EdgeInsets.zero,
                  onTap: () => onNoteTap(context, note),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _SearchResultsArea extends StatelessWidget {
  const _SearchResultsArea({
    required this.onNoteTap,
    required this.searchQuery,
    required this.filteredNotes,
  });

  final Function(BuildContext, NoteSummary) onNoteTap;
  final String searchQuery;
  final List<NoteSummary> filteredNotes;

  @override
  Widget build(BuildContext context) {
    if (filteredNotes.isEmpty) {
      return _EmptySearchState();
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeOutCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.05),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
          );
        },
        child: NotesGrid(
          key: ValueKey('search_grid_${filteredNotes.length}'),
          notes: filteredNotes,
          onNoteTap: (note) => onNoteTap(context, note),
          searchQuery: searchQuery,
        ),
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerLow,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 64,
                color: context.colors.primary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No matching notes',
              style: context.typography.titleLarge.copyWith(
                fontWeight: FontWeight.w800,
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try another keyword or tag.',
              style: context.typography.bodyMedium.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
