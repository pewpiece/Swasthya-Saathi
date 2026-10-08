import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/enums.dart';
import '../data/providers.dart';
import '../l10n/app_localizations.dart';
import 'dates/digits.dart';

/// Formats numbers and times in the chosen digit style (Latin or Devanagari).
class Fmt {
  const Fmt(this.digits);
  final DigitStyle digits;

  String n(num value) => convertDigits('$value', digits);
  String s(String text) => convertDigits(text, digits);

  /// 12-hour clock with AM/PM, e.g. `8:05 AM`.
  String time(AppL10n l, DateTime t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    return l.timeFormat(s('$h:$m'), t.hour < 12 ? l.timeAm : l.timePm);
  }
}

final fmtProvider = Provider<Fmt>(
  (ref) => Fmt(ref.watch(settingsProvider).value?.digitStyle ?? DigitStyle.latin),
);
