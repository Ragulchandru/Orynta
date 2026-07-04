// lib/features/analytics/presentation/widgets/productivity_score_card.dart
//
// Orynta 2.0 — Productivity Score Custom Gauge Widget (Animated Count-Up & Rotation)

import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/design_system/motion/motion_tokens.dart';
import '../../../../core/design_system/theme/app_theme.dart';

class ProductivityScoreCard extends StatefulWidget {
  const ProductivityScoreCard({
    super.key,
    required this.score,
  });

  final double score;

  @override
  State<ProductivityScoreCard> createState() => _ProductivityScoreCardState();
}

class _ProductivityScoreCardState extends State<ProductivityScoreCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scoreAnimation;
  double _prevScore = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: MotionTokens.slow,
    );
    _scoreAnimation = Tween<double>(
      begin: _prevScore,
      end: widget.score,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: MotionTokens.emphasized,
      ),
    );
    _controller.forward();
    _prevScore = widget.score;
  }

  @override
  void didUpdateWidget(covariant ProductivityScoreCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _scoreAnimation = Tween<double>(
        begin: oldWidget.score,
        end: widget.score,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: MotionTokens.emphasized,
        ),
      );
      _controller.reset();
      _controller.forward();
      _prevScore = widget.score;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showExplanation(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appTheme = context.appTheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: appTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How Productivity Score Works',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                _buildWeightRow(context, 'Task Completion Rate', '40%'),
                _buildWeightRow(context, 'Streak Value', '20%'),
                _buildWeightRow(context, 'Daily Activity (Focus + Notes)', '20%'),
                _buildWeightRow(context, 'Habits Consistency', '20%'),
                const Divider(height: 24),
                _buildWeightRow(context, 'Overdue Task Penalty', '−5 pts / task', isPenalty: true),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Score Scale',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '0 – 100',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeightRow(BuildContext context, String label, String value, {bool isPenalty = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isPenalty ? Colors.redAccent : colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String level = switch (widget.score) {
      >= 90 => 'Excellent',
      >= 70 => 'Good',
      >= 50 => 'Average',
      _ => 'Needs Improvement',
    };

    final Color levelColor = switch (widget.score) {
      >= 90 => Colors.greenAccent,
      >= 70 => colorScheme.primary,
      >= 50 => Colors.orangeAccent,
      _ => Colors.redAccent,
    };

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.lg),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'TODAY\'S PRODUCTIVITY SCORE',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.outline,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => _showExplanation(context),
                  child: Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: colorScheme.outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            SizedBox(
              width: 160,
              height: 160,
              child: AnimatedBuilder(
                animation: _scoreAnimation,
                builder: (context, child) {
                  final animVal = _scoreAnimation.value;
                  return CustomPaint(
                    painter: _GaugePainter(
                      score: animVal,
                      color: levelColor,
                      backgroundColor: colorScheme.outlineVariant.withValues(alpha: 0.2),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${animVal.toInt()}',
                            style: theme.textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            'POINTS',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.outline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSizes.md),
            AnimatedOpacity(
              opacity: _controller.value,
              duration: MotionTokens.fast,
              child: Chip(
                backgroundColor: levelColor.withValues(alpha: 0.1),
                side: BorderSide(color: levelColor.withValues(alpha: 0.3)),
                label: Text(
                  level,
                  style: TextStyle(
                    color: levelColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({
    required this.score,
    required this.color,
    required this.backgroundColor,
  });

  final double score;
  final Color color;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 14.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final basePaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw 240 degree gauge arc starting from 150 degrees (bottom-left) to 30 degrees (bottom-right)
    const startAngle = 150.0 * math.pi / 180.0;
    const sweepAngle = 240.0 * math.pi / 180.0;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      basePaint,
    );

    final progressSweepAngle = (score / 100.0) * sweepAngle;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      progressSweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
