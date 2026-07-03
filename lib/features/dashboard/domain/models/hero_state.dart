// lib/features/dashboard/domain/models/hero_state.dart
//
// Orynta 2.0 — Dashboard Hero State

import 'package:flutter/foundation.dart';
import 'hero_background_style.dart';
import 'motivation_message.dart';
import 'productivity_score.dart';

@immutable
class HeroState {
  const HeroState({
    this.isLoading = false,
    this.greeting = 'Good Morning',
    this.displayName = 'Guest',
    this.formattedDate = '',
    this.motivationMessage = const MotivationMessage(
      id: 'default',
      message: 'Stay focused.',
    ),
    this.productivityScore = const ProductivityScore(),
    this.backgroundStyle = HeroBackgroundStyle.subtleGlow,
  });

  final bool isLoading;
  final String greeting;
  final String displayName;
  final String formattedDate;
  final MotivationMessage motivationMessage;
  final ProductivityScore productivityScore;
  final HeroBackgroundStyle backgroundStyle;

  HeroState copyWith({
    bool? isLoading,
    String? greeting,
    String? displayName,
    String? formattedDate,
    MotivationMessage? motivationMessage,
    ProductivityScore? productivityScore,
    HeroBackgroundStyle? backgroundStyle,
  }) {
    return HeroState(
      isLoading: isLoading ?? this.isLoading,
      greeting: greeting ?? this.greeting,
      displayName: displayName ?? this.displayName,
      formattedDate: formattedDate ?? this.formattedDate,
      motivationMessage: motivationMessage ?? this.motivationMessage,
      productivityScore: productivityScore ?? this.productivityScore,
      backgroundStyle: backgroundStyle ?? this.backgroundStyle,
    );
  }
}
