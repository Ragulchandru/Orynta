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
}
