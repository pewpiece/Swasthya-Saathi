# Accessibility checklist (WCAG 2.2 AA baseline) - work in progress

Evidence = automated test or code inspection. **Nothing here was tested with
real users or TalkBack on a device yet** (marked "device").

| Item | Status | Evidence |
|---|---|---|
| Text contrast >= 4.5:1 (large 3:1) | Done (Phase 1 palette) | `test/core/theme_contrast_test.dart` checks 12 text pairs + outlines |
| Tiers never colour alone | Done | Icon + word + colour in the banner, the Home chip and the urgent screen; spoken as words (test) |
| Body text >= 18sp | Done | Test asserts body sizes >= 18 |
| Buttons >= 56dp high | Done | Test asserts button theme + Settings choice rows >= 56dp |
| Works at 200% font, EN + NE | Done for Phase 1+2 screens (Home with doses, Medicines tab, profile hub, all 6 setup steps, medicine form incl. errors) | `test/features/font_scale_test.dart`, 360x640 phone, no overflow |
| Screen-reader labels | Partly | Choice rows and dose tiles say selected / given / not given (tested); profile and contact rows read name + summary; **device: TalkBack pass pending** |
| Logical focus order | Not verified | device |
| No time limits / no gesture-only input | Done so far | No timers, swipes or long-presses used |
| Tremor-friendly inputs | Partly | Number pad for all numbers; whole-row tap targets 64-72dp; no sliders or drags; Add reading (Phase 3) will add the rest |
| Tick today's medicine in <= 2 taps | Met by design (1 tap from Home) | `home_checklist_test.dart`; **timing with real users pending** |
| Controls never hidden by messages | Done | Action buttons sit in the bottom slot; "Saved" appears above them |
| Plain, grade-6 language | Done by inspection | Short sentences; Nepali needs native review |
| Nav-bar label scaling | Known limit | Flutter caps nav labels at 1.3x |
| Urgent screen at 200% | Done | First call button is a fixed bottom button, visible without scrolling at 360x640 (test, EN + NE). Its headline is capped at 1.15x and button text at 1.3x so everything fits |
| Log a reading in < 15 s | Met by design: number pad opens automatically, defaults remembered, 1 tap to save | **timing with real users pending** |
| Call button works on a phone | **device test pending** | `tel:` link; tests use a fake launcher |
| Reminders: no gesture-only input | Done | Time and day use big +/- buttons and visible choices; no dial, no drag, no long-press |
| Reminders: changing a time takes < 1 minute | Met by design (about 3 taps) | **timing with real users pending** |
| Reminders at 200% text, EN + NE | Done | `font_scale_test.dart`: list, both permission cards, add form, every edit form, custom form with error |
| Reminders arrive on a real phone, incl. after restart | **device test pending** | `docs/device-test-phase4.md` |
| Charts without colour alone / without gestures | Done | Dots shaped differently (circle / square), solid vs dashed lines, legend in words, chart not interactive; all values are also in the list below (`history_report_test.dart`) |
| Chart for screen readers | Done | Spoken summary: count, first and last date, lowest, highest (tested); **TalkBack pass on a device pending** |
| History + report at 200% text, EN + NE | Done | `font_scale_test.dart` (charts, both measures, full scroll, report screen with Share button visible) |
| Find the report and generate it in < 1 minute | Met by design (2 taps) | **timing with real users pending** |
| PDF opens and reads well | Checked by rendering the pages to images and reading the text (poppler); **phone PDF viewer test pending** | `docs/device-test-phase5.md` |
