import 'package:care_companion/domain/guidance_engine.dart';
import 'package:flutter_test/flutter_test.dart';

// NOTE: every number below is a TEST FIXTURE, not medical advice. The engine
// has no numbers of its own; these stand in for "what the doctor wrote".

const sugarRange = RangeSpec(
  metricKey: 'blood_sugar',
  unit: 'mg/dL',
  urgentLow: 60,
  cautionLow: 80,
  cautionHigh: 160,
  urgentHigh: 300,
  doctorPlanText: 'PLAN-SUGAR',
  warningSignsText: 'WARN-SUGAR',
);

const sysRange = RangeSpec(
  metricKey: 'bp_systolic',
  unit: 'mmHg',
  urgentLow: 80,
  cautionLow: 100,
  cautionHigh: 140,
  urgentHigh: 180,
  doctorPlanText: 'PLAN-SYS',
);

const diaRange = RangeSpec(
  metricKey: 'bp_diastolic',
  unit: 'mmHg',
  urgentLow: 50,
  cautionLow: 60,
  cautionHigh: 90,
  urgentHigh: 110,
  doctorPlanText: 'PLAN-DIA',
);

ReadingInput sugar(double v, {String unit = 'mg/dL', String? tag}) =>
    ReadingInput(kind: 'blood_sugar', unit: unit, value: v, tag: tag);

ReadingInput bp(int s, int d, {int? pulse, String? tag}) => ReadingInput(
    kind: 'blood_pressure', unit: 'mmHg', systolic: s, diastolic: d, pulse: pulse, tag: tag);

GuidanceItem item(String id, ItemKind kind,
        {Set<Tier> tiers = const {Tier.inRange, Tier.outOfRange},
        Set<Direction> dirs = const {},
        Set<String> tags = const {},
        Set<String> allergens = const {}}) =>
    GuidanceItem(
        id: id,
        textKey: id,
        kind: kind,
        appliesToTiers: tiers,
        directions: dirs,
        tags: tags,
        allergens: allergens);

Tier sugarTier(double v, [RangeSpec r = sugarRange, String unit = 'mg/dL']) =>
    GuidanceEngine.evaluate(
      reading: sugar(v, unit: unit),
      ranges: [r],
      content: const [],
    ).tier;

void main() {
  group('tier from the doctor\'s numbers only', () {
    test('four bands', () {
      expect(sugarTier(50), Tier.urgent); // below urgent low
      expect(sugarTier(70), Tier.outOfRange); // below caution low
      expect(sugarTier(120), Tier.inRange);
      expect(sugarTier(200), Tier.outOfRange); // above caution high
      expect(sugarTier(350), Tier.urgent); // above urgent high
    });

    test('boundaries: a number ON a threshold stays in the milder tier', () {
      expect(sugarTier(60), Tier.outOfRange, reason: '= urgent low is not below it');
      expect(sugarTier(59.9), Tier.urgent);
      expect(sugarTier(80), Tier.inRange, reason: '= caution low');
      expect(sugarTier(79.9), Tier.outOfRange);
      expect(sugarTier(160), Tier.inRange, reason: '= caution high');
      expect(sugarTier(160.1), Tier.outOfRange);
      expect(sugarTier(300), Tier.outOfRange, reason: '= urgent high');
      expect(sugarTier(300.1), Tier.urgent);
    });

    test('changing the doctor\'s numbers changes the tier of the SAME reading',
        () {
      const reading = 150.0;
      expect(sugarTier(reading), Tier.inRange);
      const tighter = RangeSpec(
          metricKey: 'blood_sugar', unit: 'mg/dL', cautionHigh: 140, urgentHigh: 149);
      expect(sugarTier(reading, tighter), Tier.urgent);
    });

    test('direction is reported', () {
      GuidanceResult r(double v) => GuidanceEngine.evaluate(
          reading: sugar(v), ranges: [sugarRange], content: const []);
      expect(r(70).direction, Direction.low);
      expect(r(200).direction, Direction.high);
      expect(r(120).direction, Direction.none);
      expect(r(50).direction, Direction.low);
    });
  });

  group('missing thresholds: no range-based guidance at all', () {
    final content = [item('meal', ItemKind.meal), item('tip', ItemKind.tip)];

    test('no ranges at all -> unknown, no lists, no urgent screen', () {
      final r = GuidanceEngine.evaluate(
          reading: sugar(500), ranges: const [], content: content);
      expect(r.tier, Tier.unknown);
      expect(r.rangesMissing, isTrue);
      expect(r.showUrgentScreen, isFalse);
      expect(r.headlineKey, 'headlineNoRanges');
      expect(r.mealIdeas, isEmpty);
      expect(r.goEasyOn, isEmpty);
      expect(r.extraTips, isEmpty);
      expect(r.doctorPlanText, isNull);
    });

    test('a row with only text (no numbers) still means "no range"', () {
      final r = GuidanceEngine.evaluate(
          reading: sugar(500),
          ranges: const [
            RangeSpec(metricKey: 'blood_sugar', unit: 'mg/dL', doctorPlanText: 'x')
          ],
          content: content);
      expect(r.tier, Tier.unknown);
    });

    test('range for another metric does not apply', () {
      final r = GuidanceEngine.evaluate(
          reading: sugar(500), ranges: const [sysRange], content: content);
      expect(r.tier, Tier.unknown);
    });

    test('partial thresholds: only the entered side is judged', () {
      const highOnly =
          RangeSpec(metricKey: 'blood_sugar', unit: 'mg/dL', cautionHigh: 150);
      expect(sugarTier(10, highOnly), Tier.inRange, reason: 'no low limit entered');
      expect(sugarTier(151, highOnly), Tier.outOfRange);
      expect(sugarTier(9999, highOnly), Tier.outOfRange, reason: 'no urgent limit entered');
    });
  });

  group('unit conversion (mg/dL <-> mmol/L)', () {
    test('mmol/L reading against mg/dL range', () {
      expect(sugarTier(3.0, sugarRange, 'mmol/L'), Tier.urgent); // ~54 mg/dL
      expect(sugarTier(4.0, sugarRange, 'mmol/L'), Tier.outOfRange); // ~72
      expect(sugarTier(7.0, sugarRange, 'mmol/L'), Tier.inRange); // ~126
      expect(sugarTier(10.0, sugarRange, 'mmol/L'), Tier.outOfRange); // ~180
      expect(sugarTier(17.0, sugarRange, 'mmol/L'), Tier.urgent); // ~306
    });

    test('mg/dL reading against mmol/L range', () {
      const mmol = RangeSpec(
          metricKey: 'blood_sugar',
          unit: 'mmol/L',
          cautionLow: 4.0,
          cautionHigh: 9.0);
      expect(sugarTier(60, mmol), Tier.outOfRange); // 3.3
      expect(sugarTier(100, mmol), Tier.inRange); // 5.5
      expect(sugarTier(200, mmol), Tier.outOfRange); // 11.1
    });

    test('rounding to what a meter shows: 5.0 mmol/L == 90 mg/dL on the line',
        () {
      const mmol = RangeSpec(
          metricKey: 'blood_sugar', unit: 'mmol/L', cautionLow: 5.0);
      expect(sugarTier(90, mmol), Tier.inRange, reason: '90 mg/dL = 5.0 mmol/L');
      expect(sugarTier(89, mmol), Tier.outOfRange); // 4.9
      const mg = RangeSpec(
          metricKey: 'blood_sugar', unit: 'mg/dL', cautionHigh: 126);
      expect(sugarTier(7.0, mg, 'mmol/L'), Tier.inRange, reason: '7.0 -> 126');
      expect(sugarTier(7.1, mg, 'mmol/L'), Tier.outOfRange); // 128
    });

    test('convert is the identity for the same unit and for non-glucose', () {
      expect(GuidanceEngine.convert('blood_sugar', 5.55, 'mmol/L', 'mmol/L'), 5.55);
      expect(GuidanceEngine.convert('bp_systolic', 120, 'mmHg', 'kPa'), 120);
    });
  });

  group('blood pressure: the worse of systolic and diastolic decides', () {
    GuidanceResult run(int s, int d, {int? pulse, List<RangeSpec>? ranges}) =>
        GuidanceEngine.evaluate(
          reading: bp(s, d, pulse: pulse),
          ranges: ranges ?? [sysRange, diaRange],
          content: const [],
        );

    test('both fine', () => expect(run(120, 80).tier, Tier.inRange));
    test('systolic worse', () => expect(run(150, 80).tier, Tier.outOfRange));
    test('diastolic worse', () => expect(run(120, 95).tier, Tier.outOfRange));
    test('one urgent, one fine -> urgent', () {
      expect(run(190, 80).tier, Tier.urgent);
      expect(run(120, 115).tier, Tier.urgent);
    });
    test('caution + urgent -> urgent', () => expect(run(150, 115).tier, Tier.urgent));
    test('only systolic range entered', () {
      expect(run(150, 200, ranges: [sysRange]).tier, Tier.outOfRange,
          reason: 'diastolic has no range, so it is not judged');
    });
    test('only diastolic range entered', () {
      expect(run(300, 85, ranges: [diaRange]).tier, Tier.inRange);
    });
    test('mixed directions are reported as mixed', () {
      expect(run(150, 55).direction, Direction.mixed);
    });
    test('pulse counts only if the family entered a pulse range', () {
      const pulseRange =
          RangeSpec(metricKey: 'pulse', unit: 'bpm', urgentHigh: 150);
      expect(run(120, 80, pulse: 170).tier, Tier.inRange, reason: 'no pulse range');
      expect(run(120, 80, pulse: 170, ranges: [sysRange, diaRange, pulseRange]).tier,
          Tier.urgent);
      expect(run(120, 80, ranges: [sysRange, diaRange, pulseRange]).tier,
          Tier.inRange, reason: 'no pulse typed');
    });
    test('doctor plans of all out-of-range parts are shown once each', () {
      final r = run(150, 95);
      expect(r.doctorPlanText, 'PLAN-SYS\n\nPLAN-DIA');
    });
    test('in-range parts do not add their plan', () {
      expect(run(150, 80).doctorPlanText, 'PLAN-SYS');
    });
  });

  group('time-of-day context', () {
    const fasting = RangeSpec(
        metricKey: 'blood_sugar',
        tagContext: 'tagFasting',
        unit: 'mg/dL',
        cautionHigh: 100);
    test('a row for the same context wins over the "all times" row', () {
      final r = GuidanceEngine.evaluate(
          reading: sugar(130, tag: 'tagFasting'),
          ranges: [sugarRange, fasting],
          content: const []);
      expect(r.tier, Tier.outOfRange);
    });
    test('another context falls back to "all times"', () {
      final r = GuidanceEngine.evaluate(
          reading: sugar(130, tag: 'tagAfterMeal'),
          ranges: [sugarRange, fasting],
          content: const []);
      expect(r.tier, Tier.inRange);
    });
    test('a context row without numbers falls back too', () {
      const empty = RangeSpec(
          metricKey: 'blood_sugar', tagContext: 'tagFasting', doctorPlanText: 'x');
      final r = GuidanceEngine.evaluate(
          reading: sugar(130, tag: 'tagFasting'),
          ranges: [sugarRange, empty],
          content: const []);
      expect(r.tier, Tier.inRange);
    });
    test('only a context row exists and the reading has another tag -> unknown',
        () {
      final r = GuidanceEngine.evaluate(
          reading: sugar(130, tag: 'tagBedtime'), ranges: [fasting], content: const []);
      expect(r.tier, Tier.unknown);
    });
  });

  group('three-tier output', () {
    final meal = item('meal', ItemKind.meal, tags: {'soft'});
    final easy = item('easy', ItemKind.goEasyOn);
    final tip = item('tip', ItemKind.tip);
    final content = [meal, easy, tip];

    test('inRange: meal ideas, go easy on, tips; no doctor plan', () {
      final r = GuidanceEngine.evaluate(
          reading: sugar(120), ranges: [sugarRange], content: content);
      expect(r.tier, Tier.inRange);
      expect(r.mealIdeas.map((i) => i.id), ['meal']);
      expect(r.goEasyOn.map((i) => i.id), ['easy']);
      expect(r.extraTips.map((i) => i.id), ['tip']);
      expect(r.tellDoctor, isFalse);
      expect(r.doctorPlanText, isNull);
      expect(r.showUrgentScreen, isFalse);
      expect(r.headlineKey, 'headlineInRange');
    });

    test('outOfRange: tell his doctor + the family-entered plan', () {
      final r = GuidanceEngine.evaluate(
          reading: sugar(200), ranges: [sugarRange], content: content);
      expect(r.tier, Tier.outOfRange);
      expect(r.tellDoctor, isTrue);
      expect(r.doctorPlanText, 'PLAN-SUGAR');
      expect(r.showUrgentScreen, isFalse);
      expect(r.headlineKey, 'headlineOutOfRange');
    });

    test('urgent: ONLY the urgent screen - no meals, no tips', () {
      final r = GuidanceEngine.evaluate(
          reading: sugar(400), ranges: [sugarRange], content: content);
      expect(r.tier, Tier.urgent);
      expect(r.showUrgentScreen, isTrue);
      expect(r.mealIdeas, isEmpty);
      expect(r.goEasyOn, isEmpty);
      expect(r.extraTips, isEmpty);
      expect(r.warningSignsText, 'WARN-SUGAR');
      expect(r.headlineKey, 'headlineUrgent');
    });

    test('empty plan text is not shown', () {
      const noPlan = RangeSpec(
          metricKey: 'blood_sugar', unit: 'mg/dL', cautionHigh: 100, doctorPlanText: '  ');
      final r = GuidanceEngine.evaluate(
          reading: sugar(120), ranges: [noPlan], content: content);
      expect(r.doctorPlanText, isNull);
    });
  });

  group('safe content for each direction', () {
    final high = item('high', ItemKind.goEasyOn, dirs: {Direction.high});
    final any = item('any', ItemKind.tip);
    final inOnly =
        item('inOnly', ItemKind.meal, tiers: {Tier.inRange});
    final all = [high, any, inOnly];

    GuidanceResult at(double v) => GuidanceEngine.evaluate(
        reading: sugar(v), ranges: [sugarRange], content: all);

    test('high reading: items made for "high" appear', () {
      expect(at(200).goEasyOn.map((i) => i.id), ['high']);
    });
    test('LOW reading: no "go easy on sugar/salt" style items', () {
      final r = at(70);
      expect(r.tier, Tier.outOfRange);
      expect(r.goEasyOn, isEmpty);
      expect(r.extraTips.map((i) => i.id), ['any']);
    });
    test('mixed direction hides direction-specific items', () {
      final r = GuidanceEngine.evaluate(
          reading: bp(150, 55),
          ranges: [sysRange, diaRange],
          content: all);
      expect(r.direction, Direction.mixed);
      expect(r.goEasyOn, isEmpty);
    });
    test('items limited to the in-range tier never show when out of range', () {
      expect(at(200).mealIdeas, isEmpty);
      expect(at(120).mealIdeas.map((i) => i.id), ['inOnly']);
    });
    test('in range ignores direction restrictions', () {
      expect(at(120).goEasyOn.map((i) => i.id), ['high']);
    });
  });

  group('restrictions', () {
    final egg = item('egg', ItemKind.meal, tags: {'soft'}, allergens: {'egg'});
    final curd = item('curd', ItemKind.meal, tags: {'soft'}, allergens: {'dairy'});
    final roti = item('roti', ItemKind.meal, tags: {'needs_chewing'});
    final plain = item('plain', ItemKind.meal);
    final soft = item('soft', ItemKind.meal, tags: {'soft'});
    final content = [egg, curd, roti, plain, soft];

    List<String> meals(Restrictions r) => GuidanceEngine.evaluate(
            reading: sugar(120),
            ranges: [sugarRange],
            content: content,
            restrictions: r)
        .mealIdeas
        .map((i) => i.id)
        .toList();

    test('no restrictions: everything', () {
      expect(meals(const Restrictions()), ['egg', 'curd', 'roti', 'plain', 'soft']);
    });
    test('allergy text hides matching items (English words)', () {
      expect(meals(const Restrictions(allergies: 'Allergic to EGGS and peanuts')),
          ['curd', 'roti', 'plain', 'soft']);
      expect(meals(const Restrictions(allergies: 'milk')),
          ['egg', 'roti', 'plain', 'soft']);
    });
    test('allergy text in Nepali also works', () {
      expect(meals(const Restrictions(allergies: 'दही नमिल्ने')),
          ['egg', 'roti', 'plain', 'soft']);
    });
    test('soft-food flag: only soft meals, never "needs chewing"', () {
      expect(meals(const Restrictions(softFood: true)), ['egg', 'curd', 'soft']);
    });
    test('soft + allergy combine', () {
      expect(meals(const Restrictions(softFood: true, allergies: 'egg')),
          ['curd', 'soft']);
    });
    test('fasting adds the doctor note and removes nothing', () {
      final r = GuidanceEngine.evaluate(
          reading: sugar(120),
          ranges: [sugarRange],
          content: content,
          restrictions: const Restrictions(fastingToday: true));
      expect(r.fastingNote, isTrue);
      expect(r.mealIdeas.length, 5);
    });
    test('fasting note also shows when ranges are missing', () {
      final r = GuidanceEngine.evaluate(
          reading: sugar(120),
          ranges: const [],
          content: content,
          restrictions: const Restrictions(fastingToday: true));
      expect(r.fastingNote, isTrue);
    });
  });

  test('unreviewed content is flagged', () {
    final r = GuidanceEngine.evaluate(
        reading: sugar(120),
        ranges: [sugarRange],
        content: [item('a', ItemKind.tip)]);
    expect(r.hasUnreviewed, isTrue);
  });
}
