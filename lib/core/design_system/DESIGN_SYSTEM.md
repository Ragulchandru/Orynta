# Orynta 2.0 — Design System Specifications & Guide

Welcome to the **Orynta 2.0 Design System**. This document defines the visual identity, token architecture, and coding standards for all UI components in the Orynta application. 

This design system acts as the single source of truth for both developers and designers, ensuring consistency, premium aesthetics, accessibility, and high performance across all features.

---

## 📖 Table of Contents
1. [Design Philosophy](#1-design-philosophy)
2. [Color Philosophy & Palette](#2-color-philosophy--palette)
3. [Typography Rules](#3-typography-rules)
4. [Spacing & Layout System](#4-spacing--layout-system)
5. [Dimensions & Sizing](#5-dimensions--sizing)
6. [Radius & Shapes](#6-radius--shapes)
7. [Elevation & Shadows](#7-elevation--shadows)
8. [Gradient System](#8-gradient-system)
9. [Glass Effects](#9-glass-effects)
10. [Animation & Motion Guidelines](#10-animation--motion-guidelines)
11. [Component & Widget Rules](#11-component--widget-rules)
12. [Accessibility Rules](#12-accessibility-rules)
13. [Theme Extensions & Context Getters](#13-theme-extensions--context-getters)
14. [Folder Structure & Architecture](#14-folder-structure--architecture)
15. [How to Create Future Widgets](#15-how-to-create-future-widgets)
16. [Best Practices & Examples](#16-best-practices--examples)

---

## 1. Design Philosophy

Orynta is a professional, high-performance productivity application. The design philosophy is built on three pillars:

* **Premium Minimalist Style**: Visuals are clean and elegant. Content always takes center stage. We avoid decorative noise, excessive borders, or intense colors.
* **Productivity First**: Layouts emphasize clarity, logical hierarchy, speed of reading, and effortless navigation.
* **Tactile Fluidity**: All interactive states respond with immediate, micro-scale animations and subtle depth transitions that feel solid and professional.

### What We Avoid
* ❌ Childish or oversaturated primary colors.
* ❌ Overdesigned custom shapes or gaming-style UI elements.
* ❌ Flashy, highly saturated gradients that reduce readability.
* ❌ Hardcoded values for spacing, sizes, colors, and animations.

---

## 2. Color Philosophy & Palette

Orynta uses a **semantic color system**. Developers should never hardcode hex colors or directly reference raw palette tones in presentation widgets. Instead, always refer to the semantic token appropriate for the context (e.g. `context.colors.primary`, `context.colors.surfaceContainerLow`).

### Tonal Surface Modes
Orynta supports three distinct surface styles:
1. **Light Theme**: Soft warm-white background, providing high contrast and comfortable long-form reading.
2. **Dark Theme**: Deep slate-charcoal surfaces that prevent eye strain in low-light environments.
3. **AMOLED Theme**: Pitch-black background (`#000000`) designed specifically for OLED/AMOLED screens to save battery and provide infinite contrast.

### Color Tokens

| Semantic Token | Light Mode Value | Dark Mode Value | AMOLED Mode Value | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| `primary` | `#4F46E5` | `#818CF8` | `#818CF8` | Primary accent color, active checkboxes, highlights |
| `secondary` | `#6366F1` | `#818CF8` | `#818CF8` | Secondary action highlights and secondary buttons |
| `background` | `#F8F8FA` | `#0F0F17` | `#000000` | Entire screen background behind scroll containers |
| `surface` | `#FFFFFF` | `#141420` | `#000000` | Floating appbars, tab bars, dropdown background |
| `surfaceContainer` | `#F1F1F5` | `#1E1E2E` | `#0D0D18` | Standard card container fill, inputs |
| `surfaceContainerLow` | `#F8F8FA` | `#18182A` | `#050510` | Subtle background container fill |
| `surfaceContainerHigh`| `#E8E8EF` | `#252538` | `#141424` | Elevated dialogs, popup menus |
| `card` | `#FFFFFF` | `#1E1E2E` | `#0D0D18` | Main card background |
| `cardBorder` | `#E8E8EF` | `#2A2A40` | `#1A1A2E` | Subtle card outline border |
| `outline` | `#DFDFE8` | `#38384E` | `#252535` | Standard field border, outlines |
| `divider` | `#EEEEF5` | `#252535` | `#111122` | Hairline list/menu dividers |
| `textPrimary` | `#11111C` | `#EFEFF8` | `#EFEFF8` | Main headings, title labels, primary text |
| `textSecondary` | `#4E4E68` | `#C5C5D3` | `#C5C5D3` | Subtitles, description body text, inactive states |
| `textHint` | `#9A9AB0` | `#6E6E8A` | `#6E6E8A` | Field placeholder guides, hints |
| `success` | `#16A34A` | `#4ADE80` | `#4ADE80` | Checklists completed, success snackbars |
| `warning` | `#D97706` | `#FBBF24` | `#FBBF24` | Warning alerts, focus modes, critical alerts |
| `error` | `#DC2626` | `#F87171` | `#F87171` | Delete permanent actions, error states |
| `info` | `#2563EB` | `#60A5FA` | `#60A5FA` | System guide notes, info indicators |

---

## 3. Typography Rules

### Font Selection
Orynta 2.0 uses **Inter** as its sole typeface. Playfair Display and other serif fonts have been removed. Monospace text (e.g. for future code snippets) uses **JetBrains Mono**.

### Typography Type Scale
All text styles are compatible with the Material 3 scale and define explicit weights, line heights, and letter spacing.

| Token | Size | Weight | Tracking (Letter Spacing) | Leading (Line Height) | Use Case |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `displayLarge` | 57sp | W300 | `-0.25` | 1.12 | Large hero screens |
| `displayMedium` | 45sp | W300 | `0.0` | 1.16 | Large statistics, countdowns |
| `displaySmall` | 36sp | W400 | `0.0` | 1.22 | Welcome headings |
| `headlineLarge` | 32sp | W600 | `-0.5` | 1.25 | Primary dashboard, main titles |
| `headlineMedium`| 28sp | W600 | `-0.25` | 1.29 | Section titles, sub-headers |
| `headlineSmall` | 24sp | W600 | `0.0` | 1.33 | Page settings headers |
| `titleLarge` | 22sp | W600 | `0.0` | 1.27 | Appbar titles, Dialog header |
| `titleMedium` | 16sp | W500 | `0.1` | 1.50 | Card titles, action triggers |
| `titleSmall` | 14sp | W500 | `0.1` | 1.43 | Small card labels, lists |
| `bodyLarge` | 16sp | W400 | `0.15` | 1.55 | Long text, default note contents |
| `bodyMedium` | 14sp | W400 | `0.25` | 1.50 | Default lists, standard text |
| `bodySmall` | 12sp | W400 | `0.4` | 1.45 | Metadata, caption descriptors |
| `labelLarge` | 14sp | W600 | `0.1` | 1.43 | Buttons, action text |
| `labelMedium` | 12sp | W500 | `0.5` | 1.33 | Chips, tags, navigation indicators |
| `labelSmall` | 11sp | W500 | `0.5` | 1.45 | Small timestamps, bottom nav |

---

## 4. Spacing & Layout System

Spacing is based strictly on a **4px base grid** to guarantee perfect visual rhythm across all screens.

### Raw Scale Tokens
* `xxs` = 2.0 (Mini spacing, inline badge offset)
* `xs` = 4.0 (Micro spacing, label-to-icon gap)
* `sm` = 8.0 (Small spacing, inner items row gap)
* `mdSm` = 12.0 (Medium-small, chip height spacing)
* `md` = 16.0 (Standard spacing, main padding)
* `mdLg` = 20.0 (Medium-large, card interior offset)
* `lg` = 24.0 (Large spacing, section headers)
* `xl` = 32.0 (Extra large, banner spacing)
* `xxl` = 40.0 (Onboarding layout padding)
* `xxxl` = 48.0 (Empty state vertical offset)
* `hero` = 64.0 (Splash screen top spacing)

### Layout Helpers
Always use predefined `EdgeInsets` and `SizedBox` constants from `AppSpacing` to prevent layout bugs.
* `AppSpacing.paddingScreen` -> `EdgeInsets.symmetric(horizontal: 16, vertical: 16)`
* `AppSpacing.paddingCard` -> `EdgeInsets.all(16)`
* `AppSpacing.gapSm` -> `SizedBox(height: 8, width: 8)`
* `AppSpacing.gapMd` -> `SizedBox(height: 16, width: 16)`
* `AppSpacing.vGapMd` -> `SizedBox(height: 16)` (Vertical only)
* `AppSpacing.hGapSm` -> `SizedBox(width: 8)` (Horizontal only)

---

## 5. Dimensions & Sizing

Standard dimensions prevent UI inconsistencies.

| Dimension Constant | Size (dp) | Purpose |
| :--- | :--- | :--- |
| `toolbarHeight` | 64.0 | AppBar height |
| `bottomNavHeight` | 64.0 | Bottom navigation bar height |
| `navigationRailWidth` | 80.0 | Nav Rail collapsed state |
| `navigationRailWidthExtended` | 256.0 | Nav Rail expanded state |
| `fabSize` | 56.0 | Standard Floating Action Button |
| `buttonHeight` | 48.0 | Standard filled/outlined buttons |
| `searchBarHeight` | 52.0 | Text search input default height |
| `iconSm` | 16.0 | Inline text icons |
| `iconMd` | 24.0 | Default action/navigation icons |
| `iconLg` | 32.0 | Section indicators |
| `avatarSm` | 32.0 | Small profiles in headers |
| `avatarMd` | 40.0 | Standard list avatars |

---

## 6. Radius & Shapes

### Radius Scale
* `AppRadius.xs` = 4.0 (Small badge overlays)
* `AppRadius.sm` = 8.0 (Chips, tags, small inputs)
* `AppRadius.md` = 12.0 (Cards, text fields, lists)
* `AppRadius.lg` = 16.0 (Dialog borders, main cards)
* `AppRadius.xl` = 20.0 (Bottom sheets, modals)
* `AppRadius.xxl` = 28.0 (Hero card highlights)
* `AppRadius.full` = 999.0 (Circular pills, avatars, FAB)

### Shape Borders
All widget shapes must be set using pre-built `ShapeBorder` objects in `AppShapes` to avoid manual border instantiation:
* `AppShapes.card` -> `RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMd)` (12dp)
* `AppShapes.dialog` -> `RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusLg)` (16dp)
* `AppShapes.button` -> `RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMd)` (12dp)
* `AppShapes.chip` -> `RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusSm)` (8dp)
* `AppShapes.fab` -> `RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusLg)` (16dp)
* `AppShapes.bottomSheet` -> `RoundedRectangleBorder(borderRadius: AppRadius.bottomSheetRadius)` (20dp top corners)

---

## 7. Elevation & Shadows

Orynta uses **M3 Tonal Elevation** combined with soft, multi-layered shadows to convey depth.

### Elevation Levels
* `Level 0` = 0.0 dp (Flat surfaces, default cards)
* `Level 1` = 1.0 dp (Floating cards, appbars)
* `Level 2` = 3.0 dp (Menus, popup alerts)
* `Level 3` = 6.0 dp (Floating bars, snackbars)
* `Level 5` = 12.0 dp (Modal dialog drawers)

### Shadow System
* **Light Theme Shadows**: Use multiple thin layers with very low black opacity (e.g. 0.08 and 0.05) to simulate realistic ambient light.
* **Dark Theme Shadows**: Extremely soft. Ambient light is darker, so shadows are faint (e.g. single layer with 0.25 opacity) or replaced with card border outlines (`cardBorder`).
* **AMOLED Glow**: Shadows are replaced by thin outline borders (`cardBorder`) and subtle tinted glow effects (`primaryGlow(primaryColor)`).

---

## 8. Gradient System

Gradients must remain exceptionally subtle. Avoid colorful gradients.
* `AppGradients.primary`: Indigo shades used strictly in featured buttons, highlights, or headers.
* `AppGradients.surface`: Top-to-bottom shift from solid surface to slightly tinted background.
* `AppGradients.glass`: Soft shimmer overlay gradients.
* `AppGradients.shimmer`: Skeleton loader animation gradients.

---

## 9. Glass Effects

Frosted-glass UI creates visual layering when scrolling.
* **Blur Sigmas**: Standard is `AppGlass.blurMd` (16.0). Floating elements use `AppGlass.blurSm` (8.0).
* **Glass Fill Colors**: Translucent fills. Light uses `fillLight` (white at 80% opacity), Dark uses `fillDark` (dark slate-charcoal at 60%), and AMOLED uses `fillAmoled` (near-black at 70%).

---

## 10. Animation & Motion Guidelines

Animations must be fast, direct, and serve a clear visual purpose.

### Standard Duration Scale
* `fast` = 150ms (Button presses, ripple triggers, fast taps)
* `short` = 250ms (Switch toggles, checkbox fill state)
* `normal` = 300ms (Modal transitions, slide menus)
* `slow` = 500ms (Dialog enters, bottom sheets opening)
* `pageTransition` = 350ms (Screen transitions)

### Custom Curve Scales
* `AppCurves.emphasized`: Natural spring-like acceleration for card expansion.
* `AppCurves.emphasizedDecelerate`: Smooth settle-down for entering elements.
* `AppCurves.emphasizedAccelerate`: Fast acceleration for exiting elements.

### Typical Widget Animations
* **Cards**: Slide up slightly (offset +12 -> 0) and fade in over 400ms (`AppDurations.medium`) with `AppCurves.easeOutQuart` curve.
* **Dialogs**: Scale up (0.8 -> 1.0) and fade in over 300ms.
* **Bottom Sheets**: Slide up from bottom over 350ms with `AppCurves.emphasizedDecelerate`.

---

## 11. Component & Widget Rules

All standard Flutter components are fully stylized in `AppTheme`:

* **AppBars**: Center title is disabled. Surface uses flat elevation at rest, shifting to subtle background tints under scroll conditions. Icons use `c.textPrimary`.
* **Cards**: Default card is flat with a subtle 1px border. Floating cards are reserved for draggable items.
* **Buttons**: Filled and outlined buttons use `AppShapes.button` (12dp corners) and a height of `buttonHeight` (48dp). Button label style is `labelLarge`.
* **Input Decoration**: Input fields use filled containers. Border states shift between outline variants, highlighting in `primary` on focus. Help and guide labels are locked to `textSecondary`.
* **SnackBar**: Floating style, rounded 12dp card offset from bottom of screen. Dark background locks text readability.

---

## 12. Accessibility Rules

* **Text Contrast**: Primary headers must maintain at least a 4.5:1 contrast ratio against the background. Secondary guide text must maintain a 3.0:1 ratio.
* **Tappable Area**: Standard buttons and click targets must be at least 48x48dp to ensure easy tapping.
* **System Animations**: Respect user settings. Always check if system animations are disabled via `MediaQuery.disableAnimations` and skip transition timelines accordingly.

---

## 13. Theme Extensions & Context Getters

Theme data can be fetched concisely using `BuildContext` extension methods:

```dart
// Fetch colors
Color accent = context.colors.primary;
Color background = context.colors.background;

// Fetch typography styles
TextStyle title = context.typography.titleLarge;
TextStyle body = context.typography.bodyMedium;

// Fetch spacing margins
EdgeInsets screenPadding = context.spacing.paddingScreen;
SizedBox verticalSpacer = context.spacing.gapMd;

// Fetch radius and dimensions
BorderRadius cardRadius = context.radius.borderRadiusMd;
double bottomNavHeight = context.dimensions.bottomNavHeight;
```

---

## 14. Folder Structure & Architecture

All files are structured inside `lib/core/design_system/`:

```
lib/core/design_system/
├── colors/
│   └── app_colors.dart        # Semantic palettes & note variables
├── typography/
│   └── app_typography.dart    # Inter-only text scales
├── spacing/
│   └── app_spacing.dart       # Layout margins & size boxes
├── dimensions/
│   └── app_dimensions.dart    # Components size guides
├── radius/
│   └── app_radius.dart        # Corner radius helpers
├── elevation/
│   └── app_elevation.dart     # Material 3 levels
├── shadows/
│   └── app_shadows.dart       # Depth shadow layers
├── gradients/
│   └── app_gradients.dart     # Atmospheric backdrops
├── glass/
│   └── app_glass.dart         # Blur sigmas & opacities
├── durations/
│   └── app_durations.dart     # Transition intervals
├── curves/
│   └── app_curves.dart        # Motion curve bezier lines
├── icons/
│   └── app_icons.dart         # Material rounded action icons
├── shapes/
│   └── app_shapes.dart        # Reusable shape border presets
├── opacity/
│   └── app_opacity.dart       # Semantic opacity guide
├── theme/
│   └── app_theme.dart         # Global ThemeData generation
├── extensions/
│   └── theme_extensions.dart  # BuildContext access hooks
└── design_tokens.dart         # Single-import barrel file
```

---

## 15. How to Create Future Widgets

When creating custom UI widgets (e.g. inside `lib/core/widgets/`):

1. **Only use Design Tokens**: Never hardcode colors, padding, margins, durations, shapes, or curves.
2. **Context-Aware Styling**: Read spacing, radius, colors, and fonts via `context.colors`, `context.spacing`, `context.radius`, and `context.typography`.
3. **Responsive Constraints**: Ensure components size themselves using constraints rather than locked physical heights/widths where possible.
4. **ThemeExtensions**: Register custom presentation attributes in `OryColorsThemeExtension` if they change depending on whether the app is in Light, Dark, or AMOLED mode.

---

## 16. Best Practices & Examples

### Correct Component Example
```dart
import 'package:flutter/material.dart';
import 'package:orynta/core/design_system/design_tokens.dart';

class OryPremiumCard extends StatelessWidget {
  const OryPremiumCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: AppShapes.card,
      elevation: context.elevation.card,
      child: InkWell(
        borderRadius: context.radius.borderRadiusMd,
        onTap: onTap,
        child: Padding(
          padding: context.spacing.paddingCard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: context.typography.titleMedium.copyWith(
                  color: context.colors.textPrimary,
                ),
              ),
              context.spacing.gapXs, // 4dp gap
              Text(
                subtitle,
                style: context.typography.bodyMedium.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Incorrect Component Example
```dart
import 'package:flutter/material.dart';

class BadCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0), // ❌ Hardcoded padding
      decoration: BoxDecoration(
        color: Colors.white,               // ❌ Hardcoded non-semantic color
        borderRadius: BorderRadius.circular(10.0), // ❌ Hardcoded radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // ❌ Magic shadow value
            blurRadius: 5.0,
          )
        ]
      ),
      child: Text(
        'Broken',
        style: TextStyle(
          fontFamily: 'Playfair Display', // ❌ Banned serif font
          fontSize: 16.0,                  // ❌ Hardcoded font size
          color: Color(0xFF111111),        // ❌ Hardcoded text color
        ),
      ),
    );
  }
}
```
