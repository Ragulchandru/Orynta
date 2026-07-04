// lib/shared/widgets/premium_fab.dart
//
// Orynta 2.0 — Custom Scroll-Animated Floating Action Button

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../core/design_system/design_system.dart';

class PremiumFAB extends StatefulWidget {
  const PremiumFAB({
    super.key,
    required this.onPressed,
    required this.icon,
    this.label,
    this.backgroundColor,
    this.scrollController,
  });

  final VoidCallback onPressed;
  final Widget icon;
  final String? label;
  final Color? backgroundColor;
  final ScrollController? scrollController;

  @override
  State<PremiumFAB> createState() => _PremiumFABState();
}

class _PremiumFABState extends State<PremiumFAB> {
  bool _isExtended = true;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_scrollListener);
  }

  @override
  void didUpdateWidget(covariant PremiumFAB oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController?.removeListener(_scrollListener);
      widget.scrollController?.addListener(_scrollListener);
    }
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final controller = widget.scrollController;
    if (controller == null) return;
    if (controller.position.userScrollDirection == ScrollDirection.reverse && _isExtended) {
      setState(() => _isExtended = false);
    } else if (controller.position.userScrollDirection == ScrollDirection.forward && !_isExtended) {
      setState(() => _isExtended = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final bg = widget.backgroundColor ?? theme.notes.fabBackground;

    // Dynamically compute high contrast foreground color based on background luminance if custom, otherwise use token
    final fg = widget.backgroundColor != null
        ? (bg.computeLuminance() > 0.5 ? const Color(0xFF11111C) : const Color(0xFFFFFFFF))
        : theme.notes.fabForeground;

    final showLabel = widget.label != null && _isExtended;

    return ScaleOnPress(
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: MotionTokens.normal,
        curve: MotionTokens.emphasized,
        height: 56.0,
        padding: EdgeInsets.symmetric(horizontal: showLabel ? 20.0 : 16.0),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: bg.withValues(alpha: theme.isDark ? 0.4 : 0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconTheme(
              data: IconThemeData(color: fg, size: 24),
              child: widget.icon,
            ),
            AnimatedSize(
              duration: MotionTokens.normal,
              curve: MotionTokens.emphasized,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showLabel) ...[
                    const SizedBox(width: 8),
                    Text(
                      widget.label!,
                      style: context.typography.labelLarge.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
