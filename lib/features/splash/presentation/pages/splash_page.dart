// lib/features/splash/presentation/pages/splash_page.dart
//
// Orynta 2.0 — Premium Splash Screen Presentation (Revision 2 Redesign)
//
// Redesigned luxury visual hierarchy with tight, balanced grouping, 8.0 letter-spacing typography,
// 4% radial primary glow backdrop, and a smooth cinematic upward translation right before route transition.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../controllers/splash_controller.dart';
import '../widgets/animated_loading_indicator.dart';
import '../widgets/animated_logo.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _timelineController;

  // Staggered cinematic animation curves
  late final Animation<double> _backgroundFade;
  late final Animation<double> _glowFade;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _titleFade;
  late final Animation<double> _taglineFade;
  late final Animation<double> _loadingFade;
  late final Animation<double> _upwardShift;

  final GlobalKey<AnimatedLoadingIndicatorState> _loadingKey = GlobalKey();
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();

    _timelineController = AnimationController(
      vsync: this,
      duration: AppDurations.splashTotal,
    );

    // 0ms -> 250ms (0.00 -> 0.09)
    _backgroundFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _timelineController,
        curve: const Interval(0.00, 0.09, curve: Curves.easeIn),
      ),
    );

    // 150ms -> 500ms (0.05 -> 0.18)
    _glowFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _timelineController,
        curve: const Interval(0.05, 0.18, curve: Curves.easeOut),
      ),
    );

    // 250ms -> 700ms (0.09 -> 0.25)
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _timelineController,
        curve: const Interval(0.09, 0.25, curve: Curves.easeOut),
      ),
    );

    _logoScale = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _timelineController,
        curve: const Interval(0.09, 0.25, curve: Curves.easeOutCubic),
      ),
    );

    // 800ms -> 1200ms (0.28 -> 0.43)
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _timelineController,
        curve: const Interval(0.28, 0.43, curve: Curves.easeOut),
      ),
    );

    // 1200ms -> 1600ms (0.43 -> 0.57)
    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _timelineController,
        curve: const Interval(0.43, 0.57, curve: Curves.easeOut),
      ),
    );

    // 1500ms -> 1900ms (0.53 -> 0.68)
    _loadingFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _timelineController,
        curve: const Interval(0.53, 0.68, curve: Curves.easeOut),
      ),
    );

    // 2400ms -> 2800ms (0.85 -> 1.00) — Subtle -12dp cinematic upward shift
    _upwardShift = Tween<double>(begin: 0.0, end: -12.0).animate(
      CurvedAnimation(
        parent: _timelineController,
        curve: const Interval(0.85, 1.00, curve: Curves.easeInOutCubic),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSplashSequence();
    });
  }

  void _startSplashSequence() {
    final isReducedMotion = MediaQuery.of(context).disableAnimations;

    if (isReducedMotion) {
      _timelineController.value = 1.0;
    } else {
      _timelineController.forward();
    }

    ref.read(splashControllerProvider.notifier).startSplash(
          isReducedMotion: isReducedMotion,
          onReadyToNavigate: _onNavigationReady,
        );
  }

  void _onNavigationReady() {
    if (_isNavigating || !mounted) return;
    _isNavigating = true;

    // Halt dot tickers cleanly before page transition
    _loadingKey.currentState?.stop();

    final targetRoute =
        ref.read(splashControllerProvider).targetRoute ?? '/';

    context.go(targetRoute);
  }

  @override
  void dispose() {
    _timelineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watching controller state ensures active provider lifecycle
    final splashState = ref.watch(splashControllerProvider);
    final config = splashState.config;
    final isReducedMotion = MediaQuery.of(context).disableAnimations;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: FadeTransition(
        opacity: isReducedMotion
            ? const AlwaysStoppedAnimation(1.0)
            : _backgroundFade,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ── Soft 4% Radial Primary Glow Backdrop ────────────────────────
            Positioned.fill(
              child: FadeTransition(
                opacity: isReducedMotion
                    ? const AlwaysStoppedAnimation(1.0)
                    : _glowFade,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.55,
                      colors: [
                        context.colors.primary.withValues(alpha: 0.04),
                        context.colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Unified Centered Layout ────────────────────────────────────
            SafeArea(
              child: Center(
                child: AnimatedBuilder(
                  animation: _timelineController,
                  builder: (context, child) {
                    final offsetY = isReducedMotion ? 0.0 : _upwardShift.value;
                    return Transform.translate(
                      offset: Offset(0, offsetY),
                      child: child,
                    );
                  },
                  child: Padding(
                    padding: context.spacing.paddingScreen,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 1. Brand Mark / Logo
                        AnimatedLogo(
                          fadeAnimation: isReducedMotion
                              ? const AlwaysStoppedAnimation(1.0)
                              : _logoFade,
                          scaleAnimation: isReducedMotion
                              ? const AlwaysStoppedAnimation(1.0)
                              : _logoScale,
                          heroTag: config.heroTag,
                          logoAssetPath: config.logoAssetPath,
                          isReducedMotion: isReducedMotion,
                          size: 72.0,
                        ),

                        const SizedBox(height: 16.0),

                        // 2. Premium App Name ("ORYNTA")
                        FadeTransition(
                          opacity: isReducedMotion
                              ? const AlwaysStoppedAnimation(1.0)
                              : _titleFade,
                          child: Text(
                            AppStrings.appName.toUpperCase(),
                            style: context.typography.headlineLarge.copyWith(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 8.0,
                              color: context.colors.textPrimary,
                            ),
                          ),
                        ),

                        if (config.showTagline) ...[
                          const SizedBox(height: 8.0),

                          // 3. Tagline
                          FadeTransition(
                            opacity: isReducedMotion
                                ? const AlwaysStoppedAnimation(1.0)
                                : _taglineFade,
                            child: Text(
                              AppStrings.splashTagline,
                              textAlign: TextAlign.center,
                              style: context.typography.bodyMedium.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.8,
                                height: 1.5,
                                color: context.colors.textSecondary,
                              ),
                            ),
                          ),
                        ],

                        if (config.showLoadingIndicator) ...[
                          const SizedBox(height: 28.0),

                          // 4. Custom 3-Dot Loading Indicator (Visually connected)
                          FadeTransition(
                            opacity: isReducedMotion
                                ? const AlwaysStoppedAnimation(1.0)
                                : _loadingFade,
                            child: AnimatedLoadingIndicator(
                              key: _loadingKey,
                              isReducedMotion: isReducedMotion,
                            ),
                          ),
                        ],
                      ],
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
