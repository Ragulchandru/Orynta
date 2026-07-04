// lib/features/notes/presentation/widgets/notes_loading.dart
//
// Orynta 2.0 — Notes Loading (Skeleton) Component (Responsive natural sizing)

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
        final List<Widget> rows = [];
        const count = 6;

        for (int i = 0; i < count; i += crossAxisCount) {
          final rowChildren = <Widget>[];
          for (int j = 0; j < crossAxisCount; j++) {
            if (i + j < count) {
              rowChildren.add(
                Expanded(
                  child: Container(
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
                        const SizedBox(height: 24),
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
                  ),
                ),
              );
            } else {
              rowChildren.add(const Expanded(child: SizedBox.shrink()));
            }
            if (j < crossAxisCount - 1) {
              rowChildren.add(const SizedBox(width: 20));
            }
          }

          rows.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: rowChildren,
              ),
            ),
          );

          if (i + crossAxisCount < count) {
            rows.add(const SizedBox(height: 20));
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rows,
        );
      },
    );
  }
}
