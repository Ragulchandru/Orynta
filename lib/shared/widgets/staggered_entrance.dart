// lib/shared/widgets/staggered_entrance.dart
//
// Orynta 2.0 — Staggered Entrance Animations using Material 3 Motion

import 'package:flutter/material.dart';

import '../../core/design_system/motion/motion_tokens.dart';

class StaggeredEntrance extends StatefulWidget {
  const StaggeredEntrance({
    super.key,
    required this.child,
    required this.index,
  });

  final Widget child;
  final int index;

  @override
  State<StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<StaggeredEntrance> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: MotionTokens.normal, // 220ms
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: MotionTokens.decelerate),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0.0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: MotionTokens.emphasized),
    );

    // Staggered delay (40ms per card)
    Future.delayed(Duration(milliseconds: widget.index * 40), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: widget.child,
      ),
    );
  }
}
