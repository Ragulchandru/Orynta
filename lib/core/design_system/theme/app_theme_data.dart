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

  AppThemeNavigationColors copyWith({
    Color? active,
    Color? inactive,
    Color? background,
    Color? indicator,
  }) {
    return AppThemeNavigationColors(
      active: active ?? this.active,
      inactive: inactive ?? this.inactive,
      background: background ?? this.background,
      indicator: indicator ?? this.indicator,
    );
  }
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

  AppThemePlannerColors copyWith({
    Color? highPriority,
    Color? mediumPriority,
    Color? lowPriority,
    Color? progressDone,
    Color? progressTodo,
  }) {
    return AppThemePlannerColors(
      highPriority: highPriority ?? this.highPriority,
      mediumPriority: mediumPriority ?? this.mediumPriority,
      lowPriority: lowPriority ?? this.lowPriority,
      progressDone: progressDone ?? this.progressDone,
      progressTodo: progressTodo ?? this.progressTodo,
    );
  }
}

class AppThemeAnalyticsColors {
  const AppThemeAnalyticsColors({
    required this.chartPrimary,
    required this.chartSecondary,
    required this.chartTertiary,
    required this.ringActive,
    required this.ringInactive,
    required this.heatmapLow,
    required this.heatmapMedium,
    required this.heatmapHigh,
    required this.legendText,
    required this.cardBackground,
    required this.cardBorder,
    required this.progressRingActive,
    required this.progressRingInactive,
  });

  final Color chartPrimary;
  final Color chartSecondary;
  final Color chartTertiary;
  final Color ringActive;
  final Color ringInactive;
  final Color heatmapLow;
  final Color heatmapMedium;
  final Color heatmapHigh;
  final Color legendText;
  final Color cardBackground;
  final Color cardBorder;
  final Color progressRingActive;
  final Color progressRingInactive;

  AppThemeAnalyticsColors copyWith({
    Color? chartPrimary,
    Color? chartSecondary,
    Color? chartTertiary,
    Color? ringActive,
    Color? ringInactive,
    Color? heatmapLow,
    Color? heatmapMedium,
    Color? heatmapHigh,
    Color? legendText,
    Color? cardBackground,
    Color? cardBorder,
    Color? progressRingActive,
    Color? progressRingInactive,
  }) {
    return AppThemeAnalyticsColors(
      chartPrimary: chartPrimary ?? this.chartPrimary,
      chartSecondary: chartSecondary ?? this.chartSecondary,
      chartTertiary: chartTertiary ?? this.chartTertiary,
      ringActive: ringActive ?? this.ringActive,
      ringInactive: ringInactive ?? this.ringInactive,
      heatmapLow: heatmapLow ?? this.heatmapLow,
      heatmapMedium: heatmapMedium ?? this.heatmapMedium,
      heatmapHigh: heatmapHigh ?? this.heatmapHigh,
      legendText: legendText ?? this.legendText,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBorder: cardBorder ?? this.cardBorder,
      progressRingActive: progressRingActive ?? this.progressRingActive,
      progressRingInactive: progressRingInactive ?? this.progressRingInactive,
    );
  }
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

  AppThemeEditorColors copyWith({
    Color? selection,
    Color? markdownHeader,
    Color? markdownQuote,
    Color? markdownCode,
    Color? attachmentBackground,
  }) {
    return AppThemeEditorColors(
      selection: selection ?? this.selection,
      markdownHeader: markdownHeader ?? this.markdownHeader,
      markdownQuote: markdownQuote ?? this.markdownQuote,
      markdownCode: markdownCode ?? this.markdownCode,
      attachmentBackground: attachmentBackground ?? this.attachmentBackground,
    );
  }
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
    required this.chipBackground,
    required this.chipSelected,
    required this.chipText,
    required this.chipTextSelected,
    required this.fabBackground,
    required this.fabForeground,
    required this.selectionBackground,
    required this.contextMenuBackground,
  });

  final Color card;
  final Color cardBorder;
  final Color searchBackground;
  final Color searchBorder;
  final Color tagBackground;
  final Color tagText;
  final Color highlightBackground;
  final Color chipBackground;
  final Color chipSelected;
  final Color chipText;
  final Color chipTextSelected;
  final Color fabBackground;
  final Color fabForeground;
  final Color selectionBackground;
  final Color contextMenuBackground;

  AppThemeNotesColors copyWith({
    Color? card,
    Color? cardBorder,
    Color? searchBackground,
    Color? searchBorder,
    Color? tagBackground,
    Color? tagText,
    Color? highlightBackground,
    Color? chipBackground,
    Color? chipSelected,
    Color? chipText,
    Color? chipTextSelected,
    Color? fabBackground,
    Color? fabForeground,
    Color? selectionBackground,
    Color? contextMenuBackground,
  }) {
    return AppThemeNotesColors(
      card: card ?? this.card,
      cardBorder: cardBorder ?? this.cardBorder,
      searchBackground: searchBackground ?? this.searchBackground,
      searchBorder: searchBorder ?? this.searchBorder,
      tagBackground: tagBackground ?? this.tagBackground,
      tagText: tagText ?? this.tagText,
      highlightBackground: highlightBackground ?? this.highlightBackground,
      chipBackground: chipBackground ?? this.chipBackground,
      chipSelected: chipSelected ?? this.chipSelected,
      chipText: chipText ?? this.chipText,
      chipTextSelected: chipTextSelected ?? this.chipTextSelected,
      fabBackground: fabBackground ?? this.fabBackground,
      fabForeground: fabForeground ?? this.fabForeground,
      selectionBackground: selectionBackground ?? this.selectionBackground,
      contextMenuBackground: contextMenuBackground ?? this.contextMenuBackground,
    );
  }
}

class AppThemeDashboardColors {
  const AppThemeDashboardColors({
    required this.heroBackground,
    required this.heroText,
    required this.quoteBackground,
    required this.quoteBorder,
    required this.missionCard,
    required this.reminderCard,
    required this.glanceCard,
    required this.glanceBorder,
    required this.productivityBg,
  });

  final Color heroBackground;
  final Color heroText;
  final Color quoteBackground;
  final Color quoteBorder;
  final Color missionCard;
  final Color reminderCard;
  final Color glanceCard;
  final Color glanceBorder;
  final Color productivityBg;

  AppThemeDashboardColors copyWith({
    Color? heroBackground,
    Color? heroText,
    Color? quoteBackground,
    Color? quoteBorder,
    Color? missionCard,
    Color? reminderCard,
    Color? glanceCard,
    Color? glanceBorder,
    Color? productivityBg,
  }) {
    return AppThemeDashboardColors(
      heroBackground: heroBackground ?? this.heroBackground,
      heroText: heroText ?? this.heroText,
      quoteBackground: quoteBackground ?? this.quoteBackground,
      quoteBorder: quoteBorder ?? this.quoteBorder,
      missionCard: missionCard ?? this.missionCard,
      reminderCard: reminderCard ?? this.reminderCard,
      glanceCard: glanceCard ?? this.glanceCard,
      glanceBorder: glanceBorder ?? this.glanceBorder,
      productivityBg: productivityBg ?? this.productivityBg,
    );
  }
}

class AppThemeProfileColors {
  const AppThemeProfileColors({
    required this.avatarBackground,
    required this.avatarBorder,
    required this.avatarText,
    required this.headerBackground,
    required this.cardBackground,
    required this.cardBorder,
  });

  final Color avatarBackground;
  final Color avatarBorder;
  final Color avatarText;
  final Color headerBackground;
  final Color cardBackground;
  final Color cardBorder;

  AppThemeProfileColors copyWith({
    Color? avatarBackground,
    Color? avatarBorder,
    Color? avatarText,
    Color? headerBackground,
    Color? cardBackground,
    Color? cardBorder,
  }) {
    return AppThemeProfileColors(
      avatarBackground: avatarBackground ?? this.avatarBackground,
      avatarBorder: avatarBorder ?? this.avatarBorder,
      avatarText: avatarText ?? this.avatarText,
      headerBackground: headerBackground ?? this.headerBackground,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBorder: cardBorder ?? this.cardBorder,
    );
  }
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
    required this.dashboard,
    required this.profile,
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
  final AppThemeDashboardColors dashboard;
  final AppThemeProfileColors profile;

  AppThemeData copyWith({
    String? id,
    String? displayName,
    String? description,
    String? previewAsset,
    Brightness? brightness,
    bool? isDark,
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? surface,
    Color? surfaceContainer,
    Color? surfaceBright,
    Color? surfaceDim,
    Color? outline,
    Color? outlineVariant,
    Color? success,
    Color? warning,
    Color? error,
    AppThemeNavigationColors? navigation,
    AppThemePlannerColors? planner,
    AppThemeAnalyticsColors? analytics,
    AppThemeEditorColors? editor,
    AppThemeNotesColors? notes,
    AppThemeDashboardColors? dashboard,
    AppThemeProfileColors? profile,
  }) {
    return AppThemeData(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      previewAsset: previewAsset ?? this.previewAsset,
      brightness: brightness ?? this.brightness,
      isDark: isDark ?? this.isDark,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      surface: surface ?? this.surface,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceBright: surfaceBright ?? this.surfaceBright,
      surfaceDim: surfaceDim ?? this.surfaceDim,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      navigation: navigation ?? this.navigation,
      planner: planner ?? this.planner,
      analytics: analytics ?? this.analytics,
      editor: editor ?? this.editor,
      notes: notes ?? this.notes,
      dashboard: dashboard ?? this.dashboard,
      profile: profile ?? this.profile,
    );
  }
}
