// lib/core/design_system/durations/app_durations.dart
//
// Orynta 2.0 — Animation Duration Constants
//
// ── Philosophy ───────────────────────────────────────────────────────────────
// Duration constants make animations consistent and tunable.
// Fast interactions feel responsive; slow transitions feel fluid.
//
// Material 3 guidelines:
//   • < 200ms — micro-interactions (button press, state change)
//   • 200–400ms — simple transitions (fade, scale)
//   • 400–600ms — complex transitions (page, shared element)
//   • > 600ms — reserved for emphasis (rare, never routine)
//
// ── Usage ────────────────────────────────────────────────────────────────────
//   AnimatedContainer(
//     duration: AppDurations.normal,
//     curve: AppCurves.easeOut,
//   )
//
//   PageRouteBuilder(transitionDuration: AppDurations.pageTransition)

/// Animation duration tokens for Orynta 2.0.
///
/// Pair with [AppCurves] for complete animation definitions.
abstract final class AppDurations {
  // ─── Core Scale ───────────────────────────────────────────────────────────

  /// 80ms — instant feedback (ripple, hover state)
  static const Duration instant = Duration(milliseconds: 80);

  /// 150ms — fast micro-interaction (button press, toggle)
  static const Duration fast = Duration(milliseconds: 150);

  /// 250ms — standard short transition (color change, icon swap)
  static const Duration short = Duration(milliseconds: 250);

  /// 300ms — normal transition (widget appear/disappear)
  static const Duration normal = Duration(milliseconds: 300);

  /// 400ms — medium transition (card expand, list insert)
  static const Duration medium = Duration(milliseconds: 400);

  /// 500ms — slow transition (bottom sheet, dialog enter)
  static const Duration slow = Duration(milliseconds: 500);

  /// 700ms — extra slow (emphasis, hero animation)
  static const Duration xSlow = Duration(milliseconds: 700);

  // ─── Component-Specific ───────────────────────────────────────────────────

  /// Page navigation transition
  static const Duration pageTransition = Duration(milliseconds: 350);

  /// Page exit transition (faster than enter for snappier feel)
  static const Duration pageTransitionExit = Duration(milliseconds: 250);

  /// Button press animation (ripple + scale)
  static const Duration buttonAnimation = Duration(milliseconds: 150);

  /// Card hover / press animation
  static const Duration cardAnimation = Duration(milliseconds: 200);

  /// FAB appear / hide animation (scale + fade)
  static const Duration fabAnimation = Duration(milliseconds: 250);

  /// Dialog enter animation (scale + fade)
  static const Duration dialogEnter = Duration(milliseconds: 300);

  /// Dialog exit animation
  static const Duration dialogExit = Duration(milliseconds: 200);

  /// Bottom sheet slide-up duration
  static const Duration bottomSheetEnter = Duration(milliseconds: 350);

  /// Bottom sheet slide-down duration
  static const Duration bottomSheetExit = Duration(milliseconds: 250);

  /// List item stagger delay (between each item's animation)
  static const Duration listStaggerDelay = Duration(milliseconds: 50);

  /// Skeleton shimmer animation cycle
  static const Duration shimmerCycle = Duration(milliseconds: 1200);

  /// Snack bar enter animation
  static const Duration snackBarEnter = Duration(milliseconds: 300);

  /// Focus timer count animation
  static const Duration timerTick = Duration(milliseconds: 1000);

  /// Statistics counter animation
  static const Duration statsCountUp = Duration(milliseconds: 800);

  /// Tab switch animation
  static const Duration tabSwitch = Duration(milliseconds: 250);

  /// Tooltip show delay
  static const Duration tooltipDelay = Duration(milliseconds: 500);

  // ─── Splash Screen Timeline Tokens ────────────────────────────────────────

  /// Total splash duration before navigation (2800ms)
  static const Duration splashTotal = Duration(milliseconds: 2800);

  /// Splash background fade duration (0ms -> 250ms)
  static const Duration splashBackgroundFade = Duration(milliseconds: 250);

  /// Splash radial glow fade start delay (150ms)
  static const Duration splashGlowFadeDelay = Duration(milliseconds: 150);

  /// Splash logo fade start delay (250ms)
  static const Duration splashLogoFadeDelay = Duration(milliseconds: 250);

  /// Splash logo scale start delay (700ms)
  static const Duration splashLogoScaleDelay = Duration(milliseconds: 700);

  /// Splash app title fade start delay (800ms)
  static const Duration splashTitleFadeDelay = Duration(milliseconds: 800);

  /// Splash tagline fade start delay (1200ms)
  static const Duration splashTaglineFadeDelay = Duration(milliseconds: 1200);

  /// Splash loading indicator fade start delay (1500ms)
  static const Duration splashLoadingFadeDelay = Duration(milliseconds: 1500);

  /// Splash content upward shift start delay (2400ms)
  static const Duration splashUpwardShiftDelay = Duration(milliseconds: 2400);

  /// Splash loading indicator loop cycle duration (1600ms - slow & smooth)
  static const Duration splashLoadingLoop = Duration(milliseconds: 1600);

  /// Total splash duration when Reduced Motion is enabled (1500ms)
  static const Duration splashReducedMotionTotal = Duration(milliseconds: 1500);
}
