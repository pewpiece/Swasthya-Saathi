import '../data/enums.dart';

/// How often a reminder repeats. Stored as text in `Reminder.repeatRule`:
/// `daily`, `weekly:<1-7>` (Monday = 1 ... Sunday = 7) or `monthly:<1-28>`.
/// Monthly stops at 28 so every month has that day.
sealed class RepeatRule {
  const RepeatRule();

  String get encoded;

  static RepeatRule parse(String text) {
    if (text == 'daily') return const DailyRule();
    final parts = text.split(':');
    if (parts.length == 2) {
      final n = int.tryParse(parts[1]);
      if (parts[0] == 'weekly' && n != null && n >= 1 && n <= 7) return WeeklyRule(n);
      if (parts[0] == 'monthly' && n != null && n >= 1 && n <= 28) return MonthlyRule(n);
    }
    // Unknown text (should not happen): safest is the most frequent rule.
    return const DailyRule();
  }

  @override
  bool operator ==(Object other) => other is RepeatRule && other.encoded == encoded;

  @override
  int get hashCode => encoded.hashCode;
}

class DailyRule extends RepeatRule {
  const DailyRule();
  @override
  String get encoded => 'daily';
}

class WeeklyRule extends RepeatRule {
  const WeeklyRule(this.weekday);
  final int weekday; // DateTime.monday .. DateTime.sunday
  @override
  String get encoded => 'weekly:$weekday';
}

class MonthlyRule extends RepeatRule {
  const MonthlyRule(this.day);
  final int day; // 1..28
  @override
  String get encoded => 'monthly:$day';
}

/// The next moment strictly after [now] that the reminder fires, in the same
/// time zone as [now].
DateTime nextOccurrence(RepeatRule rule, int hour, int minute, DateTime now) {
  DateTime at(int y, int m, int d) => DateTime(y, m, d, hour, minute);
  switch (rule) {
    case DailyRule():
      final today = at(now.year, now.month, now.day);
      return today.isAfter(now) ? today : at(now.year, now.month, now.day + 1);
    case WeeklyRule(:final weekday):
      for (var i = 0; i <= 7; i++) {
        final d = DateTime(now.year, now.month, now.day + i);
        if (d.weekday != weekday) continue;
        final candidate = at(d.year, d.month, d.day);
        if (candidate.isAfter(now)) return candidate;
      }
      return at(now.year, now.month, now.day + 7); // unreachable
    case MonthlyRule(:final day):
      final thisMonth = at(now.year, now.month, day);
      return thisMonth.isAfter(now) ? thisMonth : at(now.year, now.month + 1, day);
  }
}

/// A reminder as the scheduler sees it (decoupled from the database row).
class ReminderSpec {
  const ReminderSpec({
    required this.id,
    required this.type,
    required this.hour,
    required this.minute,
    required this.rule,
    required this.enabled,
    this.label,
  });
  final int id;
  final ReminderType type;
  final int hour;
  final int minute;
  final RepeatRule rule;
  final bool enabled;
  final String? label;
}

/// Reminders created once after setup. Times are conveniences (not medical
/// advice) and all can be changed or switched off.
const defaultReminderPlan = <({ReminderType type, int hour, int minute, String rule})>[
  (type: ReminderType.medicineMorning, hour: 8, minute: 0, rule: 'daily'),
  (type: ReminderType.medicineNight, hour: 21, minute: 0, rule: 'daily'),
  (type: ReminderType.measureWeekly, hour: 9, minute: 0, rule: 'weekly:6'), // Saturday
  (type: ReminderType.measureMonthly, hour: 9, minute: 0, rule: 'monthly:1'),
];

/// The repeat rule a reminder type uses when first created.
RepeatRule defaultRuleFor(ReminderType type) => switch (type) {
      ReminderType.measureWeekly => const WeeklyRule(DateTime.saturday),
      ReminderType.measureMonthly => const MonthlyRule(1),
      _ => const DailyRule(),
    };

/// Where tapping the notification should take the caregiver.
String payloadFor(ReminderType type) => switch (type) {
      ReminderType.measureWeekly || ReminderType.measureMonthly => '/reading/new',
      _ => '/home',
    };
