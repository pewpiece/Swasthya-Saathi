import 'package:flutter/material.dart';

/// A big tick box (>= 64dp high). Checked = filled box icon + tint + thick
/// border + optional status text, never colour alone. The whole tile is the
/// tap target. Used for doses, conditions, medicine times and soft food.
class CheckTile extends StatelessWidget {
  const CheckTile({
    super.key,
    required this.label,
    required this.checked,
    required this.onChanged,
    this.subtitle,
    this.semanticsLabel,
    this.minHeight = 64,
  });

  final String label;
  final String? subtitle;
  final bool checked;
  final ValueChanged<bool> onChanged;

  /// Overrides the spoken label (for example to say "given" / "not given").
  final String? semanticsLabel;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Semantics(
      container: true,
      checked: checked,
      label: semanticsLabel ?? label,
      excludeSemantics: true,
      onTap: () => onChanged(!checked),
      child: Material(
        color: checked ? scheme.primaryContainer : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: checked ? scheme.primary : scheme.outline,
            width: checked ? 3 : 1.5,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onChanged(!checked),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    checked ? Icons.check_box : Icons.check_box_outline_blank,
                    size: 40,
                    color: checked ? scheme.primary : scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (subtitle != null)
                          Text(subtitle!, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
