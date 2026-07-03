// lib/features/onboarding/presentation/providers/onboarding_providers.dart
//
// Orynta 2.0 — Onboarding Riverpod Providers

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/constants/app_strings.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import '../../domain/repositories/onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final box = Hive.box<String>(AppStrings.settingsBoxName);
  return OnboardingRepositoryImpl(box);
});
