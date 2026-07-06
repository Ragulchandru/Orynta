// lib/features/more/presentation/screens/more_screen.dart
//
// Orynta 2.0 — Premium More screen for additional features and navigation

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/design_system.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../notes/domain/models/notes_filter.dart';
import '../../../notes/presentation/providers/notes_home_providers.dart';
import '../../../notes/presentation/providers/notes_notifier.dart';

class MoreScreen extends ConsumerStatefulWidget {
  const MoreScreen({super.key});

  @override
  ConsumerState<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends ConsumerState<MoreScreen> {
  void _showTagsSheet(BuildContext context, List<String> tags) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final theme = context.appTheme;
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
                border: Border.all(color: theme.outlineVariant, width: 1.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Browse by Tag',
                    style: context.typography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (tags.isEmpty)
                    Expanded(
                      child: Center(
                        child: Text(
                          'No tags found in any notes.',
                          style: context.typography.bodyMedium.copyWith(
                            color: theme.isDark ? const Color(0xFF8E8EA8) : const Color(0xFF8E8EA8),
                          ),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: tags.map((tag) {
                              return ActionChip(
                                label: Text(
                                  '#$tag',
                                  style: TextStyle(
                                    color: theme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                backgroundColor: theme.primary.withValues(alpha: 0.08),
                                side: BorderSide(color: theme.primary.withValues(alpha: 0.15)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  ref.read(notesHomeControllerProvider.notifier).setSelectedTag(tag);
                                  context.go('/notes');
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showFoldersSheet(BuildContext context) {
    final folders = ['Work', 'Personal', 'Study', 'Inspiration', 'General'];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = context.appTheme;
        return Container(
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
            border: Border.all(color: theme.outlineVariant, width: 1.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Folders & Categories',
                style: context.typography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: folders.length,
                  itemBuilder: (context, index) {
                    final folder = folders[index];
                    return ListTile(
                      leading: Icon(Icons.folder_open_rounded, color: theme.primary),
                      title: Text(
                        folder,
                        style: context.typography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        // Simulate filtering by category (search query matches folder name)
                        ref.read(notesHomeControllerProvider.notifier).search(folder);
                        context.go('/notes');
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    final theme = context.appTheme;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: theme.outlineVariant, width: 1.0),
          ),
          title: Row(
            children: [
              const OryntaLogo(size: 32),
              const SizedBox(width: 12),
              Text(
                'About Orynta',
                style: context.typography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Orynta 2.0 Productivity Suite',
                style: context.typography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Version ${AppStrings.appVersion} (Premium Build)\nOffline-First Architecture powered by Hive.\nDesigned & Built with Clean Architecture.',
                style: context.typography.bodySmall.copyWith(
                  color: theme.isDark ? const Color(0xFF8E8EA8) : const Color(0xFF8E8EA8),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '© 2026 Orynta Inc. All rights reserved.',
                style: context.typography.labelSmall.copyWith(
                  color: theme.isDark ? const Color(0xFF4E4E68) : const Color(0xFF8E8EA8),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TextStyle(
                  color: theme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = context.appTheme;
    final textColor = theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C);
    final subColor = theme.isDark ? const Color(0xFF8E8EA8) : const Color(0xFF8E8EA8);

    return PremiumCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: context.typography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: context.typography.bodySmall.copyWith(
                    color: subColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: theme.isDark ? const Color(0xFF4E4E68) : const Color(0xFF8E8EA8),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final width = MediaQuery.of(context).size.width;
    final isTabletOrDesktop = width >= 600;

    final notes = ref.watch(notesProvider).valueOrNull ?? [];
    final allTags = notes.expand((n) => n.tagIds).toSet().toList();

    final mainGrid = isTabletOrDesktop
        ? SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: width >= 1024 ? 3 : 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              childAspectRatio: 2.8,
            ),
            delegate: SliverChildListDelegate(_buildCards(context, allTags)),
          )
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final list = _buildCards(context, allTags);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: list[index],
                );
              },
              childCount: _buildCards(context, allTags).length,
            ),
          );

    return Scaffold(
      backgroundColor: theme.surfaceDim,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'More',
                      style: context.typography.headlineLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
                        letterSpacing: -1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Explore additional tools and parameters',
                      style: context.typography.bodySmall.copyWith(
                        color: theme.isDark ? const Color(0xFF8E8EA8) : const Color(0xFF8E8EA8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              sliver: mainGrid,
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCards(BuildContext context, List<String> tags) {
    final theme = context.appTheme;

    return [
      _buildCard(
        context: context,
        icon: Icons.bar_chart_rounded,
        iconColor: Colors.blue,
        title: 'Analytics',
        subtitle: 'Insights, habits, and focus charts',
        onTap: () => context.push('/insights'),
      ),
      _buildCard(
        context: context,
        icon: Icons.star_rounded,
        iconColor: Colors.amber,
        title: 'Favorites',
        subtitle: 'Browse your starred items',
        onTap: () {
          ref.read(notesHomeControllerProvider.notifier).changeFilter(NotesFilter.favorites);
          context.go('/notes');
        },
      ),
      _buildCard(
        context: context,
        icon: Icons.tag_rounded,
        iconColor: Colors.teal,
        title: 'Tags',
        subtitle: 'Search entries by hash tags',
        onTap: () => _showTagsSheet(context, tags),
      ),
      _buildCard(
        context: context,
        icon: Icons.folder_rounded,
        iconColor: Colors.orange,
        title: 'Folders',
        subtitle: 'Organize notes by folders',
        onTap: () => _showFoldersSheet(context),
      ),
      _buildCard(
        context: context,
        icon: Icons.archive_rounded,
        iconColor: Colors.purple,
        title: 'Archive',
        subtitle: 'Access archived documents',
        onTap: () => context.push('/archive'),
      ),
      _buildCard(
        context: context,
        icon: Icons.delete_rounded,
        iconColor: Colors.red,
        title: 'Trash',
        subtitle: 'Restore deleted notes',
        onTap: () => context.push('/trash'),
      ),
      _buildCard(
        context: context,
        icon: Icons.settings_rounded,
        iconColor: theme.primary,
        title: 'Settings',
        subtitle: 'Configure Orynta options',
        onTap: () => context.push('/settings'),
      ),
      _buildCard(
        context: context,
        icon: Icons.info_outline_rounded,
        iconColor: Colors.grey,
        title: 'About',
        subtitle: 'App version and system details',
        onTap: () => _showAboutDialog(context),
      ),
    ];
  }
}
