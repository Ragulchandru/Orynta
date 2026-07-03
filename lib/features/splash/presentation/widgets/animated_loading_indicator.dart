// lib/features/splash/presentation/widgets/animated_loading_indicator.dart
//
// Orynta 2.0 — Custom Animated Loading Indicator
//
// Elegant 3-dot loading indicator (● ● ●). Uses a smooth 1600ms opacity pulse
// and subtle 2dp vertical float instead of aggressive scaling.

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_tokens.dart';

class AnimatedLoadingIndicator extends StatefulWidget {
  const AnimatedLoadingIndicator({
    super.key,
    this.dotSize = 6.0,
    this.dotSpacing = 8.0,
    this.isReducedMotion = false,
  });

  final double dotSize;
  final double dotSpacing;
  final bool isReducedMotion;

  @override
  State<AnimatedLoadingIndicator> createState() => AnimatedLoadingIndicatorState();
}

class AnimatedLoadingIndicatorState extends State<AnimatedLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.splashLoadingLoop,
    );

    if (!widget.isReducedMotion) {
      _controller.repeat();
    }
  }

  /// Halts the ticker loop cleanly before route transition.
  void stop() {
    if (_controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isReducedMotion) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: widget.dotSpacing / 2),
            width: widget.dotSize,
            height: widget.dotSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.primary.withValues(alpha: 0.4),
            ),
          );
        }),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            // Stagger phase offset: 0.0, 0.25, 0.50
            final delay = index * 0.25;
            final progress = (_controller.value - delay) % 1.0;
            
            // Smooth sine-like wave (0.0 -> 1.0 -> 0.0)
            final wave = (progress < 0.5)
                ? (progress * 2)
                : ((1.0 - progress) * 2);

            final opacity = 0.30 + (0.60 * wave);
            final translateY = -2.0 * wave; // Subtle 2dp float

            return Transform.translate(
              offset: Offset(0, translateY),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: widget.dotSpacing / 2),
                width: widget.dotSize,
                height: widget.dotSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.primary.withValues(alpha: opacity),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
