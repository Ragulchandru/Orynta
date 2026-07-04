// lib/app.dart
//
// The root widget of the Orynta application, watching theme and settings.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/design_system/design_system.dart';
import 'core/router/app_router.dart';
import 'shared/providers/theme_provider.dart';
import 'features/settings/presentation/providers/settings_provider.dart';

class OryntaApp extends ConsumerWidget {
  const OryntaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final activeTheme = ref.watch(themeModeNotifierProvider);
    final settings = ref.watch(settingsStateProvider);

    return MaterialApp.router(
      title: 'Orynta',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildTheme(
        activeTheme,
        amoledMode: settings.amoledMode,
        cornerRadius: settings.cornerRadius,
      ),
      routerConfig: router,
    );
  }
}
