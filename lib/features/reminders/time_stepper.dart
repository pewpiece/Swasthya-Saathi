import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../l10n/app_localizations.dart';
import '../common/stepper_row.dart';
import 'reminder_labels.dart';

/// Choose a time with big +/- buttons (hour, 5 minutes) and AM / PM.
/// The chosen time is also written out in full, so the result is always clear.
class TimeStepper extends ConsumerWidget {
  const TimeStepper({super.key, required this.hour, required this.minute, required this.onChanged});

  final int hour; // 0..23
  final int minute; // 0..59
  final void Function(int hour, int minute) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final fmt = ref.watch(fmtProvider);
    final h12 = hour % 12 == 0 ? 12 : hour % 12;
    final isAm = hour < 12;

    int nextMinute(int m) => ((m ~/ 5) + 1) * 5 % 60;
    int prevMinute(int m) => m % 5 == 0 ? (m - 5 + 60) % 60 : (m ~/ 5) * 5;

    Widget periodButton(String text, bool selected, VoidCallback onTap) => Expanded(
          child: Semantics(
            button: true,
            selected: selected,
            inMutuallyExclusiveGroup: true,
            label: text,
            excludeSemantics: true,
            onTap: onTap,
            child: Material(
              color: selected ? theme.colorScheme.primaryContainer : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: selected ? theme.colorScheme.primary : theme.colorScheme.outline,
                  width: selected ? 3 : 1.5,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onTap,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 64),
                  child: Center(
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                          size: 26),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(text,
                            style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: selected ? FontWeight.w800 : FontWeight.w500)),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          liveRegion: true,
          child: Text(
            timeOfDayText(l, fmt, hour, minute),
            style: theme.textTheme.displaySmall,
          ),
        ),
        const SizedBox(height: 16),
        StepperRow(
          label: l.reminderHourLabel,
          value: fmt.n(h12),
          minusLabel: l.reminderFewerHours,
          plusLabel: l.reminderMoreHours,
          onMinus: () => onChanged((hour + 23) % 24, minute),
          onPlus: () => onChanged((hour + 1) % 24, minute),
        ),
        const SizedBox(height: 16),
        StepperRow(
          label: l.reminderMinuteLabel,
          value: fmt.s(minute.toString().padLeft(2, '0')),
          minusLabel: l.reminderFewerMinutes,
          plusLabel: l.reminderMoreMinutes,
          onMinus: () => onChanged(hour, prevMinute(minute)),
          onPlus: () => onChanged(hour, nextMinute(minute)),
        ),
        const SizedBox(height: 16),
        Row(children: [
          periodButton(l.timeAm, isAm, () => onChanged(isAm ? hour : hour - 12, minute)),
          const SizedBox(width: 12),
          periodButton(l.timePm, !isAm, () => onChanged(isAm ? hour + 12 : hour, minute)),
        ]),
      ],
    );
  }
}
