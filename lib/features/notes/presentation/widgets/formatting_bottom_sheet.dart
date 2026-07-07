// lib/features/notes/presentation/widgets/formatting_bottom_sheet.dart
//
// Orynta 2.0 — Redesigned Premium Formatting Options Bottom Sheet (Apple Notes / Craft Inspired)

import 'package:flutter/material.dart';
import '../../../../core/design_system/design_system.dart';
import '../controllers/editor_format_controller.dart';

class FormattingBottomSheet extends StatelessWidget {
  const FormattingBottomSheet({
    super.key,
    required this.controller,
    required this.focusNode,
    this.undoController,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final UndoHistoryController? undoController;

  void _applyFormat(BuildContext context, VoidCallback action) {
    action();
    focusNode.requestFocus();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final sheetHeight = height * 0.68;

    // Detect active styles based on current line/selection
    final text = controller.text;
    final selection = controller.selection;
    final start = selection.start;
    final end = selection.end;

    String currentLine = '';
    if (selection.isValid) {
      int lineStart = start;
      while (lineStart > 0 && text[lineStart - 1] != '\n') {
        lineStart--;
      }
      int lineEnd = end;
      while (lineEnd < text.length && text[lineEnd] != '\n') {
        lineEnd++;
      }
      currentLine = text.substring(lineStart, lineEnd);
    }

    final isH1 = currentLine.startsWith('# ');
    final isH2 = currentLine.startsWith('## ');
    final isH3 = currentLine.startsWith('### ');
    final isNormal = !isH1 && !isH2 && !isH3;

    bool isBold = false;
    bool isItalic = false;
    bool isUnderline = false;
    bool isStrikethrough = false;

    if (selection.isValid && !selection.isCollapsed) {
      final selectedText = text.substring(start, end);
      isBold = selectedText.startsWith('**') && selectedText.endsWith('**');
      isItalic = selectedText.startsWith('*') && selectedText.endsWith('*');
      isUnderline = selectedText.startsWith('<u>') && selectedText.endsWith('</u>');
      isStrikethrough = selectedText.startsWith('~~') && selectedText.endsWith('~~');
    }

    final isBulletList = currentLine.startsWith('- ') && !currentLine.startsWith('- [ ] ') && !currentLine.startsWith('- [x] ');
    final isNumberedList = RegExp(r'^\d+\.\s').hasMatch(currentLine);
    final isChecklist = currentLine.startsWith('- [ ] ') || currentLine.startsWith('- [x] ');

    final isQuote = currentLine.startsWith('> ');
    final isCodeBlock = currentLine.startsWith('```') || currentLine.contains('\n```');

    return Container(
      height: sheetHeight,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24.0),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.outlineVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),

          // Header Title
          Text(
            'Formatting',
            style: context.typography.titleLarge.copyWith(
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),

          // Categorized Lists Scroll Area
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text Style Section
                  const _SectionHeader(title: 'Text Style'),
                  _SectionGrid(
                    children: [
                      _FormattingCard(
                        icon: Icons.text_fields_rounded,
                        label: 'Normal',
                        isSelected: isNormal,
                        onTap: () => _applyFormat(context, () {
                          EditorFormatController.toggleBlockStyle(controller, '');
                        }),
                      ),
                      _FormattingCard(
                        icon: Icons.format_size_rounded,
                        label: 'Heading 1',
                        isSelected: isH1,
                        onTap: () => _applyFormat(context, () {
                          EditorFormatController.toggleBlockStyle(controller, '# ');
                        }),
                      ),
                      _FormattingCard(
                        icon: Icons.format_size_rounded,
                        label: 'Heading 2',
                        isSelected: isH2,
                        onTap: () => _applyFormat(context, () {
                          EditorFormatController.toggleBlockStyle(controller, '## ');
                        }),
                      ),
                      _FormattingCard(
                        icon: Icons.format_size_rounded,
                        label: 'Heading 3',
                        isSelected: isH3,
                        onTap: () => _applyFormat(context, () {
                          EditorFormatController.toggleBlockStyle(controller, '### ');
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Text Formatting Section
                  const _SectionHeader(title: 'Text Formatting'),
                  _SectionGrid(
                    children: [
                      _FormattingCard(
                        icon: Icons.format_bold_rounded,
                        label: 'Bold',
                        isSelected: isBold,
                        onTap: () => _applyFormat(context, () {
                          EditorFormatController.toggleInlineStyle(controller, '**');
                        }),
                      ),
                      _FormattingCard(
                        icon: Icons.format_italic_rounded,
                        label: 'Italic',
                        isSelected: isItalic,
                        onTap: () => _applyFormat(context, () {
                          EditorFormatController.toggleInlineStyle(controller, '*');
                        }),
                      ),
                      _FormattingCard(
                        icon: Icons.format_underlined_rounded,
                        label: 'Underline',
                        isSelected: isUnderline,
                        onTap: () => _applyFormat(context, () {
                          EditorFormatController.toggleUnderlineStyle(controller);
                        }),
                      ),
                      _FormattingCard(
                        icon: Icons.format_strikethrough_rounded,
                        label: 'Strikethrough',
                        isSelected: isStrikethrough,
                        onTap: () => _applyFormat(context, () {
                          EditorFormatController.toggleInlineStyle(controller, '~~');
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Lists Section
                  const _SectionHeader(title: 'Lists'),
                  _SectionGrid(
                    children: [
                      _FormattingCard(
                        icon: Icons.format_list_bulleted_rounded,
                        label: 'Bullet',
                        isSelected: isBulletList,
                        onTap: () => _applyFormat(context, () {
                          EditorFormatController.toggleBlockStyle(controller, '- ');
                        }),
                      ),
                      _FormattingCard(
                        icon: Icons.format_list_numbered_rounded,
                        label: 'Numbered',
                        isSelected: isNumberedList,
                        onTap: () => _applyFormat(context, () {
                          EditorFormatController.toggleBlockStyle(controller, '1. ');
                        }),
                      ),
                      _FormattingCard(
                        icon: Icons.checklist_rounded,
                        label: 'Checklist',
                        isSelected: isChecklist,
                        onTap: () => _applyFormat(context, () {
                          EditorFormatController.toggleBlockStyle(controller, '- [ ] ');
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Blocks Section
                  const _SectionHeader(title: 'Blocks'),
                  _SectionGrid(
                    children: [
                      _FormattingCard(
                        icon: Icons.format_quote_rounded,
                        label: 'Quote',
                        isSelected: isQuote,
                        onTap: () => _applyFormat(context, () {
                          EditorFormatController.toggleBlockStyle(controller, '> ');
                        }),
                      ),
                      _FormattingCard(
                        icon: Icons.code_rounded,
                        label: 'Code Block',
                        isSelected: isCodeBlock,
                        onTap: () => _applyFormat(context, () {
                          EditorFormatController.toggleCodeBlock(controller);
                        }),
                      ),
                      _FormattingCard(
                        icon: Icons.horizontal_rule_rounded,
                        label: 'Divider',
                        onTap: () => _applyFormat(context, () {
                          EditorFormatController.insertDivider(controller);
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Actions Section
                  const _SectionHeader(title: 'Actions'),
                  _SectionGrid(
                    children: [
                      _FormattingCard(
                        icon: Icons.format_clear_rounded,
                        label: 'Clear',
                        onTap: () => _applyFormat(context, () {
                          EditorFormatController.clearFormatting(controller);
                        }),
                      ),
                      _FormattingCard(
                        icon: Icons.undo_rounded,
                        label: 'Undo',
                        enabled: undoController?.value.canUndo ?? true,
                        onTap: () => _applyFormat(context, () {
                          undoController?.undo();
                        }),
                      ),
                      _FormattingCard(
                        icon: Icons.redo_rounded,
                        label: 'Redo',
                        enabled: undoController?.value.canRedo ?? true,
                        onTap: () => _applyFormat(context, () {
                          undoController?.redo();
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title.toUpperCase(),
        style: context.typography.labelSmall.copyWith(
          letterSpacing: 1.2,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF7C7CFF), // Orynta primary accent color
        ),
      ),
    );
  }
}

class _SectionGrid extends StatelessWidget {
  const _SectionGrid({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    int crossAxisCount = 4;
    if (width >= 900) {
      crossAxisCount = 6;
    } else if (width >= 600) {
      crossAxisCount = 5;
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 12.0,
      crossAxisSpacing: 12.0,
      childAspectRatio: 1.0,
      children: children,
    );
  }
}

class _FormattingCard extends StatefulWidget {
  const _FormattingCard({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  final bool enabled;

  @override
  State<_FormattingCard> createState() => _FormattingCardState();
}

class _FormattingCardState extends State<_FormattingCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF7C7CFF);
    final textTheme = context.typography;

    final Color bgColor = widget.isSelected
        ? context.colors.primaryContainer.withValues(alpha: 0.25)
        : context.colors.surfaceContainer;

    final Border? border = widget.isSelected
        ? Border.all(color: primary, width: 2.0)
        : null;

    final Color iconColor = widget.isSelected ? primary : context.colors.textPrimary;
    final Color textColor = widget.isSelected ? primary : context.colors.textSecondary;


    return Opacity(
      opacity: widget.enabled ? 1.0 : 0.4,
      child: Semantics(
        label: widget.label,
        enabled: widget.enabled,
        selected: widget.isSelected,
        child: GestureDetector(
          onTapDown: widget.enabled ? (_) => setState(() => _isPressed = true) : null,
          onTapUp: widget.enabled ? (_) => setState(() => _isPressed = false) : null,
          onTapCancel: widget.enabled ? () => setState(() => _isPressed = false) : null,
          onTap: widget.enabled ? widget.onTap : null,
          child: MouseRegion(
            cursor: widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
            child: AnimatedScale(
              scale: _isPressed ? 0.97 : 1.0,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              child: Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20.0),
                  border: border,
                  boxShadow: widget.isSelected
                      ? [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.15),
                            blurRadius: 8.0,
                            spreadRadius: 1.0,
                          ),
                        ]
                      : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(widget.icon, color: iconColor, size: 28),
                      const SizedBox(height: 8),
                      Text(
                        widget.label,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelSmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
