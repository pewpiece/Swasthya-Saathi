import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'data/providers.dart';
import 'features/contacts/contact_form_screen.dart';
import 'features/home/history_screen.dart';
import 'features/home/home_screen.dart';
import 'features/medicines/medicine_form_screen.dart';
import 'features/medicines/medicines_screen.dart';
import 'features/onboarding/welcome_screen.dart';
import 'features/profile/profile_hub_screen.dart';
import 'features/profile/wizard_screen.dart';
import 'features/settings/disclaimer_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/shell/app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Re-run `redirect` whenever the disclaimer flag or the patient changes.
  final refresh = ValueNotifier<int>(0);
  ref.listen(settingsProvider, (_, _) => refresh.value++);
  ref.listen(patientProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  final router = GoRouter(
    initialLocation: '/home',
    refreshListenable: refresh,
    redirect: (context, state) {
      final accepted = ref.read(settingsProvider).value?.disclaimerAccepted;
      final patient = ref.read(patientProvider);
      if (accepted == null || !patient.hasValue) return null; // still loading
      final at = state.matchedLocation;
      if (!accepted) return at == '/welcome' ? null : '/welcome';
      final hasPatient = patient.value != null;
      // No profile yet: the setup wizard is the only way forward. Once step 1
      // has saved the patient we must NOT leave /setup: the wizard itself
      // finishes with go('/home').
      if (!hasPatient) return at == '/setup' ? null : '/setup';
      if (at == '/welcome') return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/welcome', builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: '/setup', builder: (_, _) => const WizardScreen()),
      GoRoute(path: '/profile', builder: (_, _) => const ProfileHubScreen()),
      GoRoute(
        path: '/profile/edit/:step',
        builder: (_, state) {
          final n = int.tryParse(state.pathParameters['step'] ?? '') ?? 0;
          return WizardScreen(startStep: n.clamp(0, wizardSteps.length - 1), single: true);
        },
      ),
      GoRoute(
        path: '/medicine/:id',
        builder: (_, state) => MedicineFormScreen(
          medicationId: int.tryParse(state.pathParameters['id'] ?? ''),
        ),
      ),
      GoRoute(
        path: '/contact/:id',
        builder: (_, state) => ContactFormScreen(
          contactId: int.tryParse(state.pathParameters['id'] ?? ''),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/medicines', builder: (_, _) => const MedicinesScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/history', builder: (_, _) => const HistoryScreen()),
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
