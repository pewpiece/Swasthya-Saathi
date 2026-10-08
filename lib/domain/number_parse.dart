import '../core/dates/digits.dart';
import '../data/enums.dart';

/// Parses a number typed by a caregiver. Accepts Latin or Devanagari digits
/// and a comma as the decimal mark ("5,6"). Returns null for empty/invalid.
double? parseDecimal(String? text) {
  if (text == null) return null;
  final t = convertDigits(text.trim(), DigitStyle.latin).replaceAll(',', '.');
  if (t.isEmpty) return null;
  if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(t)) return null;
  return double.tryParse(t);
}

int? parseWholeNumber(String? text) {
  final d = parseDecimal(text);
  if (d == null || d != d.roundToDouble()) return null;
  return d.toInt();
}

/// A phone number the family typed: digits with optional + - ( ) and spaces.
/// This only catches typos (3-15 digits); it does not look numbers up.
bool isPlausiblePhone(String? text) {
  if (text == null) return false;
  final t = convertDigits(text.trim(), DigitStyle.latin);
  if (!RegExp(r'^\+?[\d\s\-()]+$').hasMatch(t)) return false;
  final digits = t.replaceAll(RegExp(r'\D'), '');
  return digits.length >= 3 && digits.length <= 15;
}

/// Digits and a leading + only, ready for a `tel:` link.
String dialableNumber(String text) =>
    convertDigits(text, DigitStyle.latin).replaceAll(RegExp(r'[^\d+]'), '');
