// lib/features/dashboard/presentation/pages/dashboard_page.dart
//
// Orynta 2.0 — Production Modular Dashboard Page
//
// Sliver-based scroll layout powered by CustomScrollView, BouncingScrollPhysics,
// RefreshIndicator, and dynamic module rendering.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_tokens.dart';
import '../../domain/models/dashboard_module.dart';
import '../../domain/models/dashboard_module_type.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/dashboard_empty_view.dart';
import '../widgets/dashboard_error_view.dart';
import '../widgets/dashboard_loading_view.dart';
import '../widgets/dashboard_module_card.dart';
import '../widgets/dashboard_section.dart';
import '../widgets/hero/hero_section.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardControllerProvider);
    final notifier = ref.read(dashboardControllerProvider.notifier);
    final enabledModules = ref.watch(dashboardModulesProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => notifier.refresh(),
          color: context.colors.primary,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              // Header Sliver
              SliverPadding(
                padding: context.spacing.paddingScreen,
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dashboard',
                            style: context.typography.headlineSmall.copyWith(
                              fontWeight: FontWeight.w800,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Your personal productivity hub',
                            style: context.typography.bodySmall.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => notifier.loadModules(),
                        icon: const Icon(Icons.tune_rounded),
                        tooltip: 'Customize Layout',
                      ),
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
              else
                SliverPadding(
                  padding: context.spacing.paddingHorizontalLg,
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final module = enabledModules[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _DashboardModuleRenderer(module: module),
                        );
                      },
                      childCount: enabledModules.length,
                    ),
                  ),
                ),

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
