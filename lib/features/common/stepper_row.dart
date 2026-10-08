import 'package:flutter/material.dart';

/// "[-]  value  [+]" with two big buttons (no sliders, no drags, no
/// long-press): easy to hit with a shaky hand, and each button is announced
/// with a clear label by the screen reader.
class StepperRow extends StatelessWidget {
  const StepperRow({
    super.key,
    required this.label,
    required this.value,
    required this.onMinus,
    required this.onPlus,
    required this.minusLabel,
    required this.plusLabel,
  });

  final String label;
  final String value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final String minusLabel;
  final String plusLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.titleSmall),
        const SizedBox(height: 6),
        Row(
          children: [
            IconButton.filledTonal(
              tooltip: minusLabel,
              iconSize: 32,
              style: IconButton.styleFrom(minimumSize: const Size(64, 64)),
              icon: const Icon(Icons.remove),
              onPressed: onMinus,
            ),
            Expanded(
              child: Semantics(
                label: '$label: $value',
                excludeSemantics: true,
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium,
                ),
              ),
            ),
            IconButton.filledTonal(
              tooltip: plusLabel,
              iconSize: 32,
              style: IconButton.styleFrom(minimumSize: const Size(64, 64)),
              icon: const Icon(Icons.add),
              onPressed: onPlus,
            ),
          ],
        ),
      ],
    );
  }
}
