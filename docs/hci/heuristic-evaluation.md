# Heuristic evaluation (Nielsen) - work in progress

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
