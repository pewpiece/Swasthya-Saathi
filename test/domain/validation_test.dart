import 'package:care_companion/domain/number_parse.dart';
import 'package:care_companion/domain/range_validation.dart';
import 'package:flutter_test/flutter_test.dart';

RangeCheck check({
  String metric = 'blood_sugar',
  String? unit = 'mg/dL',
  double? ul,
  double? cl,
  double? ch,
  double? uh,
}) =>
    validateRange(
      metricKey: metric,
      unit: unit,
      urgentLow: ul,
      cautionLow: cl,
      cautionHigh: ch,
      urgentHigh: uh,
    );

void main() {
  group('parseDecimal / parseWholeNumber', () {
    test('Latin, Devanagari digits and comma decimal', () {
      expect(parseDecimal('120'), 120);
      expect(parseDecimal(' 5,6 '), 5.6);
      expect(parseDecimal('१२०'), 120);
      expect(parseDecimal('५.५'), 5.5);
    });
    test('rejects empty and junk', () {
      expect(parseDecimal(''), isNull);
      expect(parseDecimal(null), isNull);
      expect(parseDecimal('abc'), isNull);
      expect(parseDecimal('1.2.3'), isNull);
      expect(parseDecimal('-5'), isNull);
    });
    test('whole numbers only', () {
      expect(parseWholeNumber('85'), 85);
      expect(parseWholeNumber('85.5'), isNull);
    });
  });

  group('phone', () {
    test('accepts typical forms', () {
      expect(isPlausiblePhone('9841234567'), isTrue);
      expect(isPlausiblePhone('+977 984-123-4567'), isTrue);
      expect(isPlausiblePhone('०१-४४४४४४४'), isTrue);
      expect(isPlausiblePhone('102'), isTrue); // short emergency numbers
    });
    test('rejects typos', () {
      expect(isPlausiblePhone(''), isFalse);
      expect(isPlausiblePhone('12'), isFalse);
      expect(isPlausiblePhone('call me'), isFalse);
      expect(isPlausiblePhone('1234567890123456'), isFalse);
      expect(isPlausiblePhone(null), isFalse);
    });
    test('dialableNumber keeps digits and +', () {
      expect(dialableNumber('+977 984-123 4567'), '+9779841234567');
      expect(dialableNumber('०१-४४४४४४४'), '014444444');
    });
  });

  group('validateRange', () {
    test('all empty is fine: nothing is ever filled in for the family', () {
      expect(check().isOk, isTrue);
    });
    test('partial entry is fine', () {
      expect(check(cl: 80, ch: 140).isOk, isTrue);
      expect(check(uh: 300).isOk, isTrue);
    });
    test('must be strictly increasing', () {
      final r = check(ul: 50, cl: 70, ch: 70);
      expect(r.problem, RangeProblem.wrongOrder);
      expect(r.badField, 2);
      expect(check(cl: 140, ch: 80).problem, RangeProblem.wrongOrder);
      expect(check(ul: 90, uh: 60).badField, 3);
    });
    test('typo catchers per unit (not medical ranges)', () {
      expect(check(uh: 5000).problem, RangeProblem.implausible);
      expect(check(unit: 'mmol/L', uh: 20).isOk, isTrue);
      expect(check(unit: 'mmol/L', uh: 200).problem, RangeProblem.implausible);
      expect(check(metric: 'bp_systolic', unit: 'mmHg', uh: 1300).problem,
          RangeProblem.implausible);
    });
    test('unknown metric skips plausibility but still checks order', () {
      expect(check(metric: 'new_metric', ul: 1, cl: 2).isOk, isTrue);
      expect(check(metric: 'new_metric', ul: 3, cl: 2).problem,
          RangeProblem.wrongOrder);
    });
  });
}
