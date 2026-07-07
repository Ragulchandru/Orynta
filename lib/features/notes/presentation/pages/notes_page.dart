import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_tokens.dart';
import '../../domain/models/note_summary.dart';
import '../../domain/models/notes_view_mode.dart';
import '../../domain/models/notes_group_by.dart';
import '../../domain/models/sort_option.dart';
import '../../domain/models/smart_filter.dart';
import '../../../workspace/presentation/widgets/workspace_avatar.dart';
import '../providers/note_selection_provider.dart';
import '../providers/notes_home_providers.dart';
import '../widgets/notes_empty_state.dart';
import '../widgets/notes_filter_bar.dart';
import '../widgets/notes_grid.dart';
import '../widgets/notes_loading.dart';
import '../widgets/notes_search_bar.dart';
import '../widgets/notes_search_overlay.dart';
import '../widgets/selection_app_bar.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  late final TextEditingController _searchBarController;
  late final FocusNode _searchBarFocusNode;

  @override
  void initState() {
    super.initState();
    _searchBarController = TextEditingController();
    _searchBarFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    _searchBarFocusNode.dispose();
    super.dispose();
  }

  void _navigateToCreateNote(BuildContext context) {
    context.push('/notes/new');
  }

  void _onNoteTap(BuildContext context, NoteSummary note) {
    context.push('/notes/${note.id}');
  }

  String _getSortLabel(SortOption opt) {
    switch (opt) {
      case SortOption.recentlyUpdated:
        return 'Recent';
      case SortOption.oldest:
        return 'Oldest';
      case SortOption.alphabetical:
        return 'A-Z';
      case SortOption.color:
        return 'Color';
      case SortOption.favorites:
        return 'Favorites';
      case SortOption.pinned:
        return 'Pinned';
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notesHomeControllerProvider);
    final controller = ref.read(notesHomeControllerProvider.notifier);
    
    // Selection state
    final selectionState = ref.watch(noteSelectionProvider);
    final inSelectionMode = selectionState.inSelectionMode;

    final showSearchOverlay = state.isSearchFocused || state.searchQuery.isNotEmpty || state.selectedTag != null;

    if (showSearchOverlay && !inSelectionMode) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
                child: NotesSearchBar(
                  initialQuery: state.searchQuery,
                  onSearch: controller.search,
                  controller: _searchBarController,
                  focusNode: _searchBarFocusNode,
                ),
              ),
              Expanded(
                child: NotesSearchOverlay(
                  onNoteTap: (context, note) => _onNoteTap(context, note),
                  searchController: _searchBarController,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return PopScope(
      canPop: !inSelectionMode,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (inSelectionMode) {
          ref.read(noteSelectionProvider.notifier).exitSelectionMode();
        }
      },
      child: Scaffold(
        appBar: inSelectionMode
            ? SelectionAppBar(
                selectedIds: selectionState.selectedIds,
                onCancel: () => ref.read(noteSelectionProvider.notifier).exitSelectionMode(),
              )
            : null,
        body: GestureDetector(
          onTap: () {
            if (inSelectionMode) {
              ref.read(noteSelectionProvider.notifier).exitSelectionMode();
            }
          },
          child: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Sliver Header
                SliverToBoxAdapter(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: AnimatedOpacity(
                      opacity: inSelectionMode ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: inSelectionMode
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(
                                left: 24.0,
                                right: 24.0,
                                top: 32.0,
                                bottom: 20.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Notes',
                                        style: context.typography.headlineLarge.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: context.colors.textPrimary,
                                          letterSpacing: -1.0,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Capture ideas and stay organized',
                                        style: context.typography.bodySmall.copyWith(
                                          color: context.colors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 4.0),
                                    child: WorkspaceAvatar(),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),

                // Search Bar Sliver
                SliverToBoxAdapter(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: AnimatedOpacity(
                      opacity: inSelectionMode ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: inSelectionMode
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: NotesSearchBar(
                                initialQuery: state.searchQuery,
                                onSearch: controller.search,
                                controller: _searchBarController,
                                focusNode: _searchBarFocusNode,
                              ),
                            ),
                    ),
                  ),
                ),

                // Filter Bar Sliver
                SliverToBoxAdapter(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: AnimatedOpacity(
                      opacity: inSelectionMode ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: inSelectionMode
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(
                                left: 24.0,
                                right: 24.0,
                                top: 20.0,
                                bottom: 12.0,
                              ),
                              child: NotesFilterBar(
                                selectedFilter: state.selectedFilter,
                                onFilterChanged: controller.changeFilter,
                              ),
                            ),
                    ),
                  ),
                ),

                // Unified Preferences Toolbelt Sliver
                SliverToBoxAdapter(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: AnimatedOpacity(
                      opacity: inSelectionMode ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: inSelectionMode
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    // Sort dropdown
                                    Row(
                                      children: [
                                        Icon(Icons.sort_rounded, size: 14, color: context.colors.textSecondary),
                                        const SizedBox(width: 4),
                                        DropdownButton<SortOption>(
                                          value: state.sortOption,
                                          onChanged: (val) {
                                            if (val != null) controller.setSortOption(val);
                                          },
                                          underline: const SizedBox(),
                                          style: context.typography.labelSmall.copyWith(
                                            color: context.colors.textPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          icon: const Icon(Icons.arrow_drop_down_rounded, size: 16),
                                          items: SortOption.values.map((opt) {
                                            return DropdownMenuItem(
                                              value: opt,
                                              child: Text(_getSortLabel(opt)),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 16),
                                    // View Mode dropdown
                                    Row(
                                      children: [
                                        Icon(Icons.grid_view_rounded, size: 14, color: context.colors.textSecondary),
                                        const SizedBox(width: 4),
                                        DropdownButton<NotesViewMode>(
                                          value: state.viewMode,
                                          onChanged: (val) {
                                            if (val != null) controller.setViewMode(val);
                                          },
                                          underline: const SizedBox(),
                                          style: context.typography.labelSmall.copyWith(
                                            color: context.colors.textPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          icon: const Icon(Icons.arrow_drop_down_rounded, size: 16),
                                          items: NotesViewMode.values.map((mode) {
                                            return DropdownMenuItem(
                                              value: mode,
                                              child: Text(mode.label),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 16),
                                    // Group By dropdown
                                    Row(
                                      children: [
                                        Icon(Icons.group_work_rounded, size: 14, color: context.colors.textSecondary),
                                        const SizedBox(width: 4),
                                        DropdownButton<NotesGroupBy>(
                                          value: state.groupBy,
                                          onChanged: (val) {
                                            if (val != null) controller.setGroupBy(val);
                                          },
                                          underline: const SizedBox(),
                                          style: context.typography.labelSmall.copyWith(
                                            color: context.colors.textPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          icon: const Icon(Icons.arrow_drop_down_rounded, size: 16),
                                          items: NotesGroupBy.values.map((grp) {
                                            return DropdownMenuItem(
                                              value: grp,
                                              child: Text(grp.label),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 16),
                                    // Pin Filter Toggle
                                    ChoiceChip(
                                      label: const Text('Pinned Only'),
                                      selected: state.activeFilters.contains(SmartFilter.pinned),
                                      onSelected: (selected) {
                                        controller.toggleSmartFilter(SmartFilter.pinned);
                                      },
                                      showCheckmark: false,
                                      selectedColor: context.colors.primary.withValues(alpha: 0.12),
                                      labelStyle: context.typography.labelSmall.copyWith(
                                        color: state.activeFilters.contains(SmartFilter.pinned)
                                            ? context.colors.primary
                                            : context.colors.textSecondary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        side: BorderSide(
                                          color: state.activeFilters.contains(SmartFilter.pinned)
                                              ? context.colors.primary
                                              : context.colors.outlineVariant,
                                        ),
                                      ),
                                      visualDensity: VisualDensity.compact,
                                      padding: EdgeInsets.zero,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                ),

                // Notes Content / Grid / Empty State / Loading
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        if (state.loading)
                          const NotesLoading()
                        else if (state.filteredNotes.isEmpty)
                          NotesEmptyState(
                            onCreateNote: () => _navigateToCreateNote(context),
                          )
                        else
                          NotesGrid(
                            notes: state.filteredNotes,
                            onNoteTap: (note) => _onNoteTap(context, note),
                            searchQuery: state.searchQuery,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: inSelectionMode
            ? null
            : PremiumFAB(
                onPressed: () => _navigateToCreateNote(context),
                icon: const Icon(Icons.add_rounded),
              ),
      ),
    );
  }
}
