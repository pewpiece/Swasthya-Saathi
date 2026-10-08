import 'package:care_companion/data/enums.dart';
import 'package:care_companion/domain/reminder_rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RepeatRule', () {
    test('encode / parse round trip', () {
      for (final r in const [DailyRule(), WeeklyRule(1), WeeklyRule(7), MonthlyRule(1), MonthlyRule(28)]) {
        expect(RepeatRule.parse(r.encoded), r);
      }
      expect(const WeeklyRule(6).encoded, 'weekly:6');
      expect(const MonthlyRule(15).encoded, 'monthly:15');
    });
    test('bad text falls back to daily (never silently stops reminding)', () {
      for (final bad in ['', 'weekly:0', 'weekly:8', 'monthly:29', 'monthly:0', 'yearly', 'weekly:x', 'a:b:c']) {
        expect(RepeatRule.parse(bad), const DailyRule(), reason: bad);
      }
    });
  });

  group('nextOccurrence (strictly after now)', () {
    // 2026-10-08 is a Thursday.
    final thu9am = DateTime(2026, 10, 8, 9, 0);

    test('daily: later today, or tomorrow once the time has passed', () {
      expect(nextOccurrence(const DailyRule(), 21, 0, thu9am), DateTime(2026, 10, 8, 21));
      expect(nextOccurrence(const DailyRule(), 8, 0, thu9am), DateTime(2026, 10, 9, 8));
      expect(nextOccurrence(const DailyRule(), 9, 0, thu9am), DateTime(2026, 10, 9, 9),
          reason: 'exactly now counts as already passed');
      expect(nextOccurrence(const DailyRule(), 9, 1, thu9am), DateTime(2026, 10, 8, 9, 1));
    });
    test('daily across month and year end', () {
      expect(nextOccurrence(const DailyRule(), 8, 0, DateTime(2026, 12, 31, 23, 0)),
          DateTime(2027, 1, 1, 8));
      expect(nextOccurrence(const DailyRule(), 8, 0, DateTime(2028, 2, 28, 23, 0)),
          DateTime(2028, 2, 29, 8), reason: 'leap day');
    });
    test('weekly: next matching weekday', () {
      expect(nextOccurrence(const WeeklyRule(DateTime.saturday), 9, 0, thu9am), DateTime(2026, 10, 10, 9));
      expect(nextOccurrence(const WeeklyRule(DateTime.thursday), 10, 0, thu9am), DateTime(2026, 10, 8, 10),
          reason: 'today, later');
      expect(nextOccurrence(const WeeklyRule(DateTime.thursday), 8, 0, thu9am), DateTime(2026, 10, 15, 8),
          reason: 'today, already passed -> next week');
      expect(nextOccurrence(const WeeklyRule(DateTime.monday), 9, 0, thu9am), DateTime(2026, 10, 12, 9));
      expect(nextOccurrence(const WeeklyRule(DateTime.sunday), 9, 0, thu9am), DateTime(2026, 10, 11, 9));
    });
    test('weekly lands on the right weekday', () {
      for (var wd = 1; wd <= 7; wd++) {
        final n = nextOccurrence(WeeklyRule(wd), 7, 30, thu9am);
        expect(n.weekday, wd);
        expect(n.isAfter(thu9am), isTrue);
        expect(n.difference(thu9am).inDays, lessThanOrEqualTo(7));
      }
    });
    test('monthly: this month if still ahead, else next month; year rollover', () {
      expect(nextOccurrence(const MonthlyRule(15), 9, 0, thu9am), DateTime(2026, 10, 15, 9));
      expect(nextOccurrence(const MonthlyRule(1), 9, 0, thu9am), DateTime(2026, 11, 1, 9));
      expect(nextOccurrence(const MonthlyRule(8), 9, 0, thu9am), DateTime(2026, 11, 8, 9));
      expect(nextOccurrence(const MonthlyRule(8), 9, 1, thu9am), DateTime(2026, 10, 8, 9, 1));
      expect(nextOccurrence(const MonthlyRule(5), 9, 0, DateTime(2026, 12, 20)), DateTime(2027, 1, 5, 9));
      expect(nextOccurrence(const MonthlyRule(28), 9, 0, DateTime(2027, 1, 30)), DateTime(2027, 2, 28, 9));
    });
  });

  test('defaults: the four the spec asks for, all valid and editable', () {
    expect(defaultReminderPlan.map((d) => d.type), [
      ReminderType.medicineMorning,
      ReminderType.medicineNight,
      ReminderType.measureWeekly,
      ReminderType.measureMonthly,
    ]);
    for (final d in defaultReminderPlan) {
      expect(d.hour, inInclusiveRange(0, 23));
      expect(d.minute, inInclusiveRange(0, 59));
      expect(RepeatRule.parse(d.rule).encoded, d.rule);
    }
  });

  test('payloads: medicine opens Home, measuring opens Add reading', () {
    expect(payloadFor(ReminderType.medicineMorning), '/home');
    expect(payloadFor(ReminderType.measureWeekly), '/reading/new');
    expect(payloadFor(ReminderType.measureMonthly), '/reading/new');
  });

  test('default rule per type', () {
    expect(defaultRuleFor(ReminderType.medicineNight), const DailyRule());
    expect(defaultRuleFor(ReminderType.measureWeekly), const WeeklyRule(DateTime.saturday));
    expect(defaultRuleFor(ReminderType.measureMonthly), const MonthlyRule(1));
  });
}
