// lib/shared/widgets/hover_card.dart
//
// Orynta 2.0 — Mouse hover translation container

import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';

class HoverCard extends StatefulWidget {
  const HoverCard({
    super.key,
    required this.child,
    this.onTap,
  });

  final Widget child;
  final VoidCallback? onTap;

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          curve: AppCurves.easeOut,
          transform: _isHovered
              ? Matrix4.translationValues(0.0, -2.0, 0.0)
              : Matrix4.identity(),
          child: widget.child,
        ),
      ),
    );
  }
}
