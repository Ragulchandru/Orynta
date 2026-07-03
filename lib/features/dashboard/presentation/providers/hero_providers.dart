// lib/features/dashboard/presentation/providers/hero_providers.dart
//
// Orynta 2.0 — Hero Riverpod Providers

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/constants/app_strings.dart';
import '../../data/repositories/user_profile_repository_impl.dart';
import '../../domain/models/hero_state.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../domain/services/date_service.dart';
import '../../domain/services/greeting_service.dart';
import '../../domain/services/motivational_message_service.dart';
import '../../domain/services/productivity_score_calculator.dart';
import '../controllers/hero_animation_coordinator.dart';
import '../controllers/hero_controller.dart';
import '../controllers/hero_height_resolver.dart';

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  final box = Hive.box<String>(AppStrings.settingsBoxName);
  return UserProfileRepositoryImpl(box);
});

final greetingServiceProvider = Provider<GreetingService>((ref) {
  return const GreetingService();
});

final dateServiceProvider = Provider<DateService>((ref) {
  return const DateService();
});

final motivationalMessageServiceProvider =
    Provider<MotivationalMessageService>((ref) {
  return const MotivationalMessageService();
});

final productivityScoreCalculatorProvider =
    Provider<ProductivityScoreCalculator>((ref) {
  return const ProductivityScoreCalculator();
});

final heroAnimationCoordinatorProvider =
    Provider<HeroAnimationCoordinator>((ref) {
  return const HeroAnimationCoordinator();
});

final heroHeightResolverProvider = Provider<HeroHeightResolver>((ref) {
  return const HeroHeightResolver();
});

final heroControllerProvider =
    StateNotifierProvider.autoDispose<HeroController, HeroState>((ref) {
  return HeroController(
    greetingService: ref.watch(greetingServiceProvider),
    dateService: ref.watch(dateServiceProvider),
    motivationalMessageService: ref.watch(motivationalMessageServiceProvider),
    productivityScoreCalculator: ref.watch(productivityScoreCalculatorProvider),
    userProfileRepository: ref.watch(userProfileRepositoryProvider),
  );
});
