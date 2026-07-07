// lib/features/analytics/presentation/widgets/category_pie_chart.dart
//
// Orynta 2.0 — Task Status Distribution Pie Chart Widget (CustomPainter)

import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/design_system/design_system.dart';
import '../../../planner/domain/entities/task_entity.dart';

class CategoryPieChart extends StatelessWidget {
  const CategoryPieChart({
    super.key,
    required this.tasks,
  });

  final List<TaskEntity> tasks;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final colors = context.colors;

    final completedCount = tasks.where((t) => t.isCompleted && !t.isArchived).length;
    final archivedCount = tasks.where((t) => t.isArchived).length;

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    final overdueCount = tasks.where((t) {
      if (t.isCompleted || t.isArchived || t.dueDate == null) return false;
      final dueStart = DateTime(t.dueDate!.year, t.dueDate!.month, t.dueDate!.day);
      return dueStart.isBefore(todayStart);
    }).length;

    final pendingCount = tasks.where((t) {
      if (t.isCompleted || t.isArchived) return false;
      if (t.dueDate == null) return true;
      final dueStart = DateTime(t.dueDate!.year, t.dueDate!.month, t.dueDate!.day);
      return dueStart.isAtSameMomentAs(todayStart) || dueStart.isAfter(todayStart);
    }).length;

    final total = completedCount + pendingCount + overdueCount + archivedCount;

    if (total == 0) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: theme.outlineVariant.withValues(alpha: 0.3)),
        ),
        color: theme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pie_chart_outline_rounded, size: 48, color: theme.secondary.withValues(alpha: 0.4)),
              const SizedBox(height: 16),
              Text(
                'No analytics yet',
                style: context.typography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Analytics will appear as you use Orynta.',
                textAlign: TextAlign.center,
                style: context.typography.bodySmall.copyWith(color: theme.secondary),
              ),
            ],
          ),
        ),
      );
    }

    // Colors mapping
    final Color completedColor = theme.success; // Green
    const Color pendingColor = Colors.orange; // Orange
    final Color overdueColor = theme.error; // Red
    const Color archivedColor = Colors.blue; // Blue

    final List<MapEntry<String, double>> segments = [];
    final List<Color> sliceColors = [];
    final List<Widget> legends = [];

    void addSegment(String label, int count, Color color) {
      if (count > 0) {
        final ratio = count / total;
        segments.add(MapEntry(label, ratio));
        sliceColors.add(color);
        legends.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: context.typography.bodySmall.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '$count (${(ratio * 100).toStringAsFixed(0)}%)',
                  style: context.typography.bodySmall.copyWith(color: theme.secondary),
                ),
              ],
            ),
          ),
        );
      }
    }

    addSegment('Completed', completedCount, completedColor);
    addSegment('Pending', pendingCount, pendingColor);
    addSegment('Overdue', overdueCount, overdueColor);
    addSegment('Archived', archivedCount, archivedColor);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: theme.outlineVariant.withValues(alpha: 0.3)),
      ),
      color: theme.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Status Distribution',
              style: context.typography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CustomPaint(
                    painter: _PieChartPainter(segments: segments, colors: sliceColors),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: legends,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  _PieChartPainter({
    required this.segments,
    required this.colors,
  });

  final List<MapEntry<String, double>> segments;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    double startAngle = -math.pi / 2;

    for (int i = 0; i < segments.length; i++) {
      final sweepAngle = segments[i].value * 2 * math.pi;
      paint.color = colors[i % colors.length];
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) {
    return oldDelegate.segments != segments || oldDelegate.colors != colors;
  }
}
