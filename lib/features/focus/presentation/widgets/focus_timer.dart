import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';

class FocusTimer extends StatelessWidget {
  const FocusTimer({
    super.key,
    required this.remainingSeconds,
    required this.sessionType,
  });

  final int remainingSeconds;
  final String sessionType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');

    final sessionTitle = switch (sessionType) {
      'shortBreak' => 'Short Break',
      'longBreak' => 'Long Break',
      _ => 'Focus Block',
    };

    final titleColor = switch (sessionType) {
      'shortBreak' => Colors.green,
      'longBreak' => Colors.teal,
      _ => colorScheme.primary,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          sessionTitle.toUpperCase(),
          style: theme.textTheme.labelMedium?.copyWith(
            color: titleColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          '$minutes:$seconds',
          style: theme.textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.w100,
            fontSize: 64,
            color: colorScheme.onSurface,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
