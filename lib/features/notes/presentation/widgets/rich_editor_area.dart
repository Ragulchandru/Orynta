import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../../../settings/presentation/providers/settings_provider.dart';

class RichEditorArea extends ConsumerWidget {
  const RichEditorArea({
    super.key,
    required this.controller,
    required this.focusNode,
    this.undoController,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final UndoHistoryController? undoController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsStateProvider);

    return TextField(
      controller: controller,
      focusNode: focusNode,
      undoController: undoController,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      style: context.typography.bodyMedium.copyWith(
        color: context.colors.textPrimary,
        fontSize: settings.defaultFontSize,
        fontFamily: settings.defaultFontFamily,
        height: settings.lineSpacing,
      ),
      decoration: InputDecoration(
        hintText: 'Start writing...',
        hintStyle: context.typography.bodyMedium.copyWith(
          color: context.colors.textSecondary.withValues(alpha: 0.4),
          fontSize: settings.defaultFontSize,
          fontFamily: settings.defaultFontFamily,
          height: settings.lineSpacing,
        ),
        border: InputBorder.none,
        isDense: true,
        contentPadding: const EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          top: 24.0,
          bottom: 40.0,
        ),
      ),
    );
  }
}
