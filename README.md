# CareCompanion

A caregiver health app for one elderly parent in Nepal (Flutter, Android first,
iOS-compatible). Caregivers log his readings, tick off his medicines, get
reminders and export a doctor report. He does not use the app himself.

> **Status: Phase 1 of 6 (Foundation) is built.** Profile, medicines, readings,
> guidance, reminders, charts and the PDF report come in the next phases.

## Safety rules (never violate)

- **No built-in medical ranges.** Every threshold comes from the doctor, typed
  in by the family. The database ships with zero ranges and zero phone numbers
  (there is a test for this).
- Three tiers per reading, from the doctor's thresholds only: `inRange`,
  `outOfRange` (caution), `urgent` (urgent screen only, no meal tips).
- Never treatment, dosing, or medicine-change advice.
- Food wording is "Prefer" / "Go easy on", never "Avoid". Never suggest
  skipping meals or cutting calories.
- "This app is not medical advice" is shown on first launch and in Settings.
- Guidance content is data and stays `"reviewed_by_clinician": false` until a
  doctor or dietitian approves it.

## Setup

```bash
flutter pub get
dart run build_runner build      # generates drift code (app_database.g.dart)
flutter gen-l10n                 # generates localizations (lib/l10n)
flutter analyze && flutter test
flutter run
```

Both generated outputs are committed, so a fresh clone also builds without
running the generators. Re-run them after editing `tables.dart` or an `.arb`.

## Architecture (Phase 1)

| Area | Where |
|---|---|
| Theme (18sp+ body, 56dp buttons, contrast-tested colours) | `lib/core/theme/` |
| AD/BS conversion, date formatting, digit style | `lib/core/dates/` |
| Drift schema, migrations, seeded metric catalogue | `lib/data/db/` |
| Settings + providers (Riverpod) | `lib/data/providers.dart` |
| Routing (go_router, disclaimer gate, 4-tab shell) | `lib/router.dart` |
| Strings (`app_en.arb` default, `app_ne.arb`) | `lib/l10n/` |

- **Dates** are stored as AD. BS is converted only for display, by
  `BsConverter` (wraps `nepali_utils`, pure Dart, covers BS 1970-2100). Tests pin
  it to known Nepali New Year dates and round-trip every day from 1944 to 2035.
- **Conditions are data.** `Metrics` rows describe what can be measured
  (unit options, tags, which condition). Diabetes and hypertension are rows,
  not code. How to add a condition (rows + a guidance JSON file) is documented
  in Phase 6, when the guidance engine exists.
- **Daily medicine reset** is date-based: `DoseLogs` has one row per
  medicine + slot + `yyyy-MM-dd`; a new day simply has no row yet. Past rows are
  never edited or deleted.
- **Fasting (upabas)** is stored as the date it was switched on, so it turns
  itself off the next day.

## Privacy

- All data stays on the device. No analytics, no network calls. Nothing in the
  app uses the internet; fonts are bundled.
- Android `FLAG_SECURE` hides the app in recent-apps and blocks screenshots.
- `.gitignore` excludes databases and PDF exports. Use fake demo data only.
  Never log health values.
- **TODO (encryption):** the SQLite file is not encrypted yet. Plan: SQLCipher
  (`sqlcipher_flutter_libs`) with a key in the Android Keystore. It needs a
  native build change, so it is scheduled for the polish phase.

## Shared use by two parents (future)

The MVP is one phone, one caregiver profile. If two parents use the app on
**separate phones**, they will not see each other's ticks, and one could give a
medicine the other already gave (**double-dosing**). Safe shared use needs a
backend (sync + conflict handling) and accounts. That is out of scope for the
MVP.

## Localization

English is the default; Nepali (`app_ne.arb`) was written by the developer
tooling and **needs review by a native speaker** before real use. Noto Sans
Devanagari is bundled (`assets/fonts/`, SIL OFL licence).
