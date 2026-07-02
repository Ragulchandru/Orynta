import 'package:flutter/material.dart';


class FocusProgressRing extends StatelessWidget {
  const FocusProgressRing({
    super.key,
    required this.progress,
    required this.child,
    required this.sessionType,
  });

  final double progress;
  final Widget child;
  final String sessionType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final ringColor = switch (sessionType) {
      'shortBreak' => Colors.green,
      'longBreak' => Colors.teal,
      _ => colorScheme.primary,
    };

    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow/shadow decorative circle
        Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ringColor.withValues(alpha: 0.05),
          ),
        ),
        // Progress Ring
        SizedBox(
          width: 200,
          height: 200,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 10,
            backgroundColor: colorScheme.outlineVariant.withValues(alpha: 0.15),
            color: ringColor,
            strokeCap: StrokeCap.round,
          ),
        ),
        // Central text/child container
        child,
      ],
    );
  }
}
