# Accessibility checklist (WCAG 2.2 AA baseline, older users)

Legend: **TESTED** = an automated test fails if it breaks; **INSPECTED** = checked
by reading the code/screens; **DEVICE** = needs a real phone; **USERS** = needs
the parents. Nothing here claims real-user testing happened.

## Automated checks that run on every build
| Check | Where | Covers |
|---|---|---|
| Colour pairs >= 4.5:1 (text), >= 3:1 (outlines/icons) | `test/core/theme_contrast_test.dart` | 12 text pairs incl. all three tiers |
| Tap targets >= 48 x 48 dp, labelled, text contrast | `test/accessibility/guidelines_test.dart` (Flutter's own `androidTapTargetGuideline`, `labeledTapTargetGuideline`, `textContrastGuideline`) | **28 screens/states**: Home, all tabs, every form, wizard, three result tiers + no-ranges, urgent, report, help, PIN screens, lock screen, data, Nepali Home + Settings. A self-test proves the audit really fails on bad widgets |
| 200% system text, no overflow, EN + NE | `test/features/font_scale_test.dart` | every screen on a 360 x 640 dp phone; key buttons stay on screen |
| Body text >= 18sp, buttons >= 56dp | `theme_contrast_test.dart`, `app_flow_test.dart` | theme + Settings rows |

## C. Accessibility items
| Item | Status | Evidence / note |
|---|---|---|
| Text contrast >= 4.5:1 (large 3:1) | TESTED | see above |
| Never colour alone for tiers | TESTED | icon + word + colour on result, Home chip, History list; urgent screen; spoken as words |
| Charts without colour alone | TESTED | circle vs square dots, solid vs dashed, legend in words, all values also in the list |
| Touch targets >= 48 dp (aim 56) | TESTED | guideline test; buttons 56, rows 64-76, PIN keys 76 |
| Spacing between targets | INSPECTED | 8-12 dp between stacked buttons/rows |
| Works at 200% font, EN + NE | TESTED | no overflow or clipped controls on 360 x 640 |
| Large text capped anywhere? | KNOWN LIMITS | (1) Bottom-bar labels: Flutter caps them at 1.3x. (2) Urgent headline 1.15x and call-button text 1.3x (already 36sp / 24sp) so the call button stays on screen. (3) PIN digits 1.3x. (4) Chart axis labels fixed 15sp |
| Screen-reader labels on all controls | TESTED + DEVICE | labelled-tap-target guideline passes on all screens; doses say "given / not given"; charts have a spoken summary; PIN dots announce "n of 4 typed". **TalkBack pass on a phone still to do** |
| Logical focus order | DEVICE | follows widget order (top to bottom); not yet verified with TalkBack |
| No time-limited actions | INSPECTED | the only timers: a 30 s PIN lock-out (counts down in words) and brief "Saved" messages (never the only record of a result; errors stay on screen) |
| No gesture-only input | INSPECTED | no swipe or long-press needed; time and day use + / - buttons; chart is not interactive |
| Tremor-friendly | INSPECTED + USERS | number pad, big keys, steppers, no sliders/drag, confirm before delete/remove; **needs real hands** |
| Low cognitive load: one main task per screen | INSPECTED | bottom button bar with one main action; short sentences; "How to use" screen |
| Plain, short sentences (about grade 6) | INSPECTED | no formal readability score computed; Nepali needs native review |
| Reduced motion / animations | INSPECTED | only default Material transitions |
| Dark mode | NOT SUPPORTED | optional in the brief; light theme only |

## Measurable usability targets (section 11D)
| Target | Status |
|---|---|
| Log a reading in < 15 s with no help | Designed for (number pad opens, defaults remembered, 1 Save tap). **USERS** to time |
| Tick today's morning medicine in <= 2 taps from opening the app | **TESTED**: 1 tap from Home. USERS to confirm they find it |
| Add or change a reminder in < 1 min first try | Designed for (about 3 taps). **USERS** |
| Find and generate the doctor report in < 1 min | **TESTED**: 2 taps (Doctor report, Share PDF). USERS to time |

## Device checks still open
See `docs/device-test-phase4.md` (reminders, restart, exact alarms on the
Redmi) and `docs/device-test-phase5.md` (charts, PDF share and viewing), plus a
TalkBack walk-through of Home, Add reading, Urgent and Reminders.
