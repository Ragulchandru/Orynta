// lib/features/dashboard/presentation/widgets/hero/hero_section.dart
//
// Orynta 2.0 — Premium Dashboard Hero Module Section
//
// Root hero component assembling greeting, date, motivational quote, and productivity score.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../profile/presentation/providers/profile_provider.dart';
import '../../../../analytics/presentation/providers/analytics_provider.dart';
import '../../../../planner/presentation/providers/tasks_notifier.dart';
import '../../../../habits/presentation/providers/habits_notifier.dart';
import '../../../../focus/presentation/providers/focus_notifier.dart';
import '../../../../notes/presentation/providers/notes_notifier.dart';
import '../../../domain/models/productivity_score.dart';
import '../../providers/hero_providers.dart';

import 'date_widget.dart';
import 'greeting_widget.dart';
import 'hero_background.dart';
import 'motivational_message_widget.dart';
import 'productivity_score_card.dart';


class HeroSection extends ConsumerWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(heroControllerProvider);
    final heightResolver = ref.watch(heroHeightResolverProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final minHeight = heightResolver.resolveMinHeight(screenHeight);

    // Watch only displayName to optimize rebuilding
    final displayName = ref.watch(profileProvider.select((p) => p.displayName));
    final effectiveName = displayName.trim().isNotEmpty ? displayName.trim() : 'Guest';

    // Subscribe directly to live score updates using the existing provider
    final scoreValue = ref.watch(productivityScoreProvider);
    final score = scoreValue.round();

    // Check empty state
    final tasks = ref.watch(tasksProvider);
    final habits = ref.watch(habitsProvider);
    final focusSessions = ref.watch(focusNotifierProvider);
    final notes = ref.watch(notesProvider).value ?? [];
    final isEmptyState = tasks.isEmpty && habits.isEmpty && focusSessions.isEmpty && notes.isEmpty;

    final String subtitle;
    if (isEmptyState || score == 0) {
      subtitle = 'Start your productivity journey! Create your first task to begin tracking your progress.';
    } else if (score >= 90) {
      subtitle = 'Incredible! Peak performance today.';
    } else if (score >= 70) {
      subtitle = 'Great focus and productivity today!';
    } else if (score >= 50) {
      subtitle = 'Steady progress. Keep it up!';
    } else {
      subtitle = 'Log some focus time to build momentum.';
    }

    final liveScore = ProductivityScore(
      value: score,
      hasData: !isEmptyState && score > 0,
      label: (isEmptyState || score == 0) ? '0' : '$score',
      subtitle: subtitle,
    );


    return HeroBackground(
      style: state.backgroundStyle,
      padding: const EdgeInsets.all(24.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Row: Greeting + Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GreetingWidget(
                    greeting: state.greeting,
                    displayName: effectiveName,
                  ),
                ),
                DateWidget(
                  formattedDate: state.formattedDate,
                ),
              ],
            ),

            const SizedBox(height: 32.0),

            // Motivational Quote Widget
            MotivationalMessageWidget(
              motivationMessage: state.motivationMessage,
            ),

            const SizedBox(height: 24.0),

            // Productivity Score Card
            ProductivityScoreCard(
              score: liveScore,
            ),
          ],
        ),
      ),
    );
  }
}
