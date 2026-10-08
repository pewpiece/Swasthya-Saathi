import 'package:flutter/material.dart';

import '../../core/format.dart';
import '../../data/enums.dart';
import '../../domain/reminder_rules.dart';
import '../../l10n/app_localizations.dart';

String reminderTypeLabel(AppL10n l, ReminderType t) => switch (t) {
      ReminderType.medicineMorning => l.reminderTypeMedicineMorning,
      ReminderType.medicineNight => l.reminderTypeMedicineNight,
      ReminderType.measureWeekly => l.reminderTypeMeasureWeekly,
      ReminderType.measureMonthly => l.reminderTypeMeasureMonthly,
      ReminderType.hydration => l.reminderTypeHydration,
      ReminderType.custom => l.reminderTypeCustom,
    };

IconData reminderTypeIcon(ReminderType t) => switch (t) {
      ReminderType.medicineMorning => Icons.wb_sunny,
      ReminderType.medicineNight => Icons.nights_stay,
      ReminderType.measureWeekly => Icons.event_repeat,
      ReminderType.measureMonthly => Icons.calendar_month,
      ReminderType.hydration => Icons.water_drop,
      ReminderType.custom => Icons.notifications,
    };

String weekdayName(AppL10n l, int weekday) => switch (weekday) {
      1 => l.weekdayMon,
      2 => l.weekdayTue,
      3 => l.weekdayWed,
      4 => l.weekdayThu,
      5 => l.weekdayFri,
      6 => l.weekdaySat,
      _ => l.weekdaySun,
    };

String repeatText(AppL10n l, Fmt fmt, RepeatRule rule) => switch (rule) {
      DailyRule() => l.reminderRepeatDaily,
      WeeklyRule(:final weekday) => l.reminderRepeatWeekly(weekdayName(l, weekday)),
      MonthlyRule(:final day) => l.reminderRepeatMonthly(fmt.n(day)),
    };

/// `8:05 AM` for a time of day.
String timeOfDayText(AppL10n l, Fmt fmt, int hour, int minute) =>
    fmt.time(l, DateTime(2000, 1, 1, hour, minute));
