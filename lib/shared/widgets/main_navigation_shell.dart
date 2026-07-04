// lib/shared/widgets/main_navigation_shell.dart
//
// Orynta 2.0 — Responsive Premium Navigation Shell

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/design_system/design_system.dart';
import 'quick_create_sheet.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  bool _isDrawerExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final width = MediaQuery.of(context).size.width;

    Widget body = AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeInOutCubic,
      switchOutCurve: Curves.easeInOutCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.02, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey(widget.navigationShell.currentIndex),
        child: widget.navigationShell,
      ),
    );

    if (width < 600) {
      // Phone: Animated floating bottom bar
      return Scaffold(
        backgroundColor: theme.surfaceDim,
        body: body,
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: theme.navigation.background,
                borderRadius: BorderRadius.circular(24.0),
                border: Border.all(color: theme.outlineVariant, width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: theme.isDark ? 0.4 : 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Sliding Active Capsule Indicator
                  AnimatedAlign(
                    duration: AppMotion.normal,
                    curve: AppCurves.emphasized,
                    alignment: Alignment(-1.0 + (widget.navigationShell.currentIndex * 2.0 / 3.0), 0.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.22,
                      heightFactor: 0.7,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.navigation.indicator,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                    ),
                  ),
                  // Icons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _NavBarItem(
                        icon: Icons.today_outlined,
                        activeIcon: Icons.today_rounded,
                        label: 'Today',
                        isActive: widget.navigationShell.currentIndex == 0,
                        onTap: () => widget.navigationShell.goBranch(0),
                      ),
                      _NavBarItem(
                        icon: Icons.sticky_note_2_outlined,
                        activeIcon: Icons.sticky_note_2_rounded,
                        label: 'Notes',
                        isActive: widget.navigationShell.currentIndex == 1,
                        onTap: () => widget.navigationShell.goBranch(1),
                      ),
                      _NavBarItem(
                        icon: Icons.calendar_month_outlined,
                        activeIcon: Icons.calendar_month_rounded,
                        label: 'Planner',
                        isActive: widget.navigationShell.currentIndex == 2,
                        onTap: () => widget.navigationShell.goBranch(2),
                      ),
                      _NavBarItem(
                        icon: Icons.insights_outlined,
                        activeIcon: Icons.insights_rounded,
                        label: 'Insights',
                        isActive: widget.navigationShell.currentIndex == 3,
                        onTap: () => widget.navigationShell.goBranch(3),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else if (width < 1024) {
      // Tablet: NavigationRail
      return Scaffold(
        backgroundColor: theme.surfaceDim,
        body: Row(
          children: [
            NavigationRail(
              backgroundColor: theme.navigation.background,
              indicatorColor: theme.navigation.indicator,
              selectedIndex: widget.navigationShell.currentIndex,
              onDestinationSelected: (index) => widget.navigationShell.goBranch(index),
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
                child: PremiumFAB(
                  onPressed: () => _showQuickCreate(context),
                  icon: const Icon(Icons.add_rounded),
                ),
              ),
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.today_outlined),
                  selectedIcon: Icon(Icons.today_rounded, color: theme.navigation.active),
                  label: const Text('Today'),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.sticky_note_2_outlined),
                  selectedIcon: Icon(Icons.sticky_note_2_rounded, color: theme.navigation.active),
                  label: const Text('Notes'),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.calendar_month_outlined),
                  selectedIcon: Icon(Icons.calendar_month_rounded, color: theme.navigation.active),
                  label: const Text('Planner'),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.insights_outlined),
                  selectedIcon: Icon(Icons.insights_rounded, color: theme.navigation.active),
                  label: const Text('Insights'),
                ),
              ],
            ),
            VerticalDivider(width: 1, color: theme.outlineVariant),
            Expanded(child: body),
          ],
        ),
      );
    } else {
      // Desktop: Collapsible NavigationDrawer
      return Scaffold(
        backgroundColor: theme.surfaceDim,
        body: Row(
          children: [
            AnimatedContainer(
              duration: AppMotion.normal,
              curve: AppCurves.emphasized,
              width: _isDrawerExpanded ? 240 : 80,
              color: theme.navigation.background,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  IconButton(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    icon: const Icon(Icons.menu_rounded),
                    onPressed: () => setState(() => _isDrawerExpanded = !_isDrawerExpanded),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _isDrawerExpanded
                        ? PremiumButton(
                            label: 'New Entry',
                            icon: const Icon(Icons.add_rounded, size: 20),
                            onTap: () => _showQuickCreate(context),
                          )
                        : PremiumFAB(
                            onPressed: () => _showQuickCreate(context),
                            icon: const Icon(Icons.add_rounded),
                          ),
                  ),
                  const SizedBox(height: 24),
                  _DrawerItem(
                    icon: Icons.today_outlined,
                    activeIcon: Icons.today_rounded,
                    label: 'Today',
                    isActive: widget.navigationShell.currentIndex == 0,
                    isExpanded: _isDrawerExpanded,
                    onTap: () => widget.navigationShell.goBranch(0),
                  ),
                  _DrawerItem(
                    icon: Icons.sticky_note_2_outlined,
                    activeIcon: Icons.sticky_note_2_rounded,
                    label: 'Notes',
                    isActive: widget.navigationShell.currentIndex == 1,
                    isExpanded: _isDrawerExpanded,
                    onTap: () => widget.navigationShell.goBranch(1),
                  ),
                  _DrawerItem(
                    icon: Icons.calendar_month_outlined,
                    activeIcon: Icons.calendar_month_rounded,
                    label: 'Planner',
                    isActive: widget.navigationShell.currentIndex == 2,
                    isExpanded: _isDrawerExpanded,
                    onTap: () => widget.navigationShell.goBranch(2),
                  ),
                  _DrawerItem(
                    icon: Icons.insights_outlined,
                    activeIcon: Icons.insights_rounded,
                    label: 'Insights',
                    isActive: widget.navigationShell.currentIndex == 3,
                    isExpanded: _isDrawerExpanded,
                    onTap: () => widget.navigationShell.goBranch(3),
                  ),
                ],
              ),
            ),
            VerticalDivider(width: 1, color: theme.outlineVariant),
            Expanded(child: body),
          ],
        ),
      );
    }
  }

  void _showQuickCreate(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const QuickCreateSheet(),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final activeColor = theme.navigation.active;
    final inactiveColor = theme.navigation.inactive;

    return Expanded(
      child: ScaleOnPress(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? activeColor : inactiveColor,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: context.typography.labelSmall.copyWith(
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? activeColor : inactiveColor,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.isExpanded,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final activeColor = theme.navigation.active;
    final inactiveColor = theme.navigation.inactive;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: ScaleOnPress(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 48.0,
          decoration: BoxDecoration(
            color: isActive ? theme.navigation.indicator : Colors.transparent,
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Icon(
                isActive ? activeIcon : icon,
                color: isActive ? activeColor : inactiveColor,
                size: 24,
              ),
              if (isExpanded) ...[
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: context.typography.bodyMedium.copyWith(
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      color: isActive ? activeColor : inactiveColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
