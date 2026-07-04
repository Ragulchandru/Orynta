// lib/app.dart
//
// The root widget of the Orynta application.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/design_system/design_system.dart';
import 'core/router/app_router.dart';
import 'shared/providers/theme_provider.dart';

class OryntaApp extends ConsumerWidget {
  const OryntaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final activeTheme = ref.watch(themeModeNotifierProvider);

    return MaterialApp.router(
      title: 'Orynta',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildTheme(activeTheme),
      routerConfig: router,
    );
  }
}
