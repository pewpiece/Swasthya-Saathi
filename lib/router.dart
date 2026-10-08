import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'data/providers.dart';
import 'features/home/history_screen.dart';
import 'features/home/home_screen.dart';
import 'features/home/medicines_screen.dart';
import 'features/onboarding/welcome_screen.dart';
import 'features/settings/disclaimer_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/shell/app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Re-run `redirect` whenever the disclaimer flag changes.
  final refresh = ValueNotifier<int>(0);
  ref.listen(settingsProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  final router = GoRouter(
    initialLocation: '/home',
    refreshListenable: refresh,
    redirect: (context, state) {
      final accepted = ref.read(settingsProvider).value?.disclaimerAccepted;
      if (accepted == null) return null; // still loading; app shows a splash
      final atWelcome = state.matchedLocation == '/welcome';
      if (!accepted && !atWelcome) return '/welcome';
      if (accepted && atWelcome) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/welcome', builder: (_, _) => const WelcomeScreen()),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/medicines',
                builder: (_, _) => const MedicinesScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/history', builder: (_, _) => const HistoryScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/settings',
              builder: (_, _) => const SettingsScreen(),
              routes: [
                GoRoute(
                  path: 'disclaimer',
                  builder: (_, _) => const DisclaimerScreen(),
                ),
              ],
            ),
          ]),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
