import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';

class MotivationCard extends StatefulWidget {
  const MotivationCard({super.key});

  @override
  State<MotivationCard> createState() => _MotivationCardState();
}

class _MotivationCardState extends State<MotivationCard> {
  // Curated collection of inspirational quotes
  static const List<_Quote> _quotes = [
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
    _Quote(
      text: 'Amateurs sit and wait for inspiration, the rest of us just get up and go to work.',
      author: 'Stephen King',
    ),
    _Quote(
      text: 'It is not that I am so smart, it is just that I stay with problems longer.',
      author: 'Albert Einstein',
    ),
    _Quote(
      text: 'Action is the foundational key to all success.',
      author: 'Pablo Picasso',
    ),
    _Quote(
      text: 'Small daily improvements over time lead to stunning results.',
      author: 'Robin Sharma',
    ),
    _Quote(
      text: 'You don\'t have to be great to start, but you have to start to be great.',
      author: 'Zig Ziglar',
    ),
    _Quote(
      text: 'Done is better than perfect.',
      author: 'Sheryl Sandberg',
    ),
    _Quote(
      text: 'The secret of getting ahead is getting started.',
      author: 'Mark Twain',
    ),
  ];

  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    // Deterministic quote of the day based on day of year
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    _currentIndex = dayOfYear % _quotes.length;
  }

  void _nextQuote() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _quotes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final quote = _quotes[_currentIndex];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.lg),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      color: colorScheme.primaryContainer.withValues(alpha: 0.15),
      child: InkWell(
        onTap: _nextQuote,
        borderRadius: BorderRadius.circular(AppSizes.lg),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.lg,
            vertical: AppSizes.xl,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.format_quote_rounded,
                    color: colorScheme.primary.withValues(alpha: 0.7),
                    size: 28,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'DAILY QUOTE',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                '"${quote.text}"',
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
                '— ${quote.author}',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
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
