import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../data/db/app_database.dart';
import '../../data/providers.dart';
import '../../domain/readings_analysis.dart';
import '../../l10n/app_localizations.dart';
import '../../report/report_providers.dart';
import '../common/choice_group.dart';
import '../common/choice_wrap.dart';

/// Pick 2 or 4 weeks, then share or preview the PDF. The default (2 weeks) is
/// already chosen, so one tap makes the report.
class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  int _days = 14;
  bool _busy = false;
  bool _failed = false;

  Future<void> _make({required bool share}) async {
    setState(() {
      _busy = true;
      _failed = false;
    });
    try {
      final Uint8List bytes = await ref.read(reportMakerProvider)(_days);
      final name = reportFileName(ref.read(clockProvider)());
      final actions = ref.read(pdfActionsProvider);
      await (share ? actions.share(bytes, name) : actions.preview(bytes, name));
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final fmt = ref.watch(fmtProvider);
    final patient = ref.watch(patientProvider).value;
    final today = ref.watch(todayProvider).value ?? ref.read(clockProvider)();
    final readings = ref.watch(allReadingsProvider).value ?? const <Reading>[];
    final start = DateTime(today.year, today.month, today.day - (_days - 1));
    final count = [
      for (final k in const ['blood_sugar', 'blood_pressure'])
        ...readingsInPeriod(readings, kind: k, start: start, end: today),
    ].length;
    final meds = (ref.watch(medicationsProvider).value ?? const []).where((m) => m.medication.active).length;

    return Scaffold(
      appBar: AppBar(title: Text(l.reportTitle)),
      bottomNavigationBar: _busy
          ? null
          : Material(
              color: theme.scaffoldBackgroundColor,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.share),
                        label: Text(l.reportShare),
                        onPressed: patient == null ? null : () => _make(share: true),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.print),
                        label: Text(l.reportPreview),
                        onPressed: patient == null ? null : () => _make(share: false),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Icon(Icons.description, size: 48, color: theme.colorScheme.primary),
          const SizedBox(height: 8),
          Text(l.reportIntro, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 20),
          Semantics(header: true, child: Text(l.reportPeriodTitle, style: theme.textTheme.titleLarge)),
          const SizedBox(height: 8),
          ChoiceWrap<int>(
            value: _days,
            onChanged: (d) => setState(() => _days = d),
            choices: [Choice(14, l.period2Weeks), Choice(28, l.period4Weeks)],
          ),
          const SizedBox(height: 16),
          Text(l.reportContains(fmt.n(count), fmt.n(meds)), style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.translate, size: 26, color: theme.colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(child: Text(l.reportEnglishNote, style: theme.textTheme.bodyLarge)),
          ]),
          const SizedBox(height: 12),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.lock, size: 26, color: theme.colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(child: Text(l.reportPrivacy, style: theme.textTheme.bodyLarge)),
          ]),
          if (patient == null) ...[
            const SizedBox(height: 16),
            Text(l.reportNeedProfile, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            OutlinedButton(onPressed: () => context.push('/profile/edit/0'), child: Text(l.stepAboutTitle)),
          ],
          if (_busy) ...[
            const SizedBox(height: 24),
            Row(children: [
              const SizedBox(width: 32, height: 32, child: CircularProgressIndicator()),
              const SizedBox(width: 14),
              Expanded(child: Semantics(liveRegion: true, child: Text(l.reportWorking, style: theme.textTheme.titleMedium))),
            ]),
          ],
          if (_failed) ...[
            const SizedBox(height: 24),
            Row(children: [
              Icon(Icons.error_outline, size: 30, color: theme.colorScheme.error),
              const SizedBox(width: 12),
              Expanded(
                child: Semantics(
                  liveRegion: true,
                  child: Text(l.reportFailed,
                      style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.error)),
                ),
              ),
            ]),
          ],
        ],
      ),
    );
  }
}
