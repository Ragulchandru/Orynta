// lib/features/settings/presentation/providers/settings_provider.dart
//
// Orynta 2.0 — Settings State and Provider using Hive persistence

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../../../core/constants/app_strings.dart';

class SettingsState {
  const SettingsState({
    required this.accentColor,
    required this.cornerRadius,
    required this.animationSpeed,
    required this.amoledMode,
    required this.followSystemTheme,
    required this.autosaveEnabled,
    required this.markdownEnabled,
    required this.defaultFontSize,
    required this.defaultFontFamily,
    required this.focusModeEnabled,
    required this.editorToolbarPosition,
    required this.weekStartsOn,
    required this.calendarView,
    required this.timeFormat24h,
    required this.dailyReminderEnabled,
    required this.dailyReminderTime,
    required this.quietHoursEnabled,
    required this.appLockEnabled,
    required this.biometricsEnabled,
  });

  final String accentColor;
  final double cornerRadius;
  final double animationSpeed;
  final bool amoledMode;
  final bool followSystemTheme;
  final bool autosaveEnabled;
  final bool markdownEnabled;
  final double defaultFontSize;
  final String defaultFontFamily;
  final bool focusModeEnabled;
  final String editorToolbarPosition;
  final String weekStartsOn;
  final String calendarView;
  final bool timeFormat24h;
  final bool dailyReminderEnabled;
  final String dailyReminderTime;
  final bool quietHoursEnabled;
  final bool appLockEnabled;
  final bool biometricsEnabled;

  factory SettingsState.initial() {
    return const SettingsState(
      accentColor: 'Default',
      cornerRadius: 16.0,
      animationSpeed: 1.0,
      amoledMode: false,
      followSystemTheme: true,
      autosaveEnabled: true,
      markdownEnabled: true,
      defaultFontSize: 14.0,
      defaultFontFamily: 'Inter',
      focusModeEnabled: false,
      editorToolbarPosition: 'Bottom',
      weekStartsOn: 'Monday',
      calendarView: 'Month',
      timeFormat24h: true,
      dailyReminderEnabled: true,
      dailyReminderTime: '09:00',
      quietHoursEnabled: false,
      appLockEnabled: false,
      biometricsEnabled: false,
    );
  }

  SettingsState copyWith({
    String? accentColor,
    double? cornerRadius,
    double? animationSpeed,
    bool? amoledMode,
    bool? followSystemTheme,
    bool? autosaveEnabled,
    bool? markdownEnabled,
    double? defaultFontSize,
    String? defaultFontFamily,
    bool? focusModeEnabled,
    String? editorToolbarPosition,
    String? weekStartsOn,
    String? calendarView,
    bool? timeFormat24h,
    bool? dailyReminderEnabled,
    String? dailyReminderTime,
    bool? quietHoursEnabled,
    bool? appLockEnabled,
    bool? biometricsEnabled,
  }) {
    return SettingsState(
      accentColor: accentColor ?? this.accentColor,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      animationSpeed: animationSpeed ?? this.animationSpeed,
      amoledMode: amoledMode ?? this.amoledMode,
      followSystemTheme: followSystemTheme ?? this.followSystemTheme,
      autosaveEnabled: autosaveEnabled ?? this.autosaveEnabled,
      markdownEnabled: markdownEnabled ?? this.markdownEnabled,
      defaultFontSize: defaultFontSize ?? this.defaultFontSize,
      defaultFontFamily: defaultFontFamily ?? this.defaultFontFamily,
      focusModeEnabled: focusModeEnabled ?? this.focusModeEnabled,
      editorToolbarPosition: editorToolbarPosition ?? this.editorToolbarPosition,
      weekStartsOn: weekStartsOn ?? this.weekStartsOn,
      calendarView: calendarView ?? this.calendarView,
      timeFormat24h: timeFormat24h ?? this.timeFormat24h,
      dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
      dailyReminderTime: dailyReminderTime ?? this.dailyReminderTime,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState.initial()) {
    loadSettings();
  }

  Box<String> get _box => Hive.box<String>(AppStrings.settingsBoxName);

  void loadSettings() {
    state = SettingsState(
      accentColor: _box.get('setting_accentColor') ?? 'Default',
      cornerRadius: double.tryParse(_box.get('setting_cornerRadius') ?? '16.0') ?? 16.0,
      animationSpeed: double.tryParse(_box.get('setting_animationSpeed') ?? '1.0') ?? 1.0,
      amoledMode: _box.get('setting_amoledMode') == 'true',
      followSystemTheme: _box.get('setting_followSystemTheme') != 'false',
      autosaveEnabled: _box.get('setting_autosaveEnabled') != 'false',
      markdownEnabled: _box.get('setting_markdownEnabled') != 'false',
      defaultFontSize: double.tryParse(_box.get('setting_defaultFontSize') ?? '14.0') ?? 14.0,
      defaultFontFamily: _box.get('setting_defaultFontFamily') ?? 'Inter',
      focusModeEnabled: _box.get('setting_focusModeEnabled') == 'true',
      editorToolbarPosition: _box.get('setting_editorToolbarPosition') ?? 'Bottom',
      weekStartsOn: _box.get('setting_weekStartsOn') ?? 'Monday',
      calendarView: _box.get('setting_calendarView') ?? 'Month',
      timeFormat24h: _box.get('setting_timeFormat24h') != 'false',
      dailyReminderEnabled: _box.get('setting_dailyReminderEnabled') != 'false',
      dailyReminderTime: _box.get('setting_dailyReminderTime') ?? '09:00',
      quietHoursEnabled: _box.get('setting_quietHoursEnabled') == 'true',
      appLockEnabled: _box.get('app_lock_enabled') == 'true',
      biometricsEnabled: _box.get('app_lock_biometrics_enabled') == 'true',
    );
  }

  Future<void> updateAccentColor(String value) async {
    state = state.copyWith(accentColor: value);
    await _box.put('setting_accentColor', value);
  }

  Future<void> updateCornerRadius(double value) async {
    state = state.copyWith(cornerRadius: value);
    await _box.put('setting_cornerRadius', value.toString());
  }

  Future<void> updateAnimationSpeed(double value) async {
    state = state.copyWith(animationSpeed: value);
    await _box.put('setting_animationSpeed', value.toString());
  }

  Future<void> updateAmoledMode(bool value) async {
    state = state.copyWith(amoledMode: value);
    await _box.put('setting_amoledMode', value.toString());
  }

  Future<void> updateFollowSystemTheme(bool value) async {
    state = state.copyWith(followSystemTheme: value);
    await _box.put('setting_followSystemTheme', value.toString());
  }

  Future<void> updateAutosaveEnabled(bool value) async {
    state = state.copyWith(autosaveEnabled: value);
    await _box.put('setting_autosaveEnabled', value.toString());
  }

  Future<void> updateMarkdownEnabled(bool value) async {
    state = state.copyWith(markdownEnabled: value);
    await _box.put('setting_markdownEnabled', value.toString());
  }

  Future<void> updateDefaultFontSize(double value) async {
    state = state.copyWith(defaultFontSize: value);
    await _box.put('setting_defaultFontSize', value.toString());
  }

  Future<void> updateDefaultFontFamily(String value) async {
    state = state.copyWith(defaultFontFamily: value);
    await _box.put('setting_defaultFontFamily', value);
  }

  Future<void> updateFocusModeEnabled(bool value) async {
    state = state.copyWith(focusModeEnabled: value);
    await _box.put('setting_focusModeEnabled', value.toString());
  }

  Future<void> updateEditorToolbarPosition(String value) async {
    state = state.copyWith(editorToolbarPosition: value);
    await _box.put('setting_editorToolbarPosition', value);
  }

  Future<void> updateWeekStartsOn(String value) async {
    state = state.copyWith(weekStartsOn: value);
    await _box.put('setting_weekStartsOn', value);
  }

  Future<void> updateCalendarView(String value) async {
    state = state.copyWith(calendarView: value);
    await _box.put('setting_calendarView', value);
  }

  Future<void> updateTimeFormat24h(bool value) async {
    state = state.copyWith(timeFormat24h: value);
    await _box.put('setting_timeFormat24h', value.toString());
  }

  Future<void> updateDailyReminderEnabled(bool value) async {
    state = state.copyWith(dailyReminderEnabled: value);
    await _box.put('setting_dailyReminderEnabled', value.toString());
  }

  Future<void> updateDailyReminderTime(String value) async {
    state = state.copyWith(dailyReminderTime: value);
    await _box.put('setting_dailyReminderTime', value);
  }

  Future<void> updateQuietHoursEnabled(bool value) async {
    state = state.copyWith(quietHoursEnabled: value);
    await _box.put('setting_quietHoursEnabled', value.toString());
  }

  Future<void> updateAppLockEnabled(bool value) async {
    state = state.copyWith(appLockEnabled: value);
    await _box.put('app_lock_enabled', value.toString());
    if (!value) {
      await _box.delete('app_lock_pin_hash');
      await _box.delete('app_lock_pin_length');
      await _box.put('app_lock_biometrics_enabled', 'false');
      state = state.copyWith(biometricsEnabled: false);
    }
  }

  Future<void> updateBiometricsEnabled(bool value) async {
    state = state.copyWith(biometricsEnabled: value);
    await _box.put('app_lock_biometrics_enabled', value.toString());
  }
}

final settingsStateProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
