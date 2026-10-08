import 'package:nepali_utils/nepali_utils.dart';

/// A Bikram Sambat calendar date. Display only: never store this.
class BsDate {
  const BsDate(this.year, this.month, this.day);

  final int year;
  final int month; // 1 = Baisakh ... 12 = Chaitra
  final int day;

  @override
  bool operator ==(Object other) =>
      other is BsDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => 'BsDate($year-$month-$day)';
}

/// AD <-> BS conversion.
///
/// Wraps `nepali_utils` (pure Dart, covers BS 1970-2100+ with a lookup table)
/// so the rest of the app never imports it and it can be swapped out. The
/// tests pin the conversion to known anchor dates.
class BsConverter {
  const BsConverter._();

  /// Earliest/latest AD year we promise to convert (BS 2000 -> 2100ish).
  static const int minAdYear = 1944;
  static const int maxAdYear = 2040;

  static BsDate fromAd(DateTime ad) {
    final n = DateTime(ad.year, ad.month, ad.day).toNepaliDateTime();
    return BsDate(n.year, n.month, n.day);
  }

  static DateTime toAd(BsDate bs) {
    final d = NepaliDateTime(bs.year, bs.month, bs.day).toDateTime();
    return DateTime(d.year, d.month, d.day);
  }
}
