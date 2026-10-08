import 'package:flutter/material.dart';

import 'choice_group.dart';

/// A row of big choices that wraps onto more lines when there is no room.
/// Selected = check icon + bold + thick border + tint (not colour alone).
class ChoiceWrap<T> extends StatelessWidget {
  const ChoiceWrap({
    super.key,
    required this.choices,
    required this.value,
    required this.onChanged,
  });

  final List<Choice<T>> choices;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final c in choices)
          Semantics(
            button: true,
            selected: c.value == value,
            inMutuallyExclusiveGroup: true,
            label: c.label,
            excludeSemantics: true,
            onTap: () => onChanged(c.value),
            child: Material(
              color: c.value == value ? scheme.primaryContainer : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: c.value == value ? scheme.primary : scheme.outline,
                  width: c.value == value ? 3 : 1.5,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => onChanged(c.value),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 56, minWidth: 56),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(
                        c.value == value ? Icons.check_circle : Icons.circle_outlined,
                        size: 24,
                        color: c.value == value ? scheme.primary : scheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          c.label,
                          style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: c.value == value ? FontWeight.w800 : FontWeight.w500),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
