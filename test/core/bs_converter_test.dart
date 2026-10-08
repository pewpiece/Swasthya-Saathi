import 'package:care_companion/core/dates/bs_date.dart';
import 'package:care_companion/core/dates/date_only.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BsConverter known anchors (Baisakh 1 = Nepali new year)', () {
    // Independent of the package: public calendar facts.
    final anchors = <BsDate, DateTime>{
      const BsDate(2075, 1, 1): DateTime(2018, 4, 14),
      const BsDate(2077, 1, 1): DateTime(2020, 4, 13),
      const BsDate(2078, 1, 1): DateTime(2021, 4, 14),
      const BsDate(2079, 1, 1): DateTime(2022, 4, 14),
      const BsDate(2080, 1, 1): DateTime(2023, 4, 14),
      const BsDate(2081, 1, 1): DateTime(2024, 4, 13),
      const BsDate(2082, 1, 1): DateTime(2025, 4, 14),
      const BsDate(2083, 1, 1): DateTime(2026, 4, 14),
    };

    anchors.forEach((bs, ad) {
      test('$bs <-> $ad', () {
        expect(BsConverter.fromAd(ad), bs);
        expect(BsConverter.toAd(bs), ad);
      });
    });

    test('Dashain 2082: Ghatasthapana was Ashwin 6 (2025-09-22)', () {
      expect(BsConverter.fromAd(DateTime(2025, 9, 22)), const BsDate(2082, 6, 6));
    });

    test('day before Baisakh 1 is the last day of Chaitra', () {
      final bs = BsConverter.fromAd(DateTime(2025, 4, 13));
      expect(bs.year, 2081);
      expect(bs.month, 12);
      expect(bs.day, inInclusiveRange(29, 32));
    });
  });

  group('BsConverter structure', () {
    test('every day 1944-2035 round-trips and BS advances by exactly one day',
        () {
      var ad = DateTime(BsConverter.minAdYear, 1, 1);
      final end = DateTime(2035, 12, 31);
      var prev = BsConverter.fromAd(ad);
      expect(BsConverter.toAd(prev), ad);
      while (ad.isBefore(end)) {
        ad = DateTime(ad.year, ad.month, ad.day + 1); // DST-safe
        final bs = BsConverter.fromAd(ad);
        expect(BsConverter.toAd(bs), ad, reason: 'round trip $ad');
        final sameMonth = bs.year == prev.year &&
            bs.month == prev.month &&
            bs.day == prev.day + 1;
        final nextMonth = bs.day == 1 &&
            ((bs.year == prev.year && bs.month == prev.month + 1) ||
                (bs.year == prev.year + 1 && prev.month == 12 && bs.month == 1));
        expect(sameMonth || nextMonth, isTrue, reason: '$prev -> $bs at $ad');
        expect(bs.month, inInclusiveRange(1, 12));
        expect(bs.day, inInclusiveRange(1, 32));
        prev = bs;
      }
    });

    test('time of day does not change the BS date', () {
      expect(
        BsConverter.fromAd(DateTime(2025, 4, 14, 23, 59)),
        const BsDate(2082, 1, 1),
      );
    });
  });

  group('dateKey', () {
    test('formats and parses a calendar day', () {
      expect(dateKey(DateTime(2026, 10, 8, 23, 30)), '2026-10-08');
      expect(parseDateKey('2026-01-05'), DateTime(2026, 1, 5));
      expect(dateKey(parseDateKey('2024-02-29')), '2024-02-29');
    });

    test('time of day never changes the key; midnight does', () {
      expect(dateKey(DateTime(2026, 10, 8, 0, 0)), '2026-10-08');
      expect(dateKey(DateTime(2026, 10, 8, 23, 59, 59)), '2026-10-08');
      expect(dateKey(DateTime(2026, 10, 9, 0, 0, 1)), '2026-10-09');
    });
  });
}
