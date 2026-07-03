// lib/features/notes/presentation/widgets/notes_loading.dart
//
// Orynta 2.0 — Notes Loading (Skeleton) Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';

class NotesLoading extends StatelessWidget {
  const NotesLoading({super.key});

  int _calculateCrossAxisCount(double width) {
    if (width < 600) return 2;
    if (width < 1000) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _calculateCrossAxisCount(constraints.maxWidth);
        final baseColor = context.colors.outlineVariant.withValues(alpha: 0.3);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
            childAspectRatio: constraints.maxWidth < 600 ? 1.0 : 1.25,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerLow,
                borderRadius: context.radius.borderRadiusLg,
                border: Border.all(color: context.colors.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 18,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: context.radius.borderRadiusSm,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 12,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: context.radius.borderRadiusSm,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    height: 12,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: context.radius.borderRadiusSm,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 60,
                    height: 10,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: context.radius.borderRadiusSm,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
