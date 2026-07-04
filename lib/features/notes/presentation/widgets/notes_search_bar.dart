// lib/features/notes/presentation/widgets/notes_search_bar.dart
//
// Orynta 2.0 — Notes Search Bar Component with Focus & Cancel Actions

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../providers/notes_home_providers.dart';

class NotesSearchBar extends ConsumerStatefulWidget {
  const NotesSearchBar({
    super.key,
    required this.onSearch,
    required this.initialQuery,
    this.focusNode,
    this.controller,
  });

  final ValueChanged<String> onSearch;
  final String initialQuery;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  @override
  ConsumerState<NotesSearchBar> createState() => _NotesSearchBarState();
}

class _NotesSearchBarState extends ConsumerState<NotesSearchBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  Timer? _debounce;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialQuery);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
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
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    _debounce?.cancel();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    ref.read(notesHomeControllerProvider.notifier).setSearchFocused(_focusNode.hasFocus);
  }

  void _onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      widget.onSearch(value);
      if (value.isNotEmpty) {
        ref.read(notesHomeControllerProvider.notifier).addRecentSearch(value);
      }
    });
    setState(() {});
  }

  void _onClear() {
    _controller.clear();
    widget.onSearch('');
    setState(() {});
  }

  void _onCancelSearch() {
    _focusNode.unfocus();
    _controller.clear();
    widget.onSearch('');
    ref.read(notesHomeControllerProvider.notifier).setSearchFocused(false);
    ref.read(notesHomeControllerProvider.notifier).setSelectedTag(null);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hasText = _controller.text.isNotEmpty;
    final showCancel = _isFocused || hasText;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.appTheme.notes.searchBackground,
        borderRadius: context.radius.borderRadiusLg,
        border: Border.all(
          color: _isFocused ? context.colors.primary : context.appTheme.notes.searchBorder,
          width: _isFocused ? 1.5 : 1.0,
        ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: _onChanged,
        style: context.typography.bodyMedium.copyWith(
          color: context.colors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search notes, tags, attachments...',
          hintStyle: context.typography.bodyMedium.copyWith(
            color: context.colors.textSecondary.withValues(alpha: 0.6),
          ),
          prefixIcon: showCancel
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: _onCancelSearch,
                  color: context.colors.primary,
                )
              : Icon(
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
