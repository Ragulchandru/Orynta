// lib/features/notes/presentation/widgets/metadata_action_tile.dart
//
// Orynta 2.0 — Metadata Action Tile Component

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_tokens.dart';

class MetadataActionTile extends StatelessWidget {
  const MetadataActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.value,
    this.onChanged,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool? value;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? (onChanged != null && value != null ? () => onChanged!(!value!) : null),
        borderRadius: context.radius.borderRadiusLg,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.08),
                  borderRadius: context.radius.borderRadiusMd,
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: context.colors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.typography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: context.typography.bodySmall.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (onChanged != null && value != null)
                Switch.adaptive(
                  value: value!,
                  onChanged: onChanged,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
