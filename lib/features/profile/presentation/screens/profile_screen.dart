// lib/features/profile/presentation/screens/profile_screen.dart
//
// Orynta 2.0 — Premium Profile Hub

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_tokens.dart';

import '../../../../core/router/route_names.dart';
import '../../../notes/presentation/providers/notes_notifier.dart';
import '../../../planner/presentation/providers/tasks_notifier.dart';
import '../../../planner/presentation/providers/planner_stats_provider.dart';
import '../../../analytics/presentation/providers/productivity_score_provider.dart';
import '../../../settings/presentation/screens/sub_screens/about_settings_screen.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  static const List<int> avatarColors = [
    0xFF3A86F0, // Ocean Blue
    0xFFD4AF37, // Elegant Gold
    0xFF2E7D32, // Forest Green
    0xFF7B2CBF, // Lavender Purple
    0xFFF77F00, // Sunset Orange
    0xFF008080, // Classic Teal
    0xFFD81B60, // Rose Pink
    0xFFFFB300, // Amber Yellow
    0xFFE76F51, // Coral Clay
    0xFF3F51B5, // Indigo Blue
  ];

  void _showEditProfileSheet(BuildContext context) {
    HapticFeedback.lightImpact();
    final profile = ref.read(profileProvider);
    final theme = context.appTheme;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: profile.displayName);
    final workspaceController = TextEditingController(text: profile.workspaceName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.notes.card,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        side: BorderSide(color: theme.notes.cardBorder, width: 1.0),
      ),
      builder: (context) {
        final sheetTheme = context.appTheme;
        final sheetColors = context.colors;
        return Padding(
          padding: EdgeInsets.only(
            top: 16.0,
            left: 24.0,
            right: 24.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: sheetTheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Edit Profile Details',
                  style: context.typography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: sheetColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  style: context.typography.bodyMedium.copyWith(
                    color: sheetColors.textPrimary,
                  ),
                  maxLength: 25,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  decoration: InputDecoration(
                    labelText: 'Display Name',
                    labelStyle: TextStyle(color: sheetColors.textSecondary),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: sheetTheme.primary),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: sheetTheme.outlineVariant),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Display name cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: workspaceController,
                  style: context.typography.bodyMedium.copyWith(
                    color: sheetColors.textPrimary,
                  ),
                  maxLength: 25,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  decoration: InputDecoration(
                    labelText: 'Workspace Name',
                    labelStyle: TextStyle(color: sheetColors.textSecondary),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: sheetTheme.primary),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: sheetTheme.outlineVariant),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Workspace name cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        HapticFeedback.mediumImpact();
                        ref.read(profileProvider.notifier).updateProfile(
                              name: nameController.text,
                              workspaceName: workspaceController.text,
                              avatarColor: profile.avatarColor,
                            );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: sheetTheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                    ),
                    child: Text(
                      'Save Changes',
                      style: context.typography.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAvatarSheet(BuildContext context) {
    HapticFeedback.lightImpact();
    final theme = context.appTheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.notes.card,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        side: BorderSide(color: theme.notes.cardBorder, width: 1.0),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final profile = ref.watch(profileProvider);
            final sheetTheme = context.appTheme;
            final sheetColors = context.colors;
            final avatarBgColor = Color(profile.avatarColor).withValues(alpha: 0.12);
            final avatarTextColor = Color(profile.avatarColor);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: sheetTheme.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Avatar Customization',
                    style: context.typography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: sheetColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: avatarBgColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: avatarTextColor.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        profile.initials,
                        style: context.typography.headlineLarge.copyWith(
                          fontWeight: FontWeight.w800,
                          color: avatarTextColor,
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Select Color Theme',
                    style: context.typography.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: sheetColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 52,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: avatarColors.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, idx) {
                        final colVal = avatarColors[idx];
                        final isSelected = profile.avatarColor == colVal;
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            ref.read(profileProvider.notifier).updateAvatarColor(colVal);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(colVal),
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(
                                      color: sheetColors.textPrimary,
                                      width: 3.5,
                                    )
                                  : null,
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check_rounded,
                                    size: 18,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showStatisticsSheet(BuildContext context) {
    HapticFeedback.lightImpact();
    final theme = context.appTheme;

    final notesState = ref.read(notesProvider);
    final notesCount = notesState.valueOrNull?.length ?? 0;
    final tasks = ref.read(tasksProvider);
    final tasksCount = tasks.length;
    final stats = ref.read(plannerStatsProvider);
    final scoreData = ref.read(unifiedScoreProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.notes.card,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        side: BorderSide(color: theme.notes.cardBorder, width: 1.0),
      ),
      builder: (context) {
        final sheetTheme = context.appTheme;
        final sheetColors = context.colors;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: sheetTheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Personal Statistics',
                style: context.typography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: sheetColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.1,
                children: [
                  _StatItemCard(
                    title: 'Total Notes',
                    value: notesCount,
                    icon: Icons.article_outlined,
                    color: Colors.blue,
                  ),
                  _StatItemCard(
                    title: 'Total Tasks',
                    value: tasksCount,
                    icon: Icons.check_circle_outline_rounded,
                    color: sheetTheme.primary,
                  ),
                  _StatItemCard(
                    title: 'Current Streak',
                    value: stats.currentStreak,
                    icon: Icons.local_fire_department_rounded,
                    color: Colors.orange,
                  ),
                  _StatItemCard(
                    title: 'Productivity',
                    value: scoreData.score,
                    icon: Icons.speed_rounded,
                    color: Colors.teal,
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final theme = context.appTheme;
    final colors = context.colors;

    final avatarBgColor = Color(profile.avatarColor).withValues(alpha: 0.12);
    final avatarTextColor = Color(profile.avatarColor);

    return Scaffold(
      backgroundColor: theme.surfaceDim,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.textPrimary),
          onPressed: () {
            HapticFeedback.lightImpact();
            context.pop();
          },
        ),
        title: Text(
          'Profile',
          style: context.typography.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: context.spacing.paddingScreen,
        child: Column(
          children: [
            // Premium Hero Header
            Hero(
              tag: 'workspace_avatar',
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: avatarBgColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: avatarTextColor.withValues(alpha: 0.3),
                    width: 3.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  profile.initials,
                  style: context.typography.displayMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: avatarTextColor,
                    fontSize: 36,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              profile.displayName.isNotEmpty ? profile.displayName : 'Guest',
              style: context.typography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              profile.workspaceName,
              style: context.typography.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Member since ${profile.memberSince}',
              style: context.typography.bodySmall.copyWith(
                color: colors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),

            _buildMenuSection(
              context: context,
              title: 'Personal',
              children: [
                _buildMenuItem(
                  context: context,
                  leading: Icons.edit_rounded,
                  title: 'Edit Profile',
                  onTap: () => _showEditProfileSheet(context),
                ),
                _buildMenuItem(
                  context: context,
                  leading: Icons.palette_rounded,
                  title: 'Avatar Customization',
                  onTap: () => _showAvatarSheet(context),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildMenuSection(
              context: context,
              title: 'Workspace',
              children: [
                _buildMenuItem(
                  context: context,
                  leading: Icons.bar_chart_rounded,
                  title: 'Statistics',
                  onTap: () => _showStatisticsSheet(context),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildMenuSection(
              context: context,
              title: 'Application',
              children: [
                _buildMenuItem(
                  context: context,
                  leading: Icons.settings_rounded,
                  title: 'Settings',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.pushNamed(RouteNames.settings);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildMenuSection(
              context: context,
              title: 'Information',
              children: [
                _buildMenuItem(
                  context: context,
                  leading: Icons.info_outline_rounded,
                  title: 'About Orynta',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AboutSettingsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),
            Text(
              'Version 2.0.0',
              style: context.typography.labelSmall.copyWith(
                color: colors.textSecondary.withValues(alpha: 0.6),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    final theme = context.appTheme;

    final items = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      items.add(children[i]);
      if (i < children.length - 1) {
        items.add(Divider(color: theme.notes.cardBorder, height: 1));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            title,
            style: context.typography.labelMedium.copyWith(
              color: theme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.zero,
          color: theme.notes.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            side: BorderSide(color: theme.notes.cardBorder, width: 1.0),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData leading,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    final colors = context.colors;

    return ListTile(
      leading: Icon(leading, color: colors.textSecondary),
      title: Text(
        title,
        style: context.typography.bodyMedium.copyWith(
          color: colors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: context.typography.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
            )
          : null,
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: colors.textSecondary.withValues(alpha: 0.5),
      ),
      onTap: onTap,
    );
  }
}

class _StatItemCard extends StatelessWidget {
  const _StatItemCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final num value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final colors = context.colors;

    return Card(
      margin: EdgeInsets.zero,
      color: theme.notes.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: theme.notes.cardBorder, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$value',
                    style: context.typography.titleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.typography.labelSmall.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
