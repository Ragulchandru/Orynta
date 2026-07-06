// lib/features/onboarding/presentation/widgets/onboarding_page_one_welcome.dart
//
// Orynta 2.0 — Onboarding Page 1 (Welcome)

import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/design_system/design_system.dart';

class OnboardingPageOneWelcome extends StatelessWidget {
  const OnboardingPageOneWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.spacing.paddingHorizontalLg,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // Official Orynta Branding Logo
          const OryntaLogo(size: 180),

          SizedBox(height: context.spacing.xxl),

          // Title
          Text(
            'Welcome to ${AppStrings.appName}',
            textAlign: TextAlign.center,
            style: context.typography.headlineMedium.copyWith(
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),

          SizedBox(height: context.spacing.sm),

          // Subtitle
          Text(
            'Your personal workspace for notes, planning and productivity.',
            textAlign: TextAlign.center,
            style: context.typography.bodyLarge.copyWith(
              color: context.colors.textSecondary,
              height: 1.5,
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
