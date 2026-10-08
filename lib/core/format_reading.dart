import '../data/db/app_database.dart';
import '../l10n/app_localizations.dart';
import 'format.dart';

/// `120` not `120.0`; `5.6` stays `5.6`.
String numText(double v) => v == v.roundToDouble() ? '${v.toInt()}' : '$v';

/// "126 mg/dL" or "130/85 mmHg" in the chosen digit style.
String readingValueText(AppL10n l, Fmt fmt, Reading r) {
  if (r.metricKey == 'blood_pressure') {
    return fmt.s(l.readingBpLine('${r.systolic ?? '-'}', '${r.diastolic ?? '-'}'));
  }
  return fmt.s(l.readingValueLine(numText(r.value ?? 0), r.unit));
}
