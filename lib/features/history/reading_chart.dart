import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/dates/date_formatter.dart';
import '../../core/format.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/readings_analysis.dart';

/// Line chart of one reading kind with the doctor's range shaded.
/// Not interactive on purpose (no tap/drag needed); the same numbers are in
/// the list below, and a spoken summary is given to the screen reader.
class ReadingChart extends StatelessWidget {
  const ReadingChart({
    super.key,
    required this.series,
    required this.band,
    required this.formatter,
    required this.fmt,
    required this.semanticsLabel,
  });

  final List<ChartSeries> series;
  final RangeBand? band; // for the FIRST series (sugar / top number)
  final DateFormatter formatter;
  final Fmt fmt;
  final String semanticsLabel;

  static const _lineColors = [AppColors.green, AppColors.cautionFg];

  @override
  Widget build(BuildContext context) {
    final all = [for (final s in series) ...s.points];
    if (all.isEmpty) return const SizedBox.shrink();

    var minX = all.map((p) => p.at.millisecondsSinceEpoch.toDouble()).reduce((a, b) => a < b ? a : b);
    var maxX = all.map((p) => p.at.millisecondsSinceEpoch.toDouble()).reduce((a, b) => a > b ? a : b);
    if (maxX - minX < 1) {
      minX -= 12 * 3600 * 1000; // a single day: give it some room
      maxX += 12 * 3600 * 1000;
    }

    final ys = <double>[
      for (final p in all) p.y,
      if (band != null) ...[
        ?band!.urgentLow,
        ?band!.cautionLow,
        ?band!.cautionHigh,
        ?band!.urgentHigh,
      ],
    ];
    var minY = ys.reduce((a, b) => a < b ? a : b);
    var maxY = ys.reduce((a, b) => a > b ? a : b);
    final pad = ((maxY - minY) * 0.12).clamp(1.0, double.infinity);
    minY -= pad;
    maxY += pad;

    final theme = Theme.of(context);
    const axisStyle = TextStyle(fontSize: 15, color: AppColors.ink, fontWeight: FontWeight.w600);

    Widget axisText(String t) => Text(t, style: axisStyle, textScaler: TextScaler.noScaling);

    final lines = <LineChartBarData>[];
    for (var i = 0; i < series.length; i++) {
      final color = _lineColors[i % _lineColors.length];
      final dashed = i > 0;
      lines.add(LineChartBarData(
        spots: [for (final p in series[i].points) FlSpot(p.at.millisecondsSinceEpoch.toDouble(), p.y)],
        isCurved: false,
        color: color,
        barWidth: 3,
        dashArray: dashed ? [8, 5] : null,
        dotData: FlDotData(
          getDotPainter: (spot, percent, bar, index) => dashed
              ? FlDotSquarePainter(size: 9, color: color, strokeWidth: 0)
              : FlDotCirclePainter(radius: 5, color: color, strokeWidth: 0),
        ),
      ));
    }

    final shade = <HorizontalRangeAnnotation>[];
    final b = band;
    if (b != null && b.hasShade) {
      shade.add(HorizontalRangeAnnotation(
        y1: b.cautionLow ?? minY,
        y2: b.cautionHigh ?? maxY,
        color: AppColors.inRangeBg,
      ));
    }
    final urgentLines = <HorizontalLine>[
      if (b?.urgentLow != null)
        HorizontalLine(y: b!.urgentLow!, color: AppColors.urgentFg, strokeWidth: 2, dashArray: [10, 6]),
      if (b?.urgentHigh != null)
        HorizontalLine(y: b!.urgentHigh!, color: AppColors.urgentFg, strokeWidth: 2, dashArray: [10, 6]),
    ];

    return Semantics(
      container: true,
      label: semanticsLabel,
      image: true,
      excludeSemantics: true,
      child: SizedBox(
        height: 260,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 12, 0),
          child: LineChart(
            LineChartData(
              minX: minX,
              maxX: maxX,
              minY: minY,
              maxY: maxY,
              lineTouchData: const LineTouchData(enabled: false),
              lineBarsData: lines,
              rangeAnnotations: RangeAnnotations(horizontalRangeAnnotations: shade),
              extraLinesData: ExtraLinesData(horizontalLines: urgentLines),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) =>
                    FlLine(color: theme.dividerTheme.color ?? Colors.black12, strokeWidth: 1),
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  left: BorderSide(color: AppColors.outline),
                  bottom: BorderSide(color: AppColors.outline),
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 52,
                    maxIncluded: false,
                    minIncluded: false,
                    getTitlesWidget: (v, meta) => SideTitleWidget(
                      meta: meta,
                      child: axisText(fmt.s(v == v.roundToDouble() ? '${v.toInt()}' : v.toStringAsFixed(1))),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 34,
                    interval: (maxX - minX) / 3,
                    getTitlesWidget: (v, meta) {
                      final d = DateTime.fromMillisecondsSinceEpoch(v.round());
                      return SideTitleWidget(meta: meta, child: axisText(formatter.formatShort(d)));
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
