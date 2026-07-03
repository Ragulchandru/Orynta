// lib/features/notes/presentation/widgets/notes_search_bar.dart
//
// Orynta 2.0 — Notes Search Bar Component

import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../core/design_system/design_tokens.dart';

class NotesSearchBar extends StatefulWidget {
  const NotesSearchBar({
    super.key,
    required this.onSearch,
    required this.initialQuery,
  });

  final ValueChanged<String> onSearch;
  final String initialQuery;

  @override
  State<NotesSearchBar> createState() => _NotesSearchBarState();
}

class _NotesSearchBarState extends State<NotesSearchBar> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void didUpdateWidget(covariant NotesSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuery != _controller.text) {
      _controller.text = widget.initialQuery;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      widget.onSearch(value);
    });
    setState(() {});
  }

  void _onClear() {
    _controller.clear();
    widget.onSearch('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hasText = _controller.text.isNotEmpty;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: context.radius.borderRadiusLg,
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        style: context.typography.bodyMedium.copyWith(
          color: context.colors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search notes...',
          hintStyle: context.typography.bodyMedium.copyWith(
            color: context.colors.textSecondary,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: context.colors.textSecondary,
          ),
          suffixIcon: hasText
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: _onClear,
                  color: context.colors.textSecondary,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
