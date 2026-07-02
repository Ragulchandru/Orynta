import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../widgets/focus_card.dart';
import '../widgets/greeting_card.dart';
import '../widgets/habit_card.dart';
import '../widgets/motivation_card.dart';
import '../widgets/notes_card.dart';
import '../widgets/progress_card.dart';
import '../widgets/quick_actions_card.dart';
import '../widgets/tasks_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.lg,
            vertical: AppSizes.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Greeting Card
              GreetingCard(),
              SizedBox(height: AppSizes.md),

              // 2. Daily Progress Card
              ProgressCard(),
              SizedBox(height: AppSizes.md),

              // 3. Today's Tasks Card
              TasksCard(),
              SizedBox(height: AppSizes.md),

              // 4. Recent Notes Card
              NotesCard(),
              SizedBox(height: AppSizes.md),

              // 5. Habit Summary Card
              HabitCard(),
              SizedBox(height: AppSizes.md),

              // 6. Focus Summary Card
              FocusCard(),
              SizedBox(height: AppSizes.md),

              // 7. Quick Actions Card
              QuickActionsCard(),
              SizedBox(height: AppSizes.md),

              // 8. Motivation Card
              MotivationCard(),
              SizedBox(height: AppSizes.lg),
            ],
          ),
        ),
      ),
    );
  }
}
