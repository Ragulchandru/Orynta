// lib/shared/widgets/in_app_notification_overlay.dart
//
// Orynta 2.0 — Global In-App Notification Banner Overlay
//
// Renders a premium glassmorphic slide-down banner whenever a task reminder
// fires while the app is in the foreground (AppLifecycleState.resumed).
//
// Architecture:
//   - Listens to PlannerNotificationService.foregroundNotificationStream.
//   - Built as an Overlay entry injected via MaterialApp.router builder.
//   - Handles: Open, Complete, Snooze (+10 min), Dismiss.
//   - Auto-dismisses after 5 seconds.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_system/design_system.dart';
import '../../features/planner/domain/entities/task_entity.dart';
import '../../features/planner/domain/services/planner_notification_service.dart';
import '../../features/planner/presentation/providers/tasks_notifier.dart';

// ─── Provider ────────────────────────────────────────────────────────────────

class InAppNotificationOverlay extends ConsumerStatefulWidget {
  const InAppNotificationOverlay({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<InAppNotificationOverlay> createState() =>
      _InAppNotificationOverlayState();
}

class _InAppNotificationOverlayState
    extends ConsumerState<InAppNotificationOverlay>
    with SingleTickerProviderStateMixin {
  // ── State ─────────────────────────────────────────────────────────────────

  TaskEntity? _activeTask;
  StreamSubscription<TaskEntity>? _sub;
  Timer? _autoDismissTimer;

  late final AnimationController _animController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOut,
      ),
    );

    _sub = PlannerNotificationService.foregroundNotificationStream
        .listen(_onNotificationReceived);
  }

  @override
  void dispose() {
    _sub?.cancel();
    _autoDismissTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  // ── Handlers ──────────────────────────────────────────────────────────────

  void _onNotificationReceived(TaskEntity task) {
    if (!mounted) return;
    setState(() => _activeTask = task);
    _animController.forward(from: 0);
    _autoDismissTimer?.cancel();
    _autoDismissTimer = Timer(const Duration(seconds: 5), _dismiss);
  }

  void _dismiss() {
    if (!mounted) return;
    _animController.reverse().then((_) {
      if (mounted) setState(() => _activeTask = null);
    });
    _autoDismissTimer?.cancel();
  }

  void _handleOpen() {
    final task = _activeTask;
    _dismiss();
    if (task != null && mounted) {
      context.push('/tasks/${task.id}');
    }
  }

  void _handleComplete() {
    final task = _activeTask;
    _dismiss();
    if (task != null) {
      ref.read(tasksNotifierProvider.notifier).toggleTaskCompletion(task.id);
    }
  }

  void _handleSnooze() {
    final task = _activeTask;
    _dismiss();
    if (task != null) {
      PlannerNotificationService.snoozeTaskReminder(
        task.id,
        const Duration(minutes: 10),
        storedNotificationId: task.notificationId,
      );
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_activeTask != null) _buildBanner(context, _activeTask!),
      ],
    );
  }

  Widget _buildBanner(BuildContext context, TaskEntity task) {
    final colors = context.colors;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colors.outlineVariant.withValues(alpha: 0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 24,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: colors.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.notifications_active_rounded,
                                  color: colors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title,
                                      style: context.typography.titleSmall
                                          .copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: colors.textPrimary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (task.description.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        task.description,
                                        style: context.typography.bodySmall
                                            .copyWith(
                                          color: colors.textSecondary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: colors.textSecondary,
                                ),
                                onPressed: _dismiss,
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Action buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _ActionButton(
                                label: 'Snooze',
                                icon: Icons.snooze_rounded,
                                onTap: _handleSnooze,
                                outlined: true,
                              ),
                              const SizedBox(width: 8),
                              _ActionButton(
                                label: 'Complete',
                                icon: Icons.check_rounded,
                                onTap: _handleComplete,
                                outlined: true,
                              ),
                              const SizedBox(width: 8),
                              _ActionButton(
                                label: 'Open',
                                icon: Icons.open_in_new_rounded,
                                onTap: _handleOpen,
                                outlined: false,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Compact action button ────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.outlined,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (outlined) {
      return OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 13),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: context.typography.labelSmall
              .copyWith(fontWeight: FontWeight.w600),
          side: BorderSide(color: colors.outlineVariant),
          foregroundColor: colors.textPrimary,
        ),
      );
    }
    return FilledButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 13),
      label: Text(label),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle:
            context.typography.labelSmall.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
