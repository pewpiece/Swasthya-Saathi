import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/dates/date_formatter.dart';
import '../../data/enums.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../common/choice_group.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider).value;
    final actions = ref.read(settingsActionsProvider);
    final now = ref.watch(clockProvider)();

    if (settings == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.settingsTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final formatter = DateFormatter(
      l10n: l,
      style: settings.dateStyle,
      digits: settings.digitStyle,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ChoiceGroup<AppLanguage>(
            title: l.settingsLanguage,
            value: settings.language,
            onChanged: actions.setLanguage,
            choices: [
              Choice(AppLanguage.en, l.languageEnglish),
              Choice(AppLanguage.ne, l.languageNepali),
            ],
          ),
          const SizedBox(height: 16),
          ChoiceGroup<DateStyle>(
            title: l.settingsDateStyle,
            value: settings.dateStyle,
            onChanged: actions.setDateStyle,
            choices: [
              Choice(DateStyle.ad, l.dateStyleAd),
              Choice(DateStyle.bs, l.dateStyleBs),
            ],
          ),
          const SizedBox(height: 8),
          // Live preview = immediate feedback that the change took effect.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              l.settingsPreviewDate(formatter.format(now)),
              style: theme.textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 16),
          ChoiceGroup<GlucoseUnit>(
            title: l.settingsGlucoseUnit,
            value: settings.glucoseUnit,
            onChanged: actions.setGlucoseUnit,
            choices: [
              Choice(GlucoseUnit.mgDl, l.unitMgDl),
              Choice(GlucoseUnit.mmolL, l.unitMmolL),
            ],
          ),
          const SizedBox(height: 16),
          ChoiceGroup<DigitStyle>(
            title: l.settingsDigitStyle,
            value: settings.digitStyle,
            onChanged: actions.setDigitStyle,
            choices: [
              Choice(DigitStyle.latin, l.digitsLatin),
              Choice(DigitStyle.devanagari, l.digitsDevanagari),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.text_increase,
                          size: 28, color: theme.colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(l.settingsTextSizeHelpTitle,
                            style: theme.textTheme.titleMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(l.settingsTextSizeHelpBody,
                      style: theme.textTheme.bodyLarge),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: Icon(Icons.info_outline,
                  size: 28, color: theme.colorScheme.primary),
              title: Text(l.settingsDisclaimerTile),
              trailing: const Icon(Icons.chevron_right, size: 28),
              onTap: () => context.push('/settings/disclaimer'),
            ),
          ),
        ],
      ),
    );
  }
}
