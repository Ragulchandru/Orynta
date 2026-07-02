import 'dart:math';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';

class MotivationCard extends StatefulWidget {
  const MotivationCard({super.key});

  @override
  State<MotivationCard> createState() => _MotivationCardState();
}

class _MotivationCardState extends State<MotivationCard> {
  // A curated list of premium motivational quotes
  final List<_Quote> _quotes = const [
    _Quote(
      text: 'The only way to do great work is to love what you do.',
      author: 'Steve Jobs',
    ),
    _Quote(
      text: 'Productivity is never an accident. It is always the result of a commitment to excellence, intelligent planning, and focused effort.',
      author: 'Paul J. Meyer',
    ),
    _Quote(
      text: 'Focus on being productive instead of busy.',
      author: 'Tim Ferriss',
    ),
    _Quote(
      text: 'Your mind is for having ideas, not holding them.',
      author: 'David Allen',
    ),
    _Quote(
      text: 'Start where you are. Use what you have. Do what you can.',
      author: 'Arthur Ashe',
    ),
  ];

  late _Quote _selectedQuote;

  @override
  void initState() {
    super.initState();
    // Select a random quote for this session
    final randomIndex = Random().nextInt(_quotes.length);
    _selectedQuote = _quotes[randomIndex];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.lg),
      ),
      // Use a subtle primary-themed gradient backdrop
      color: colorScheme.primaryContainer.withValues(alpha: 0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg, vertical: AppSizes.xl),
        child: Column(
          children: [
            Icon(
              Icons.format_quote_rounded,
              color: colorScheme.primary.withValues(alpha: 0.6),
              size: 32,
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              '"${_selectedQuote.text}"',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                color: colorScheme.onSurface,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              '— ${_selectedQuote.author}',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Quote {
  const _Quote({
    required this.text,
    required this.author,
  });

  final String text;
  final String author;
}
