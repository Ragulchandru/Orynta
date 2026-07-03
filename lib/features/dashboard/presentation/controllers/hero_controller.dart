// lib/features/dashboard/presentation/controllers/hero_controller.dart
//
// Orynta 2.0 — Hero Controller

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/hero_background_style.dart';
import '../../domain/models/hero_state.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../domain/services/date_service.dart';
import '../../domain/services/greeting_service.dart';
import '../../domain/services/motivational_message_service.dart';
import '../../domain/services/productivity_score_calculator.dart';

class HeroController extends StateNotifier<HeroState> {
  HeroController({
    required GreetingService greetingService,
    required DateService dateService,
    required MotivationalMessageService motivationalMessageService,
    required ProductivityScoreCalculator productivityScoreCalculator,
    required UserProfileRepository userProfileRepository,
  })  : _greetingService = greetingService,
        _dateService = dateService,
        _motivationalMessageService = motivationalMessageService,
        _productivityScoreCalculator = productivityScoreCalculator,
        _userProfileRepository = userProfileRepository,
        super(const HeroState(isLoading: true)) {
    loadHeroData();
  }

  final GreetingService _greetingService;
  final DateService _dateService;
  final MotivationalMessageService _motivationalMessageService;
  final ProductivityScoreCalculator _productivityScoreCalculator;
  final UserProfileRepository _userProfileRepository;

  Future<void> loadHeroData() async {
    state = state.copyWith(isLoading: true);

    final greeting = _greetingService.getGreeting();
    final date = _dateService.getFormattedDate();
    final name = await _userProfileRepository.getUserDisplayName();
    final quote = _motivationalMessageService.getDailyQuote();
    final score = await _productivityScoreCalculator.calculateScore();

    state = state.copyWith(
      isLoading: false,
      greeting: greeting,
      displayName: name,
      formattedDate: date,
      motivationMessage: quote,
      productivityScore: score,
      backgroundStyle: HeroBackgroundStyle.subtleGlow,
    );
  }
}
