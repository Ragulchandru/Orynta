// lib/features/notes/presentation/pages/notes_page.dart
//
// Orynta 2.0 — Notes Page (Root Container)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_tokens.dart';
import '../../domain/models/note_summary.dart';
import '../providers/notes_home_providers.dart';
import '../widgets/notes_empty_state.dart';
import '../widgets/notes_filter_bar.dart';
import '../widgets/notes_grid.dart';
import '../widgets/notes_loading.dart';
import '../widgets/notes_search_bar.dart';

class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  void _navigateToCreateNote(BuildContext context) {
    context.push('/notes/new');
  }

  void _onNoteTap(BuildContext context, NoteSummary note) {
    context.push('/notes/${note.id}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notesHomeControllerProvider);
    final controller = ref.read(notesHomeControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Sliver Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  top: 32.0,
                  bottom: 20.0,
                ),
                child: Column(
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
              ),
            ),

            // Search Bar Sliver
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: NotesSearchBar(
                  initialQuery: state.searchQuery,
                  onSearch: controller.search,
                ),
              ),
            ),

            // Filter Bar Sliver
            SliverToBoxAdapter(
              child: Padding(
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
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToCreateNote(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create Note'),
        backgroundColor: context.colors.primary,
        foregroundColor: context.colors.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: context.radius.borderRadiusLg,
        ),
      ),
    );
  }
}
