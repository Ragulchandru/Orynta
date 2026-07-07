// test/widget/hero_section_test.dart
//
// Orynta 2.0 — HeroSection Widget Tests

import 'dart:io';
import 'package:flutter/material.dart' hide HeroController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:orynta/core/constants/app_strings.dart';
import 'package:orynta/features/analytics/presentation/providers/analytics_provider.dart';
import 'package:orynta/features/dashboard/domain/models/hero_background_style.dart';
import 'package:orynta/features/dashboard/domain/models/hero_state.dart';
import 'package:orynta/features/dashboard/domain/models/motivation_message.dart';
import 'package:orynta/features/dashboard/domain/models/productivity_score.dart';
import 'package:orynta/features/dashboard/domain/repositories/user_profile_repository.dart';
import 'package:orynta/features/dashboard/domain/services/date_service.dart';
import 'package:orynta/features/dashboard/domain/services/greeting_service.dart';
import 'package:orynta/features/dashboard/domain/services/motivational_message_service.dart';
import 'package:orynta/features/dashboard/domain/services/productivity_score_calculator.dart';
import 'package:orynta/features/dashboard/presentation/controllers/hero_controller.dart';
import 'package:orynta/features/dashboard/presentation/providers/hero_providers.dart';
import 'package:orynta/features/dashboard/presentation/widgets/hero/hero_section.dart';

class FakeUserProfileRepository implements UserProfileRepository {
  @override
  Future<String> getUserDisplayName() async => 'Tester';
}

class FakeHeroController extends HeroController {
  FakeHeroController(HeroState initialState)
      : super(
          greetingService: const GreetingService(),
          dateService: const DateService(),
          motivationalMessageService: const MotivationalMessageService(),
          productivityScoreCalculator: const ProductivityScoreCalculator(),
          userProfileRepository: FakeUserProfileRepository(),
        ) {
    state = initialState;
  }

  @override
  Future<void> loadHeroData() async {}
}

void main() {
  late Directory tempDir;
  late Box<String> box;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('orynta_hero_widget_test');
    Hive.init(tempDir.path);
    box = await Hive.openBox<String>(AppStrings.settingsBoxName);
    await box.put(AppStrings.userDisplayNameSetting, 'Tester');
  });

  tearDown(() async {
    await box.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('HeroSection Widget Tests', () {
    testWidgets('Renders greeting, formatted date, motivational quote, and live score',
        (tester) async {
      const heroState = HeroState(
        isLoading: false,
        greeting: 'Good morning',
        displayName: 'Tester',
        formattedDate: 'Tuesday, July 7',
        motivationMessage: MotivationMessage(
          id: 'test',
          message: 'Keep crushing it!',
          author: 'Self',
        ),
        productivityScore: ProductivityScore(
          value: 75,
          hasData: true,
          label: '75',
          subtitle: 'Doing great!',
        ),
        backgroundStyle: HeroBackgroundStyle.subtleGlow,
      );

      final now = DateTime.now();
      final todayMidnight = DateTime(now.year, now.month, now.day);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            heroControllerProvider.overrideWith((ref) => FakeHeroController(heroState)),
            productivityScoreProvider.overrideWithValue(75.0),
            todayStatsProvider.overrideWithValue(DailyStats(
              date: todayMidnight,
              tasksCompleted: 3,
              tasksPending: 1,
              habitsCompleted: 1,
              habitsTotal: 2,
              focusMinutes: 20,
              notesCreated: 1,
              notesEdited: 0,
              productivityScore: 75.0,
            ),),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: HeroSection(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Greeting and Name
      expect(find.textContaining('Good morning'), findsOneWidget);
      expect(find.textContaining('Tester'), findsOneWidget);

      // Verify Date
      expect(find.text('Tuesday, July 7'), findsOneWidget);

      // Verify Motivational Quote
      expect(find.text('Keep crushing it!'), findsOneWidget);

      // Verify Productivity Score
      expect(find.text('75'), findsOneWidget);
    });
  });
}
