import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/dates/date_formatter.dart';
import '../../core/format.dart';
import '../../core/format_reading.dart';
import '../../core/l10n/l10n_keys.dart';
import '../../data/db/app_database.dart';
import '../../data/enums.dart';
import '../../data/guidance_service.dart';
import '../../data/providers.dart';
import '../../domain/guidance_engine.dart';
import '../../domain/readings_analysis.dart';
import '../../l10n/app_localizations.dart';
import '../common/choice_group.dart';
import '../common/choice_wrap.dart';
import '../readings/add_reading_chooser.dart';
import '../readings/tier_banner.dart';
import 'reading_chart.dart';

/// Readings over time: a chart per measure with the doctor's range shaded, a
/// short summary, and every reading in the list (tap to open it).
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String? _kind;
  int _days = 14;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final fmt = ref.watch(fmtProvider);
    final settings = ref.watch(settingsProvider).value!;
    final all = ref.watch(allReadingsProvider).value ?? const <Reading>[];
    final today = ref.watch(todayProvider).value ?? ref.read(clockProvider)();
    final available = ref.watch(availableKindsProvider);

    // Kinds to offer: the conditions that are on, plus any kind that already
    // has readings (so old readings never disappear if a condition is off).
    final kinds = [
      for (final k in const ['blood_sugar', 'blood_pressure'])
        if (available.contains(k) || all.any((r) => r.metricKey == k)) k,
    ];

    if (kinds.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l.navHistory)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Icon(Icons.show_chart, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text(l.historyEmptyTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(l.historyEmptyBody, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: const Icon(Icons.add_circle),
              label: Text(l.addReading),
              onPressed: () => context.push('/reading/new'),
            ),
          ],
        ),
      );
    }

    final kind = kinds.contains(_kind) ? _kind! : kinds.first;
    final isSugar = kind == 'blood_sugar';
    final unit = isSugar
        ? (settings.glucoseUnit == GlucoseUnit.mmolL ? 'mmol/L' : 'mg/dL')
        : 'mmHg';
    final start = DateTime(today.year, today.month, today.day - (_days - 1));
    final readings = readingsInPeriod(all, kind: kind, start: start, end: today);
    final ranges = (ref.watch(rangesProvider).value ?? const <TargetRange>[])
        .map(rangeSpecOf)
        .toList();
    final formatter =
        DateFormatter(l10n: l, style: settings.dateStyle, digits: settings.digitStyle);

    final series = seriesFor(readings, kind, unit);
    final band = bandFor(isSugar ? 'blood_sugar' : 'bp_systolic', ranges, unit);

    String num(double v) => fmt.s(numText(v));

    List<(String, Stats)> statRows() {
      if (isSugar) return [(kindLabel(l, kind), statsOf(series.first.points.map((p) => p.y).toList(), unit))];
      final pulse = [for (final r in readings) if (r.pulse != null) r.pulse!.toDouble()];
      return [
        (l.bpTopLabel, statsOf(series[0].points.map((p) => p.y).toList(), unit)),
        (l.bpBottomLabel, statsOf(series[1].points.map((p) => p.y).toList(), unit)),
        if (pulse.isNotEmpty) (l.bpPulseLabel.replaceAll(RegExp(r'\s*\(.*\)'), ''), statsOf(pulse, 'bpm')),
      ];
    }

    final allPoints = [for (final s in series) ...s.points];
    String summary = '';
    if (allPoints.isNotEmpty) {
      final ys = allPoints.map((p) => p.y);
      summary = l.chartSummary(
        fmt.n(readings.length),
        formatter.format(readings.first.measuredAt),
        formatter.format(readings.last.measuredAt),
        num(ys.reduce((a, b) => a < b ? a : b)),
        num(ys.reduce((a, b) => a > b ? a : b)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.navHistory)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        children: [
          Semantics(header: true, child: Text(l.periodTitle, style: theme.textTheme.titleMedium)),
          const SizedBox(height: 8),
          ChoiceWrap<int>(
            value: _days,
            onChanged: (d) => setState(() => _days = d),
            choices: [
              Choice(14, l.period2Weeks),
              Choice(28, l.period4Weeks),
              Choice(90, l.period3Months),
            ],
          ),
          if (kinds.length > 1) ...[
            const SizedBox(height: 12),
            ChoiceWrap<String>(
              value: kind,
              onChanged: (k) => setState(() => _kind = k),
              choices: [for (final k in kinds) Choice(k, kindLabel(l, k))],
            ),
          ],
          const SizedBox(height: 16),
          if (readings.isEmpty) ...[
            Icon(kindIcon(kind), size: 40, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(all.any((r) => r.metricKey == kind) ? l.historyNoneInPeriod : l.historyEmptyTitle,
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(l.historyEmptyBody, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 12),
            FilledButton.icon(
              icon: const Icon(Icons.add_circle),
              label: Text(l.addReading),
              onPressed: () => context.push('/reading/new/$kind'),
            ),
          ] else ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                        header: true,
                        child: Text('${l.chartTitle} ($unit)', style: theme.textTheme.titleLarge)),
                    const SizedBox(height: 8),
                    ReadingChart(
                      series: series,
                      band: band,
                      formatter: formatter,
                      fmt: fmt,
                      semanticsLabel: summary,
                    ),
                    const SizedBox(height: 8),
                    _Legend(
                      isBp: !isSugar,
                      band: band,
                      unit: unit,
                      num: num,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(header: true, child: Text(l.statsTitle, style: theme.textTheme.titleLarge)),
                    const SizedBox(height: 6),
                    Text(l.statsCount(fmt.n(readings.length)), style: theme.textTheme.bodyLarge),
                    for (final (label, s) in statRows()) ...[
                      const SizedBox(height: 8),
                      if (!isSugar) Text(label, style: theme.textTheme.titleSmall),
                      Text(
                        '${l.statsLine(l.statsAverage, num(s.average ?? 0))}  ·  '
                        '${l.statsLine(l.statsLowest, num(s.min ?? 0))}  ·  '
                        '${l.statsLine(l.statsHighest, num(s.max ?? 0))}',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Semantics(header: true, child: Text(l.historyListTitle, style: theme.textTheme.titleLarge)),
            const SizedBox(height: 10),
            for (final r in readings.reversed) ...[
              _ReadingRow(reading: r, tier: statusOf(r, ranges), formatter: formatter),
              const SizedBox(height: 10),
            ],
          ],
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.isBp, required this.band, required this.unit, required this.num});
  final bool isBp;
  final RangeBand? band;
  final String unit;
  final String Function(double) num;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final style = Theme.of(context).textTheme.bodyMedium;
    final lines = <String>[];
    if (isBp) {
      lines..add(l.chartTopLegend)..add(l.chartBottomLegend);
    }
    final b = band;
    if (b != null && b.hasShade) {
      lines.add((isBp ? '${l.bpTopLabel}: ' : '') +
          l.chartBandLegend(
            b.cautionLow == null ? '–' : num(b.cautionLow!),
            b.cautionHigh == null ? '–' : num(b.cautionHigh!),
            unit,
          ));
    } else {
      lines.add(l.chartBandNone);
    }
    if (b != null && (b.urgentLow != null || b.urgentHigh != null)) lines.add(l.chartUrgentLegend);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [for (final t in lines) Padding(padding: const EdgeInsets.only(top: 4), child: Text(t, style: style))],
    );
  }
}

class _ReadingRow extends ConsumerWidget {
  const _ReadingRow({required this.reading, required this.tier, required this.formatter});
  final Reading reading;
  final Tier tier;
  final DateFormatter formatter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final fmt = ref.watch(fmtProvider);
    final value = readingValueText(l, fmt, reading);
    final when = l.readingMeasuredAt(formatter.format(reading.measuredAt), fmt.time(l, reading.measuredAt));
    final tag = reading.tag == null ? null : l10nByKey(l, reading.tag!);
    return Semantics(
      button: true,
      label: '$value. ${tierLabel(l, tier)}. ${tag ?? ''} $when',
      excludeSemantics: true,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push('/reading/${reading.id}'),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(value, style: theme.textTheme.headlineSmall),
                    if (reading.pulse != null)
                      Text(fmt.s(l.readingPulseLine('${reading.pulse}')), style: theme.textTheme.bodyMedium),
                    if (tag != null) Text(tag, style: theme.textTheme.bodyMedium),
                    Text(when, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 6),
                    Align(alignment: Alignment.centerLeft, child: TierChip(tier: tier)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 32),
            ]),
          ),
        ),
      ),
    );
  }
}
