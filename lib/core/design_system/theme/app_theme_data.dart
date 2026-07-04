// lib/core/design_system/theme/app_theme_data.dart
//
// Orynta 2.0 — Premium Theme Data Model

import 'package:flutter/material.dart';

class AppThemeNavigationColors {
  const AppThemeNavigationColors({
    required this.active,
    required this.inactive,
    required this.background,
    required this.indicator,
  });

  final Color active;
  final Color inactive;
  final Color background;
  final Color indicator;
}

class AppThemePlannerColors {
  const AppThemePlannerColors({
    required this.highPriority,
    required this.mediumPriority,
    required this.lowPriority,
    required this.progressDone,
    required this.progressTodo,
  });

  final Color highPriority;
  final Color mediumPriority;
  final Color lowPriority;
  final Color progressDone;
  final Color progressTodo;
}

class AppThemeAnalyticsColors {
  const AppThemeAnalyticsColors({
    required this.chartPrimary,
    required this.chartSecondary,
    required this.chartTertiary,
    required this.ringActive,
    required this.ringInactive,
  });

  final Color chartPrimary;
  final Color chartSecondary;
  final Color chartTertiary;
  final Color ringActive;
  final Color ringInactive;
}

class AppThemeEditorColors {
  const AppThemeEditorColors({
    required this.selection,
    required this.markdownHeader,
    required this.markdownQuote,
    required this.markdownCode,
    required this.attachmentBackground,
  });

  final Color selection;
  final Color markdownHeader;
  final Color markdownQuote;
  final Color markdownCode;
  final Color attachmentBackground;
}

class AppThemeNotesColors {
  const AppThemeNotesColors({
    required this.card,
    required this.cardBorder,
    required this.searchBackground,
    required this.searchBorder,
    required this.tagBackground,
    required this.tagText,
    required this.highlightBackground,
  });

  final Color card;
  final Color cardBorder;
  final Color searchBackground;
  final Color searchBorder;
  final Color tagBackground;
  final Color tagText;
  final Color highlightBackground;
}

class AppThemeData {
  const AppThemeData({
    required this.id,
    required this.displayName,
    required this.description,
    required this.previewAsset,
    required this.brightness,
    required this.isDark,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.surface,
    required this.surfaceContainer,
    required this.surfaceBright,
    required this.surfaceDim,
    required this.outline,
    required this.outlineVariant,
    required this.success,
    required this.warning,
    required this.error,
    required this.navigation,
    required this.planner,
    required this.analytics,
    required this.editor,
    required this.notes,
  });

  final String id;
  final String displayName;
  final String description;
  final String previewAsset;
  final Brightness brightness;
  final bool isDark;

  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color surface;
  final Color surfaceContainer;
  final Color surfaceBright;
  final Color surfaceDim;
  final Color outline;
  final Color outlineVariant;
  final Color success;
  final Color warning;
  final Color error;

  final AppThemeNavigationColors navigation;
  final AppThemePlannerColors planner;
  final AppThemeAnalyticsColors analytics;
  final AppThemeEditorColors editor;
  final AppThemeNotesColors notes;
}
