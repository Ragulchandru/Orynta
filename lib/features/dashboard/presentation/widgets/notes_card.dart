import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/widgets/ink_loading.dart';
import '../../../notes/domain/entities/note_status.dart';
import '../../../notes/presentation/providers/notes_notifier.dart';
import '../../../notes/presentation/widgets/note_card.dart';

class NotesCard extends ConsumerWidget {
  const NotesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final notesAsync = ref.watch(notesProvider);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.lg),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Notes',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to the Notes Tab (index 1)
                    // If we use GoRouter shell, navigating to /notes is clean
                    context.go('/notes');
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            notesAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSizes.md),
                  child: InkLoading(),
                ),
              ),
              error: (err, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
                  child: Text(
                    'Error loading notes',
                    style: TextStyle(color: colorScheme.error),
                  ),
                ),
              ),
              data: (notes) {
                // Filter strictly active notes
                final activeNotes = notes
                    .where((n) => n.status == NoteStatus.active)
                    .toList();
                
                // Sort strictly by updatedAt descending (ignore pin status)
                activeNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

                final recentNotes = activeNotes.take(3).toList();

                if (recentNotes.isEmpty) {
                  return _buildEmptyState(theme);
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: recentNotes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
                  itemBuilder: (context, index) {
                    final note = recentNotes[index];
                    return NoteCard(
                      key: ValueKey(note.id),
                      note: note,
                      animationDelay: Duration(milliseconds: index * 30),
                      onTap: () {
                        context.pushNamed(
                          RouteNames.noteDetail,
                          pathParameters: {'id': note.id},
                        );
                      },
                      onToggleFavorite: null,
                      onTogglePin: null,
                      onArchive: null,
                      onDelete: null,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
        child: Column(
          children: [
            Icon(
              Icons.sticky_note_2_outlined,
              size: 40,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              'No recent notes',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Your workspace is clear. Tap + to write.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
