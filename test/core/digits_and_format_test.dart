import 'package:care_companion/core/dates/date_formatter.dart';
import 'package:care_companion/core/dates/digits.dart';
import 'package:care_companion/data/enums.dart';
import 'package:care_companion/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('convertDigits both directions, leaves other text alone', () {
    expect(convertDigits('12 Oct 2026', DigitStyle.devanagari), '१२ Oct २०२६');
    expect(convertDigits('१२ अक्टोबर', DigitStyle.latin), '12 अक्टोबर');
    expect(convertDigits('abc', DigitStyle.devanagari), 'abc');
    expect(convertDigits('', DigitStyle.latin), '');
  });

  group('DateFormatter', () {
    late AppL10n en;
    late AppL10n ne;
    setUp(() async {
      en = await AppL10n.delegate.load(const Locale('en'));
      ne = await AppL10n.delegate.load(const Locale('ne'));
    });

    final newYear = DateTime(2025, 4, 14);

    test('AD English', () {
      final f = DateFormatter(
          l10n: en, style: DateStyle.ad, digits: DigitStyle.latin);
      expect(f.format(newYear), '14 Apr 2025');
    });

    test('BS English', () {
      final f = DateFormatter(
          l10n: en, style: DateStyle.bs, digits: DigitStyle.latin);
      expect(f.format(newYear), '1 Baisakh 2082 BS');
    });

    test('BS Nepali with Devanagari digits', () {
      final f = DateFormatter(
          l10n: ne, style: DateStyle.bs, digits: DigitStyle.devanagari);
      expect(f.format(newYear), '१ बैशाख २०८२ वि.सं.');
    });

    test('digit style is independent of language', () {
      final f = DateFormatter(
          l10n: ne, style: DateStyle.ad, digits: DigitStyle.latin);
      expect(f.format(newYear), '14 अप्रिल 2025');
    });

    test('report format is always AD, BS appended when BS is on', () {
      final ad = DateFormatter(
          l10n: ne, style: DateStyle.ad, digits: DigitStyle.devanagari);
      expect(ad.formatForReport(newYear), '14 अप्रिल 2025');
      final bs = DateFormatter(
          l10n: en, style: DateStyle.bs, digits: DigitStyle.latin);
      expect(bs.formatForReport(newYear), '14 Apr 2025 (1 Baisakh 2082 BS)');
    });
  });
}
