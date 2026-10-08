import '../../data/enums.dart';
import '../../l10n/app_localizations.dart';
import 'bs_date.dart';
import 'digits.dart';

/// Formats a stored AD date for display in the chosen calendar, language and
/// digit style. Sorting and charts always use the underlying AD DateTime.
class DateFormatter {
  const DateFormatter({
    required this.l10n,
    required this.style,
    required this.digits,
  });

  final AppL10n l10n;
  final DateStyle style;
  final DigitStyle digits;

  String format(DateTime ad) {
    final String text;
    if (style == DateStyle.bs) {
      final bs = BsConverter.fromAd(ad);
      text = l10n.bsDateFormat(
        '${bs.day}',
        _bsMonth(bs.month),
        '${bs.year}',
      );
    } else {
      text = l10n.adDateFormat(
        '${ad.day}',
        _adMonth(ad.month),
        '${ad.year}',
      );
    }
    return convertDigits(text, digits);
  }

  /// Short form for chart axes: `8 Oct` / `22 Ashwin` (no year).
  String formatShort(DateTime ad) {
    final String text;
    if (style == DateStyle.bs) {
      final bs = BsConverter.fromAd(ad);
      text = '${bs.day} ${_bsMonth(bs.month)}';
    } else {
      text = '${ad.day} ${_adMonth(ad.month)}';
    }
    return convertDigits(text, digits);
  }

  /// AD always, BS appended when the setting is BS. Used on the doctor report,
  /// where the doctor must be able to read an AD date.
  String formatForReport(DateTime ad) {
    final adText = convertDigits(
      l10n.adDateFormat('${ad.day}', _adMonth(ad.month), '${ad.year}'),
      DigitStyle.latin,
    );
    if (style != DateStyle.bs) return adText;
    return '$adText (${format(ad)})';
  }

  String _bsMonth(int m) => switch (m) {
        1 => l10n.bsMonth1,
        2 => l10n.bsMonth2,
        3 => l10n.bsMonth3,
        4 => l10n.bsMonth4,
        5 => l10n.bsMonth5,
        6 => l10n.bsMonth6,
        7 => l10n.bsMonth7,
        8 => l10n.bsMonth8,
        9 => l10n.bsMonth9,
        10 => l10n.bsMonth10,
        11 => l10n.bsMonth11,
        _ => l10n.bsMonth12,
      };

  String _adMonth(int m) => switch (m) {
        1 => l10n.adMonth1,
        2 => l10n.adMonth2,
        3 => l10n.adMonth3,
        4 => l10n.adMonth4,
        5 => l10n.adMonth5,
        6 => l10n.adMonth6,
        7 => l10n.adMonth7,
        8 => l10n.adMonth8,
        9 => l10n.adMonth9,
        10 => l10n.adMonth10,
        11 => l10n.adMonth11,
        _ => l10n.adMonth12,
      };
}
