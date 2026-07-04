// lib/features/notes/presentation/widgets/attachment_picker_sheet.dart
//
// Orynta 2.0 — Note Attachment Picker Bottom Sheet

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../providers/note_attachment_providers.dart';

class AttachmentPickerSheet extends ConsumerWidget {
  const AttachmentPickerSheet({super.key, required this.noteId});

  final String noteId;

  void _showLinkDialog(BuildContext context, WidgetRef ref) {
    final urlController = TextEditingController();
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colors.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0)),
        title: Text(
          'Add Web Link',
          style: context.typography.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: 'URL',
                hintText: 'https://example.com',
                labelStyle: TextStyle(color: context.colors.textSecondary),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: context.colors.outlineVariant)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: context.colors.primary)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Example Website',
                labelStyle: TextStyle(color: context.colors.textSecondary),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: context.colors.outlineVariant)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: context.colors.primary)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'An amazing site for developers',
                labelStyle: TextStyle(color: context.colors.textSecondary),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: context.colors.outlineVariant)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: context.colors.primary)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: context.colors.textSecondary)),
          ),
          FilledButton(
            onPressed: () {
              final url = urlController.text.trim();
              final title = titleController.text.trim();
              final desc = descController.text.trim();
              if (url.isNotEmpty && title.isNotEmpty) {
                ref.read(noteAttachmentsProvider(noteId).notifier).simulateAddLink(
                  url,
                  title,
                  desc.isEmpty ? 'No description available' : desc,
                );
                Navigator.pop(ctx);
                Navigator.pop(context); // close sheet too
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAudioRecorder(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AudioRecorderBottomSheet(noteId: noteId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(noteAttachmentsProvider(noteId).notifier);

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: context.colors.outlineVariant,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Add Attachment',
            style: context.typography.titleLarge.copyWith(
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.9,
            children: [
              _PickerItem(
                icon: Icons.camera_alt_rounded,
                label: 'Camera',
                onTap: () {
                  controller.simulateAddImage(true);
                  Navigator.pop(context);
                },
              ),
              _PickerItem(
                icon: Icons.image_rounded,
                label: 'Gallery',
                onTap: () {
                  controller.simulateAddImage(false);
                  Navigator.pop(context);
                },
              ),
              _PickerItem(
                icon: Icons.picture_as_pdf_rounded,
                label: 'PDF',
                onTap: () {
                  controller.simulateAddPdf();
                  Navigator.pop(context);
                },
              ),
              _PickerItem(
                icon: Icons.description_rounded,
                label: 'File',
                onTap: () {
                  controller.simulateAddFile();
                  Navigator.pop(context);
                },
              ),
              _PickerItem(
                icon: Icons.mic_rounded,
                label: 'Recording',
                onTap: () => _showAudioRecorder(context, ref),
              ),
              _PickerItem(
                icon: Icons.link_rounded,
                label: 'Web Link',
                onTap: () => _showLinkDialog(context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PickerItem extends StatelessWidget {
  const _PickerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.0),
      child: Ink(
        decoration: BoxDecoration(
          color: context.colors.surfaceContainer,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: context.colors.outlineVariant.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: context.colors.primary),
            const SizedBox(height: 8),
            Text(
              label,
              style: context.typography.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AudioRecorderBottomSheet extends StatefulWidget {
  const _AudioRecorderBottomSheet({required this.noteId});
  final String noteId;

  @override
  State<_AudioRecorderBottomSheet> createState() => _AudioRecorderBottomSheetState();
}

class _AudioRecorderBottomSheetState extends State<_AudioRecorderBottomSheet> {
  bool _isRecording = true;
  int _seconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted) {
        setState(() {
          _seconds++;
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime() {
    final min = (_seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (_seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => Container(
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLow,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28.0)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isRecording ? 'Recording Audio' : 'Recording Paused',
              style: context.typography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isRecording)
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  )
                      .animate(onPlay: (controller) => controller.repeat(reverse: true))
                      .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.3, 1.3), duration: const Duration(milliseconds: 600))
                      .fade(begin: 0.5, end: 1.0)
                else
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                const SizedBox(width: 12),
                Text(
                  _formatTime(),
                  style: context.typography.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    color: context.colors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Waveform simulation
            SizedBox(
              height: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  15,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                    width: 4,
                    height: _isRecording ? (10.0 + (index * 3 % 20) + (index % 3 * 6)) : 6.0,
                    decoration: BoxDecoration(
                      color: context.colors.primary.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton.filledTonal(
                  onPressed: () {
                    _stopTimer();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: _isRecording ? Colors.red : context.colors.primary,
                    minimumSize: const Size(56, 56),
                  ),
                  onPressed: () {
                    setState(() {
                      _isRecording = !_isRecording;
                      if (_isRecording) {
                        _startTimer();
                      } else {
                        _stopTimer();
                      }
                    });
                  },
                  icon: Icon(_isRecording ? Icons.pause_rounded : Icons.mic_rounded, size: 28),
                ),
                IconButton.filledTonal(
                  onPressed: () {
                    _stopTimer();
                    ref.read(noteAttachmentsProvider(widget.noteId).notifier).simulateAddAudio(
                      Duration(seconds: _seconds),
                    );
                    Navigator.pop(context);
                    Navigator.pop(context); // Close picker too
                  },
                  icon: const Icon(Icons.check_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
