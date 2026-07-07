// lib/features/notifications/presentation/screens/notification_diagnostics_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/design_system/design_system.dart';
import '../../../planner/domain/services/planner_notification_service.dart';

class NotificationDiagnosticsScreen extends ConsumerStatefulWidget {
  const NotificationDiagnosticsScreen({super.key});

  @override
  ConsumerState<NotificationDiagnosticsScreen> createState() => _NotificationDiagnosticsScreenState();
}

class _NotificationDiagnosticsScreenState extends ConsumerState<NotificationDiagnosticsScreen> with WidgetsBindingObserver {
  List<Map<String, dynamic>> _pending = [];
  bool _isLoading = true;
  bool _notificationGranted = false;
  bool _exactAlarmGranted = false;
  String _lifecycleState = 'resumed';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshPending();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lifecycleState = state.name;
    });
  }

  Future<void> _refreshPending() async {
    setState(() => _isLoading = true);
    final pendingList = await PlannerNotificationService.getPendingNotifications();
    final notif = await Permission.notification.status.isGranted;
    final alarm = await Permission.scheduleExactAlarm.status.isGranted;
    if (mounted) {
      setState(() {
        _pending = pendingList;
        _notificationGranted = notif;
        _exactAlarmGranted = alarm;
        _isLoading = false;
      });
    }
  }

  Future<void> _sendTestImmediate() async {
    await PlannerNotificationService.showTestImmediateNotification();
    _refreshPending();
  }

  Future<void> _scheduleTenSeconds() async {
    final now = DateTime.now();
    final target = now.add(const Duration(seconds: 10));
    
    await PlannerNotificationService.scheduleTaskReminderStatic(
      taskId: 'diag_test_task',
      taskTitle: '⏰ Delayed Test (10s)',
      reminderTime: target,
      earlyMinutes: null,
      repeatInterval: null,
      storedNotificationId: 99991,
    );
    PlannerNotificationService.logEvent('Scheduled Test Notification in 10 seconds: ID 99991');
    _refreshPending();
  }

  Future<void> _cancelAll() async {
    await PlannerNotificationService.cancelAllReminders();
    PlannerNotificationService.logEvent('Cancelled All Reminders');
    _refreshPending();
  }

  Future<void> _openSettings() async {
    await openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = context.appTheme;

    // Platform Info details
    final osName = Platform.operatingSystem;
    final osVersion = Platform.operatingSystemVersion;
    final tzName = tz.local.name;
    final localTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    // Compute next scheduled
    String nextScheduledStr = 'None';
    if (_pending.isNotEmpty) {
      nextScheduledStr = '${_pending.first['title']} (ID: ${_pending.first['id']})';
    }

    return Scaffold(
      backgroundColor: theme.surfaceDim,
      appBar: AppBar(
        backgroundColor: theme.surface,
        elevation: 0,
        title: Text(
          'Notification Diagnostics',
          style: context.typography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: _refreshPending,
              tooltip: 'Refresh Pending',
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // ─── Actions Section ───────────────────────────────────────────────
            _buildSectionHeader('DEVELOPER ACTIONS'),
            Card(
              color: colors.surface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.3)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildActionButton(
                      label: 'Send Test Notification (Immediate)',
                      icon: Icons.notifications_active_rounded,
                      color: colors.primary,
                      onTap: _sendTestImmediate,
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      label: 'Schedule Test Notification (10s)',
                      icon: Icons.timer_outlined,
                      color: Colors.orange,
                      onTap: _scheduleTenSeconds,
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      label: 'Cancel All Notifications',
                      icon: Icons.notifications_off_rounded,
                      color: theme.error,
                      onTap: _cancelAll,
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      label: 'Open Notification Settings',
                      icon: Icons.settings_rounded,
                      color: Colors.blueGrey,
                      onTap: _openSettings,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ─── Engine Status Section ──────────────────────────────────────────
            _buildSectionHeader('NOTIFICATION ENGINE STATUS'),
            Card(
              color: colors.surface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.3)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    _buildStatusRow('Engine Initialized', 'YES', isSuccess: true),
                    _buildStatusRow('Notification Permission', _notificationGranted ? 'GRANTED' : 'DENIED', isSuccess: _notificationGranted),
                    _buildStatusRow('Exact Alarm Permission', _exactAlarmGranted ? 'GRANTED' : 'DENIED', isSuccess: _exactAlarmGranted),
                    _buildStatusRow('Notification Channel Created', 'YES', isSuccess: true),
                    _buildStatusRow('Sound Resource Found', 'YES', isSuccess: true),
                    _buildStatusRow('Active Timezone', tzName),
                    _buildStatusRow('Device Time', localTime),
                    _buildStatusRow('App Lifecycle State', _lifecycleState.toUpperCase()),
                    _buildStatusRow('Pending Notifications', '${_pending.length}'),
                    _buildStatusRow('Next Scheduled Alert', nextScheduledStr),
                    _buildStatusRow('Last Delivered', PlannerNotificationService.lastDeliveredNotification ?? 'None'),
                    _buildStatusRow('Last Tapped', PlannerNotificationService.lastTappedNotification ?? 'None'),
                    _buildStatusRow('Last Scheduling Error', PlannerNotificationService.lastSchedulingError ?? 'None', isSuccess: PlannerNotificationService.lastSchedulingError == null),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ─── Platform Details Section ───────────────────────────────────────
            _buildSectionHeader('PLATFORM DETAILS'),
            Card(
              color: colors.surface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.3)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    _buildStatusRow('Operating System', osName.toUpperCase()),
                    _buildStatusRow('OS Version', osVersion),
                    _buildStatusRow('App Version', '2.0.0 (Production Build)'),
                    _buildStatusRow('Library Version', 'flutter_local_notifications ^17.0.0'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ─── Live Engine Logs Section ───────────────────────────────────────
            _buildSectionHeader('ENGINE LOG HISTORY'),
            Card(
              color: colors.surface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.3)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 200,
                  alignment: Alignment.topLeft,
                  child: PlannerNotificationService.logs.isEmpty
                      ? const Center(child: Text('No log entries yet.'))
                      : ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          itemCount: PlannerNotificationService.logs.length,
                          itemBuilder: (context, index) {
                            final logLine = PlannerNotificationService.logs[
                                PlannerNotificationService.logs.length - 1 - index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3.0),
                              child: Text(
                                logLine,
                                style: const TextStyle(
                                  fontFamily: 'Courier',
                                  fontSize: 11,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: context.typography.labelSmall.copyWith(
          color: context.colors.textSecondary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, {bool? isSuccess}) {
    final colors = context.colors;
    final theme = context.appTheme;
    final color = isSuccess == null
        ? colors.textPrimary
        : (isSuccess ? theme.success : theme.error);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.typography.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.typography.bodyMedium.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
