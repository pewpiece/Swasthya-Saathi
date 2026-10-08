import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Number-pad text field (no tiny steppers or sliders). Allows digits in both
/// scripts plus a decimal mark; validation happens when the user saves.
class NumberTextField extends StatelessWidget {
  const NumberTextField({
    super.key,
    required this.controller,
    required this.label,
    this.errorText,
    this.decimal = false,
    this.textInputAction = TextInputAction.next,
  });

  final TextEditingController controller;
  final String label;
  final String? errorText;
  final bool decimal;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      textInputAction: textInputAction,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9०-९.,]')),
      ],
      style: Theme.of(context).textTheme.titleLarge,
      decoration: InputDecoration(labelText: label, errorText: errorText),
    );
  }
}
