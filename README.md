# CareCompanion

A caregiver health app for one elderly parent in Nepal (Flutter, Android first,
iOS-compatible). Caregivers log his readings, tick off his medicines, get
reminders and export a doctor report. He does not use the app himself.

> **Status: Phase 5 of 6 (History, charts, doctor report) is built.** Reminders
> and the report still need a test on a real phone (`docs/device-test-phase4.md`,
> `docs/device-test-phase5.md`). Polish and the final docs are next.

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

## What works so far

- First launch: notice, then a 6-step setup wizard (about him, conditions, food
  and allergies, medicines, the doctor's numbers, emergency contacts). Every part
  can be edited later from **Profile** (person icon on Home, or Settings).
- Home: today's morning and night medicine checklist (one tap to tick, tap
  again to undo), and the "fasting today (upabas)" switch with the doctor note.
- Medicines tab: add / edit / remove, and the last 14 days of history.
- Debug builds only: **Load demo data** on the first screen fills fake data.

## How a reading becomes guidance

`lib/domain/guidance_engine.dart` (pure Dart, fully unit-tested) compares the
reading with **only the numbers the family typed in from the doctor**:

| Result | Shown |
|---|---|
| No usable numbers | "Enter the doctor's ranges in the profile". No tier, no guidance, no urgent screen |
| `inRange` | Prefer / Go easy on / Other tips |
| `outOfRange` | Cautious banner, "Tell his doctor", the doctor's own plan text, tips made for a *high* reading only |
| `urgent` | One big "Contact his doctor or emergency services now" screen: tap-to-call contacts + the doctor's warning signs. No food advice |

- A number exactly **on** a threshold is the milder tier (the labels say "below"
  / "above").
- Blood pressure: the worse of top and bottom (and pulse, only if a pulse range
  was entered) decides.
- mg/dL <-> mmol/L is converted and rounded to what a meter shows, so
  90 mg/dL equals 5.0 mmol/L on the line.
- A time-of-day range (fasting, bedtime...) wins over the "all times" range for
  that reading; otherwise "all times" is used.
- The tier is **never stored**. It is recomputed from the saved reading and the
  current ranges, so changing a range changes the same reading at once.
- Low readings get no food advice (only "tell his doctor" and the doctor's plan).
- Allergy text hides matching ideas; the soft-food flag keeps only soft meals;
  fasting adds the doctor note and removes nothing.

### Guidance content is data

`assets/guidance/<condition>.json` (`general`, `diabetes`, `hypertension`).
Every item has `id`, `textKey`, `kind` (`meal` / `goEasyOn` / `tip`),
`appliesToTiers`, optional `directions` (`high` / `low`), `tags`, `allergens`
and `"reviewed_by_clinician": false`. All items start **unreviewed** and show
"Not yet reviewed by a clinician". Text lives in `app_en.arb` / `app_ne.arb`
under the item's `textKey`, and is resolved in `lib/core/l10n/guidance_texts.dart`.
Tests fail if an item is marked reviewed, has no text in a language, uses
"avoid"/"forbidden" wording, or mentions medicines or doses. The full "add a
new condition" guide is part of the final phase.

## History and the doctor report

- **History tab:** per measure (blood sugar, blood pressure) a line chart with
  the doctor's "all times" range shaded and the urgent limits dashed, a summary
  (count / average / lowest / highest) and the list of readings with a tier
  word + icon. Period: 2 weeks, 4 weeks or 3 months. Readings in another sugar
  unit are converted for the chart; the list keeps what was typed. The chart has
  a spoken summary, and the same numbers are in the list (no tap needed).
  Nothing is shaded when no range was entered.
- **Deleting a reading** (bin on the result screen, also on the urgent screen so
  a typo can be fixed) asks first; the reading leaves the history and reports.
- **Doctor report (PDF):** Home -> Doctor report -> Share PDF (two taps; 2 weeks
  is preselected) or Preview/print. Contents: patient facts, the family-entered
  doctor's ranges with the doctor's plan and warning signs *as the family wrote
  them*, per measure: stats, a chart with the range band, the readings table
  with how each compares with the doctor's range, then medicines and
  "doses marked as given" (totals and a day table), and the disclaimer on every
  page. Dates are AD, with BS in brackets if BS is on.
- **Report language is English** so any doctor can read it. The `pdf` library
  cannot shape Devanagari, so anything the family typed in Nepali (name, notes,
  plan text, medicine names) is drawn as a picture by Flutter's own text engine
  (`lib/report/text_image.dart`). Chart and summary use the chosen sugar unit;
  the table shows each reading as typed.
- The PDF is generated on the phone and only leaves it when you share it. The
  file name has no patient name. Share/print use the `printing` package.

## Reminders

- Default reminders (created once after setup, all editable): morning medicine
  8:00, night medicine 21:00, measure again every Saturday 9:00, monthly check
  on day 1 at 9:00. Hydration and your own named reminders can be added.
  Times are conveniences, not medical advice.
- `flutter_local_notifications` + `timezone` (+ `flutter_timezone` for the
  phone's own zone; Nepal is UTC+5:45). Repeats: daily, weekly (day of week),
  monthly (day 1-28).
- **Permissions:** Android 13+ notification permission is asked from the
  Reminders screen, never on first launch. Exact alarms (Android 12+
  "Alarms & reminders") are requested through the system settings page; until
  allowed, reminders still arrive but may be a few minutes late.
- **After a restart:** the plugin's boot receiver restores scheduled
  reminders; in addition the app re-creates all of them at every start and when
  it returns to the front, and whenever a reminder, his name, the language or a
  permission changes. Re-scheduling is idempotent.
- Notification text never contains a health value (it can show on a lock
  screen), and there is no "mark as given" button on it, so a swipe can never
  cause a double dose. Tapping opens Home (medicine) or Add reading (measure).
- The Reminders screen has **Send a test reminder now** and **Test reminder in
  1 minute** to check a phone quickly.

## Getting the app on a phone

Every push to a `claude/*` branch runs `.github/workflows/build-apk.yml`
(analyze, tests, debug + release APK). Download the APK from the run's
**Artifacts**. The debug build has the "Load demo data (testing only)" button.

## Architecture

| Area | Where |
|---|---|
| Theme (18sp+ body, 56dp buttons, contrast-tested colours) | `lib/core/theme/` |
| AD/BS conversion, date formatting, digit style | `lib/core/dates/` |
| Drift schema, migrations, seeded metric catalogue | `lib/data/db/` |
| Settings + providers (Riverpod) | `lib/data/providers.dart` |
| Routing (go_router, disclaimer gate, 4-tab shell) | `lib/router.dart` |
| Strings (`app_en.arb` default, `app_ne.arb`) | `lib/l10n/` |
| Pure logic: daily checklist, adherence, range + number validation | `lib/domain/` |
| Repositories (profile, ranges, medicines + dose logs) | `lib/data/repositories/` |
| Wizard, profile hub, medicines, contacts, Home | `lib/features/` |

- **Dates** are stored as AD. BS is converted only for display, by
  `BsConverter` (wraps `nepali_utils`, pure Dart, covers BS 1970-2100). Tests pin
  it to known Nepali New Year dates and round-trip every day from 1944 to 2035.
- **Conditions are data.** `Metrics` rows describe what can be measured
  (unit options, tags, which condition). Diabetes and hypertension are rows,
  not code. How to add a condition (rows + a guidance JSON file) is documented
  in Phase 6, when the guidance engine exists.
- **Daily medicine reset** is date-based: `DoseLogs` has one row per
  medicine + slot + `yyyy-MM-dd`; a new day simply has no row yet. Past rows are
  never edited or deleted, and the repository only ever writes today's row.
  Home notices midnight while open (the clock is checked every 20 s).
- **Medicine history stays honest.** Each slot has `startedOn` / `endedOn`, so
  adding a medicine or a new time later never counts earlier days as missed, and
  "removing" a medicine only hides it (history is kept). The remove dialog says
  it does not change his real medicine.
- **The doctor's numbers** are saved exactly as typed (empty = not entered, and
  an all-empty set is not stored). Typo catchers in `lib/domain/input_limits.dart`
  are NOT medical ranges; they only stop things like 1300 being saved by mistake.
- **Fasting (upabas)** is stored as the date it was switched on, so it turns
  itself off the next day.

## Schema versions

- v1: Phase 1.
- v2: `medication_slots.started_on / ended_on` (migration tested in
  `test/data/migration_test.dart`).
- v3: `app_settings.reminders_seeded` (default reminders are created once).

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
