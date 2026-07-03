// lib/features/dashboard/presentation/widgets/hero/hero_section.dart
//
// Orynta 2.0 — Premium Dashboard Hero Module Section
//
// Root hero component assembling greeting, date, motivational quote, and productivity score.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                    displayName: state.displayName,
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
              score: state.productivityScore,
            ),
          ],
        ),
      ),
    );
  }
}
