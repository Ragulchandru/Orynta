// lib/features/notes/presentation/widgets/editor_toolbar.dart
//
// Orynta 2.0 — Editor Formatting Toolbar Component

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../controllers/editor_format_controller.dart';
import 'editor_toolbar_button.dart';
import 'heading_style_menu.dart';

class EditorToolbar extends StatelessWidget {
  const EditorToolbar({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  void _applyFormat(VoidCallback action) {
    action();
    // Keep focus on editor after format button is pressed
    focusNode.requestFocus();
  }

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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                EditorToolbarButton(
                  icon: Icons.format_bold_rounded,
                  tooltip: 'Bold',
                  onPressed: () => _applyFormat(() {
                    EditorFormatController.toggleInlineStyle(controller, '**');
                  }),
                ),
                EditorToolbarButton(
                  icon: Icons.format_italic_rounded,
                  tooltip: 'Italic',
                  onPressed: () => _applyFormat(() {
                    EditorFormatController.toggleInlineStyle(controller, '*');
                  }),
                ),
                EditorToolbarButton(
                  icon: Icons.format_underlined_rounded,
                  tooltip: 'Underline',
                  onPressed: () => _applyFormat(() {
                    EditorFormatController.toggleInlineStyle(controller, '<u>');
                  }),
                ),
                EditorToolbarButton(
                  icon: Icons.format_strikethrough_rounded,
                  tooltip: 'Strikethrough',
                  onPressed: () => _applyFormat(() {
                    EditorFormatController.toggleInlineStyle(controller, '~~');
                  }),
                ),
                VerticalDivider(
                  color: context.colors.outlineVariant,
                  indent: 8,
                  endIndent: 8,
                ),
                HeadingStyleMenu(
                  onSelected: (style) => _applyFormat(() {
                    if (style == 'h1') {
                      EditorFormatController.toggleBlockStyle(controller, '# ');
                    } else if (style == 'h2') {
                      EditorFormatController.toggleBlockStyle(controller, '## ');
                    } else if (style == 'h3') {
                      EditorFormatController.toggleBlockStyle(controller, '### ');
                    } else {
                      EditorFormatController.toggleBlockStyle(controller, '');
                    }
                  }),
                ),
                VerticalDivider(
                  color: context.colors.outlineVariant,
                  indent: 8,
                  endIndent: 8,
                ),
                EditorToolbarButton(
                  icon: Icons.format_list_bulleted_rounded,
                  tooltip: 'Bullet List',
                  onPressed: () => _applyFormat(() {
                    EditorFormatController.toggleBlockStyle(controller, '- ');
                  }),
                ),
                EditorToolbarButton(
                  icon: Icons.format_list_numbered_rounded,
                  tooltip: 'Numbered List',
                  onPressed: () => _applyFormat(() {
                    EditorFormatController.toggleBlockStyle(controller, '1. ');
                  }),
                ),
                EditorToolbarButton(
                  icon: Icons.checklist_rounded,
                  tooltip: 'Checklist',
                  onPressed: () => _applyFormat(() {
                    EditorFormatController.toggleBlockStyle(controller, '- [ ] ');
                  }),
                ),
                VerticalDivider(
                  color: context.colors.outlineVariant,
                  indent: 8,
                  endIndent: 8,
                ),
                EditorToolbarButton(
                  icon: Icons.format_quote_rounded,
                  tooltip: 'Quote',
                  onPressed: () => _applyFormat(() {
                    EditorFormatController.toggleBlockStyle(controller, '> ');
                  }),
                ),
                EditorToolbarButton(
                  icon: Icons.code_rounded,
                  tooltip: 'Code Block',
                  onPressed: () => _applyFormat(() {
                    EditorFormatController.toggleCodeBlock(controller);
                  }),
                ),
                EditorToolbarButton(
                  icon: Icons.horizontal_rule_rounded,
                  tooltip: 'Horizontal Divider',
                  onPressed: () => _applyFormat(() {
                    EditorFormatController.insertDivider(controller);
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
