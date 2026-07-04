// lib/features/workspace/presentation/widgets/workspace_sheet.dart
//
// Orynta 2.0 — Responsive M3 Workspace Sheet

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/design_system.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../settings/presentation/widgets/settings_widgets.dart';

class WorkspaceSheet extends ConsumerWidget {
  const WorkspaceSheet({
    super.key,
    this.isSideSheet = false,
    this.isDropdown = false,
  });

  final bool isSideSheet;
  final bool isDropdown;

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
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(Icons.info_outline_rounded, color: theme.primary),
              ),
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
                'Version 2.0.1\nBuild 102 (Stable Premium)\nOffline-First Architecture powered by Hive.\nDesigned & Built with Clean Architecture.',
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final profile = ref.watch(profileProvider);

    final containerDecoration = BoxDecoration(
      color: theme.surface,
      borderRadius: isSideSheet
          ? const BorderRadius.only(
              topLeft: Radius.circular(24.0),
              bottomLeft: Radius.circular(24.0),
            )
          : (isDropdown
              ? BorderRadius.circular(24.0)
              : const BorderRadius.vertical(top: Radius.circular(24.0))),
      border: Border.all(color: theme.outlineVariant, width: 1.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: theme.isDark ? 0.4 : 0.08),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    );

    Widget sheetContent = Container(
      decoration: containerDecoration,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isSideSheet && !isDropdown) ...[
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
            const SizedBox(height: 16),
          ],
          // Profile section
          Row(
            children: [
              Hero(
                tag: 'workspace_avatar',
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(profile.avatarColor),
                  child: Text(
                    profile.initials,
                    style: context.typography.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.displayName.isNotEmpty ? profile.displayName : 'Guest User',
                      style: context.typography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.workspaceName,
                      style: context.typography.bodySmall.copyWith(
                        color: context.colors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 12),
          // Option Items
          Flexible(
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                PremiumListTile(
                  title: 'Appearance',
                  subtitle: 'Themes, dark mode, animation speeds',
                  icon: Icons.palette_rounded,
                  iconColor: theme.primary,
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/appearance');
                  },
                ),
                PremiumListTile(
                  title: 'Settings',
                  subtitle: 'Editor, planner, security configurations',
                  icon: Icons.settings_rounded,
                  iconColor: theme.primary,
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/settings');
                  },
                ),


                PremiumListTile(
                  title: 'AI Assistant',
                  subtitle: 'Coming Soon',
                  icon: Icons.psychology_outlined,
                  iconColor: theme.isDark ? const Color(0xFF4E4E68) : const Color(0xFF8E8EA8),
                ),
                PremiumListTile(
                  title: 'Premium Subscription',
                  subtitle: 'Coming Soon',
                  icon: Icons.star_border_rounded,
                  iconColor: theme.isDark ? const Color(0xFF4E4E68) : const Color(0xFF8E8EA8),
                ),
                PremiumListTile(
                  title: 'About Orynta',
                  subtitle: 'Version details & build number',
                  icon: Icons.info_outline_rounded,
                  iconColor: theme.isDark ? const Color(0xFF4E4E68) : const Color(0xFF8E8EA8),
                  onTap: () => _showAboutDialog(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Orynta v2.0.1 (Build 102)',
              style: context.typography.labelSmall.copyWith(
                color: theme.isDark ? const Color(0xFF4E4E68) : const Color(0xFF8E8EA8),
              ),
            ),
          ),
        ],
      ),
    );

    if (isSideSheet) {
      return Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: 320,
          height: double.infinity,
          child: sheetContent,
        ),
      );
    }

    return sheetContent;
  }
}

// Responsive Launcher helper
void showWorkspaceSheet(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width >= 1024) {
    // Desktop: Top-Right Dropdown Dialog
    showDialog(
      context: context,
      barrierColor: Colors.black12,
      builder: (context) {
        return const Stack(
          children: [
            Positioned(
              top: 64,
              right: 24,
              width: 320,
              child: Material(
                color: Colors.transparent,
                child: WorkspaceSheet(isDropdown: true),
              ),
            ),
          ],
        );
      },
    );
  } else if (width >= 600) {
    // Tablet: Slide-in Side Sheet from Right
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Workspace Side Sheet',
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) {
        return const WorkspaceSheet(isSideSheet: true);
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic)),
          child: child,
        );
      },
    );
  } else {
    // Phone: Bottom Sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const WorkspaceSheet(),
    );
  }
}
