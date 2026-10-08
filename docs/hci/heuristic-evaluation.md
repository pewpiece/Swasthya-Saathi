# Heuristic evaluation (Nielsen's 10) - FINAL consolidated matrix

**Method: inspection by the developer plus automated tests. No real user has
used the app.** Severity 0-4 (0 none, 1 cosmetic, 2 minor, 3 major, 4 blocker);
"-" = does not apply. The per-phase tables further down keep the detail and
the fixes made. Real-user findings are added by the usability test
(`usability-test-plan.md`).

Heuristics: H1 status visibility, H2 real-world match, H3 user control,
H4 consistency, H5 error prevention, H6 recognition, H7 efficiency,
H8 minimalism, H9 error recovery, H10 help.

| Screen | H1 | H2 | H3 | H4 | H5 | H6 | H7 | H8 | H9 | H10 | Fix applied / note |
|---|---|---|---|---|---|---|---|---|---|---|---|
| First launch + disclaimer | 0 | 0 | 1 | 0 | - | 0 | - | 0 | - | 0 | No cancel on purpose (notice must be read once) |
| Setup wizard (6 steps) | 0 | 1 | 1 | 0 | 0 | 0 | 1 | 1 | 0 | 1 | Back arrow moved to app bar; Nepali needs native review; many steps (each optional after step 1) |
| Home | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | One tap per dose; "?" help; longer at large text (scrolls) |
| Medicines tab + form | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | "Remove" says it does not change his real medicine |
| Profile hub + steps | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | Ranges step is long when two conditions are on |
| Doctor's numbers | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | Order and typo checks; plain "Careful / Urgent" wording |
| Add reading (chooser, sugar, BP) | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | Number pad opens by itself; last time of day + unit remembered |
| Result: in range / outside | 0 | 0 | 0 | 0 | - | 0 | - | 1 | - | 0 | Long at large text; "Not yet reviewed" label on food lists |
| Result: no ranges | 0 | 0 | 0 | 0 | - | 0 | - | 0 | 0 | 0 | Says exactly what to do ("Enter the doctor's ranges") |
| Urgent screen | 0 | 0 | 1 | 0 | - | 0 | 0 | 0 | 0 | 0 | First contact is a fixed bottom button; no "mark as done" |
| History (chart, list) | 0 | 0 | 0 | 0 | - | 0 | 0 | 1 | - | 0 | Chart has spoken summary; shapes + dashes, not colour |
| Reminders list + form | 0 | 1 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 1 | Minutes move in 5s; "Alarms & reminders" is the phone's own English name |
| Doctor report | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 2 taps from Home; English by design (explained on screen) |
| Settings | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | - | 0 | Longer list; every row has an icon + words |
| PIN lock + PIN setup | 0 | 0 | 1 | 0 | 0 | 0 | - | 0 | 0 | 0 | "Forgot PIN" = erase everything, said plainly; 30 s lock-out after 5 wrong tries |
| Your data (save / delete) | 0 | 0 | 0 | 0 | 0 | 0 | - | 0 | 0 | 0 | Two confirmations before deleting; backup cannot be restored yet (stated) |
| How to use | - | 0 | 0 | 0 | - | 0 | - | 0 | - | 0 | Five steps, big icons, urgent step stands out |
| Error page / startup failure | 0 | 0 | - | 0 | - | - | - | 0 | 0 | - | Plain words, one button, no technical text |

## Open issues (need real users or a device)
1. Reminder minute steps of 5 may annoy someone who needs 8:07 (sev 2).
2. A saved reading cannot be edited, only deleted and re-added (sev 1-2).
3. Is "Urgent" understood by the parents? (usability task 6)
4. Nepali wording of every screen and of the food items (native speaker).
5. Does the long Result screen get read to the end at large text?

---

# Detail by phase

Method: **inspection by the developer and automated tests only.** No real
caregiver has used the app. Severity: 0 = none, 1 = cosmetic, 2 = minor,
3 = major, 4 = blocker. `n/a` = screen does not have the feature yet.

## Phase 1 screens: Welcome, Home/Medicines/History (placeholders), Settings, Disclaimer

| # | Heuristic | Welcome | Settings | Disclaimer | Sev | Notes / fix applied |
|---|---|---|---|---|---|---|
| 1 | Visibility of status | Accepting moves straight to Home | Selected option has icon + bold + border; live "Today's date" preview shows the change | n/a | 0 | Preview added so a date-style change is visible at once |
| 2 | Real-world match | Plain words, "his doctor" | "Blood sugar", "Number style" | Plain words | 0 | Nepali copy needs native review |
| 3 | User control | No cancel by design (must read the notice once) | Changes are instant and reversible; Back works | Back works | 1 | Intentional on Welcome |
| 4 | Consistency | One primary button | Same `ChoiceGroup` for all four settings | Same `DisclaimerCard` as Welcome | 0 | One shared widget, one wording |
| 5 | Error prevention | n/a | Only fixed choices, no free typing | n/a | 0 | |
| 6 | Recognition over recall | n/a | All options visible, none hidden | n/a | 0 | |
| 7 | Flexibility/efficiency | n/a | Defaults: English, AD, mg/dL, Latin digits | n/a | 0 | Last-used tag/unit columns exist; used in Phase 3 |
| 8 | Minimalist design | One button, one card | 5 cards, one decision each | One card | 1 | Settings is long at large text; it scrolls |
| 9 | Error recovery | n/a | n/a | n/a | n/a | No errors possible yet |
| 10 | Help | n/a | "How to make text bigger" card | n/a | 2 | Optional "How to use" screen planned for Phase 6 |

## Open items (need a human)

- Nav-bar labels are capped by Flutter at 1.3x text scale (base 16sp, so
  about 21sp at most). Icons + labels together; check on a phone at 200%.
- Read the Nepali strings with a native speaker.

## Phase 2 screens: Setup wizard, Profile hub, Home checklist, Medicines tab, Medicine form, Contact form

Method unchanged: inspection + automated tests only, **no real users yet**.

| # | Heuristic | Where checked | Sev | Notes / fix applied |
|---|---|---|---|---|
| 1 | Visibility of status | Home: "Given at 9:00 AM", "2 of 3 given", "All given" with icons; wizard "Step 2 of 6" + progress bar; "Saved" message after every save | 0 | Snackbar used to cover the next screen's buttons - **fixed** by putting action buttons in the Scaffold bottom slot |
| 2 | Real-world match | "Give Ram his morning medicine"; "Be careful if above"; medicine typed as on the packet | 0 | Nepali wording needs a native reader |
| 3 | User control | Tick is undone by tapping again (hint shown); back arrow on every step; remove has a confirmation | 1 | Wizard has no "skip" button; Next with nothing typed is the skip |
| 4 | Consistency | Same big check tile for doses, conditions, times, soft food; same bottom button bar | 0 | |
| 5 | Error prevention | Name required; age 1-120; doses can only be changed for today; ranges must be in order; typo catcher on numbers; phone check; delete/remove confirm | 0 | Wrong-order message names the fix |
| 6 | Recognition | Times shown with sun/moon icons + text; options always visible | 0 | |
| 7 | Efficiency | One tap per dose on Home; sugar unit defaults to the Settings choice; numeric keypad | 1 | Remember-last-tag arrives with readings (Phase 3) |
| 8 | Minimalist | One main button per screen | 1 | Ranges step is long when 2 conditions are on (collapsed "different times" sections) |
| 9 | Error recovery | Messages say what to do ("Please type his name.") | 0 | |
| 10 | Help | Short intro line on each wizard step | 2 | Full "How to use" screen still planned (Phase 6) |

### Real problems found and fixed this phase (by automated tests)
- **Setup bounced out after step 1** - the router left the wizard as soon as the patient was saved. Fixed; test covers the whole wizard.
- **"Saved" message hid the next Save/Next button** (time-limited overlay covering a control). Fixed.
- **Wizard header + two button rows filled a 360x640 phone at 200% text** (overflow). Fixed: back arrow moved to the app bar, one big bottom button.
- **Medicine time label overflowed at 200%.** Fixed (flexible text).

## Phase 3 screens: Add reading (chooser + 2 forms), Result (guidance / urgent / no ranges), Home readings

Inspection + automated tests only; **no real users yet**.

| # | Heuristic | Where checked | Sev | Notes / fix applied |
|---|---|---|---|---|
| 1 | Visibility of status | After Save the result appears at once; tier shown as icon + words + colour; "Not yet reviewed" label; the reading value is repeated on the result | 0 | |
| 2 | Real-world match | "Top number / Bottom number", "Prefer", "Go easy on"; meter unit names as on the device | 0 | Nepali needs a native reader |
| 3 | User control | Back works on every form; urgent screen has "Back to Home"; entering a wrong number is fixed before saving | 1 | A saved reading cannot be edited or deleted yet (history screen, Phase 5) |
| 4 | Consistency | Same tier banner/chip on result and Home; same bottom button bar | 0 | |
| 5 | Error prevention | Empty / 99999 / BP 1300 / top <= bottom are refused with a plain message and nothing is saved | 0 | Typo catchers, not medical ranges |
| 6 | Recognition | Time of day and unit are visible choices, not codes | 0 | |
| 7 | Efficiency | Number pad opens by itself; last time-of-day and unit are remembered; single condition skips the chooser. Saving needs: type number + 1 tap | 0 | Timing with the parents still to do |
| 8 | Minimalist | One main action per screen; urgent screen has only the message and contacts | 1 | Result screen can be long (3 cards + plan) at large text |
| 9 | Error recovery | "This number looks wrong. Please check the meter and type it again." ; failed call shows the number to dial by hand | 0 | |
| 10 | Help | "No range to compare" explains why and links to the fix | 2 | Full help screen still planned |

### Real problems found and fixed this phase (by automated tests)
- **At 200% text on a small phone the call buttons were off-screen on the urgent screen.** Fixed: the first contact (doctor first) is a fixed bottom button; headline text is capped at 1.15x (it is already 36sp), call text at 1.3x.
- **A general "go easy on deep-fried" tip showed on a LOW reading**, against the "no food advice for lows" rule. Fixed (in-range only) and covered by a test.
- Home shortcut layout pushed older controls below the fold; test updated to scroll.

## Phase 4 screens: Reminders list, Reminder form, permission cards, Home nudge

Inspection + automated tests (with a pretend phone) only; **real phone test and real users still pending**.

| # | Heuristic | Where checked | Sev | Notes / fix applied |
|---|---|---|---|---|
| 1 | Visibility of status | Each reminder shows time, repeat and "Next: Tomorrow, 8:00 AM"; On/Off is a big box with words and icon; "Saved" message; permission card turns into "Reminders are on and will arrive on time" | 0 | |
| 2 | Real-world match | "Morning medicine", "Every Saturday", 12-hour AM/PM times; permission wording in plain language with where to tap in the phone settings | 1 | "Alarms & reminders" is the phone's own name and is kept in English |
| 3 | User control | Switch off without deleting; delete asks first and says medicines are not changed; Cancel and Back on the form | 0 | |
| 4 | Consistency | Same big tick box for On/Off as for doses; same bottom Save bar | 0 | |
| 5 | Error prevention | Time is chosen with + / - (no typing, no invalid time); own reminder needs a name; days limited to 1-28 | 0 | |
| 6 | Recognition | The chosen time is written out in full in big text and spoken by the screen reader | 0 | |
| 7 | Efficiency | Defaults are ready; change a time in about 3 taps. Minutes move in 5s (a time like 8:07 cannot be set) | 2 | Documented limit; fine for medicine times |
| 8 | Minimalist | One decision per block; permission cards only when something is missing | 1 | Reminder card has two tap areas (edit, on/off) |
| 9 | Error recovery | If notifications are denied the card stays, explains the phone-settings route, and nothing breaks; test button says "Allow notifications first." | 0 | |
| 10 | Help | Test buttons + battery hint ("auto-start") on the same screen | 1 | |

### Real problems found and fixed this phase (by automated tests)
- A new snackbar queued behind older ones (a message could appear 8 seconds late). Now replaces the current one.
- v1 databases could not upgrade to v3 (migration test updated and passing).

## Phase 5 screens: History (chart, summary, list), Doctor report screen, Delete reading

Inspection + automated tests only; **real phone and real users still pending**.

| # | Heuristic | Where checked | Sev | Notes / fix applied |
|---|---|---|---|---|
| 1 | Visibility of status | Report: "Making the report..." while working; counts of what will be included; failure message in words | 0 | |
| 2 | Real-world match | "Last 2 weeks", "Share PDF", "Preview or print"; chart legend in plain sentences | 0 | |
| 3 | User control | Delete asks first ("cannot be undone"); a typo on the urgent screen can be removed | 1 | No edit of a saved reading (delete + add again) |
| 4 | Consistency | Same big choice buttons (check icon + bold + border) for period and measure; same tier chip as Home | 0 | |
| 5 | Error prevention | Report can't start without a profile; period has only two choices | 0 | |
| 6 | Recognition | Chart legend explains shading, dashed lines, dot shapes in words | 0 | Colour is never the only code: shapes + dashes + words |
| 7 | Efficiency | 2 taps from Home to the share sheet; 2 weeks already selected | 0 | Timing with real users pending |
| 8 | Minimalist | One chart + one summary + list; report screen has one purpose | 1 | History is long at large text; it scrolls |
| 9 | Error recovery | "The report could not be made. Please try again." with the button still there | 0 | |
| 10 | Help | Report screen says it is in English and private | 1 | |

### Real problems found and fixed this phase
- The chart's spoken summary was merged into its heading by the screen-reader tree; the chart is now its own node.
- Y-axis labels were odd numbers (351, 244, 136); now round numbers (100, 200, 300), tested.
- Blood-pressure shading belongs to the top number only; the legend now says so.
- Nepali text in a PDF would be garbled by the PDF library; it is drawn as pictures instead (tested, and checked by rendering the pages).

## Phase 6 additions: PIN lock, Your data, How to use, error page

Inspection + automated tests only.

- **Real problem found and fixed by a test:** the lock screen sits above the app's navigator, so "Forgot PIN?" (a dialog) would have crashed on a phone. The lock screen now has its own navigator.
- PIN: wrong-PIN message is in words with an icon and is announced; a 30-second lock-out counts down in words; the PIN pad keys are 76 dp and announced by digit.
- Delete all data needs two confirmations, with the "keep my data" choice as the filled (default) button.
- How to use: five steps, the "Urgent" step is visually distinct (icon + colour + words).
- The automated audit (tap-target size, labels, contrast) found no failures on the 28 screens/states tested; a self-test proves it can fail.
