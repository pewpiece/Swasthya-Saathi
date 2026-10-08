import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'data/enums.dart';
import 'data/providers.dart';
import 'data/pin_providers.dart';
import 'data/privacy_screen.dart';
import 'data/reminder_providers.dart';
import 'features/common/error_view.dart';
import 'features/lock/lock_screen.dart';
import 'l10n/app_localizations.dart';
import 'router.dart';

class CareCompanionApp extends ConsumerWidget {
  const CareCompanionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final settings = settingsAsync.value;
    final locked = ref.watch(appLockProvider);
    final patientLoaded = ref.watch(patientProvider).hasValue;
    final router = ref.watch(routerProvider);
    ref.watch(privacyScreenSyncProvider);
    ref.watch(reminderSyncProvider); // keeps phone notifications up to date
    final locale = Locale(settings?.language.name ?? 'en');

    return MaterialApp.router(
      onGenerateTitle: (c) => AppL10n.of(c).appName,
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: AppL10n.supportedLocales,
      localizationsDelegates: const [
        AppL10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light(nepali: settings?.language == AppLanguage.ne),
      routerConfig: router,
      builder: (context, child) {
        // Wait for the first settings read so we never flash the wrong
        // language or skip the disclaimer.
        if (settingsAsync.hasError) {
          return ErrorView(onRetry: () => ref.invalidate(settingsProvider));
        }
        if (settings == null || !patientLoaded) {
          return const ColoredBox(
            color: AppColors.cream,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        // The lock sits above the app's own navigator, so it brings one of its
        // own (dialogs such as "Forgot PIN?" need it).
        if (locked) {
          return Navigator(
            onGenerateRoute: (_) =>
                MaterialPageRoute<void>(builder: (_) => const LockScreen()),
          );
        }
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
