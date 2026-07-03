// lib/features/dashboard/presentation/controllers/hero_height_resolver.dart
//
// Orynta 2.0 — Hero Height Resolver
//
// Calculates proportional viewport height (~35-45% of available screen height).

class HeroHeightResolver {
  const HeroHeightResolver();

  /// Resolves target minimum height based on screen height.
  double resolveMinHeight(double screenHeight) {
    if (screenHeight < 600) return 260.0;
    if (screenHeight > 1000) return 380.0;
    return screenHeight * 0.38;
  }
}
