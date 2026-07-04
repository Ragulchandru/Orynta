// lib/features/notes/presentation/widgets/note_color_picker.dart
//
// Orynta 2.0 — Note Color Picker Component

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../../domain/models/note_color.dart';

class NoteColorPicker extends StatelessWidget {
  const NoteColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  final NoteColor selectedColor;
  final ValueChanged<NoteColor> onColorSelected;

  Color _getColorFromEnum(BuildContext context, NoteColor color) {
    switch (color) {
      case NoteColor.defaultColor:
        return context.colors.surfaceContainerHigh;
      case NoteColor.blue:
        return const Color(0xFFDBEAFE);
      case NoteColor.green:
        return const Color(0xFFD1FAE5);
      case NoteColor.yellow:
        return const Color(0xFFFEF9C3);
      case NoteColor.orange:
        return const Color(0xFFFFEDD5);
      case NoteColor.red:
        return const Color(0xFFFFE4E6);
      case NoteColor.purple:
        return const Color(0xFFEDE9FE);
      case NoteColor.pink:
        return const Color(0xFFFCE7F3);
    }
  }

  String _getColorName(NoteColor color) {
    switch (color) {
      case NoteColor.defaultColor:
        return 'Default';
      case NoteColor.blue:
        return 'Blue';
      case NoteColor.green:
        return 'Green';
      case NoteColor.yellow:
        return 'Yellow';
      case NoteColor.orange:
        return 'Orange';
      case NoteColor.red:
        return 'Red';
      case NoteColor.purple:
        return 'Purple';
      case NoteColor.pink:
        return 'Pink';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Color Label',
            style: context.typography.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: NoteColor.values.length,
            itemBuilder: (context, index) {
              final colorEnum = NoteColor.values[index];
              final isSelected = colorEnum == selectedColor;
              final hexColor = _getColorFromEnum(context, colorEnum);

              return Tooltip(
                message: _getColorName(colorEnum),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: InkWell(
                    onTap: () => onColorSelected(colorEnum),
                    borderRadius: BorderRadius.circular(24),
                    child: AnimatedContainer(
                      duration: AppDurations.fast,
                      curve: AppCurves.easeOut,
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: hexColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? context.colors.primary
                              : context.colors.outlineVariant,
                          width: isSelected ? 2.5 : 1.0,
                        ),
                        boxShadow: isSelected ? context.shadows.small : null,
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check_rounded,
                              size: 20,
                              color: colorEnum == NoteColor.defaultColor
                                  ? context.colors.primary
                                  : Colors.black87,
                            )
                          : null,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
