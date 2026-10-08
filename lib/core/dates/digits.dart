import '../../data/enums.dart';

const _devanagari = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];

/// Converts every digit in [text] (Latin or Devanagari) to [style].
/// Used for dates, readings and any number shown on screen.
String convertDigits(String text, DigitStyle style) {
  final out = StringBuffer();
  for (final rune in text.runes) {
    final ch = String.fromCharCode(rune);
    final latin = rune >= 0x30 && rune <= 0x39 ? rune - 0x30 : -1;
    final dev = rune >= 0x966 && rune <= 0x96F ? rune - 0x966 : -1;
    final value = latin >= 0 ? latin : dev;
    if (value < 0) {
      out.write(ch);
    } else {
      out.write(style == DigitStyle.latin ? '$value' : _devanagari[value]);
    }
  }
  return out.toString();
}
