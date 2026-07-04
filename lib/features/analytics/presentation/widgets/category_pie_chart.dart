// lib/features/analytics/presentation/widgets/category_pie_chart.dart
//
// Orynta 2.0 — Category Distribution Pie Chart Widget (CustomPainter)

import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../../core/constants/app_sizes.dart';

class CategoryPieChart extends StatelessWidget {
  const CategoryPieChart({
    super.key,
    required this.categoryCounts,
  });

  final Map<String, int> categoryCounts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final total = categoryCounts.values.fold<int>(0, (sum, val) => sum + val);

    if (total == 0) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.lg),
          side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
        ),
        color: colorScheme.surfaceContainerLow,
        child: const Padding(
          padding: EdgeInsets.all(AppSizes.lg),
          child: Center(
            child: Text('No categories data available'),
          ),
        ),
      );
    }

    final List<Color> colors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      Colors.orange,
      Colors.teal,
      Colors.purple,
      Colors.indigo,
    ];

    int colorIndex = 0;
    final List<MapEntry<String, double>> segments = [];
    final List<Widget> legends = [];

    categoryCounts.forEach((category, count) {
      if (count > 0) {
        final ratio = count / total;
        final color = colors[colorIndex % colors.length];
        segments.add(MapEntry(category, ratio));
        legends.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    category,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '$count (${(ratio * 100).toStringAsFixed(0)}%)',
                  style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.outline),
                ),
              ],
            ),
          ),
        );
        colorIndex++;
      }
    });

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.lg),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Distribution',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Row(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CustomPaint(
                    painter: _PieChartPainter(segments: segments, colors: colors),
                  ),
                ),
                const SizedBox(width: 24),
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
