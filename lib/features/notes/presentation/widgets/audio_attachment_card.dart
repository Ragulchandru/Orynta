// lib/features/notes/presentation/widgets/audio_attachment_card.dart
//
// Orynta 2.0 — Audio Attachment Card Component

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../../domain/models/note_attachment.dart';
import '../providers/note_attachment_providers.dart';

class AudioAttachmentCard extends ConsumerStatefulWidget {
  const AudioAttachmentCard({super.key, required this.attachment});
  final NoteAttachment attachment;

  @override
  ConsumerState<AudioAttachmentCard> createState() => _AudioAttachmentCardState();
}

class _AudioAttachmentCardState extends ConsumerState<AudioAttachmentCard> {
  bool _isPlaying = false;
  int _currentSeconds = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        final totalSec = widget.attachment.duration?.inSeconds ?? 42;
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (_currentSeconds >= totalSec) {
            setState(() {
              _isPlaying = false;
              _currentSeconds = 0;
            });
            _timer?.cancel();
          } else {
            setState(() {
              _currentSeconds++;
            });
          }
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final totalSeconds = widget.attachment.duration?.inSeconds ?? 42;

    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: context.colors.surfaceContainer,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: context.colors.outlineVariant.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.audiotrack_rounded,
                size: 28,
                color: context.colors.primary,
              ),
              GestureDetector(
                onTap: () {
                  ref.read(noteAttachmentsProvider(widget.attachment.noteId).notifier).removeAttachment(widget.attachment.id);
                },
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: context.colors.outlineVariant.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close_rounded, size: 14, color: context.colors.textPrimary),
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: _togglePlay,
                icon: Icon(
                  _isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                  size: 32,
                  color: context.colors.primary,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          10,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 1.5),
                            width: 3,
                            height: _isPlaying
                                ? (4.0 + (index * 4 % 12) + (_currentSeconds % 3 * 3))
                                : 4.0,
                            decoration: BoxDecoration(
                              color: context.colors.primary.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatDuration(_currentSeconds)} / ${_formatDuration(totalSeconds)}',
                      style: context.typography.labelSmall.copyWith(
                        color: context.colors.textSecondary,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
