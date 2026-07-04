// lib/shared/widgets/main_navigation_shell.dart
//
// Orynta 2.0 — Responsive Premium Navigation Shell

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final currentIndex = widget.navigationShell.currentIndex;

    Widget body = widget.navigationShell;

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
                    duration: MotionTokens.durationNormal,
                    curve: MotionTokens.emphasizedCurve,
                    alignment: Alignment(-1.0 + (currentIndex * 2.0 / 3.0), 0.0),
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
                        isActive: currentIndex == 0,
                        onTap: () => widget.navigationShell.goBranch(0),
                      ),
                      _NavBarItem(
                        icon: Icons.sticky_note_2_outlined,
                        activeIcon: Icons.sticky_note_2_rounded,
                        label: 'Notes',
                        isActive: currentIndex == 1,
                        onTap: () => widget.navigationShell.goBranch(1),
                      ),
                      _NavBarItem(
                        icon: Icons.calendar_month_outlined,
                        activeIcon: Icons.calendar_month_rounded,
                        label: 'Planner',
                        isActive: currentIndex == 2,
                        onTap: () => widget.navigationShell.goBranch(2),
                      ),
                      _NavBarItem(
                        icon: Icons.insights_outlined,
                        activeIcon: Icons.insights_rounded,
                        label: 'Insights',
                        isActive: currentIndex == 3,
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
              selectedIndex: currentIndex,
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
                    isActive: currentIndex == 0,
                    isExpanded: _isDrawerExpanded,
                    onTap: () => widget.navigationShell.goBranch(0),
                  ),
                  _DrawerItem(
                    icon: Icons.sticky_note_2_outlined,
                    activeIcon: Icons.sticky_note_2_rounded,
                    label: 'Notes',
                    isActive: currentIndex == 1,
                    isExpanded: _isDrawerExpanded,
                    onTap: () => widget.navigationShell.goBranch(1),
                  ),
                  _DrawerItem(
                    icon: Icons.calendar_month_outlined,
                    activeIcon: Icons.calendar_month_rounded,
                    label: 'Planner',
                    isActive: currentIndex == 2,
                    isExpanded: _isDrawerExpanded,
                    onTap: () => widget.navigationShell.goBranch(2),
                  ),
                  _DrawerItem(
                    icon: Icons.insights_outlined,
                    activeIcon: Icons.insights_rounded,
                    label: 'Insights',
                    isActive: currentIndex == 3,
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

class _NavBarItem extends StatefulWidget {
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
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final activeColor = theme.navigation.active;
    final inactiveColor = theme.navigation.inactive;

    return Expanded(
      child: Material(
        type: MaterialType.transparency,
        child: InkResponse(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onTap();
          },
          radius: 28,
          highlightColor: Colors.transparent,
          splashColor: theme.navigation.indicator.withValues(alpha: 0.12),
          child: AnimatedScale(
            scale: _isPressed ? 0.97 : (widget.isActive ? 1.18 : 1.0),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            child: TweenAnimationBuilder<Color?>(
              tween: ColorTween(
                begin: widget.isActive ? inactiveColor : activeColor,
                end: widget.isActive ? activeColor : inactiveColor,
              ),
              duration: MotionTokens.durationNormal,
              curve: MotionTokens.decelerateCurve,
              builder: (context, animColor, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.isActive ? widget.activeIcon : widget.icon,
                      color: animColor,
                      size: 24,
                    ),
                    const SizedBox(height: 2),
                    AnimatedSlide(
                      offset: widget.isActive ? const Offset(0, -0.15) : Offset.zero,
                      duration: MotionTokens.durationNormal,
                      curve: MotionTokens.emphasizedCurve,
                      child: AnimatedOpacity(
                        opacity: widget.isActive ? 1.0 : 0.6,
                        duration: MotionTokens.durationNormal,
                        curve: MotionTokens.emphasizedCurve,
                        child: Text(
                          widget.label,
                          style: context.typography.labelSmall.copyWith(
                            fontWeight: widget.isActive ? FontWeight.bold : FontWeight.normal,
                            color: animColor,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: MotionTokens.emphasizedCurve,
          width: double.infinity,
          height: 48.0,
          decoration: BoxDecoration(
            color: isActive ? theme.navigation.indicator : Colors.transparent,
            borderRadius: BorderRadius.circular(isActive ? 16.0 : 12.0),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: theme.isDark ? 0.2 : 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
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
