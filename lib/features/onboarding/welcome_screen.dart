import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../dev/demo_seed.dart';
import '../settings/disclaimer_card.dart';

/// First launch: short welcome + the "not medical advice" notice.
/// The only way forward is the big "I understand" button.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.monitor_heart,
                      size: 56,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Semantics(
                      header: true,
                      child: Text(
                        l.welcomeTitle,
                        style: theme.textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(l.welcomeIntro, style: theme.textTheme.bodyLarge),
                    const SizedBox(height: 24),
                    const DisclaimerCard(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (kDebugMode)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextButton.icon(
                        icon: const Icon(Icons.science),
                        label: Text(l.debugLoadDemo),
                        onPressed: () async {
                          // Debug builds only: fake data to try the screens.
                          final db = ref.read(databaseProvider);
                          await seedDemoData(db, ref.read(clockProvider)());
                          await ref
                              .read(settingsActionsProvider)
                              .acceptDisclaimer();
                          if (context.mounted) {
                            context.go('/home');
                          }
                        },
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.check),
                      label: Text(l.disclaimerAccept),
                      onPressed: () async {
                        await ref
                            .read(settingsActionsProvider)
                            .acceptDisclaimer();
                        if (context.mounted) {
                          context.go(
                            '/home',
                          ); // router sends to /setup if needed
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
