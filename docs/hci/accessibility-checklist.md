# Accessibility checklist (WCAG 2.2 AA baseline) - work in progress

Evidence = automated test or code inspection. **Nothing here was tested with
real users or TalkBack on a device yet** (marked "device").

| Item | Status | Evidence |
|---|---|---|
| Text contrast >= 4.5:1 (large 3:1) | Done (Phase 1 palette) | `test/core/theme_contrast_test.dart` checks 12 text pairs + outlines |
| Tiers never colour alone | Done (styles) | Each tier has its own icon (tested); text labels come in Phase 3 |
| Body text >= 18sp | Done | Test asserts body sizes >= 18 |
| Buttons >= 56dp high | Done | Test asserts button theme + Settings choice rows >= 56dp |
| Works at 200% font, EN + NE | Done for Phase 1 screens | `test/features/font_scale_test.dart`, 360x640 phone, no overflow |
| Screen-reader labels | Partly | Choice rows expose label/selected/button (tested); **device: TalkBack pass pending** |
| Logical focus order | Not verified | device |
| No time limits / no gesture-only input | Done so far | No timers, swipes or long-presses used |
| Tremor-friendly inputs | n/a yet | Number pad + steppers arrive with Add reading (Phase 3) |
| Plain, grade-6 language | Done by inspection | Short sentences; Nepali needs native review |
| Nav-bar label scaling | Known limit | Flutter caps nav labels at 1.3x |
