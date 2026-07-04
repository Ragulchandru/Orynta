// lib/core/router/app_router.dart
//
// GoRouter configuration for Orynta.
//
// Why wrap GoRouter in a Riverpod provider?
//   1. Future auth guards: the redirect callback can call
//      ref.watch(authProvider) to redirect unauthenticated users.
//   2. Testability: inject a different router in tests via ProviderScope overrides.
//   3. Consistency: everything is in Riverpod's dependency graph.
//
// @Riverpod(keepAlive: true) means this provider NEVER disposes.
// The router must persist for the entire app lifecycle.
//
// The generated file (app_router.g.dart) is created by running:
//   dart run build_runner build --delete-conflicting-outputs

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/notes/presentation/screens/archive_screen.dart';
import '../../features/notes/presentation/screens/trash_screen.dart';
import '../../features/notes/presentation/pages/note_editor_page.dart';
import '../../features/notes/presentation/pages/notes_page.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/auth/presentation/screens/lock_screen.dart';
import '../../features/auth/presentation/providers/app_lock_provider.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/planner/presentation/screens/planner_screen.dart';
import '../../features/planner/presentation/screens/create_task_screen.dart';
import '../../features/planner/presentation/screens/task_detail_screen.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/settings/presentation/screens/appearance_screen.dart';
import '../../features/habits/presentation/screens/habits_screen.dart';
import '../../features/habits/presentation/screens/create_habit_screen.dart';
import '../../features/focus/presentation/screens/focus_screen.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../shared/widgets/main_navigation_shell.dart';
import 'route_names.dart';

// This line tells build_runner to generate app_router.g.dart.
// The generated file contains the appRouterProvider definition.
part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// A Riverpod provider that supplies the app's [GoRouter] instance.
///
/// `keepAlive: true` ensures the router is never garbage-collected
/// as long as the ProviderScope exists.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/splash',

    redirect: (BuildContext context, GoRouterState state) {
      final lockState = ref.read(appLockStateProvider);
      final isLocked = lockState.isLocked;
      final isLockingRoute = state.uri.path == '/lock';
      final isSplashRoute = state.uri.path == '/splash';
      final isOnboardingRoute = state.uri.path == '/onboarding';

      if (isSplashRoute || isOnboardingRoute) return null;

      if (isLocked) {
        if (isLockingRoute) return null;
        final target = state.uri.toString();
        return '/lock?redirect=${Uri.encodeComponent(target)}';
      }

      if (isLockingRoute) {
        final redirectTarget = state.uri.queryParameters['redirect'];
        return redirectTarget ?? '/';
      }

      return null;
    },

    routes: [
      // ── Splash Screen ────────────────────────────────────────────────────────
      GoRoute(
        path: '/splash',
        name: RouteNames.splash,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: const SplashPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCubic).animate(animation),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 350),
          );
        },
      ),

      // ── Onboarding Screen ────────────────────────────────────────────────────
      GoRoute(
        path: '/onboarding',
        name: RouteNames.onboarding,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: const OnboardingPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCubic).animate(animation),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 350),
          );
        },
      ),

      // ── Lock Screen ──────────────────────────────────────────────────────────
      GoRoute(
        path: '/lock',
        name: RouteNames.lock,
        builder: (BuildContext context, GoRouterState state) {
          final redirect = state.uri.queryParameters['redirect'] ?? '/';
          return LockScreen(
            mode: LockScreenMode.unlock,
            redirectUri: redirect,
          );
        },
      ),

      // ── Main Shell Route ────────────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationShell(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Today (Dashboard)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: RouteNames.dashboard,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),

          // Branch 1: Notes
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/notes',
                name: RouteNames.notes,
                builder: (context, state) => const NotesPage(),
              ),
            ],
          ),

          // Branch 2: Planner
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/planner',
                name: RouteNames.planner,
                builder: (context, state) => const PlannerScreen(),
              ),
            ],
          ),

          // Branch 3: Insights
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/insights',
                name: RouteNames.insights,
                builder: (context, state) => const AnalyticsScreen(),
              ),
            ],
          ),
        ],
      ),

      // ── Note Editor — Create mode ────────────────────────────────────────────
      GoRoute(
        path: '/notes/new',
        name: RouteNames.noteEditor,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          return const NoteEditorPage();
        },
      ),

      // ── Note Editor — Edit mode ──────────────────────────────────────────────
      GoRoute(
        path: '/notes/:id',
        name: RouteNames.noteDetail,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          final noteId = state.pathParameters['id']!;
          return NoteEditorPage(noteId: noteId);
        },
      ),

      // ── Archive Screen ───────────────────────────────────────────────────────
      GoRoute(
        path: '/archive',
        name: RouteNames.archive,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          return const ArchiveScreen();
        },
      ),

      // ── Trash Screen ─────────────────────────────────────────────────────────
      GoRoute(
        path: '/trash',
        name: RouteNames.trash,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          return const TrashScreen();
        },
      ),

      // ── Create Task Screen ───────────────────────────────────────────────────
      GoRoute(
        path: '/tasks/new',
        name: RouteNames.createTask,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          return const CreateTaskScreen();
        },
      ),

      // ── Task Details Screen ──────────────────────────────────────────────────
      GoRoute(
        path: '/tasks/:id',
        name: RouteNames.taskDetail,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          final id = state.pathParameters['id']!;
          return TaskDetailScreen(taskId: id);
        },
      ),

      // ── Edit Task Screen ─────────────────────────────────────────────────────
      GoRoute(
        path: '/tasks/:id/edit',
        name: RouteNames.taskEdit,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          final id = state.pathParameters['id']!;
          return CreateTaskScreen(taskId: id);
        },
      ),

      // ── Habits Screens ───────────────────────────────────────────────────────
      GoRoute(
        path: '/habits',
        name: RouteNames.habits,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          return const HabitsScreen();
        },
      ),
      GoRoute(
        path: '/habits/new',
        name: RouteNames.createHabit,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          return const CreateHabitScreen();
        },
      ),
      GoRoute(
        path: '/habits/:id/edit',
        name: RouteNames.editHabit,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          final id = state.pathParameters['id']!;
          return CreateHabitScreen(habitId: id);
        },
      ),

      // ── Focus Screen ─────────────────────────────────────────────────────────
      GoRoute(
        path: '/focus',
        name: RouteNames.focus,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          return const FocusScreen();
        },
      ),

      // ── Settings Screen ──────────────────────────────────────────────────────
      GoRoute(
        path: '/settings',
        name: RouteNames.settings,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          return const SettingsScreen();
        },
      ),

      // ── Appearance Screen ───────────────────────────────────────────────────
      GoRoute(
        path: '/appearance',
        name: RouteNames.appearance,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          return const AppearanceScreen();
        },
      ),

      // ── Profile Screen ───────────────────────────────────────────────────────
      GoRoute(
        path: '/profile',
        name: RouteNames.profile,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          return const ProfileScreen();
        },
      ),
    ],

    // Shown when the user navigates to an unknown route.
    errorBuilder: (BuildContext context, GoRouterState state) {
      return Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(
          child: Text(
            'No route found for: ${state.uri}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    },
  );

  ref.listen(appLockStateProvider, (previous, next) {
    if (previous?.isLocked != next.isLocked) {
      router.refresh();
    }
  });

  return router;
}
