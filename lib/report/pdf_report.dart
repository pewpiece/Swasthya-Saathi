import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../core/dates/date_formatter.dart';
import '../core/format.dart';
import '../core/l10n/l10n_keys.dart';
import '../data/enums.dart';
import '../domain/guidance_engine.dart';
import '../domain/readings_analysis.dart';
import '../domain/report_data.dart';
import '../l10n/app_localizations.dart';
import 'text_image.dart';

const _pageWidth = 523.0; // A4 (595pt) minus 2 x 36pt margins

String _num(double v) =>
    v == v.roundToDouble() ? '${v.toInt()}' : v.toStringAsFixed(1);

/// Builds the doctor report. [l] should be the English strings (the report is
/// English so any doctor can read it); [fmt] and [dates] use Latin digits and
/// AD dates (BS added in brackets if the family uses BS).
///
/// Text typed by the family that contains Devanagari is drawn through
/// [renderer] as pictures, because the PDF library cannot shape it.
Future<Uint8List> buildReportPdf({
  required ReportData data,
  required AppL10n l,
  required Fmt fmt,
  required DateFormatter dates,
  required Uint8List fontBytes,
  TextPictureRenderer? renderer,
}) async {
  final font = pw.Font.ttf(
    fontBytes.buffer.asByteData(
      fontBytes.offsetInBytes,
      fontBytes.lengthInBytes,
    ),
  );
  final pictures = <String, TextPicture>{};
  final wanted = <String, (String, double, double)>{};

  // Pass 1 finds which texts need a picture; pass 2 uses them.
  var bytes = await _build(data, l, fmt, dates, font, pictures, wanted);
  if (renderer != null && wanted.isNotEmpty) {
    for (final e in wanted.entries) {
      final (text, size, width) = e.value;
      final p = await renderer(text, size, width);
      if (p != null) pictures[e.key] = p;
    }
    wanted.clear();
    bytes = await _build(data, l, fmt, dates, font, pictures, wanted);
  }
  return bytes;
}

Future<Uint8List> _build(
  ReportData d,
  AppL10n l,
  Fmt fmt,
  DateFormatter dates,
  pw.Font font,
  Map<String, TextPicture> pictures,
  Map<String, (String, double, double)> wanted,
) async {
  const ink = PdfColors.black;
  final green = PdfColor.fromInt(0xFF1E4D33);

  pw.TextStyle style(double size, {PdfColor color = ink}) =>
      pw.TextStyle(font: font, fontSize: size, color: color, lineSpacing: 2);

  /// Text widget, or a picture when it contains Devanagari.
  pw.Widget t(
    String text, {
    double size = 10,
    double maxWidth = _pageWidth,
    PdfColor color = ink,
  }) {
    if (needsPicture(text)) {
      final key = '$size|$maxWidth|$text';
      final p = pictures[key];
      if (p == null) {
        wanted[key] = (text, size, maxWidth);
      } else {
        return pw.Image(
          pw.MemoryImage(p.png),
          width: p.width,
          height: p.height,
        );
      }
    }
    return pw.Text(text, style: style(size, color: color));
  }

  pw.Widget h(String text) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 14, bottom: 6),
    child: t(text, size: 14, color: green),
  );

  pw.Widget cell(String text, {double w = 90}) => pw.Padding(
    padding: const pw.EdgeInsets.all(3),
    child: t(text, size: 8.5, maxWidth: w),
  );

  pw.Widget table(
    List<double> widths,
    List<List<String>> rows, {
    List<String>? header,
  }) {
    pw.TableRow row(List<String> cells, {bool head = false}) => pw.TableRow(
      decoration: head
          ? const pw.BoxDecoration(color: PdfColors.grey200)
          : null,
      children: [
        for (var i = 0; i < cells.length; i++) cell(cells[i], w: widths[i] - 6),
      ],
    );
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.5),
      columnWidths: {
        for (var i = 0; i < widths.length; i++)
          i: pw.FixedColumnWidth(widths[i]),
      },
      children: [
        if (header != null) row(header, head: true),
        for (final r in rows) row(r),
      ],
    );
  }

  String tagText(String? tag) => tag == null ? '' : l10nByKey(l, tag);
  String measureName(String metricKey) => switch (metricKey) {
    'blood_sugar' => l.kindBloodSugar,
    'bp_systolic' => l.metricBloodPressureSystolic,
    'bp_diastolic' => l.metricBloodPressureDiastolic,
    _ => l10nByKey(l, metricKey == 'pulse' ? 'metricPulse' : metricKey),
  };
  String tierText(Tier tier) => switch (tier) {
    Tier.inRange => l.pdfStatusIn,
    Tier.outOfRange => l.pdfStatusOut,
    Tier.urgent => l.pdfStatusUrgent,
    Tier.unknown => l.pdfStatusNone,
  };
  String range(double? v) => v == null ? '-' : _num(v);
  String dateOnly(DateTime x) => dates.formatForReport(x);
  String readingText(dynamic r) {
    if (r.metricKey == 'blood_pressure') {
      final pulse = r.pulse == null ? '' : ', pulse ${r.pulse}';
      return '${r.systolic}/${r.diastolic} mmHg$pulse';
    }
    return '${_num(r.value ?? 0)} ${r.unit}';
  }

  String statLine(String Function(String, String, String) template, Stats s) =>
      template(_num(s.average ?? 0), _num(s.min ?? 0), _num(s.max ?? 0));

  // ---- the chart -------------------------------------------------------------
  pw.Widget chart(ReportSection sec) {
    const w = _pageWidth;
    const hgt = 170.0;
    const left = 44.0, bottom = 22.0, top = 8.0, right = 8.0;
    const plotW = w - left - right;
    const plotH = hgt - bottom - top;

    final pts = [for (final s in sec.series) ...s.points];
    var minT = pts
        .map((p) => p.at.millisecondsSinceEpoch)
        .reduce((a, b) => a < b ? a : b)
        .toDouble();
    var maxT = pts
        .map((p) => p.at.millisecondsSinceEpoch)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    if (maxT - minT < 1) {
      minT -= 12 * 3600 * 1000;
      maxT += 12 * 3600 * 1000;
    }
    final b = sec.band;
    final ys = <double>[
      for (final p in pts) p.y,
      if (b != null) ...[
        ?b.urgentLow,
        ?b.cautionLow,
        ?b.cautionHigh,
        ?b.urgentHigh,
      ],
    ];
    var minY = ys.reduce((a, c) => a < c ? a : c);
    var maxY = ys.reduce((a, c) => a > c ? a : c);
    final pad = ((maxY - minY) * 0.12).clamp(1.0, double.infinity);
    minY -= pad;
    maxY += pad;

    double mx(double tt) => left + (tt - minT) / (maxT - minT) * plotW;
    double my(double v) => bottom + (v - minY) / (maxY - minY) * plotH;

    final yTicks = niceTicks(minY, maxY);
    final xTicks = [for (var i = 0; i <= 2; i++) minT + (maxT - minT) * i / 2];

    return pw.SizedBox(
      width: w,
      height: hgt,
      child: pw.Stack(
        children: [
          pw.CustomPaint(
            size: const PdfPoint(w, hgt),
            painter: (canvas, size) {
              // shaded doctor's range
              if (b != null && b.hasShade) {
                final lo = my(b.cautionLow ?? minY);
                final hi = my(b.cautionHigh ?? maxY);
                canvas
                  ..setFillColor(PdfColors.grey300)
                  ..drawRect(left, lo, plotW, hi - lo)
                  ..fillPath();
              }
              // axes
              canvas
                ..setStrokeColor(PdfColors.grey700)
                ..setLineWidth(0.8)
                ..moveTo(left, bottom)
                ..lineTo(left, bottom + plotH)
                ..moveTo(left, bottom)
                ..lineTo(left + plotW, bottom)
                ..strokePath();
              // urgent limits (dashed)
              for (final u in [b?.urgentLow, b?.urgentHigh]) {
                if (u == null) continue;
                canvas
                  ..setStrokeColor(PdfColors.black)
                  ..setLineWidth(1)
                  ..setLineDashPattern([4, 3])
                  ..moveTo(left, my(u))
                  ..lineTo(left + plotW, my(u))
                  ..strokePath()
                  ..setLineDashPattern();
              }
              // data
              for (var i = 0; i < sec.series.length; i++) {
                final s = sec.series[i];
                if (s.points.isEmpty) continue;
                final color = i == 0 ? green : PdfColors.brown800;
                canvas
                  ..setStrokeColor(color)
                  ..setLineWidth(1.6);
                if (i > 0) canvas.setLineDashPattern([5, 3]);
                for (var k = 0; k < s.points.length; k++) {
                  final x = mx(
                    s.points[k].at.millisecondsSinceEpoch.toDouble(),
                  );
                  final y = my(s.points[k].y);
                  k == 0 ? canvas.moveTo(x, y) : canvas.lineTo(x, y);
                }
                canvas
                  ..strokePath()
                  ..setLineDashPattern()
                  ..setFillColor(color);
                for (final p in s.points) {
                  final x = mx(p.at.millisecondsSinceEpoch.toDouble());
                  final y = my(p.y);
                  // circles for the first line, squares for the second
                  i == 0
                      ? canvas.drawEllipse(x, y, 2.6, 2.6)
                      : canvas.drawRect(x - 2.4, y - 2.4, 4.8, 4.8);
                  canvas.fillPath();
                }
              }
            },
          ),
          for (final v in yTicks)
            pw.Positioned(
              left: 0,
              bottom: my(v) - 5,
              child: pw.SizedBox(
                width: left - 4,
                child: pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    _num(roundForUnit(v, sec.unit)),
                    style: style(8),
                  ),
                ),
              ),
            ),
          for (final tt in xTicks)
            pw.Positioned(
              left: (mx(tt) - 22).clamp(0.0, w - 44),
              bottom: 4,
              child: pw.SizedBox(
                width: 44,
                child: pw.Center(
                  child: pw.Text(
                    dates.formatShort(
                      DateTime.fromMillisecondsSinceEpoch(tt.round()),
                    ),
                    style: style(8),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ---- the document ----------------------------------------------------------
  final doc = pw.Document(title: l.pdfTitle(d.patientName), author: l.appName);

  final conditions = d.conditionKeys
      .map((k) => conditionLabel(l, k))
      .join(', ');
  final widgets = <pw.Widget>[
    t(l.pdfTitle(d.patientName), size: 20, color: green),
    pw.SizedBox(height: 4),
    t(l.pdfPeriodLine(dateOnly(d.start), dateOnly(d.end)), size: 11),
    t(l.pdfMadeOn(dateOnly(d.generatedAt)), size: 9),
    h(l.pdfAbout),
    if (d.age != null) t(l.pdfAge(fmt.n(d.age!)), size: 10),
    if (conditions.isNotEmpty) t(l.pdfConditions(conditions), size: 10),
    if ((d.allergies ?? '').isNotEmpty)
      t(l.pdfAllergies(d.allergies!), size: 10),
    if (d.softFood) t(l.pdfSoftFood, size: 10),
    if ((d.notes ?? '').isNotEmpty) t(l.pdfNotes(d.notes!), size: 10),

    h(l.pdfRangesTitle),
    if (d.ranges.isEmpty)
      t(l.pdfRangesNone, size: 10)
    else ...[
      table(
        [
          105,
          60,
          55,
          70,
          70,
          70,
          70,
        ].map((e) => e * (_pageWidth / 500)).toList(),
        [
          for (final r in d.ranges)
            [
              measureName(r.metricKey),
              r.tagContext == null ? l.pdfAllTimes : tagText(r.tagContext),
              r.unit ?? '',
              range(r.urgentLow),
              range(r.cautionLow),
              range(r.cautionHigh),
              range(r.urgentHigh),
            ],
        ],
        header: [
          l.pdfColMeasure,
          l.pdfColTime,
          'Unit',
          l.pdfColUrgentLow,
          l.pdfColCautionLow,
          l.pdfColCautionHigh,
          l.pdfColUrgentHigh,
        ],
      ),
      for (final r in d.ranges) ...[
        if ((r.plan ?? '').isNotEmpty) ...[
          pw.SizedBox(height: 4),
          t('${measureName(r.metricKey)}: ${l.pdfPlanLine(r.plan!)}', size: 9),
        ],
        if ((r.warning ?? '').isNotEmpty) ...[
          pw.SizedBox(height: 2),
          t(
            '${measureName(r.metricKey)}: ${l.pdfWarningLine(r.warning!)}',
            size: 9,
          ),
        ],
      ],
    ],

    for (final sec in d.sections) ...[
      h(
        l.pdfReadingsTitle(
          sec.kind == 'blood_pressure' ? l.kindBloodPressure : l.kindBloodSugar,
        ),
      ),
      if (sec.rows.isEmpty)
        t(l.pdfNoReadings, size: 10)
      else ...[
        t(l.pdfUnitLine(sec.unit), size: 9),
        pw.SizedBox(height: 4),
        if (sec.kind == 'blood_sugar')
          t(
            l.pdfStatsLine(
              fmt.n(sec.stats.single.$2.count),
              _num(sec.stats.single.$2.average ?? 0),
              _num(sec.stats.single.$2.min ?? 0),
              _num(sec.stats.single.$2.max ?? 0),
            ),
            size: 10,
          )
        else ...[
          t(l.statsCount(fmt.n(sec.rows.length)), size: 10),
          t(statLine(l.pdfTopStats, sec.stats[0].$2), size: 10),
          t(statLine(l.pdfBottomStats, sec.stats[1].$2), size: 10),
          if (sec.stats[2].$2.count > 0)
            t(statLine(l.pdfPulseStats, sec.stats[2].$2), size: 10),
        ],
        pw.SizedBox(height: 8),
        chart(sec),
        pw.SizedBox(height: 2),
        t(
          (sec.band != null && sec.band!.hasShade)
              ? (sec.kind == 'blood_pressure' ? '${l.bpTopLabel}: ' : '') +
                    l.pdfChartBand(
                      sec.band!.cautionLow == null
                          ? '-'
                          : _num(sec.band!.cautionLow!),
                      sec.band!.cautionHigh == null
                          ? '-'
                          : _num(sec.band!.cautionHigh!),
                    )
              : l.pdfChartNoBand,
          size: 8.5,
        ),
        if (sec.kind == 'blood_pressure')
          t('${l.chartTopLegend}. ${l.chartBottomLegend}.', size: 8.5),
        pw.SizedBox(height: 8),
        table(
          [118, 100, 90, 105, 110].map((e) => e * (_pageWidth / 523)).toList(),
          [
            for (final r in sec.rows)
              [
                '${dateOnly(r.reading.measuredAt)}, ${fmt.time(l, r.reading.measuredAt)}',
                readingText(r.reading),
                tagText(r.reading.tag),
                tierText(r.tier),
                r.reading.note ?? '',
              ],
          ],
          header: [
            l.pdfColDate,
            l.pdfColValue,
            l.pdfColWhen,
            l.pdfColStatus,
            l.pdfColNote,
          ],
        ),
      ],
    ],

    h(l.pdfMedicinesTitle),
    if (d.meds.isEmpty)
      t(l.pdfMedsNone, size: 10)
    else ...[
      table(
        [250, 170, 103].map((e) => e * (_pageWidth / 523)).toList(),
        [
          for (final m in d.meds)
            [
              m.name,
              m.notes ?? '',
              [
                for (final s in DoseSlot.values)
                  if (m.slots.contains(s))
                    s == DoseSlot.morning ? l.slotMorning : l.slotNight,
              ].join(', '),
            ],
        ],
        header: [l.pdfMedColName, l.noteColumnFallback, l.pdfMedColTimes],
      ),
      pw.SizedBox(height: 8),
      if (d.morning.expected > 0)
        t(
          l.pdfAdherenceLine(
            l.slotMorning,
            fmt.n(d.morning.taken),
            fmt.n(d.morning.expected),
            fmt.n(d.morning.percent),
          ),
          size: 10,
        ),
      if (d.night.expected > 0)
        t(
          l.pdfAdherenceLine(
            l.slotNight,
            fmt.n(d.night.taken),
            fmt.n(d.night.expected),
            fmt.n(d.night.percent),
          ),
          size: 10,
        ),
      pw.SizedBox(height: 4),
      t(l.pdfAdherenceNote, size: 9),
      pw.SizedBox(height: 8),
      table(
        [180, 171, 172].map((e) => e * (_pageWidth / 523)).toList(),
        [
          for (final day in d.days)
            [
              dateOnly(DateTime.parse(day.dayKey)),
              day.morning.expected == 0
                  ? '-'
                  : '${day.morning.taken}/${day.morning.expected}',
              day.night.expected == 0
                  ? '-'
                  : '${day.night.taken}/${day.night.expected}',
            ],
        ],
        header: [l.pdfDayCol, l.slotMorning, l.slotNight],
      ),
    ],
  ];

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(36),
      maxPages: 40,
      footer: (ctx) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Divider(thickness: 0.5, color: PdfColors.grey600),
          pw.Text(l.pdfDisclaimer, style: style(7.5)),
          pw.SizedBox(height: 2),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              l.pdfPage('${ctx.pageNumber}', '${ctx.pagesCount}'),
              style: style(8),
            ),
          ),
        ],
      ),
      build: (ctx) => widgets,
    ),
  );
  return doc.save();
}
