// lib/features/onboarding/presentation/pages/onboarding_page.dart
//
// Orynta 2.0 — Premium Onboarding Root Screen
//
// Features PopScope back-button navigation, PageView, Smart Skip confirmation dialog,
// M3 animated pill page indicator, scale-on-press primary buttons, and 800ms blurred preparation overlay.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_tokens.dart';
import '../../domain/models/onboarding_page_definition.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_page_four_ready.dart';
import '../widgets/onboarding_page_indicator.dart';
import '../widgets/onboarding_page_one_welcome.dart';
import '../widgets/onboarding_page_three_personalization.dart';
import '../widgets/onboarding_page_two_experience.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late final PageController _pageController;

  static final List<OnboardingPageDefinition> _pageDefinitions = [
    OnboardingPageDefinition(
      id: 'welcome',
      stepNumber: 1,
      title: 'Welcome',
      widgetBuilder: (_) => const OnboardingPageOneWelcome(),
    ),
    OnboardingPageDefinition(
      id: 'preferences',
      stepNumber: 2,
      title: 'Workspace Preferences',
      widgetBuilder: (_) => const OnboardingPageTwoExperience(),
    ),
    OnboardingPageDefinition(
      id: 'personalization',
      stepNumber: 3,
      title: 'Personalization',
      widgetBuilder: (_) => const OnboardingPageThreePersonalization(),
    ),
    OnboardingPageDefinition(
      id: 'ready',
      stepNumber: 4,
      title: 'Ready',
      allowSkip: false,
      widgetBuilder: (_) => const OnboardingPageFourReady(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    ref.read(onboardingControllerProvider.notifier).setPage(index);
  }

  void _nextPage() {
    final state = ref.read(onboardingControllerProvider);
    if (state.currentPage < _pageDefinitions.length - 1) {
      _pageController.nextPage(
        duration: AppDurations.normal,
        curve: AppCurves.easeOutCubic,
      );
    } else {
      _completeAndNavigate();
    }
  }

  Future<void> _completeAndNavigate() async {
    final state = ref.read(onboardingControllerProvider);
    await ref.read(onboardingControllerProvider.notifier).completeOnboarding(() {
      if (mounted) {
        context.go(state.defaultHomeScreen);
      }
    });
  }

  Future<void> _handleSkip() async {
    final state = ref.read(onboardingControllerProvider);
    final notifier = ref.read(onboardingControllerProvider.notifier);

    if (state.isDirty && state.config.enableSkipConfirmation) {
      final shouldSkip = await _showSkipConfirmationDialog();
      if (shouldSkip != true) return;
    }

    await notifier.smartSkip(() {
      if (mounted) {
        context.go('/');
      }
    });
  }

  Future<bool?> _showSkipConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: context.radius.borderRadiusLg,
          ),
          backgroundColor: context.colors.card,
          title: Text(
            'Discard setup?',
            style: context.typography.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
          content: Text(
            'Your custom selections will be replaced with standard workspace defaults.',
            style: context.typography.bodyMedium.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Continue Setup',
                style: TextStyle(color: context.colors.primary),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Skip Anyway',
                style: TextStyle(color: context.colors.textSecondary),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);
    final isLastPage = state.currentPage == _pageDefinitions.length - 1;
    final currentDef = _pageDefinitions[state.currentPage];

    return PopScope(
      canPop: state.currentPage == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && state.currentPage > 0) {
          _pageController.previousPage(
            duration: AppDurations.normal,
            curve: AppCurves.easeOutCubic,
          );
        }
      },
      child: Scaffold(
        backgroundColor: context.colors.background,
        body: Stack(
          children: [
            // ── Background Glow ───────────────────────────────────────────────
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 0.85,
                    colors: [
                      context.colors.primary.withValues(alpha: 0.04),
                      context.colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // ── Core Layout ───────────────────────────────────────────────────
            SafeArea(
              child: Column(
                children: [
                  // 1. Header (Skip Button)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 56,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (currentDef.allowSkip)
                            TextButton(
                              onPressed: state.isPreparing ? null : _handleSkip,
                              child: Text(
                                'Skip',
                                style: context.typography.labelLarge.copyWith(
                                  color: context.colors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // 2. PageView
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _pageDefinitions.length,
                      onPageChanged: _onPageChanged,
                      itemBuilder: (context, index) {
                        return _pageDefinitions[index].widgetBuilder(context);
                      },
                    ),
                  ),

                  // 3. Footer (Indicator + Primary Action Button)
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.spacing.lg,
                      context.spacing.sm,
                      context.spacing.lg,
                      context.spacing.lg,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Page Indicator
                        OnboardingPageIndicator(
                          currentPage: state.currentPage,
                          totalPages: _pageDefinitions.length,
                        ),

                        SizedBox(height: context.spacing.lg),

                        // Primary Button
                        SizedBox(
                          width: double.infinity,
                          height: context.dimensions.buttonHeight,
                          child: _ScalePressButton(
                            onPressed: state.isPreparing ? null : _nextPage,
                            label: isLastPage ? 'Start Organizing' : 'Continue',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── 800ms Blurred Workspace Preparation Overlay ─────────────────
            if (state.isPreparing)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: context.colors.background.withValues(alpha: 0.8),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                        decoration: BoxDecoration(
                          color: context.colors.card,
                          borderRadius: context.radius.borderRadiusXl,
                          border: Border.all(color: context.colors.outlineVariant),
                          boxShadow: context.shadows.medium,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: context.colors.primary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Preparing your workspace...',
                              style: context.typography.titleMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: context.colors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Applying your preferences',
                              style: context.typography.bodySmall.copyWith(
                                color: context.colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ScalePressButton extends StatefulWidget {
  const _ScalePressButton({
    required this.onPressed,
    required this.label,
  });

  final VoidCallback? onPressed;
  final String label;

  @override
  State<_ScalePressButton> createState() => _ScalePressButtonState();
}

class _ScalePressButtonState extends State<_ScalePressButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: AppDurations.fast,
        child: FilledButton(
          onPressed: widget.onPressed,
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: context.radius.borderRadiusFull,
            ),
          ),
          child: Text(
            widget.label,
            style: context.typography.labelLarge.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
