// lib/features/dashboard/presentation/pages/dashboard_page.dart
//
// Orynta 2.0 — Production Modular Dashboard Page
//
// Sliver-based scroll layout powered by CustomScrollView, BouncingScrollPhysics,
// RefreshIndicator, and dynamic module rendering.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../workspace/presentation/widgets/workspace_avatar.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../../domain/models/dashboard_module.dart';
import '../../domain/models/dashboard_module_type.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/dashboard_empty_view.dart';
import '../widgets/dashboard_error_view.dart';
import '../widgets/dashboard_loading_view.dart';
import '../widgets/dashboard_module_card.dart';
import '../widgets/dashboard_section.dart';
import '../widgets/analytics/analytics_snapshot_section.dart';
import '../widgets/habits/habits_section.dart';
import '../widgets/hero/hero_section.dart';
import '../widgets/planner_snapshot/planner_snapshot_section.dart';
import '../widgets/quick_actions/quick_actions_section.dart';
import '../widgets/recent_notes/recent_notes_section.dart';
import '../widgets/smart_suggestions/smart_suggestions_section.dart';
import '../widgets/today/today_section.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardControllerProvider);
    final notifier = ref.read(dashboardControllerProvider.notifier);
    final enabledModules = ref.watch(dashboardModulesProvider);

    final theme = context.appTheme;

    return Scaffold(
      backgroundColor: theme.surfaceDim,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => notifier.refresh(),
          color: theme.primary,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              // Header Sliver
              SliverPadding(
                padding: context.spacing.paddingScreen,
                sliver: SliverToBoxAdapter(
                  child: PremiumHeader(
                    title: 'Dashboard',
                    subtitle: 'Your personal productivity hub',
                    actions: [
                      IconButton(
                        onPressed: () => notifier.loadModules(),
                        icon: const Icon(Icons.tune_rounded),
                        tooltip: 'Customize Layout',
                      ),
                      const SizedBox(width: 8),
                      const WorkspaceAvatar(),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // Dynamic State & Module Rendering Slivers
              if (state.isLoading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: DashboardLoadingView(),
                )
              else if (state.hasError)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: DashboardErrorView(
                    errorMessage: state.errorMessage,
                    onRetry: () => notifier.loadModules(),
                  ),
                )
              else if (enabledModules.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: DashboardEmptyView(),
                )
              else ...[
                if (MediaQuery.of(context).size.width >= 800)
                  SliverPadding(
                    padding: context.spacing.paddingHorizontalLg,
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: enabledModules
                                  .where(
                                    (m) =>
                                        m.type == DashboardModuleType.hero ||
                                        m.type == DashboardModuleType.recentNotes ||
                                        m.type == DashboardModuleType.suggestions,
                                  )
                                  .map(
                                    (m) => Padding(
                                      padding: const EdgeInsets.only(bottom: 16.0),
                                      child: _DashboardModuleRenderer(
                                        module: m,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              children: enabledModules
                                  .where(
                                    (m) =>
                                        m.type != DashboardModuleType.hero &&
                                        m.type != DashboardModuleType.recentNotes &&
                                        m.type != DashboardModuleType.suggestions,
                                  )
                                  .map(
                                    (m) => Padding(
                                      padding: const EdgeInsets.only(bottom: 16.0),
                                      child: _DashboardModuleRenderer(
                                        module: m,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: context.spacing.paddingHorizontalLg,
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final module = enabledModules[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _DashboardModuleRenderer(
                              module: module,
                            ),
                          );
                        },
                        childCount: enabledModules.length,
                      ),
                    ),
                  ),
              ],

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Extensible module renderer mapping [DashboardModule] to its container card.
class _DashboardModuleRenderer extends StatelessWidget {
  const _DashboardModuleRenderer({
    required this.module,
  });

  final DashboardModule module;

  @override
  Widget build(BuildContext context) {
    if (module.type == DashboardModuleType.hero) {
      return const HeroSection();
    }
    if (module.type == DashboardModuleType.today) {
      return const TodaySection();
    }
    if (module.type == DashboardModuleType.quickActions) {
      return const QuickActionsSection();
    }
    if (module.type == DashboardModuleType.recentNotes) {
      return const RecentNotesSection();
    }
    if (module.type == DashboardModuleType.planner) {
      return const PlannerSnapshotSection();
    }
    if (module.type == DashboardModuleType.suggestions) {
      return const SmartSuggestionsSection();
    }
    if (module.type == DashboardModuleType.habits) {
      return const HabitsSection();
    }
    if (module.type == DashboardModuleType.analytics) {
      return const AnalyticsSnapshotSection();
    }

    return DashboardSection(
      title: module.title,
      subtitle: module.subtitle,
      icon: module.icon,
      animationDelay: module.animationDelay,
      child: DashboardModuleCard(
        heroTag: 'dashboard_module_${module.id}',
        isPremium: module.isPremium,
        isLocked: module.isLocked,
        isCollapsed: module.isCollapsed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${module.title} Module Container',
              style: context.typography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Ready for feature widget integration.',
              style: context.typography.bodySmall.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
