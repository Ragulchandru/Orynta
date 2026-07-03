// lib/features/notes/presentation/widgets/editor_content_field.dart
//
// Orynta 2.0 — Editor Content Field Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';

class EditorContentField extends StatefulWidget {
  const EditorContentField({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  State<EditorContentField> createState() => _EditorContentFieldState();
}

class _EditorContentFieldState extends State<EditorContentField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant EditorContentField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      style: context.typography.bodyMedium.copyWith(
        color: context.colors.textPrimary,
        height: 1.6,
      ),
      decoration: InputDecoration(
        hintText: 'Start writing...',
        hintStyle: context.typography.bodyMedium.copyWith(
          color: context.colors.textSecondary.withValues(alpha: 0.4),
          height: 1.6,
        ),
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
