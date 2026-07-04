// lib/features/notes/presentation/widgets/editor_toolbar.dart
//
// Orynta 2.0 — Redesigned Premium Editor Bottom Toolbar (Minimalist style)

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_tokens.dart';
import 'attachment_picker_sheet.dart';
import 'formatting_bottom_sheet.dart';

class EditorToolbar extends StatelessWidget {
  const EditorToolbar({
    super.key,
    required this.controller,
    required this.focusNode,
    this.noteId,
    this.undoController,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String? noteId;
  final UndoHistoryController? undoController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        border: Border(
          top: BorderSide(color: context.colors.outlineVariant),
          bottom: BorderSide(color: context.colors.outlineVariant),
        ),
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Attachment button (left)
                if (noteId != null)
                  _ScaleTapButton(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => AttachmentPickerSheet(noteId: noteId!),
                      );
                    },
                    child: Tooltip(
                      message: 'Attachments',
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.attach_file_rounded,
                          color: context.colors.primary,
                          size: 24,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),

                // Formatting button (right)
                _ScaleTapButton(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (context) => FormattingBottomSheet(
                        controller: controller,
                        focusNode: focusNode,
                        undoController: undoController,
                      ),
                    );
                  },
                  child: Tooltip(
                    message: 'Formatting Options',
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: context.colors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: context.colors.primary.withValues(alpha: 0.15)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.text_fields_rounded,
                            color: context.colors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Aa',
                            style: context.typography.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.colors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScaleTapButton extends StatefulWidget {
  const _ScaleTapButton({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

  @override
  State<_ScaleTapButton> createState() => _ScaleTapButtonState();
}

class _ScaleTapButtonState extends State<_ScaleTapButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      ),
    );
  }
}
