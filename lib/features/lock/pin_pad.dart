import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../domain/pin.dart';
import '../../l10n/app_localizations.dart';

/// Four dots + a big number pad (>= 72dp keys, no gestures). Digits follow
/// the chosen digit style; the value is always kept as Latin digits.
class PinEntry extends ConsumerWidget {
  const PinEntry({super.key, required this.value, required this.onChanged, this.enabled = true});

  final String value;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final theme = Theme.of(context);
    final fmt = ref.watch(fmtProvider);

    void add(String d) {
      if (!enabled || value.length >= pinLength) return;
      onChanged(value + d);
    }

    Widget key(String label, {required VoidCallback? onTap, String? semantics, IconData? icon}) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Semantics(
            button: true,
            label: semantics ?? label,
            excludeSemantics: true,
            child: SizedBox(
              height: 76,
              child: icon != null
                  ? OutlinedButton(onPressed: onTap, child: Icon(icon, size: 34))
                  : FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.zero,
                        textStyle: theme.textTheme.headlineMedium,
                      ),
                      onPressed: onTap,
                      // The digits are already large; do not let them outgrow the key.
                      child: MediaQuery.withClampedTextScaling(
                        maxScaleFactor: 1.3,
                        child: Text(label),
                      ),
                    ),
            ),
          ),
        ),
      );
    }

    Widget row(List<String> digits) => Row(children: [
          for (final d in digits)
            key(fmt.s(d), onTap: enabled ? () => add(d) : null, semantics: fmt.s(d)),
        ]);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          liveRegion: true,
          label: l.pinDotsLabel(fmt.n(value.length)),
          excludeSemantics: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < pinLength; i++)
                Container(
                  margin: const EdgeInsets.all(10),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < value.length ? theme.colorScheme.primary : Colors.transparent,
                    border: Border.all(color: theme.colorScheme.primary, width: 3),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        row(['1', '2', '3']),
        row(['4', '5', '6']),
        row(['7', '8', '9']),
        Row(children: [
          const Expanded(child: SizedBox(height: 76)),
          key(fmt.s('0'), onTap: enabled ? () => add('0') : null, semantics: fmt.s('0')),
          key('',
              icon: Icons.backspace_outlined,
              semantics: l.pinDigitDelete,
              onTap: enabled && value.isNotEmpty ? () => onChanged(value.substring(0, value.length - 1)) : null),
        ]),
      ],
    );
  }
}
