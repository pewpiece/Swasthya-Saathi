
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../core/dates/date_formatter.dart';
import '../core/dates/date_only.dart';
import '../core/format.dart';
import '../data/enums.dart';
import '../data/providers.dart';
import '../data/repositories/medication_repository.dart';
import '../domain/report_data.dart';
import '../l10n/app_localizations.dart';
import 'pdf_report.dart';
import 'text_image.dart';

/// Loads the bundled font. Overridden in tests (assets do not load reliably
/// under the fake test clock).
final reportFontProvider = Provider<Future<Uint8List> Function()>((ref) => () async {
      final data = await rootBundle.load('assets/fonts/NotoSansDevanagari.ttf');
      return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    });

/// Draws Devanagari text as pictures for the PDF. Overridden in tests.
final textPictureRendererProvider =
    Provider<TextPictureRenderer?>((ref) => renderTextPicture);

/// Sharing / printing. Overridden in tests.
class PdfActions {
  const PdfActions({required this.share, required this.preview});
  final Future<void> Function(Uint8List bytes, String filename) share;
  final Future<void> Function(Uint8List bytes, String filename) preview;
}

final pdfActionsProvider = Provider<PdfActions>((ref) => PdfActions(
      share: (bytes, name) => Printing.sharePdf(bytes: bytes, filename: name),
      preview: (bytes, name) => Printing.layoutPdf(name: name, onLayout: (_) async => bytes),
    ));

/// What the report for [days] days would contain (for the short preview).
class ReportPreview {
  const ReportPreview(this.readings, this.medicines);
  final int readings;
  final int medicines;
}

/// Reads everything from the database and builds the data for the report.
Future<ReportData> loadReportData(Ref ref, int days) async {
  final db = ref.read(databaseProvider);
  final patient = await ref.read(profileRepositoryProvider).getPatient();
  if (patient == null) throw StateError('no patient');
  final conditions = await db.select(db.conditions).get();
  return buildReportData(
    patient: patient,
    enabledConditionKeys: [for (final c in conditions) if (c.enabled) c.conditionKey],
    metrics: await db.select(db.metrics).get(),
    ranges: await db.select(db.targetRanges).get(),
    readings: await db.select(db.readings).get(),
    meds: await MedicationRepository(db).getAll(),
    logs: await db.select(db.doseLogs).get(),
    glucoseUnit: (await db.getSettings()).glucoseUnit,
    days: days,
    now: ref.read(clockProvider)(),
  );
}

/// Makes the PDF. English text, Latin digits, AD dates (BS added in brackets
/// when the family uses BS).
Future<Uint8List> makeReportPdf(Ref ref, int days) async {
  final data = await loadReportData(ref, days);
  final settings = await ref.read(databaseProvider).getSettings();
  final l = lookupAppL10n(const Locale('en'));
  return buildReportPdf(
    data: data,
    l: l,
    fmt: const Fmt(DigitStyle.latin),
    dates: DateFormatter(l10n: l, style: settings.dateStyle, digits: DigitStyle.latin),
    fontBytes: await ref.read(reportFontProvider)(),
    renderer: ref.read(textPictureRendererProvider),
  );
}

/// No patient name in the file name (it can be seen in a share sheet).
String reportFileName(DateTime now) => 'care_companion_report_${dateKey(now)}.pdf';

/// Used by the screen: `ref.read(reportMakerProvider)(days)`.
final reportMakerProvider = Provider<Future<Uint8List> Function(int days)>(
  (ref) => (days) => makeReportPdf(ref, days),
);
