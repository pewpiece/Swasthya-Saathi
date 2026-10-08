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
