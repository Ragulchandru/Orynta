// lib/features/notes/presentation/widgets/editor_title_field.dart
//
// Orynta 2.0 — Editor Title Field Component

import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';

class EditorTitleField extends StatefulWidget {
  const EditorTitleField({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  State<EditorTitleField> createState() => _EditorTitleFieldState();
}

class _EditorTitleFieldState extends State<EditorTitleField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant EditorTitleField oldWidget) {
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
      style: context.typography.headlineMedium.copyWith(
        fontWeight: FontWeight.w800,
        color: context.colors.textPrimary,
        letterSpacing: -0.5,
      ),
      decoration: InputDecoration(
        hintText: 'Title',
        hintStyle: context.typography.headlineMedium.copyWith(
          fontWeight: FontWeight.w800,
          color: context.colors.textSecondary.withValues(alpha: 0.4),
          letterSpacing: -0.5,
        ),
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
