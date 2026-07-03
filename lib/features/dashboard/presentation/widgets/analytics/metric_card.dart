// lib/features/dashboard/presentation/widgets/analytics/metric_card.dart
//
// Orynta 2.0 — Metric Card Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';

class MetricCard extends StatefulWidget {
  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.emptySubtitle,
    required this.icon,
    this.hasValue = false,
    this.onTap,
  });

  final String title;
  final String value;
  final String emptySubtitle;
  final IconData icon;
  final bool hasValue;
  final VoidCallback? onTap;

  @override
  State<MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<MetricCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.colors.primary;

    return AnimatedScale(
      scale: _isPressed && widget.onTap != null ? 0.97 : 1.0,
      duration: AppDurations.fast,
      curve: AppCurves.easeOut,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLow,
          borderRadius: context.radius.borderRadiusLg,
          border: Border.all(
            color: widget.hasValue
                ? context.colors.outlineVariant
                : context.colors.outlineVariant.withValues(alpha: 0.6),
          ),
          boxShadow: widget.hasValue ? context.shadows.small : null,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: context.radius.borderRadiusLg,
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: widget.onTap != null ? (_) => setState(() => _isPressed = true) : null,
            onTapUp: widget.onTap != null ? (_) => setState(() => _isPressed = false) : null,
            onTapCancel: widget.onTap != null ? () => setState(() => _isPressed = false) : null,
            borderRadius: context.radius.borderRadiusLg,
            hoverColor: primaryColor.withValues(alpha: 0.04),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon + Title
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.08),
                          borderRadius: context.radius.borderRadiusMd,
                        ),
                        child: Icon(
                          widget.icon,
                          size: 18,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: context.typography.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Value vs Empty Subtitle
                  if (widget.hasValue)
                    Text(
                      widget.value,
                      style: context.typography.headlineLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        color: context.colors.primary,
                        letterSpacing: -0.5,
                      ),
                    )
                  else
                    Text(
                      widget.emptySubtitle,
                      style: context.typography.bodySmall.copyWith(
                        color: context.colors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
