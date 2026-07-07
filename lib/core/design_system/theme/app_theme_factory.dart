// lib/core/design_system/theme/app_theme_factory.dart
//
// Orynta 2.0 — Factory for Premium Theme Definitions

import 'package:flutter/material.dart';
import 'app_theme_type.dart';
import 'app_theme_data.dart';

abstract final class AppThemeFactory {
  static AppThemeData getTheme(AppThemeType type) {
    switch (type) {
      case AppThemeType.gold:
        return _gold();
      case AppThemeType.midnight:
        return _midnight();
      case AppThemeType.forest:
        return _forest();
      case AppThemeType.ocean:
        return _ocean();
      case AppThemeType.lavender:
        return _lavender();
      case AppThemeType.sunset:
        return _sunset();
      case AppThemeType.light:
        return _lightTheme();
      case AppThemeType.sepia:
        return _sepia();
      case AppThemeType.amoled:
        return _amoled();
      case AppThemeType.graphite:
        return _graphite();
      case AppThemeType.whiteMinimal:
        return _whiteMinimal();
      case AppThemeType.arctic:
        return _arctic();
      case AppThemeType.rose:
        return _rose();
      case AppThemeType.emerald:
        return _emerald();
      case AppThemeType.crimson:
        return _crimson();
      case AppThemeType.indigo:
        return _indigo();
    }
  }

  static AppThemeData _gold() {
    const primary = Color(0xFFD4AF37);
    const secondary = Color(0xFFE8C349);
    const tertiary = Color(0xFFB8860B);
    const background = Color(0xFF0F0F17);
    const surface = Color(0xFF141420);
    const outline = Color(0xFF38384E);

    return const AppThemeData(
      id: 'gold',
      displayName: 'Orynta Gold',
      description: 'Elegant gold accents on slate surfaces',
      previewAsset: 'assets/themes/gold_preview.png',
      brightness: Brightness.dark,
      isDark: true,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      surface: surface,
      surfaceContainer: Color(0xFF1E1E2E),
      surfaceBright: Color(0xFF28283E),
      surfaceDim: Color(0xFF0C0C12),
      outline: outline,
      outlineVariant: Color(0xFF2A2A40),
      success: Color(0xFF10B981),
      warning: Color(0xFFF59E0B),
      error: Color(0xFFEF4444),
      navigation: AppThemeNavigationColors(
        active: primary,
        inactive: Color(0xFF8E8EA8),
        background: background,
        indicator: Color(0xFF252538),
      ),
      planner: AppThemePlannerColors(
        highPriority: Color(0xFFEF4444),
        mediumPriority: Color(0xFFF59E0B),
        lowPriority: Color(0xFF10B981),
        progressDone: primary,
        progressTodo: Color(0xFF252538),
      ),
      analytics: AppThemeAnalyticsColors(
        chartPrimary: primary,
        chartSecondary: secondary,
        chartTertiary: Color(0xFF818CF8),
        ringActive: primary,
        ringInactive: Color(0xFF252538),
        heatmapLow: Color(0xFF1B1B2A),
        heatmapMedium: primary,
        heatmapHigh: secondary,
        legendText: Color(0xFF8E8EA8),
        cardBackground: Color(0xFF1E1E2E),
        cardBorder: Color(0xFF2A2A40),
        progressRingActive: primary,
        progressRingInactive: Color(0xFF252538),
      ),
      editor: AppThemeEditorColors(
        selection: Color(0xFF4B431D),
        markdownHeader: primary,
        markdownQuote: secondary,
        markdownCode: Color(0xFF1A1A28),
        attachmentBackground: Color(0xFF1A1A28),
      ),
      notes: AppThemeNotesColors(
        card: Color(0xFF1E1E2E),
        cardBorder: Color(0xFF2A2A40),
        searchBackground: Color(0xFF1E1E2E),
        searchBorder: outline,
        tagBackground: Color(0xFF2E2A1C),
        tagText: primary,
        highlightBackground: Color(0x66D4AF37),
        chipBackground: Color(0xFF141420),
        chipSelected: primary,
        chipText: Color(0xFF8E8EA8),
        chipTextSelected: Color(0xFF0F0F17),
        fabBackground: primary,
        fabForeground: Color(0xFF0F0F17),
        selectionBackground: Color(0x33D4AF37),
        contextMenuBackground: Color(0xFF1E1E2E),
      ),
      dashboard: AppThemeDashboardColors(
        heroBackground: Color(0xFF252538),
        heroText: primary,
        quoteBackground: Color(0xFF1E1E2E),
        quoteBorder: Color(0xFF2A2A40),
        missionCard: Color(0xFF1E1E2E),
        reminderCard: Color(0xFF1E1E2E),
        glanceCard: Color(0xFF1E1E2E),
        glanceBorder: Color(0xFF2A2A40),
        productivityBg: Color(0xFF252538),
      ),
      profile: AppThemeProfileColors(
        avatarBackground: Color(0xFF2E2A1C),
        avatarBorder: primary,
        avatarText: primary,
        headerBackground: Color(0xFF141420),
        cardBackground: Color(0xFF1E1E2E),
        cardBorder: Color(0xFF2A2A40),
      ),
    );
  }

  static AppThemeData _midnight() {
    const primary = Color(0xFF3B82F6);
    const secondary = Color(0xFF60A5FA);
    const tertiary = Color(0xFF1D4ED8);
    const background = Color(0xFF070B19);
    const surface = Color(0xFF0F172A);
    const outline = Color(0xFF1E293B);

    return const AppThemeData(
      id: 'midnight',
      displayName: 'Midnight',
      description: 'Cool blue tones for a deep dark visual mode',
      previewAsset: 'assets/themes/midnight_preview.png',
      brightness: Brightness.dark,
      isDark: true,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      surface: surface,
      surfaceContainer: Color(0xFF1E293B),
      surfaceBright: Color(0xFF334155),
      surfaceDim: Color(0xFF020617),
      outline: outline,
      outlineVariant: Color(0xFF334155),
      success: Color(0xFF10B981),
      warning: Color(0xFFF59E0B),
      error: Color(0xFFEF4444),
      navigation: AppThemeNavigationColors(
        active: primary,
        inactive: Color(0xFF64748B),
        background: background,
        indicator: Color(0xFF1E293B),
      ),
      planner: AppThemePlannerColors(
        highPriority: Color(0xFFEF4444),
        mediumPriority: Color(0xFFF59E0B),
        lowPriority: Color(0xFF10B981),
        progressDone: primary,
        progressTodo: Color(0xFF1E293B),
      ),
      analytics: AppThemeAnalyticsColors(
        chartPrimary: primary,
        chartSecondary: secondary,
        chartTertiary: Color(0xFFC084FC),
        ringActive: primary,
        ringInactive: Color(0xFF1E293B),
        heatmapLow: Color(0xFF111A2E),
        heatmapMedium: primary,
        heatmapHigh: secondary,
        legendText: Color(0xFF64748B),
        cardBackground: Color(0xFF1E293B),
        cardBorder: Color(0xFF334155),
        progressRingActive: primary,
        progressRingInactive: Color(0xFF1E293B),
      ),
      editor: AppThemeEditorColors(
        selection: Color(0xFF1E3A8A),
        markdownHeader: primary,
        markdownQuote: secondary,
        markdownCode: Color(0xFF0F172A),
        attachmentBackground: Color(0xFF0F172A),
      ),
      notes: AppThemeNotesColors(
        card: Color(0xFF1E293B),
        cardBorder: Color(0xFF334155),
        searchBackground: Color(0xFF1E293B),
        searchBorder: outline,
        tagBackground: Color(0xFF172554),
        tagText: secondary,
        highlightBackground: Color(0x663B82F6),
        chipBackground: Color(0xFF0F172A),
        chipSelected: primary,
        chipText: Color(0xFF64748B),
        chipTextSelected: Colors.white,
        fabBackground: primary,
        fabForeground: Colors.white,
        selectionBackground: Color(0x333B82F6),
        contextMenuBackground: Color(0xFF1E293B),
      ),
      dashboard: AppThemeDashboardColors(
        heroBackground: Color(0xFF1E293B),
        heroText: primary,
        quoteBackground: Color(0xFF1E293B),
        quoteBorder: Color(0xFF334155),
        missionCard: Color(0xFF1E293B),
        reminderCard: Color(0xFF1E293B),
        glanceCard: Color(0xFF1E293B),
        glanceBorder: Color(0xFF334155),
        productivityBg: Color(0xFF1E293B),
      ),
      profile: AppThemeProfileColors(
        avatarBackground: Color(0xFF172554),
        avatarBorder: primary,
        avatarText: primary,
        headerBackground: Color(0xFF0F172A),
        cardBackground: Color(0xFF1E293B),
        cardBorder: Color(0xFF334155),
      ),
    );
  }

  static AppThemeData _forest() {
    const primary = Color(0xFF10B981);
    const secondary = Color(0xFF34D399);
    const tertiary = Color(0xFF047857);
    const background = Color(0xFF05120E);
    const surface = Color(0xFF0B211A);
    const outline = Color(0xFF1F3D33);

    return const AppThemeData(
      id: 'forest',
      displayName: 'Forest',
      description: 'Refreshing pine green shades to aid concentration',
      previewAsset: 'assets/themes/forest_preview.png',
      brightness: Brightness.dark,
      isDark: true,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      surface: surface,
      surfaceContainer: Color(0xFF143027),
      surfaceBright: Color(0xFF1D4537),
      surfaceDim: Color(0xFF020806),
      outline: outline,
      outlineVariant: Color(0xFF1A382D),
      success: Color(0xFF34D399),
      warning: Color(0xFFFBBF24),
      error: Color(0xFFF87171),
      navigation: AppThemeNavigationColors(
        active: primary,
        inactive: Color(0xFF6B8A7E),
        background: background,
        indicator: Color(0xFF143027),
      ),
      planner: AppThemePlannerColors(
        highPriority: Color(0xFFF87171),
        mediumPriority: Color(0xFFFBBF24),
        lowPriority: Color(0xFF34D399),
        progressDone: primary,
        progressTodo: Color(0xFF143027),
      ),
      analytics: AppThemeAnalyticsColors(
        chartPrimary: primary,
        chartSecondary: secondary,
        chartTertiary: Color(0xFFFB923C),
        ringActive: primary,
        ringInactive: Color(0xFF143027),
        heatmapLow: Color(0xFF0D251E),
        heatmapMedium: primary,
        heatmapHigh: secondary,
        legendText: Color(0xFF6B8A7E),
        cardBackground: Color(0xFF143027),
        cardBorder: Color(0xFF1F3D33),
        progressRingActive: primary,
        progressRingInactive: Color(0xFF143027),
      ),
      editor: AppThemeEditorColors(
        selection: Color(0xFF064E3B),
        markdownHeader: primary,
        markdownQuote: secondary,
        markdownCode: Color(0xFF0B211A),
        attachmentBackground: Color(0xFF0B211A),
      ),
      notes: AppThemeNotesColors(
        card: Color(0xFF143027),
        cardBorder: Color(0xFF1F3D33),
        searchBackground: Color(0xFF143027),
        searchBorder: outline,
        tagBackground: Color(0xFF022C22),
        tagText: secondary,
        highlightBackground: Color(0x6610B981),
        chipBackground: Color(0xFF0B211A),
        chipSelected: primary,
        chipText: Color(0xFF6B8A7E),
        chipTextSelected: Color(0xFF05120E),
        fabBackground: primary,
        fabForeground: Color(0xFF05120E),
        selectionBackground: Color(0x3310B981),
        contextMenuBackground: Color(0xFF143027),
      ),
      dashboard: AppThemeDashboardColors(
        heroBackground: Color(0xFF143027),
        heroText: primary,
        quoteBackground: Color(0xFF143027),
        quoteBorder: Color(0xFF1F3D33),
        missionCard: Color(0xFF143027),
        reminderCard: Color(0xFF143027),
        glanceCard: Color(0xFF143027),
        glanceBorder: Color(0xFF1F3D33),
        productivityBg: Color(0xFF143027),
      ),
      profile: AppThemeProfileColors(
        avatarBackground: Color(0xFF022C22),
        avatarBorder: primary,
        avatarText: primary,
        headerBackground: Color(0xFF0B211A),
        cardBackground: Color(0xFF143027),
        cardBorder: Color(0xFF1F3D33),
      ),
    );
  }

  static AppThemeData _ocean() {
    const primary = Color(0xFF06B6D4);
    const secondary = Color(0xFF22D3EE);
    const tertiary = Color(0xFF0891B2);
    const background = Color(0xFF04101A);
    const surface = Color(0xFF0C1D2A);
    const outline = Color(0xFF1A354A);

    return const AppThemeData(
      id: 'ocean',
      displayName: 'Ocean',
      description: 'Deep ocean currents with glowing cyan highlights',
      previewAsset: 'assets/themes/ocean_preview.png',
      brightness: Brightness.dark,
      isDark: true,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      surface: surface,
      surfaceContainer: Color(0xFF122C3F),
      surfaceBright: Color(0xFF1D4562),
      surfaceDim: Color(0xFF02070D),
      outline: outline,
      outlineVariant: Color(0xFF1A3852),
      success: Color(0xFF10B981),
      warning: Color(0xFFF59E0B),
      error: Color(0xFFEF4444),
      navigation: AppThemeNavigationColors(
        active: primary,
        inactive: Color(0xFF5E7F96),
        background: background,
        indicator: Color(0xFF122C3F),
      ),
      planner: AppThemePlannerColors(
        highPriority: Color(0xFFEF4444),
        mediumPriority: Color(0xFFF59E0B),
        lowPriority: Color(0xFF10B981),
        progressDone: primary,
        progressTodo: Color(0xFF122C3F),
      ),
      analytics: AppThemeAnalyticsColors(
        chartPrimary: primary,
        chartSecondary: secondary,
        chartTertiary: Color(0xFF60A5FA),
        ringActive: primary,
        ringInactive: Color(0xFF122C3F),
        heatmapLow: Color(0xFF0A2234),
        heatmapMedium: primary,
        heatmapHigh: secondary,
        legendText: Color(0xFF5E7F96),
        cardBackground: Color(0xFF122C3F),
        cardBorder: Color(0xFF1E435E),
        progressRingActive: primary,
        progressRingInactive: Color(0xFF122C3F),
      ),
      editor: AppThemeEditorColors(
        selection: Color(0xFF164E63),
        markdownHeader: primary,
        markdownQuote: secondary,
        markdownCode: Color(0xFF0C1D2A),
        attachmentBackground: Color(0xFF0C1D2A),
      ),
      notes: AppThemeNotesColors(
        card: Color(0xFF122C3F),
        cardBorder: Color(0xFF1E435E),
        searchBackground: Color(0xFF122C3F),
        searchBorder: outline,
        tagBackground: Color(0xFF083344),
        tagText: secondary,
        highlightBackground: Color(0x6606B6D4),
        chipBackground: Color(0xFF0C1D2A),
        chipSelected: primary,
        chipText: Color(0xFF5E7F96),
        chipTextSelected: Color(0xFF04101A),
        fabBackground: primary,
        fabForeground: Color(0xFF04101A),
        selectionBackground: Color(0x3306B6D4),
        contextMenuBackground: Color(0xFF122C3F),
      ),
      dashboard: AppThemeDashboardColors(
        heroBackground: Color(0xFF122C3F),
        heroText: primary,
        quoteBackground: Color(0xFF122C3F),
        quoteBorder: Color(0xFF1E435E),
        missionCard: Color(0xFF122C3F),
        reminderCard: Color(0xFF122C3F),
        glanceCard: Color(0xFF122C3F),
        glanceBorder: Color(0xFF1E435E),
        productivityBg: Color(0xFF122C3F),
      ),
      profile: AppThemeProfileColors(
        avatarBackground: Color(0xFF083344),
        avatarBorder: primary,
        avatarText: primary,
        headerBackground: Color(0xFF0C1D2A),
        cardBackground: Color(0xFF122C3F),
        cardBorder: Color(0xFF1E435E),
      ),
    );
  }

  static AppThemeData _lavender() {
    const primary = Color(0xFFA855F7);
    const secondary = Color(0xFFC084FC);
    const tertiary = Color(0xFF7E22CE);
    const background = Color(0xFF0F0B1A);
    const surface = Color(0xFF18122B);
    const outline = Color(0xFF2C224D);

    return const AppThemeData(
      id: 'lavender',
      displayName: 'Lavender',
      description: 'Vibrant purple tones on deep amethyst surfaces',
      previewAsset: 'assets/themes/lavender_preview.png',
      brightness: Brightness.dark,
      isDark: true,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      surface: surface,
      surfaceContainer: Color(0xFF211B3D),
      surfaceBright: Color(0xFF312A5C),
      surfaceDim: Color(0xFF0A0712),
      outline: outline,
      outlineVariant: Color(0xFF281F48),
      success: Color(0xFF10B981),
      warning: Color(0xFFF59E0B),
      error: Color(0xFFEF4444),
      navigation: AppThemeNavigationColors(
        active: primary,
        inactive: Color(0xFF887D9C),
        background: background,
        indicator: Color(0xFF211B3D),
      ),
      planner: AppThemePlannerColors(
        highPriority: Color(0xFFEF4444),
        mediumPriority: Color(0xFFF59E0B),
        lowPriority: Color(0xFF10B981),
        progressDone: primary,
        progressTodo: Color(0xFF211B3D),
      ),
      analytics: AppThemeAnalyticsColors(
        chartPrimary: primary,
        chartSecondary: secondary,
        chartTertiary: Color(0xFFFB7185),
        ringActive: primary,
        ringInactive: Color(0xFF211B3D),
        heatmapLow: Color(0xFF1B1533),
        heatmapMedium: primary,
        heatmapHigh: secondary,
        legendText: Color(0xFF887D9C),
        cardBackground: Color(0xFF211B3D),
        cardBorder: Color(0xFF2E2657),
        progressRingActive: primary,
        progressRingInactive: Color(0xFF211B3D),
      ),
      editor: AppThemeEditorColors(
        selection: Color(0xFF581C87),
        markdownHeader: primary,
        markdownQuote: secondary,
        markdownCode: Color(0xFF18122B),
        attachmentBackground: Color(0xFF18122B),
      ),
      notes: AppThemeNotesColors(
        card: Color(0xFF211B3D),
        cardBorder: Color(0xFF2E2657),
        searchBackground: Color(0xFF211B3D),
        searchBorder: outline,
        tagBackground: Color(0xFF3B0764),
        tagText: secondary,
        highlightBackground: Color(0x66A855F7),
        chipBackground: Color(0xFF18122B),
        chipSelected: primary,
        chipText: Color(0xFF887D9C),
        chipTextSelected: Colors.white,
        fabBackground: primary,
        fabForeground: Colors.white,
        selectionBackground: Color(0x33A855F7),
        contextMenuBackground: Color(0xFF211B3D),
      ),
      dashboard: AppThemeDashboardColors(
        heroBackground: Color(0xFF211B3D),
        heroText: primary,
        quoteBackground: Color(0xFF211B3D),
        quoteBorder: Color(0xFF2E2657),
        missionCard: Color(0xFF211B3D),
        reminderCard: Color(0xFF211B3D),
        glanceCard: Color(0xFF211B3D),
        glanceBorder: Color(0xFF2E2657),
        productivityBg: Color(0xFF211B3D),
      ),
      profile: AppThemeProfileColors(
        avatarBackground: Color(0xFF3B0764),
        avatarBorder: primary,
        avatarText: primary,
        headerBackground: Color(0xFF18122B),
        cardBackground: Color(0xFF211B3D),
        cardBorder: Color(0xFF2E2657),
      ),
    );
  }

  static AppThemeData _sunset() {
    const primary = Color(0xFFF97316);
    const secondary = Color(0xFFFB923C);
    const tertiary = Color(0xFFC2410C);
    const background = Color(0xFF140D0D);
    const surface = Color(0xFF221515);
    const outline = Color(0xFF3D2525);

    return const AppThemeData(
      id: 'sunset',
      displayName: 'Sunset',
      description: 'Warm evening orange on deep reddish terracotta',
      previewAsset: 'assets/themes/sunset_preview.png',
      brightness: Brightness.dark,
      isDark: true,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      surface: surface,
      surfaceContainer: Color(0xFF2F1D1D),
      surfaceBright: Color(0xFF452C2C),
      surfaceDim: Color(0xFF0F0909),
      outline: outline,
      outlineVariant: Color(0xFF3A2424),
      success: Color(0xFF10B981),
      warning: Color(0xFFF59E0B),
      error: Color(0xFFEF4444),
      navigation: AppThemeNavigationColors(
        active: primary,
        inactive: Color(0xFF967D7D),
        background: background,
        indicator: Color(0xFF2F1D1D),
      ),
      planner: AppThemePlannerColors(
        highPriority: Color(0xFFEF4444),
        mediumPriority: Color(0xFFF59E0B),
        lowPriority: Color(0xFF10B981),
        progressDone: primary,
        progressTodo: Color(0xFF2F1D1D),
      ),
      analytics: AppThemeAnalyticsColors(
        chartPrimary: primary,
        chartSecondary: secondary,
        chartTertiary: Color(0xFFE11D48),
        ringActive: primary,
        ringInactive: Color(0xFF2F1D1D),
        heatmapLow: Color(0xFF251818),
        heatmapMedium: primary,
        heatmapHigh: secondary,
        legendText: Color(0xFF967D7D),
        cardBackground: Color(0xFF2F1D1D),
        cardBorder: Color(0xFF412B2B),
        progressRingActive: primary,
        progressRingInactive: Color(0xFF2F1D1D),
      ),
      editor: AppThemeEditorColors(
        selection: Color(0xFF7C2D12),
        markdownHeader: primary,
        markdownQuote: secondary,
        markdownCode: Color(0xFF221515),
        attachmentBackground: Color(0xFF221515),
      ),
      notes: AppThemeNotesColors(
        card: Color(0xFF2F1D1D),
        cardBorder: Color(0xFF412B2B),
        searchBackground: Color(0xFF2F1D1D),
        searchBorder: outline,
        tagBackground: Color(0xFF431407),
        tagText: secondary,
        highlightBackground: Color(0x66F97316),
        chipBackground: Color(0xFF221515),
        chipSelected: primary,
        chipText: Color(0xFF967D7D),
        chipTextSelected: Colors.white,
        fabBackground: primary,
        fabForeground: Colors.white,
        selectionBackground: Color(0x33F97316),
        contextMenuBackground: Color(0xFF2F1D1D),
      ),
      dashboard: AppThemeDashboardColors(
        heroBackground: Color(0xFF2F1D1D),
        heroText: primary,
        quoteBackground: Color(0xFF2F1D1D),
        quoteBorder: Color(0xFF412B2B),
        missionCard: Color(0xFF2F1D1D),
        reminderCard: Color(0xFF2F1D1D),
        glanceCard: Color(0xFF2F1D1D),
        glanceBorder: Color(0xFF412B2B),
        productivityBg: Color(0xFF2F1D1D),
      ),
      profile: AppThemeProfileColors(
        avatarBackground: Color(0xFF431407),
        avatarBorder: primary,
        avatarText: primary,
        headerBackground: Color(0xFF221515),
        cardBackground: Color(0xFF2F1D1D),
        cardBorder: Color(0xFF412B2B),
      ),
    );
  }

  static AppThemeData _lightTheme() {
    const primary = Color(0xFF4F46E5);
    const secondary = Color(0xFF6366F1);
    const tertiary = Color(0xFF3730C5);
    const background = Color(0xFFF8F8FA);
    const surface = Color(0xFFFFFFFF);
    const outline = Color(0xFFDFDFE8);

    return const AppThemeData(
      id: 'light',
      displayName: 'Light',
      description: 'Clean Indigo accents on bright white surfaces',
      previewAsset: 'assets/themes/light_preview.png',
      brightness: Brightness.light,
      isDark: false,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      surface: surface,
      surfaceContainer: Color(0xFFF1F1F5),
      surfaceBright: Color(0xFFFCFCFD),
      surfaceDim: Color(0xFFDFDFE8),
      outline: outline,
      outlineVariant: Color(0xFFEEEEF5),
      success: Color(0xFF16A34A),
      warning: Color(0xFFD97706),
      error: Color(0xFFDC2626),
      navigation: AppThemeNavigationColors(
        active: primary,
        inactive: Color(0xFF7E7E9A),
        background: background,
        indicator: Color(0xFFEEEEFD),
      ),
      planner: AppThemePlannerColors(
        highPriority: Color(0xFFDC2626),
        mediumPriority: Color(0xFFD97706),
        lowPriority: Color(0xFF16A34A),
        progressDone: primary,
        progressTodo: Color(0xFFEEEEF5),
      ),
      analytics: AppThemeAnalyticsColors(
        chartPrimary: primary,
        chartSecondary: secondary,
        chartTertiary: Color(0xFF818CF8),
        ringActive: primary,
        ringInactive: Color(0xFFEEEEF5),
        heatmapLow: Color(0xFFEEEDFF),
        heatmapMedium: primary,
        heatmapHigh: secondary,
        legendText: Color(0xFF7E7E9A),
        cardBackground: Color(0xFFFFFFFF),
        cardBorder: Color(0xFFE8E8EF),
        progressRingActive: primary,
        progressRingInactive: Color(0xFFEEEEF5),
      ),
      editor: AppThemeEditorColors(
        selection: Color(0xFFC7D2FE),
        markdownHeader: primary,
        markdownQuote: secondary,
        markdownCode: Color(0xFFF1F1F5),
        attachmentBackground: Color(0xFFF1F1F5),
      ),
      notes: AppThemeNotesColors(
        card: Color(0xFFFFFFFF),
        cardBorder: Color(0xFFE8E8EF),
        searchBackground: Color(0xFFF1F1F5),
        searchBorder: outline,
        tagBackground: Color(0xFFE8E7FF),
        tagText: primary,
        highlightBackground: Color(0x664F46E5),
        chipBackground: Color(0xFFF1F1F5),
        chipSelected: primary,
        chipText: Color(0xFF7E7E9A),
        chipTextSelected: Colors.white,
        fabBackground: primary,
        fabForeground: Colors.white,
        selectionBackground: Color(0x334F46E5),
        contextMenuBackground: Color(0xFFFFFFFF),
      ),
      dashboard: AppThemeDashboardColors(
        heroBackground: Color(0xFFEEEEFD),
        heroText: primary,
        quoteBackground: Color(0xFFFFFFFF),
        quoteBorder: Color(0xFFE8E8EF),
        missionCard: Color(0xFFFFFFFF),
        reminderCard: Color(0xFFFFFFFF),
        glanceCard: Color(0xFFFFFFFF),
        glanceBorder: Color(0xFFE8E8EF),
        productivityBg: Color(0xFFEEEEFD),
      ),
      profile: AppThemeProfileColors(
        avatarBackground: Color(0xFFEEEEFD),
        avatarBorder: primary,
        avatarText: primary,
        headerBackground: Color(0xFFFFFFFF),
        cardBackground: Color(0xFFFFFFFF),
        cardBorder: Color(0xFFE8E8EF),
      ),
    );
  }

  static AppThemeData _sepia() {
    const primary = Color(0xFF8B5A2B);
    const secondary = Color(0xFFA0522D);
    const tertiary = Color(0xFF5C3317);
    const background = Color(0xFFF4ECD8);
    const surface = Color(0xFFFDFBF7);
    const outline = Color(0xFFE5D5B3);

    return const AppThemeData(
      id: 'sepia',
      displayName: 'Sepia',
      description: 'Vintage warm reading tone, easy on the eyes',
      previewAsset: 'assets/themes/sepia_preview.png',
      brightness: Brightness.light,
      isDark: false,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      surface: surface,
      surfaceContainer: Color(0xFFEADFCA),
      surfaceBright: Color(0xFFFEFDFB),
      surfaceDim: Color(0xFFDDD2B8),
      outline: outline,
      outlineVariant: Color(0xFFEFE8D8),
      success: Color(0xFF2E8B57),
      warning: Color(0xFFD2691E),
      error: Color(0xFF8B0000),
      navigation: AppThemeNavigationColors(
        active: primary,
        inactive: Color(0xFF8B7E66),
        background: background,
        indicator: Color(0xFFF1E6D0),
      ),
      planner: AppThemePlannerColors(
        highPriority: Color(0xFF8B0000),
        mediumPriority: Color(0xFFD2691E),
        lowPriority: Color(0xFF2E8B57),
        progressDone: primary,
        progressTodo: Color(0xFFEFE8D8),
      ),
      analytics: AppThemeAnalyticsColors(
        chartPrimary: primary,
        chartSecondary: secondary,
        chartTertiary: Color(0xFFCD853F),
        ringActive: primary,
        ringInactive: Color(0xFFEFE8D8),
        heatmapLow: Color(0xFFF8EED9),
        heatmapMedium: primary,
        heatmapHigh: secondary,
        legendText: Color(0xFF8B7E66),
        cardBackground: Color(0xFFFDFBF7),
        cardBorder: Color(0xFFEDE3CB),
        progressRingActive: primary,
        progressRingInactive: Color(0xFFEFE8D8),
      ),
      editor: AppThemeEditorColors(
        selection: Color(0xFFF3E3CD),
        markdownHeader: primary,
        markdownQuote: secondary,
        markdownCode: Color(0xFFEADFCA),
        attachmentBackground: Color(0xFFEADFCA),
      ),
      notes: AppThemeNotesColors(
        card: Color(0xFFFDFBF7),
        cardBorder: Color(0xFFEDE3CB),
        searchBackground: Color(0xFFEADFCA),
        searchBorder: outline,
        tagBackground: Color(0xFFF3E5D8),
        tagText: primary,
        highlightBackground: Color(0x668B5A2B),
        chipBackground: Color(0xFFEADFCA),
        chipSelected: primary,
        chipText: Color(0xFF8B7E66),
        chipTextSelected: Colors.white,
        fabBackground: primary,
        fabForeground: Colors.white,
        selectionBackground: Color(0x338B5A2B),
        contextMenuBackground: Color(0xFFFDFBF7),
      ),
      dashboard: AppThemeDashboardColors(
        heroBackground: Color(0xFFF1E6D0),
        heroText: primary,
        quoteBackground: Color(0xFFFDFBF7),
        quoteBorder: Color(0xFFEDE3CB),
        missionCard: Color(0xFFFDFBF7),
        reminderCard: Color(0xFFFDFBF7),
        glanceCard: Color(0xFFFDFBF7),
        glanceBorder: Color(0xFFEDE3CB),
        productivityBg: Color(0xFFF1E6D0),
      ),
      profile: AppThemeProfileColors(
        avatarBackground: Color(0xFFF1E6D0),
        avatarBorder: primary,
        avatarText: primary,
        headerBackground: Color(0xFFFDFBF7),
        cardBackground: Color(0xFFFDFBF7),
        cardBorder: Color(0xFFEDE3CB),
      ),
    );
  }

  static AppThemeData _amoled() {
    const primary = Color(0xFFFFFFFF);
    const secondary = Color(0xFFE0E0E0);
    const tertiary = Color(0xFF8E8EA8);
    const background = Color(0xFF000000);
    const surface = Color(0xFF000000);
    const outline = Color(0xFF1F1F1F);
    const outlineVariant = Color(0xFF121212);

    return const AppThemeData(
      id: 'amoled',
      displayName: 'AMOLED Black',
      description: 'Infinite contrast with pure black backgrounds',
      previewAsset: 'assets/themes/amoled_preview.png',
      brightness: Brightness.dark,
      isDark: true,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      surface: surface,
      surfaceContainer: Color(0xFF000000),
      surfaceBright: Color(0xFF161616),
      surfaceDim: Color(0xFF000000),
      outline: outline,
      outlineVariant: outlineVariant,
      success: Color(0xFF4ADE80),
      warning: Color(0xFFFBBF24),
      error: Color(0xFFF87171),
      navigation: AppThemeNavigationColors(
        active: primary,
        inactive: Color(0xFF8E8EA8),
        background: background,
        indicator: Color(0xFF1A1A1A),
      ),
      planner: AppThemePlannerColors(
        highPriority: Color(0xFFF87171),
        mediumPriority: Color(0xFFFBBF24),
        lowPriority: Color(0xFF4ADE80),
        progressDone: primary,
        progressTodo: Color(0xFF1A1A1A),
      ),
      analytics: AppThemeAnalyticsColors(
        chartPrimary: primary,
        chartSecondary: secondary,
        chartTertiary: Color(0xFF4F46E5),
        ringActive: primary,
        ringInactive: Color(0xFF1A1A1A),
        heatmapLow: Color(0xFF0A0A0A),
        heatmapMedium: primary,
        heatmapHigh: secondary,
        legendText: Color(0xFF8E8EA8),
        cardBackground: Color(0xFF0A0A0A),
        cardBorder: Color(0xFF1A1A1A),
        progressRingActive: primary,
        progressRingInactive: Color(0xFF1A1A1A),
      ),
      editor: AppThemeEditorColors(
        selection: Color(0xFF333333),
        markdownHeader: primary,
        markdownQuote: secondary,
        markdownCode: Color(0xFF0A0A0A),
        attachmentBackground: Color(0xFF0A0A0A),
      ),
      notes: AppThemeNotesColors(
        card: Color(0xFF000000),
        cardBorder: Color(0xFF1F1F1F),
        searchBackground: Color(0xFF0A0A0A),
        searchBorder: outline,
        tagBackground: Color(0xFF1F1F1F),
        tagText: primary,
        highlightBackground: Color(0x66FFFFFF),
        chipBackground: Color(0xFF0A0A0A),
        chipSelected: primary,
        chipText: Color(0xFF8E8EA8),
        chipTextSelected: Colors.black,
        fabBackground: primary,
        fabForeground: Colors.black,
        selectionBackground: Color(0x33FFFFFF),
        contextMenuBackground: Color(0xFF0A0A0A),
      ),
      dashboard: AppThemeDashboardColors(
        heroBackground: Color(0xFF000000),
        heroText: primary,
        quoteBackground: Color(0xFF000000),
        quoteBorder: Color(0xFF1F1F1F),
        missionCard: Color(0xFF000000),
        reminderCard: Color(0xFF000000),
        glanceCard: Color(0xFF000000),
        glanceBorder: Color(0xFF1F1F1F),
        productivityBg: Color(0xFF0A0A0A),
      ),
      profile: AppThemeProfileColors(
        avatarBackground: Color(0xFF1A1A1A),
        avatarBorder: primary,
        avatarText: primary,
        headerBackground: Color(0xFF000000),
        cardBackground: Color(0xFF000000),
        cardBorder: Color(0xFF1F1F1F),
      ),
    );
  }

  static AppThemeData _graphite() {
    const primary = Color(0xFF9E9E9E);
    const secondary = Color(0xFFCCCCCC);
    const tertiary = Color(0xFF666666);
    const background = Color(0xFF121212);
    const surface = Color(0xFF1E1E1E);
    const outline = Color(0xFF2C2C2C);
    const outlineVariant = Color(0xFF3C3C3C);

    return const AppThemeData(
      id: 'graphite',
      displayName: 'Graphite',
      description: 'Sleek carbon gray tones for minimalists',
      previewAsset: 'assets/themes/graphite_preview.png',
      brightness: Brightness.dark,
      isDark: true,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      surface: surface,
      surfaceContainer: Color(0xFF1E1E1E),
      surfaceBright: Color(0xFF2C2C2C),
      surfaceDim: Color(0xFF121212),
      outline: outline,
      outlineVariant: outlineVariant,
      success: Color(0xFF34D399),
      warning: Color(0xFFFBBF24),
      error: Color(0xFFF87171),
      navigation: AppThemeNavigationColors(
        active: primary,
        inactive: Color(0xFF8E8EA8),
        background: background,
        indicator: Color(0xFF2C2C2C),
      ),
      planner: AppThemePlannerColors(
        highPriority: Color(0xFFF87171),
        mediumPriority: Color(0xFFFBBF24),
        lowPriority: Color(0xFF34D399),
        progressDone: primary,
        progressTodo: Color(0xFF2C2C2C),
      ),
      analytics: AppThemeAnalyticsColors(
        chartPrimary: primary,
        chartSecondary: secondary,
        chartTertiary: Color(0xFF6366F1),
        ringActive: primary,
        ringInactive: Color(0xFF2C2C2C),
        heatmapLow: Color(0xFF1A1A1A),
        heatmapMedium: primary,
        heatmapHigh: secondary,
        legendText: Color(0xFF8E8EA8),
        cardBackground: Color(0xFF242424),
        cardBorder: Color(0xFF2C2C2C),
        progressRingActive: primary,
        progressRingInactive: Color(0xFF2C2C2C),
      ),
      editor: AppThemeEditorColors(
        selection: Color(0xFF444444),
        markdownHeader: primary,
        markdownQuote: secondary,
        markdownCode: Color(0xFF1A1A1A),
        attachmentBackground: Color(0xFF1A1A1A),
      ),
      notes: AppThemeNotesColors(
        card: Color(0xFF242424),
        cardBorder: Color(0xFF2C2C2C),
        searchBackground: Color(0xFF242424),
        searchBorder: outline,
        tagBackground: Color(0xFF2C2C2C),
        tagText: primary,
        highlightBackground: Color(0x66FFFFFF),
        chipBackground: Color(0xFF242424),
        chipSelected: primary,
        chipText: Color(0xFF8E8EA8),
        chipTextSelected: Colors.black,
        fabBackground: primary,
        fabForeground: Colors.black,
        selectionBackground: Color(0x33FFFFFF),
        contextMenuBackground: Color(0xFF242424),
      ),
      dashboard: AppThemeDashboardColors(
        heroBackground: Color(0xFF1E1E1E),
        heroText: primary,
        quoteBackground: Color(0xFF242424),
        quoteBorder: Color(0xFF2C2C2C),
        missionCard: Color(0xFF242424),
        reminderCard: Color(0xFF242424),
        glanceCard: Color(0xFF242424),
        glanceBorder: Color(0xFF2C2C2C),
        productivityBg: Color(0xFF242424),
      ),
      profile: AppThemeProfileColors(
        avatarBackground: Color(0xFF2C2C2C),
        avatarBorder: primary,
        avatarText: primary,
        headerBackground: Color(0xFF1E1E1E),
        cardBackground: Color(0xFF242424),
        cardBorder: Color(0xFF2C2C2C),
      ),
    );
  }

  static AppThemeData _whiteMinimal() {
    const primary = Color(0xFF000000);
    const secondary = Color(0xFF333333);
    const tertiary = Color(0xFF777777);
    const background = Color(0xFFF9F9F9);
    const surface = Color(0xFFFFFFFF);
    const outline = Color(0xFFEAEAEA);
    const outlineVariant = Color(0xFFF2F2F2);

    return const AppThemeData(
      id: 'whiteMinimal',
      displayName: 'White Minimal',
      description: 'Crisp layout on pure white surfaces',
      previewAsset: 'assets/themes/white_preview.png',
      brightness: Brightness.light,
      isDark: false,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      surface: surface,
      surfaceContainer: Color(0xFFFFFFFF),
      surfaceBright: Color(0xFFF0F0F0),
      surfaceDim: Color(0xFFF5F5F5),
      outline: outline,
      outlineVariant: outlineVariant,
      success: Color(0xFF059669),
      warning: Color(0xFFD97706),
      error: Color(0xFFDC2626),
      navigation: AppThemeNavigationColors(
        active: primary,
        inactive: Color(0xFF888888),
        background: background,
        indicator: Color(0xFFEAEAEA),
      ),
      planner: AppThemePlannerColors(
        highPriority: Color(0xFFDC2626),
        mediumPriority: Color(0xFFD97706),
        lowPriority: Color(0xFF059669),
        progressDone: primary,
        progressTodo: Color(0xFFEAEAEA),
      ),
      analytics: AppThemeAnalyticsColors(
        chartPrimary: primary,
        chartSecondary: secondary,
        chartTertiary: Color(0xFF2563EB),
        ringActive: primary,
        ringInactive: Color(0xFFEAEAEA),
        heatmapLow: Color(0xFFF3F4F6),
        heatmapMedium: primary,
        heatmapHigh: secondary,
        legendText: Color(0xFF888888),
        cardBackground: Color(0xFFFFFFFF),
        cardBorder: Color(0xFFEAEAEA),
        progressRingActive: primary,
        progressRingInactive: Color(0xFFEAEAEA),
      ),
      editor: AppThemeEditorColors(
        selection: Color(0xFFE0E0E0),
        markdownHeader: primary,
        markdownQuote: secondary,
        markdownCode: Color(0xFFF3F4F6),
        attachmentBackground: Color(0xFFF3F4F6),
      ),
      notes: AppThemeNotesColors(
        card: Color(0xFFFFFFFF),
        cardBorder: Color(0xFFEAEAEA),
        searchBackground: Color(0xFFFFFFFF),
        searchBorder: outline,
        tagBackground: Color(0xFFF3F4F6),
        tagText: primary,
        highlightBackground: Color(0x66000000),
        chipBackground: Color(0xFFFFFFFF),
        chipSelected: primary,
        chipText: Color(0xFF888888),
        chipTextSelected: Colors.white,
        fabBackground: primary,
        fabForeground: Colors.white,
        selectionBackground: Color(0x33000000),
        contextMenuBackground: Color(0xFFFFFFFF),
      ),
      dashboard: AppThemeDashboardColors(
        heroBackground: Color(0xFFFFFFFF),
        heroText: primary,
        quoteBackground: Color(0xFFFFFFFF),
        quoteBorder: Color(0xFFEAEAEA),
        missionCard: Color(0xFFFFFFFF),
        reminderCard: Color(0xFFFFFFFF),
        glanceCard: Color(0xFFFFFFFF),
        glanceBorder: Color(0xFFEAEAEA),
        productivityBg: Color(0xFFFFFFFF),
      ),
      profile: AppThemeProfileColors(
        avatarBackground: Color(0xFFF3F4F6),
        avatarBorder: primary,
        avatarText: primary,
        headerBackground: Color(0xFFFFFFFF),
        cardBackground: Color(0xFFFFFFFF),
        cardBorder: Color(0xFFEAEAEA),
      ),
    );
  }

  static AppThemeData _arctic() {
    const primary = Color(0xFF0077E6);
    const secondary = Color(0xFF3399FF);
    const tertiary = Color(0xFF66B2FF);
    const background = Color(0xFFF0F8FF);
    const surface = Color(0xFFFFFFFF);
    const outline = Color(0xFFC2DFFF);
    const outlineVariant = Color(0xFFD9E9FF);

    return const AppThemeData(
      id: 'arctic',
      displayName: 'Arctic Ice',
      description: 'Cool blue highlights on frosty ice surfaces',
      previewAsset: 'assets/themes/arctic_preview.png',
      brightness: Brightness.light,
      isDark: false,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      surface: surface,
      surfaceContainer: Color(0xFFFFFFFF),
      surfaceBright: Color(0xFFEBF5FF),
      surfaceDim: Color(0xFFE6F2FF),
      outline: outline,
      outlineVariant: outlineVariant,
      success: Color(0xFF059669),
      warning: Color(0xFFD97706),
      error: Color(0xFFDC2626),
      navigation: AppThemeNavigationColors(
        active: primary,
        inactive: Color(0xFF88A2C4),
        background: background,
        indicator: Color(0xFFC2DFFF),
      ),
      planner: AppThemePlannerColors(
        highPriority: Color(0xFFDC2626),
        mediumPriority: Color(0xFFD97706),
        lowPriority: Color(0xFF059669),
        progressDone: primary,
        progressTodo: Color(0xFFC2DFFF),
      ),
      analytics: AppThemeAnalyticsColors(
        chartPrimary: primary,
        chartSecondary: secondary,
        chartTertiary: Color(0xFF7C3AED),
        ringActive: primary,
        ringInactive: Color(0xFFC2DFFF),
        heatmapLow: Color(0xFFE6F2FF),
        heatmapMedium: primary,
        heatmapHigh: secondary,
        legendText: Color(0xFF88A2C4),
        cardBackground: Color(0xFFFFFFFF),
        cardBorder: Color(0xFFC2DFFF),
        progressRingActive: primary,
        progressRingInactive: Color(0xFFC2DFFF),
      ),
      editor: AppThemeEditorColors(
        selection: Color(0xFFCCE6FF),
        markdownHeader: primary,
        markdownQuote: secondary,
        markdownCode: Color(0xFFEBF5FF),
        attachmentBackground: Color(0xFFEBF5FF),
      ),
      notes: AppThemeNotesColors(
        card: Color(0xFFFFFFFF),
        cardBorder: Color(0xFFC2DFFF),
        searchBackground: Color(0xFFFFFFFF),
        searchBorder: outline,
        tagBackground: Color(0xFFEBF5FF),
        tagText: primary,
        highlightBackground: Color(0x660077E6),
        chipBackground: Color(0xFFFFFFFF),
        chipSelected: primary,
        chipText: Color(0xFF88A2C4),
        chipTextSelected: Colors.white,
        fabBackground: primary,
        fabForeground: Colors.white,
        selectionBackground: Color(0x330077E6),
        contextMenuBackground: Color(0xFFFFFFFF),
      ),
      dashboard: AppThemeDashboardColors(
        heroBackground: Color(0xFFFFFFFF),
        heroText: primary,
        quoteBackground: Color(0xFFFFFFFF),
        quoteBorder: Color(0xFFC2DFFF),
        missionCard: Color(0xFFFFFFFF),
        reminderCard: Color(0xFFFFFFFF),
        glanceCard: Color(0xFFFFFFFF),
        glanceBorder: Color(0xFFC2DFFF),
        productivityBg: Color(0xFFFFFFFF),
      ),
      profile: AppThemeProfileColors(
        avatarBackground: Color(0xFFEBF5FF),
        avatarBorder: primary,
        avatarText: primary,
        headerBackground: Color(0xFFFFFFFF),
        cardBackground: Color(0xFFFFFFFF),
        cardBorder: Color(0xFFC2DFFF),
      ),
    );
  }

  static AppThemeData _rose() {
    const primary = Color(0xFFC71585);
    const secondary = Color(0xFFFF69B4);
    const tertiary = Color(0xFFFFB6C1);
    const background = Color(0xFF1A0A10);
    const surface = Color(0xFF2D161F);
    const outline = Color(0xFF4C2A38);
    const outlineVariant = Color(0xFF3A1F2B);

    return const AppThemeData(
      id: 'rose',
      displayName: 'Rose Wine',
      description: 'Warm burgundy tones with bright magenta highlights',
      previewAsset: 'assets/themes/rose_preview.png',
      brightness: Brightness.dark,
      isDark: true,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      surface: surface,
      surfaceContainer: Color(0xFF2D161F),
      surfaceBright: Color(0xFF3D232E),
      surfaceDim: Color(0xFF1A0A10),
      outline: outline,
      outlineVariant: outlineVariant,
      success: Color(0xFF10B981),
      warning: Color(0xFFF59E0B),
      error: Color(0xFFEF4444),
      navigation: AppThemeNavigationColors(
        active: primary,
        inactive: Color(0xFFB08C9D),
        background: background,
        indicator: Color(0xFF3A1F2B),
      ),
      planner: AppThemePlannerColors(
        highPriority: Color(0xFFEF4444),
        mediumPriority: Color(0xFFF59E0B),
        lowPriority: Color(0xFF10B981),
        progressDone: primary,
        progressTodo: Color(0xFF3A1F2B),
      ),
      analytics: AppThemeAnalyticsColors(
        chartPrimary: primary,
        chartSecondary: secondary,
        chartTertiary: Color(0xFFF59E0B),
        ringActive: primary,
        ringInactive: Color(0xFF3A1F2B),
        heatmapLow: Color(0xFF2D161F),
        heatmapMedium: primary,
        heatmapHigh: secondary,
        legendText: Color(0xFFB08C9D),
        cardBackground: Color(0xFF251119),
        cardBorder: Color(0xFF3A1F2B),
        progressRingActive: primary,
        progressRingInactive: Color(0xFF3A1F2B),
      ),
      editor: AppThemeEditorColors(
        selection: Color(0xFF5E1736),
        markdownHeader: primary,
        markdownQuote: secondary,
        markdownCode: Color(0xFF251119),
        attachmentBackground: Color(0xFF251119),
      ),
      notes: AppThemeNotesColors(
        card: Color(0xFF251119),
        cardBorder: Color(0xFF3A1F2B),
        searchBackground: Color(0xFF251119),
        searchBorder: outline,
        tagBackground: Color(0xFF3A1F2B),
        tagText: primary,
        highlightBackground: Color(0x66C71585),
        chipBackground: Color(0xFF251119),
        chipSelected: primary,
        chipText: Color(0xFFB08C9D),
        chipTextSelected: Colors.white,
        fabBackground: primary,
        fabForeground: Colors.white,
        selectionBackground: Color(0x33C71585),
        contextMenuBackground: Color(0xFF251119),
      ),
      dashboard: AppThemeDashboardColors(
        heroBackground: Color(0xFF2D161F),
        heroText: primary,
        quoteBackground: Color(0xFF251119),
        quoteBorder: Color(0xFF3A1F2B),
        missionCard: Color(0xFF251119),
        reminderCard: Color(0xFF251119),
        glanceCard: Color(0xFF251119),
        glanceBorder: Color(0xFF3A1F2B),
        productivityBg: Color(0xFF251119),
      ),
      profile: AppThemeProfileColors(
        avatarBackground: Color(0xFF3D232E),
        avatarBorder: primary,
        avatarText: primary,
        headerBackground: Color(0xFF2D161F),
        cardBackground: Color(0xFF251119),
        cardBorder: Color(0xFF3A1F2B),
      ),
    );
  }

  static AppThemeData _emerald() {
    const primary = Color(0xFF2ECC71);
    const secondary = Color(0xFF27AE60);
    const tertiary = Color(0xFF1ABC9C);
    const background = Color(0xFF04120A);
    const surface = Color(0xFF0A2416);
    const outline = Color(0xFF15442A);
    const outlineVariant = Color(0xFF0E331E);

    return const AppThemeData(
      id: 'emerald',
      displayName: 'Emerald Forest',
      description: 'Lush green hues on deep forest backgrounds',
      previewAsset: 'assets/themes/emerald_preview.png',
      brightness: Brightness.dark,
      isDark: true,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      surface: surface,
      surfaceContainer: Color(0xFF0A2416),
      surfaceBright: Color(0xFF133822),
      surfaceDim: Color(0xFF04120A),
      outline: outline,
      outlineVariant: outlineVariant,
      success: Color(0xFF2ECC71),
      warning: Color(0xFFF1C40F),
      error: Color(0xFFE74C3C),
      navigation: AppThemeNavigationColors(
        active: primary,
        inactive: Color(0xFF7FA892),
        background: background,
        indicator: Color(0xFF0E331E),
      ),
      planner: AppThemePlannerColors(
        highPriority: Color(0xFFE74C3C),
        mediumPriority: Color(0xFFF1C40F),
        lowPriority: Color(0xFF2ECC71),
        progressDone: primary,
        progressTodo: Color(0xFF0E331E),
      ),
      analytics: AppThemeAnalyticsColors(
        chartPrimary: primary,
        chartSecondary: secondary,
        chartTertiary: Color(0xFFE67E22),
        ringActive: primary,
        ringInactive: Color(0xFF0E331E),
        heatmapLow: Color(0xFF0A2416),
        heatmapMedium: primary,
        heatmapHigh: secondary,
        legendText: Color(0xFF7FA892),
        cardBackground: Color(0xFF061A0F),
        cardBorder: Color(0xFF0E331E),
        progressRingActive: primary,
        progressRingInactive: Color(0xFF0E331E),
      ),
      editor: AppThemeEditorColors(
        selection: Color(0xFF0A4E2C),
        markdownHeader: primary,
        markdownQuote: secondary,
        markdownCode: Color(0xFF061A0F),
        attachmentBackground: Color(0xFF061A0F),
      ),
      notes: AppThemeNotesColors(
        card: Color(0xFF061A0F),
        cardBorder: Color(0xFF0E331E),
        searchBackground: Color(0xFF061A0F),
        searchBorder: outline,
        tagBackground: Color(0xFF0E331E),
        tagText: primary,
        highlightBackground: Color(0x662ECC71),
        chipBackground: Color(0xFF061A0F),
        chipSelected: primary,
        chipText: Color(0xFF7FA892),
        chipTextSelected: Colors.black,
        fabBackground: primary,
        fabForeground: Colors.black,
        selectionBackground: Color(0x332ECC71),
        contextMenuBackground: Color(0xFF061A0F),
      ),
      dashboard: AppThemeDashboardColors(
        heroBackground: Color(0xFF0A2416),
        heroText: primary,
        quoteBackground: Color(0xFF061A0F),
        quoteBorder: Color(0xFF0E331E),
        missionCard: Color(0xFF061A0F),
        reminderCard: Color(0xFF061A0F),
        glanceCard: Color(0xFF061A0F),
        glanceBorder: Color(0xFF0E331E),
        productivityBg: Color(0xFF061A0F),
      ),
      profile: AppThemeProfileColors(
        avatarBackground: Color(0xFF133822),
        avatarBorder: primary,
        avatarText: primary,
        headerBackground: Color(0xFF0A2416),
        cardBackground: Color(0xFF061A0F),
        cardBorder: Color(0xFF0E331E),
      ),
    );
  }

  static AppThemeData _crimson() {
    const primary = Color(0xFFE74C3C);
    const secondary = Color(0xFFC0392B);
    const tertiary = Color(0xFFD35400);
    const background = Color(0xFF150406);
    const surface = Color(0xFF2D0A0F);
    const outline = Color(0xFF4C151B);
    const outlineVariant = Color(0xFF380E13);

    return const AppThemeData(
      id: 'crimson',
      displayName: 'Crimson Ruby',
      description: 'Striking red highlights on royal ruby borders',
      previewAsset: 'assets/themes/crimson_preview.png',
      brightness: Brightness.dark,
      isDark: true,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      surface: surface,
      surfaceContainer: Color(0xFF2D0A0F),
      surfaceBright: Color(0xFF3E1319),
      surfaceDim: Color(0xFF150406),
      outline: outline,
      outlineVariant: outlineVariant,
      success: Color(0xFF2ECC71),
      warning: Color(0xFFF1C40F),
      error: Color(0xFFE74C3C),
      navigation: AppThemeNavigationColors(
        active: primary,
        inactive: Color(0xFFB08488),
        background: background,
        indicator: Color(0xFF380E13),
      ),
      planner: AppThemePlannerColors(
        highPriority: Color(0xFFE74C3C),
        mediumPriority: Color(0xFFF1C40F),
        lowPriority: Color(0xFF2ECC71),
        progressDone: primary,
        progressTodo: Color(0xFF380E13),
      ),
      analytics: AppThemeAnalyticsColors(
        chartPrimary: primary,
        chartSecondary: secondary,
        chartTertiary: Color(0xFF9B59B6),
        ringActive: primary,
        ringInactive: Color(0xFF380E13),
        heatmapLow: Color(0xFF2D0A0F),
        heatmapMedium: primary,
        heatmapHigh: secondary,
        legendText: Color(0xFFB08488),
        cardBackground: Color(0xFF210609),
        cardBorder: Color(0xFF380E13),
        progressRingActive: primary,
        progressRingInactive: Color(0xFF380E13),
      ),
      editor: AppThemeEditorColors(
        selection: Color(0xFF5E171E),
        markdownHeader: primary,
        markdownQuote: secondary,
        markdownCode: Color(0xFF210609),
        attachmentBackground: Color(0xFF210609),
      ),
      notes: AppThemeNotesColors(
        card: Color(0xFF210609),
        cardBorder: Color(0xFF380E13),
        searchBackground: Color(0xFF210609),
        searchBorder: outline,
        tagBackground: Color(0xFF380E13),
        tagText: primary,
        highlightBackground: Color(0x66E74C3C),
        chipBackground: Color(0xFF210609),
        chipSelected: primary,
        chipText: Color(0xFFB08488),
        chipTextSelected: Colors.white,
        fabBackground: primary,
        fabForeground: Colors.white,
        selectionBackground: Color(0x33E74C3C),
        contextMenuBackground: Color(0xFF210609),
      ),
      dashboard: AppThemeDashboardColors(
        heroBackground: Color(0xFF2D0A0F),
        heroText: primary,
        quoteBackground: Color(0xFF210609),
        quoteBorder: Color(0xFF380E13),
        missionCard: Color(0xFF210609),
        reminderCard: Color(0xFF210609),
        glanceCard: Color(0xFF210609),
        glanceBorder: Color(0xFF380E13),
        productivityBg: Color(0xFF210609),
      ),
      profile: AppThemeProfileColors(
        avatarBackground: Color(0xFF3E1319),
        avatarBorder: primary,
        avatarText: primary,
        headerBackground: Color(0xFF2D0A0F),
        cardBackground: Color(0xFF210609),
        cardBorder: Color(0xFF380E13),
      ),
    );
  }

  static AppThemeData _indigo() {
    const primary = Color(0xFF9F7AEA);
    const secondary = Color(0xFFB794F4);
    const tertiary = Color(0xFF805AD5);
    const background = Color(0xFF0B071A);
    const surface = Color(0xFF170F33);
    const outline = Color(0xFF2A1F4C);
    const outlineVariant = Color(0xFF1E163B);

    return const AppThemeData(
      id: 'indigo',
      displayName: 'Indigo Royal',
      description: 'Vibrant indigo violet shades on royal night surfaces',
      previewAsset: 'assets/themes/indigo_preview.png',
      brightness: Brightness.dark,
      isDark: true,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      surface: surface,
      surfaceContainer: Color(0xFF170F33),
      surfaceBright: Color(0xFF23174C),
      surfaceDim: Color(0xFF0B071A),
      outline: outline,
      outlineVariant: outlineVariant,
      success: Color(0xFF48BB78),
      warning: Color(0xFFECC94B),
      error: Color(0xFFF56565),
      navigation: AppThemeNavigationColors(
        active: primary,
        inactive: Color(0xFF908AA6),
        background: background,
        indicator: Color(0xFF1E163B),
      ),
      planner: AppThemePlannerColors(
        highPriority: Color(0xFFF56565),
        mediumPriority: Color(0xFFECC94B),
        lowPriority: Color(0xFF48BB78),
        progressDone: primary,
        progressTodo: Color(0xFF1E163B),
      ),
      analytics: AppThemeAnalyticsColors(
        chartPrimary: primary,
        chartSecondary: secondary,
        chartTertiary: Color(0xFFED64A6),
        ringActive: primary,
        ringInactive: Color(0xFF1E163B),
        heatmapLow: Color(0xFF170F33),
        heatmapMedium: primary,
        heatmapHigh: secondary,
        legendText: Color(0xFF908AA6),
        cardBackground: Color(0xFF110A26),
        cardBorder: Color(0xFF1E163B),
        progressRingActive: primary,
        progressRingInactive: Color(0xFF1E163B),
      ),
      editor: AppThemeEditorColors(
        selection: Color(0xFF4A2B8C),
        markdownHeader: primary,
        markdownQuote: secondary,
        markdownCode: Color(0xFF110A26),
        attachmentBackground: Color(0xFF110A26),
      ),
      notes: AppThemeNotesColors(
        card: Color(0xFF110A26),
        cardBorder: Color(0xFF1E163B),
        searchBackground: Color(0xFF110A26),
        searchBorder: outline,
        tagBackground: Color(0xFF1E163B),
        tagText: primary,
        highlightBackground: Color(0x669F7AEA),
        chipBackground: Color(0xFF110A26),
        chipSelected: primary,
        chipText: Color(0xFF908AA6),
        chipTextSelected: Colors.white,
        fabBackground: primary,
        fabForeground: Colors.white,
        selectionBackground: Color(0x339F7AEA),
        contextMenuBackground: Color(0xFF110A26),
      ),
      dashboard: AppThemeDashboardColors(
        heroBackground: Color(0xFF170F33),
        heroText: primary,
        quoteBackground: Color(0xFF110A26),
        quoteBorder: Color(0xFF1E163B),
        missionCard: Color(0xFF110A26),
        reminderCard: Color(0xFF110A26),
        glanceCard: Color(0xFF110A26),
        glanceBorder: Color(0xFF1E163B),
        productivityBg: Color(0xFF110A26),
      ),
      profile: AppThemeProfileColors(
        avatarBackground: Color(0xFF23174C),
        avatarBorder: primary,
        avatarText: primary,
        headerBackground: Color(0xFF170F33),
        cardBackground: Color(0xFF110A26),
        cardBorder: Color(0xFF1E163B),
      ),
    );
  }
}
