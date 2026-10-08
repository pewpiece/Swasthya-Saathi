/// Enums stored in the database by name (see `textEnum` in tables.dart).
/// Renaming a value needs a migration.
enum AppLanguage { en, ne }

enum DateStyle { ad, bs }

enum GlucoseUnit { mgDl, mmolL }

enum DigitStyle { latin, devanagari }

enum DoseSlot { morning, night }

enum ReminderType {
  medicineMorning,
  medicineNight,
  measureWeekly,
  measureMonthly,
  hydration,
  custom,
}

enum ContactRole { doctor, hospital, ambulance, family }
