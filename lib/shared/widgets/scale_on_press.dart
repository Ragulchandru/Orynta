// lib/shared/widgets/scale_on_press.dart
//
// Orynta 2.0 — Spring scale feedback container

import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';

class ScaleOnPress extends StatefulWidget {
  const ScaleOnPress({
    super.key,
    required this.child,
    required this.onTap,
  });

  final Widget child;
  final VoidCallback onTap;

  @override
  State<ScaleOnPress> createState() => _ScaleOnPressState();
}

class _ScaleOnPressState extends State<ScaleOnPress> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: AppMotion.fast,
        curve: AppCurves.easeOut,
        child: widget.child,
      ),
    );
  }
}
