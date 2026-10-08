# Swasthya Saathi (स्वास्थ्य साथी)

_(The repository and internal package are still called CareCompanion.)_

A caregiver health app (Flutter, Android first, iOS-compatible) for **one elderly
parent in Nepal**. The family caregivers use it to look after him; he does not
use the app himself.

They can: fill in his health profile once, log blood sugar and blood pressure,
get safe rule-based guidance from each reading, tick off morning and night
medicines each day, get reminders, see charts, and make a PDF for his doctor.
Everything stays on the phone: **no accounts, no backend, no analytics, no
network calls.**

> **Status: all six phases are built** (foundation, profile + medicines,
> readings + guidance, reminders, history + report, polish). Automated tests
> pass, but **nothing has been tested by real caregivers or on every phone yet**.
> See [Before real use](#before-real-use-checklist) and `docs/hci/`.

## Safety rules (never violate)

1. **No built-in medical ranges.** Every threshold comes from the profile,
   typed in from the doctor's instructions. With none entered the app says
   "Enter the doctor's ranges in the profile" and gives no range-based
   guidance. (A test checks the database ships with zero ranges and zero phone
   numbers.)
2. **Three tiers**, from the doctor's thresholds only: *inRange* (meal ideas,
   foods to go easy on), *outOfRange* (cautious tips + "Tell his doctor" + the
   doctor's own plan text), *urgent* (one big "Contact his doctor or emergency
   services now" screen with tap-to-call contacts; no meal tips).
3. **Never** treatment, dosing or medicine-change advice. Never "stop" or
   "change" a medicine. Removing a medicine from the app's list says it does not
   change his real medicine.
4. Food wording is **"Prefer" / "Go easy on"**, never "Avoid" or "Forbidden".
   Never suggest skipping meals or cutting calories (tests enforce the wording).
5. "This app is not medical advice" is shown on first launch, in Settings, in
   How to use, and on every report page.
6. All guidance content is data and starts as `"reviewed_by_clinician": false`;
   unreviewed lists show "Not yet reviewed by a clinician".
   See `docs/clinician-review.md`.

## Quick start

```bash
flutter pub get
dart run build_runner build      # drift code (lib/data/db/app_database.g.dart)
flutter gen-l10n                 # localizations (lib/l10n)
flutter analyze && flutter test
flutter run                      # phone or emulator
```
Generated files are committed, so a fresh clone also builds without running the
generators. Re-run them after editing `tables.dart` or an `.arb` file.

**Install on a phone without a computer:** every push to a `claude/*` branch runs
`.github/workflows/build-apk.yml` (analyze, tests, debug + release APK). Open
the repo on GitHub -> **Actions** -> newest run -> **Artifacts**. The *debug*
build has a "Load demo data (testing only)" button (fake person, fake medicines,
no ranges, no phone numbers).

## What it does

| Area | Details |
|---|---|
| Setup | 6-step wizard (about him, conditions, food/allergies + soft food, medicines, the doctor's numbers, emergency contacts); everything editable from Profile |
| Home | Today's morning/night medicine checklist (1 tap, tap again to undo; resets each day, history kept), fasting (upabas) switch with the doctor note, latest readings with tier icon + word, today's guidance, shortcuts |
| Readings | Blood sugar (mg/dL or mmol/L) and blood pressure + pulse; number pad, remembered unit and time of day, typo checks (e.g. BP 1300/80 is refused); delete a reading (also from the urgent screen) |
| Guidance | See below |
| Reminders | Defaults + your own; daily/weekly/monthly; permissions flow; survives restarts; test buttons |
| History | Chart per measure with the doctor's range shaded and urgent limits dashed, summary, list; 2 weeks / 4 weeks / 3 months |
| Doctor report | PDF, 2 or 4 weeks; share or preview/print |
| Settings | Language (English/Nepali), date style (AD/BS), sugar unit, digit style (1 2 3 / १ २ ३), text-size help, PIN lock, reminders, save a copy / delete all data, How to use, disclaimer |
| Languages | English (default) and Nepali; Noto Sans Devanagari bundled; dates stored as AD, BS only for display |

### How a reading becomes guidance
`lib/domain/guidance_engine.dart` (pure Dart, unit-tested):
- A number exactly **on** a threshold is the milder tier (labels say "below" /
  "above"). Blood pressure: the worse of top and bottom (and pulse only if a
  pulse range was entered). mg/dL <-> mmol/L is converted and rounded to what a
  meter shows. A time-of-day range (fasting, bedtime...) beats the "all times"
  range. The tier is **never stored**: it is recomputed from the saved reading
  and the current ranges, so changing a range changes the same reading at once.
- Low readings get no food advice (only "tell his doctor" and the doctor's plan).
  Allergy text hides matching ideas; the soft-food flag keeps only soft meals;
  fasting adds the doctor note and removes nothing.

### The doctor report
Patient facts, the family-entered ranges with the doctor's plan and warning signs
*as the family wrote them*, per measure: stats, chart with the range band, the
readings table with how each compares with the doctor's range, medicines and
"doses marked as given" (totals + day table), and the disclaimer on every page.
**English by design** (any doctor can read it); AD dates, BS in brackets if on.
The `pdf` library cannot shape Devanagari, so anything typed in Nepali (name,
notes, plan text) is drawn as a picture by Flutter's text engine
(`lib/report/text_image.dart`). The file name has no patient name.

### Reminders
`flutter_local_notifications` + `timezone` + `flutter_timezone` (phone's own zone;
Nepal is UTC+5:45). Android 13+ notification permission is asked from the
Reminders screen (never on first launch). Exact alarms ("Alarms & reminders",
Android 12+) via the system page; until allowed, reminders still arrive, maybe a
few minutes late. The plugin's boot receiver restores reminders after a restart,
and the app re-creates all of them at every start / return to the front and
whenever a reminder, his name, the language or a permission changes.
Notification text never contains a health value and has no "mark as given"
button (a swipe can never cause a double dose).

## Privacy and security
- All data stays on the device. No network permission is requested.
- Android `FLAG_SECURE`: hidden in recent apps, no screenshots.
- Android cloud/device backup of app data is **turned off** (`allowBackup=false`).
- **PIN lock (optional):** 4 digits, asked at start and after 60 s in the
  background; 30 s lock-out after 5 wrong tries; only a salted hash is stored.
  It is a *privacy screen, not strong security* (only 10,000 PINs, and the file
  is not encrypted). "Forgot PIN" erases everything.
- **Save a copy / delete all data** in Settings -> Your data. The copy is one JSON
  file (no PIN inside; it contains health information, so keep it private);
  restoring from it is not built yet. Delete asks twice.
- Never log health values (error handlers log only the error type). No analytics.
- `.gitignore` excludes databases, exports and PDFs. Use fake demo data only.
- **Not done: database encryption.** It needs SQLCipher plus a Keystore key plus
  a one-time migration of existing data, and a mistake would lock the family out
  of their own data. It cannot be verified without a real phone, so it was
  deliberately not shipped blind. Plan: `sqlcipher_flutter_libs` + a random key in
  Android Keystore (`flutter_secure_storage`), `PRAGMA key` on open, migrate an
  existing plaintext file with `sqlcipher_export`, offer "Save a copy" first, and
  test on real phones (fresh install, upgrade, reboot, low storage).

## Adding a new condition (data, not code - with one honest limit)

A condition that uses an **existing reading kind** (`blood_sugar` or
`blood_pressure`) is data only. Example: adding "kidney" that reuses blood
pressure.
1. **Measures:** add rows to `_seedMetrics` in `lib/data/db/app_database.dart`
   (`key`, `nameKey`, `unitOptions`, `tagOptions`, `conditionKey`, `readingKey`)
   and insert the same rows in a new `if (from < N)` block of `onUpgrade` (bump
   `schemaVersion`) so existing installs get them.
2. **Words:** add the strings to `app_en.arb` and `app_ne.arb`:
   `condition<Name>`, metric names, tags. Add a case for each in
   `lib/core/l10n/l10n_keys.dart` (`l10nByKey`, `conditionLabel`).
3. **Guidance:** create `assets/guidance/<condition>.json` (same fields as the
   others: `id`, `textKey`, `kind`, `appliesToTiers`, `directions`, `tags`,
   `allergens`, `"reviewed_by_clinician": false`), add the texts to both `.arb`
   files, and a `case` per key in `lib/core/l10n/guidance_texts.dart`. The
   file is picked up automatically (no code change).
4. **Run** `flutter test`: the content tests fail if a text is missing in either
   language, uses "avoid"/"forbidden", mentions medicines/doses, is marked
   reviewed, or if English and Nepali keys differ.
5. The conditions step, the doctor's-numbers step, History and the report then
   show it automatically.

A brand-new **kind of reading** (for example weight or oxygen) also needs a
little code in these places: `GuidanceEngine.componentsOf` / `_valueOf`, the
reading form (`reading_form_screen.dart`), `seriesFor` / `buildReportData`, and
the labels in `add_reading_chooser.dart`. Have a developer do this and add tests.

## Shared use by two parents (future)
The MVP is **one phone, one caregiver profile**. If two parents use the app on
**separate phones** they will not see each other's ticks, and one could give a
medicine the other already gave (**double-dosing**). Safe shared use needs a
backend (accounts, sync, conflict handling) and a decision about who may change
what. That is out of scope for the MVP.

## Architecture
| Area | Where |
|---|---|
| Theme (18sp+ body, 56dp buttons, contrast-tested) | `lib/core/theme/` |
| AD/BS conversion, date formatting, digits (wraps `nepali_utils`) | `lib/core/dates/` |
| Drift schema v4, migrations, measure catalogue | `lib/data/db/` |
| Repositories, providers (Riverpod), PIN, export | `lib/data/` |
| Pure logic: guidance engine, checklist/adherence, ranges, analysis, report data, PIN, reminder rules | `lib/domain/` |
| Notifications (gateway interface + real impl) | `lib/data/notifications/` |
| PDF | `lib/report/` |
| Screens | `lib/features/` |
| Strings | `lib/l10n/app_en.arb`, `app_ne.arb` |
| Guidance content | `assets/guidance/*.json` |

**Schema versions:** v1 Phase 1; v2 medicine-slot start/end dates; v3 reminders
seeded flag; v4 PIN hash/salt. Every upgrade has a test.

## Tests and CI
`flutter test` runs ~370 tests: engine and rules, content safety wording, database
and every migration, daily reset (incl. midnight), reminder scheduling with a
fake phone, report content (checked with `pdftotext`), end-to-end screen flows,
200% font on every screen in English and Nepali, and the automated accessibility
audit. CI (GitHub Actions) runs analyze + tests + builds the APKs.

## Before real use (checklist)
- [ ] **A doctor or dietitian reviews the food/tip content** (`docs/clinician-review.md`).
- [ ] **A native Nepali speaker reads every screen and the PDF disclaimer.**
- [ ] **Run the usability test with 3-5 real caregivers** (`docs/hci/usability-test-plan.md`)
      and fix severity 3-4 problems.
- [ ] **Device tests** on the family's phone: reminders incl. restart
      (`docs/device-test-phase4.md`), history/PDF (`docs/device-test-phase5.md`),
      TalkBack walk-through.
- [ ] Decide on **database encryption** (see above) before storing real data.
- [ ] Create a proper **release signing key** (the release APK currently uses
      the debug key) and decide how the family receives updates.
- [ ] Doctor confirms the ranges the family typed; nobody changes a medicine
      because of this app.

## Known limitations
One phone, one profile; no restore from the backup file; a saved reading can only
be deleted and re-added; reminder minutes move in steps of 5; report text is
English; light theme only; bottom-bar labels are capped at 1.3x text size by
Flutter; not tested on iOS; database not encrypted.


## Updates after the first device test

- **Notifications in release builds:** shrinking is switched off (it removed what
  the notification plugin needs), the app now shows the real reason when a test
  reminder fails, and the Reminders screen has a "Reminder check" card (how many
  reminders the phone holds, last problem). CI checks the icon is in the APK.
- **Profile photo:** optional, camera or gallery, resized and stored in the
  app's private folder only. Not in the PDF, not in the backup file, deleted by
  "Delete all data".
- **Screenshots:** Settings -> "Hide the app in screenshots and recent apps".
  On by default (privacy). Switch it off to take screenshots; the app then also
  shows in the recent-apps preview.
- **Logo and name:** heart with a heartbeat line; the app is called Swasthya
  Saathi.
