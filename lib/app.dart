import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'data/enums.dart';
import 'data/providers.dart';
import 'l10n/app_localizations.dart';
import 'router.dart';

class CareCompanionApp extends ConsumerWidget {
  const CareCompanionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).value;
    final router = ref.watch(routerProvider);
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
        if (settings == null) {
          return const ColoredBox(
            color: AppColors.cream,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
