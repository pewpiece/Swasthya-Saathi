/// Helpers for "date only" values. Dates are always AD in storage and logic;
/// Bikram Sambat (BS) is for display only.
DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Stable text key for a calendar day, e.g. `2026-10-08`. Used as the
/// DoseLog date so "today" never depends on a time zone offset.
String dateKey(DateTime d) {
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '$y-$m-$day';
}

DateTime parseDateKey(String key) {
  final parts = key.split('-');
  if (parts.length != 3) throw FormatException('Bad date key', key);
  return DateTime(
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
  );
}
