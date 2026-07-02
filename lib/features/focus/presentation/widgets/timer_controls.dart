import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';

class TimerControls extends StatelessWidget {
  const TimerControls({
    super.key,
    required this.isRunning,
    required this.onStart,
    required this.onPause,
    required this.onReset,
    required this.onStop,
    required this.onSkip,
  });

  final bool isRunning;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onReset;
  final VoidCallback onStop;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Reset Button
        IconButton.outlined(
          icon: const Icon(Icons.refresh_rounded),
          onPressed: onReset,
          tooltip: 'Reset Timer',
        ),
        const SizedBox(width: AppSizes.md),

        // Start / Pause Floating action button or major button
        ElevatedButton(
          onPressed: isRunning ? onPause : onStart,
          style: ElevatedButton.styleFrom(
            backgroundColor: isRunning ? colorScheme.errorContainer : colorScheme.primary,
            foregroundColor: isRunning ? colorScheme.onErrorContainer : colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl, vertical: AppSizes.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.lg),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded),
              const SizedBox(width: AppSizes.xs),
              Text(
                isRunning ? 'PAUSE' : 'START',
                style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSizes.md),

        // Skip Button
        IconButton.outlined(
          icon: const Icon(Icons.skip_next_rounded),
          onPressed: onSkip,
          tooltip: 'Skip Session',
        ),
      ],
    );
  }
}
