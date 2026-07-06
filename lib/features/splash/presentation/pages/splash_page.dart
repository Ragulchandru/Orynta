// lib/features/splash/presentation/pages/splash_page.dart
//
// Orynta 2.0 — Premium Full-Screen Brand Reveal Splash

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../controllers/splash_controller.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _timelineController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;

  bool _isAnimationComplete = false;
  bool _isInitComplete = false;
  bool _hasNavigated = false;
  String? _targetRoute;

  @override
  void initState() {
    super.initState();

    _timelineController = AnimationController(
      vsync: this,
      duration: AppDurations.splashTotal, // 2700ms
    );

    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.85, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.22)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 1.0,
      ),
    ]).animate(_timelineController);

    _logoOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 1.0,
      ),
    ]).animate(_timelineController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSplashSequence();
    });
  }

  Future<void> _startSplashSequence() async {
    if (!mounted) return;

    // 1. Precache Logo asset
    await precacheImage(
      const AssetImage('assets/images/orynta_logo.png'),
      context,
    );

    if (!mounted) return;

    final isReducedMotion = MediaQuery.of(context).disableAnimations;

    // 2. Start initialization process concurrently
    ref.read(splashControllerProvider.notifier).startSplash(
          isReducedMotion: isReducedMotion,
          onReadyToNavigate: () {}, // Handled by our state machine check
        );

    // 3. Play animation or jump to end depending on accessibility reduced motion
    if (isReducedMotion) {
      _timelineController.value = 0.5; // Stay visible in Phase 2
      _isAnimationComplete = true;
      _tryNavigate();
    } else {
      await _timelineController.forward();
      _isAnimationComplete = true;
      _tryNavigate();
    }
  }

  void _tryNavigate() {
    if (_hasNavigated || !mounted) return;

    // Check if both conditions are met
    if (_isAnimationComplete && _isInitComplete) {
      _hasNavigated = true;
      context.go(_targetRoute ?? '/');
    }
  }

  @override
  void dispose() {
    _timelineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch splashState to update _isInitComplete and retrieve targetRoute
    final splashState = ref.watch(splashControllerProvider);
    final isReducedMotion = MediaQuery.of(context).disableAnimations;

    if (splashState.status == SplashStatus.initialized ||
        splashState.status == SplashStatus.navigating) {
      if (!_isInitComplete) {
        _isInitComplete = true;
        _targetRoute = splashState.targetRoute;
        // Schedule next check on next microtask so we don't call navigate during build phase
        Future.microtask(() => _tryNavigate());
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Center(
        child: AnimatedBuilder(
          animation: _timelineController,
          builder: (context, child) {
            final double opacityValue = isReducedMotion ? 1.0 : _logoOpacity.value;
            final double scaleValue = isReducedMotion ? 1.0 : _logoScale.value;

            return Opacity(
              opacity: opacityValue,
              child: Transform.scale(
                scale: scaleValue,
                child: child,
              ),
            );
          },
          child: Hero(
            tag: 'orynta_logo',
            child: LayoutBuilder(
              builder: (context, constraints) {
                final logoWidth = constraints.maxWidth * 0.82;
                return SizedBox(
                  width: logoWidth,
                  child: Image.asset(
                    'assets/images/orynta_logo.png',
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    isAntiAlias: true,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
