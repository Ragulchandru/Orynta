// lib/core/design_system/dimensions/app_dimensions.dart
//
// Orynta 2.0 — Component Dimensions
//
// ── Philosophy ───────────────────────────────────────────────────────────────
// Named component-size tokens prevent inconsistent widget heights across
// screens. Rather than writing `height: 56` everywhere, use
// `AppDimensions.toolbarHeight` for clarity and global change control.
//
// All values follow Material 3 guidelines or are derived from the app's
// design language.
//
// ── Usage ────────────────────────────────────────────────────────────────────
//   SizedBox(height: AppDimensions.toolbarHeight)
//   Container(width: AppDimensions.navigationRailWidth)
//   CircleAvatar(radius: AppDimensions.avatarMd / 2)

/// Reusable component-size tokens for Orynta 2.0.
abstract final class AppDimensions {
  // ─── Navigation ───────────────────────────────────────────────────────────

  /// AppBar / Toolbar height — M3 spec: 64dp
  static const double toolbarHeight = 64.0;

  /// Bottom navigation bar height — M3 spec: 80dp
  static const double bottomNavHeight = 64.0;

  /// Navigation rail width (compact) — M3 spec: 80dp
  static const double navigationRailWidth = 80.0;

  /// Navigation rail width (extended) — M3 spec: 256dp
  static const double navigationRailWidthExtended = 256.0;

  /// Navigation drawer width — M3 spec: 360dp
  static const double navigationDrawerWidth = 360.0;

  // ─── FAB ──────────────────────────────────────────────────────────────────

  /// Standard FAB diameter — M3 spec: 56dp
  static const double fabSize = 56.0;

  /// Small FAB diameter — M3 spec: 40dp
  static const double fabSizeSmall = 40.0;

  /// Large FAB diameter — M3 spec: 96dp
  static const double fabSizeLarge = 96.0;

  // ─── Buttons ──────────────────────────────────────────────────────────────

  /// Standard button height (filled, outlined, text) — M3 spec: 40dp min
  static const double buttonHeight = 48.0;

  /// Large button height (prominent CTAs)
  static const double buttonHeightLg = 56.0;

  /// Small button height (compact actions)
  static const double buttonHeightSm = 36.0;

  /// Icon button size (tap target) — M3 spec: 48dp min
  static const double iconButtonSize = 48.0;

  // ─── Inputs ───────────────────────────────────────────────────────────────

  /// Text field height (single-line)
  static const double textFieldHeight = 52.0;

  /// Search bar height — M3 spec: 56dp
  static const double searchBarHeight = 52.0;

  // ─── Cards ────────────────────────────────────────────────────────────────

  /// Minimum card height (e.g., quick-note list item)
  static const double cardMinHeight = 72.0;

  /// Standard compact card height
  static const double cardHeightSm = 96.0;

  /// Standard card height
  static const double cardHeightMd = 120.0;

  /// Large card height (dashboard feature cards)
  static const double cardHeightLg = 160.0;

  // ─── Chips ────────────────────────────────────────────────────────────────

  /// Chip height — M3 spec: 32dp
  static const double chipHeight = 32.0;

  /// Chip height (input chip variant)
  static const double chipHeightInput = 32.0;

  // ─── Dialogs ──────────────────────────────────────────────────────────────

  /// Default dialog max width on phones
  static const double dialogMaxWidth = 400.0;

  /// Bottom sheet drag handle width
  static const double bottomSheetHandleWidth = 32.0;

  /// Bottom sheet drag handle height
  static const double bottomSheetHandleHeight = 4.0;

  // ─── Icons ────────────────────────────────────────────────────────────────

  /// 16dp — inline icon (next to text)
  static const double iconSm = 16.0;

  /// 20dp — compact action icon
  static const double iconMdSm = 20.0;

  /// 24dp — standard icon (AppBar, list, nav bar)
  static const double iconMd = 24.0;

  /// 32dp — prominent icon (section header)
  static const double iconLg = 32.0;

  /// 48dp — large icon (empty state, illustration)
  static const double iconXl = 48.0;

  /// 80dp — hero icon (splash, onboarding)
  static const double iconHero = 80.0;

  // ─── Avatars ──────────────────────────────────────────────────────────────

  /// 24dp — mini avatar (inline with text)
  static const double avatarXs = 24.0;

  /// 32dp — small avatar (list item, chip)
  static const double avatarSm = 32.0;

  /// 40dp — medium avatar (standard list item)
  static const double avatarMd = 40.0;

  /// 56dp — large avatar (profile section)
  static const double avatarLg = 56.0;

  /// 80dp — extra-large avatar (profile screen)
  static const double avatarXl = 80.0;

  // ─── Dividers ─────────────────────────────────────────────────────────────

  /// Standard divider thickness
  static const double dividerThickness = 1.0;

  /// Heavy divider thickness (section separators)
  static const double dividerThicknessHeavy = 2.0;

  // ─── Progress Indicators ──────────────────────────────────────────────────

  /// Linear progress indicator height
  static const double progressBarHeight = 4.0;

  /// Circular progress size (compact)
  static const double progressCircularSm = 20.0;

  /// Circular progress size (standard)
  static const double progressCircularMd = 36.0;

  // ─── Misc ─────────────────────────────────────────────────────────────────

  /// Status bar height placeholder (use MediaQuery in practice)
  static const double statusBarHeight = 24.0;

  /// Keyboard toolbar height
  static const double keyboardToolbarHeight = 48.0;

  /// Bottom safe-area padding fallback
  static const double safeAreaBottom = 24.0;
}
