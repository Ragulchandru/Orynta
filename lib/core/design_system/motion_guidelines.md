# Orynta 2.0 — Motion Guidelines

> **Purpose**: This document defines the animation philosophy and per-component  
> motion specifications for Orynta 2.0. All future screens and components must  
> follow these guidelines to ensure a consistent, premium feel.

---

## Core Animation Philosophy

**Animations serve the user, not the designer.**

Every animation must:
- **Aid comprehension** — help the user understand what just happened
- **Feel natural** — mimic real-world physics without being distracting
- **Be fast enough** — never block the user or feel sluggish
- **Be consistent** — same widget animates the same way everywhere

**Animations must NOT:**
- ❌ Play for more than 600ms (reserved for very rare emphasis)
- ❌ Use bouncy springs for productivity UI (save for social/gaming apps)
- ❌ Animate constantly or loop without user interaction
- ❌ Distract from the content being shown
- ❌ Repeat on every rebuild (use `key` or state guards)

---

## Duration Scale Reference

| Token | Value | Use Case |
|-------|-------|----------|
| `AppDurations.instant` | 80ms | Ripple, hover, micro-feedback |
| `AppDurations.fast` | 150ms | Button press, icon swap, toggle |
| `AppDurations.short` | 250ms | Color fade, chip select |
| `AppDurations.normal` | 300ms | Widget enter/exit, modal dismiss |
| `AppDurations.medium` | 400ms | Card expand, list insert |
| `AppDurations.slow` | 500ms | Bottom sheet, dialog appear |
| `AppDurations.pageTransition` | 350ms | Navigation transitions |
| `AppDurations.statsCountUp` | 800ms | Number count-up animations |
| `AppDurations.shimmerCycle` | 1200ms | Loading skeleton loop |

---

## Curve Reference

| Token | Use Case |
|-------|----------|
| `AppCurves.emphasizedDecelerate` | Element **enters** screen (M3 standard) |
| `AppCurves.emphasizedAccelerate` | Element **exits** screen (M3 standard) |
| `AppCurves.easeOut` | Standard widget appearance |
| `AppCurves.easeIn` | Standard widget disappearance |
| `AppCurves.easeOutCubic` | Button/card press, fast interactions |
| `AppCurves.easeOutQuart` | List item stagger entry |
| `AppCurves.easeOutExpo` | Hero element dramatic entry |
| `AppCurves.fastOutSlowIn` | Panel/drawer open |
| `AppCurves.linear` | Progress bars, shimmer, loops |
| `AppCurves.bounceOut` | Pull-to-refresh elastic |

---

## Per-Component Motion Specs

### 📄 Cards
- **Appear**: Fade + Slide (fade from 0→1, translate Y +12→0)
- **Duration**: `AppDurations.medium` (400ms)
- **Curve**: `AppCurves.easeOutQuart`
- **Stagger**: `AppDurations.listStaggerDelay` (50ms) per item in lists
- **Press**: Scale 1.0→0.97, `AppDurations.fast` (150ms), `AppCurves.easeOutCubic`
- **Release**: Scale 0.97→1.0, `AppDurations.fast` (150ms), `AppCurves.easeOut`
- **Expand**: Height expand + fade children, `AppDurations.normal` (300ms)

### 📱 Page Transitions
- **Style**: Shared Axis (horizontal) — M3 navigation pattern
- **Enter**: `AppDurations.pageTransition` (350ms), `AppCurves.emphasizedDecelerate`
- **Exit**: `AppDurations.pageTransitionExit` (250ms), `AppCurves.emphasizedAccelerate`
- **Alternative for detail pages**: Fade Through — suits note editor open

### 💬 Dialogs
- **Enter**: Scale (0.8→1.0) + Fade, `AppDurations.dialogEnter` (300ms), `AppCurves.emphasizedDecelerate`
- **Exit**: Scale (1.0→0.9) + Fade, `AppDurations.dialogExit` (200ms), `AppCurves.emphasizedAccelerate`
- **Barier**: Fade black overlay, `AppDurations.normal` (300ms)

### 🗂️ Bottom Sheets
- **Enter**: Slide Up (Y: +height→0) + Fade, `AppDurations.bottomSheetEnter` (350ms), `AppCurves.emphasizedDecelerate`
- **Exit**: Slide Down (Y: 0→+height), `AppDurations.bottomSheetExit` (250ms), `AppCurves.emphasizedAccelerate`
- **Drag dismiss**: Follow finger velocity, snap with `AppCurves.easeOutCubic`

### 🔘 FAB
- **Appear**: Scale (0→1) + Fade, `AppDurations.fabAnimation` (250ms), `AppCurves.emphasizedDecelerate`
- **Disappear (on scroll)**: Scale (1→0) + Fade, `AppDurations.fast` (150ms), `AppCurves.emphasizedAccelerate`
- **Press**: Scale 1.0→0.90, `AppDurations.instant` (80ms)
- **Release**: Scale 0.90→1.0, `AppDurations.fast` (150ms), `AppCurves.easeOutCubic`

### 📊 Statistics / Analytics
- **Count Up**: Number count from 0→target, `AppDurations.statsCountUp` (800ms), `AppCurves.easeOutExpo`
- **Progress bars**: Width expand 0%→value%, `AppDurations.slow` (500ms), `AppCurves.easeOutCubic`
- **Chart bars**: Height grow 0→value, stagger 50ms, `AppCurves.easeOutQuart`

### 📋 Lists & Grids
- **Item insert**: Fade + Slide (Y: +16→0), `AppDurations.normal` (300ms), `AppCurves.easeOutCubic`
- **Item remove**: Fade + Slide (Y: 0→-16) + Collapse height, `AppDurations.short` (250ms)
- **Stagger**: `AppDurations.listStaggerDelay` (50ms) between items
- **Max stagger items**: 6 (remaining items appear instantly after)
- **Reorder drag**: Lift shadow, scale 1.0→1.03, `AppDurations.fast`

### 🔄 Pull to Refresh
- **Style**: Elastic spring
- **Curve**: `AppCurves.bounceOut`
- **Indicator**: Spin + fade in, `AppDurations.normal`

### ⌨️ Buttons
- **Tap feedback**: Ripple (Material default) + Scale 1.0→0.97
- **Duration**: `AppDurations.buttonAnimation` (150ms)
- **Curve**: `AppCurves.easeOutCubic`
- **Loading state**: Fade label + Show spinner, `AppDurations.fast`

### 🏷️ Chips & Tags
- **Select**: Background color fill, `AppDurations.fast` (150ms), `AppCurves.easeOut`
- **Checkmark appear**: Scale + Fade, `AppDurations.fast` (150ms)

### 🎯 Focus Timer
- **Ring animation**: Circular progress, `AppDurations.timerTick` (1000ms), `AppCurves.linear`
- **Session complete**: Scale + Glow, `AppDurations.medium` (400ms), `AppCurves.easeOutExpo`

### 🔔 Snack Bar
- **Enter**: Slide up + Fade, `AppDurations.snackBarEnter` (300ms), `AppCurves.easeOutCubic`
- **Exit**: Slide down + Fade, `AppDurations.normal` (300ms), `AppCurves.easeIn`

### ⏳ Skeleton / Shimmer
- **Loop**: Left-to-right sweep, `AppDurations.shimmerCycle` (1200ms), `AppCurves.linear`
- **Appear/Disappear**: Fade cross-dissolve, `AppDurations.normal` (300ms)

### 🔍 Search Bar
- **Expand**: Width expand, `AppDurations.normal` (300ms), `AppCurves.emphasizedDecelerate`
- **Results**: Fade in staggered list, `AppDurations.fast` per item

### 🗓️ Calendar
- **Month switch**: Slide left/right depending on direction, `AppDurations.normal`
- **Day select**: Scale + color fill, `AppDurations.fast` (150ms)

---

## Accessibility Rules

- **Respect `AnimationController` with `AccessibilityFeatures.disableAnimations`**
- Always check `MediaQuery.disableAnimations` and reduce/skip animations when true
- Ensure all animated widgets can be used without animation (functional first)
- Loading states must have non-animated fallbacks

---

## Implementation Reference

```dart
// Standard enter animation pattern (Phase 1 Step 2+)
AnimatedOpacity(
  opacity: _visible ? 1.0 : 0.0,
  duration: AppDurations.normal,
  curve: AppCurves.easeOut,
  child: AnimatedSlide(
    offset: _visible ? Offset.zero : const Offset(0, 0.05),
    duration: AppDurations.normal,
    curve: AppCurves.easeOutCubic,
    child: widget,
  ),
)

// Button press scale
GestureDetector(
  onTapDown: (_) => setState(() => _pressed = true),
  onTapUp: (_) => setState(() => _pressed = false),
  onTapCancel: () => setState(() => _pressed = false),
  child: AnimatedScale(
    scale: _pressed ? 0.97 : 1.0,
    duration: AppDurations.buttonAnimation,
    curve: AppCurves.easeOutCubic,
    child: child,
  ),
)
```

---

*Last updated: Orynta 2.0 Phase 1 Step 1*  
*Next update: Phase 1 Step 2 — Component Library*
