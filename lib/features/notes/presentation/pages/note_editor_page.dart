// lib/features/notes/presentation/pages/note_editor_page.dart
//
// Orynta 2.0 — Note Editor Page (Markdown Rich Editor with Metadata Options)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_tokens.dart';
import '../../domain/models/note_color.dart';
import '../../domain/models/note_attachment.dart';
import '../controllers/rich_text_editing_controller.dart';
import '../providers/note_editor_providers.dart';
import '../providers/note_attachment_providers.dart';
import '../widgets/editor_app_bar.dart';
import '../widgets/editor_status_bar.dart';
import '../widgets/editor_toolbar.dart';
import '../widgets/note_metadata_sheet.dart';
import '../widgets/rich_editor_area.dart';
import '../widgets/attachment_empty_state.dart';
import '../widgets/attachment_grid.dart';

class NoteEditorPage extends ConsumerStatefulWidget {
  const NoteEditorPage({
    super.key,
    this.noteId,
  });

  final String? noteId;

  @override
  ConsumerState<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends ConsumerState<NoteEditorPage> {
  late final TextEditingController _titleController;
  late final RichTextEditingController _contentController;
  late final UndoHistoryController _undoController;
  final FocusNode _contentFocusNode = FocusNode();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = RichTextEditingController();
    _undoController = UndoHistoryController();

    _titleController.addListener(_onTitleChanged);
    _contentController.addListener(_onContentChanged);
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTitleChanged);
    _contentController.removeListener(_onContentChanged);
    _titleController.dispose();
    _contentController.dispose();
    _undoController.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  void _onTitleChanged() {
    ref.read(noteEditorControllerProvider(widget.noteId).notifier).updateTitle(_titleController.text);
  }

  void _onContentChanged() {
    ref.read(noteEditorControllerProvider(widget.noteId).notifier).updateContent(_contentController.text);
  }

  Future<void> _handlePop() async {
    final controller = ref.read(noteEditorControllerProvider(widget.noteId).notifier);
    await controller.finishEditing();
    if (mounted) {
      context.pop();
    }
  }

  void _showMetadataSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final liveState = ref.watch(noteEditorControllerProvider(widget.noteId));
            final liveController = ref.read(noteEditorControllerProvider(widget.noteId).notifier);

            return NoteMetadataSheet(
              isPinned: liveState.isPinned,
              isFavorite: liveState.isFavorite,
              isArchived: liveState.isArchived,
              selectedColor: liveState.color,
              onPinChanged: liveController.togglePin,
              onFavoriteChanged: liveController.toggleFavorite,
              onArchiveChanged: liveController.toggleArchive,
              onColorChanged: liveController.updateColor,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(noteEditorControllerProvider(widget.noteId));
    final noteId = state.noteId;
    final attachments = noteId != null
        ? ref.watch(noteAttachmentsProvider(noteId))
        : <NoteAttachment>[];

    if (state.noteId != null && !_isInitialized) {
      _titleController.text = state.title;
      _contentController.text = state.content;
      _isInitialized = true;
    }

    final hasCustomColor = state.color != NoteColor.defaultColor && state.color.argbValue != null;
    final backgroundColor = hasCustomColor
        ? Color(state.color.argbValue!).withValues(alpha: 0.12)
        : context.colors.background;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handlePop();
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: EditorAppBar(
          onBack: _handlePop,
          onShowOptions: () => _showMetadataSheet(context),
        ),
        body: SafeArea(
          child: Column(
            children: [
              EditorStatusBar(
                saving: state.saving,
                saved: state.saved,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 24.0,
                          right: 24.0,
                          top: 24.0,
                          bottom: 8.0,
                        ),
                        child: TextField(
                          controller: _titleController,
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
                        ),
                      ),
                      RichEditorArea(
                        controller: _contentController,
                        focusNode: _contentFocusNode,
                        undoController: _undoController,
                      ),
                      if (noteId != null) ...[
                        const Divider(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            'Attachments',
                            style: context.typography.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.colors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: attachments.isEmpty
                              ? const AttachmentEmptyState()
                              : AttachmentGrid(attachments: attachments),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ],
                  ),
                ),
              ),
              EditorToolbar(
                controller: _contentController,
                focusNode: _contentFocusNode,
                noteId: noteId,
                undoController: _undoController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
