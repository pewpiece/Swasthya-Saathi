# Usability test plan (for you and the parents to run)

**Status: NOT YET RUN.** Nothing in this app has been tested by real caregivers.
Everything the developer could check by inspection or automated tests is in
`heuristic-evaluation.md` and `accessibility-checklist.md`. This plan is how to
find out what the tests cannot.

## Who and where
- **3 to 5 caregivers** like the real ones: older adults who help care for a
  parent, comfortable with a phone but not technical. Test with each on their
  *own* phone if possible (their font size, their habits), otherwise on the
  same test phone.
- Use **test data only**: tap "Load demo data" on a debug build, then type
  made-up doctor numbers. Never use a real parent's medicines or numbers.
- Quiet room, about 30-40 minutes each. One facilitator, one note-taker (can be
  the same person with a phone recording, if the participant agrees).

## Before you start (facilitator)
1. Install the latest APK. Set up the demo profile ("Ram") with: sugar ranges,
   blood pressure ranges, one emergency contact (a made-up number such as your
   own), two medicines (morning + night), the four default reminders.
2. Put the phone back at the **Home screen**. Language: English for tasks 1-3,
   5, 6; the language switch is task 4.
3. Have the **timer**, the **observation notes** page and the **SUS** form ready.
4. Reset between participants: Settings -> Your data -> Delete all data, then
   load the demo data again.

## Say this to the participant (script)
> "Thank you for helping. We are testing the **app**, not you. If something is
> confusing, that is the app's fault, and it helps us fix it. Please **say out
> loud what you are thinking** as you go, even small things like 'I'm looking for
> the button'. I will not help unless you are completely stuck. You can stop at
> any time. Nothing here is real medical information."

## Think-aloud protocol
- Ask the participant to keep talking: what they look at, what they expect, what
  they are unsure about.
- If silent for 10 seconds: "What are you thinking now?"
- Do **not** explain, hint or point. If stuck for 60 seconds, note "needed help
  at <time>" and give the smallest hint. Mark the task "assisted".
- Note exact words used for things ("the sugar button", "the red thing").

## Tasks
Read the scenario aloud. Start the timer when the participant starts touching
the phone. Stop when they say they are done or reach the success state.

| # | Scenario to read | Starts on | Success = | Target | Measures |
|---|---|---|---|---|---|
| 1 | "It is morning. You just measured Ram's **blood sugar: 120**. Please write it in the app." | Home | Reading saved and the result screen is shown | **< 15 s, no help** | time, errors, taps |
| 2 | "You have just given Ram his **night medicine**. Mark it as given. Then you notice you tapped the wrong one: undo it." | Home | Night dose ticked, then un-ticked | Tick in **<= 2 taps** from opening the app | taps, did they find undo without help? |
| 3 | "Ram's morning medicine reminder should be at **7:30**, not 8:00. Change it." | Home | Reminder shows 7:30 AM and is on | **< 1 min first try** | time, errors |
| 4 | "Please switch the app to **Nepali**." (Then back to English.) | Home | Language changed; they can say what changed | < 30 s | time, errors |
| 5 | "The doctor wants to see the last **2 weeks**. Make the report so you can send it." | Home | Share sheet (or preview) opens | **< 1 min** | time, errors, did they choose the period? |
| 6 | "Ram's sugar is **400**. Enter it. Tell me what the app is telling you to do, and show me what you would do." | Home | They enter the number, read the Urgent screen, say "call the doctor/emergency", and find the call button | understanding, **< 30 s to reach the call button** | comprehension, time |

(Task 6 uses made-up urgent numbers set up in the demo profile. Do not place a
real call: stop at the button.)

## Observation notes template (one per task per participant)
```
Participant: ___  Age: ___  Phone/font size: ___  Date: ___
Task #: ___   Start time: ___   End time: ___   Total: ___ s
Result:  [ ] Success   [ ] Success with help   [ ] Gave up / fail
Taps counted: ___    Wrong taps / backtracking: ___
Where they hesitated or looked lost: ______________________
Words they used for things: ________________________________
Things they said (quotes): _________________________________
Did they read the screen text? [ ] yes [ ] partly [ ] no
Anything hard to see/hit (small text, mis-taps, shaky hand)? ____
Severity of the worst problem (0-4): ___    Idea for a fix: ____
```
Severity: 0 = not a problem, 1 = cosmetic, 2 = minor (slows them), 3 = major
(causes mistakes or failure for some), 4 = blocker (cannot continue).

## Results table (fill in)
| Participant | T1 time | T1 ok? | T2 taps | T2 undo found? | T3 time | T3 ok? | T4 ok? | T5 time | T5 ok? | T6 understood? | T6 time to call btn |
|---|---|---|---|---|---|---|---|---|---|---|---|
| P1 | | | | | | | | | | | |
| P2 | | | | | | | | | | | |
| P3 | | | | | | | | | | | |
| Median | | | | | | | | | | | |
| Target | < 15 s | 100% | <= 2 | yes | < 60 s | 100% | 100% | < 60 s | 100% | 100% | < 30 s |

Targets from the project brief (section 11D): log a reading under 15 s with no
help; tick a medicine in at most 2 taps; change a reminder in under 1 minute on
the first try; find and generate the report in under 1 minute. A target is
**met** only if most participants reach it unaided.

## After the tasks
1. Ask: "What was the easiest thing? What was the most confusing?"
2. Ask: "Was there any word you did not understand?" (especially in Nepali)
3. Ask: "Would you trust the app's colours/words about 'Urgent'?"
4. Give the **SUS** (plain-language version, `sus-questionnaire.md`).
5. Thank them. Do not discuss real medical decisions.

## Also check on the phone (device checks, any time)
Use `docs/device-test-phase4.md` (reminders, restart) and
`docs/device-test-phase5.md` (history, PDF) and, with TalkBack on, listen to
Home, the Add reading form, the Urgent screen and the Reminders list: does every
control say what it is?

## What to do with the results
- Fix every severity 3-4 problem before real use. Re-test those tasks.
- Record SUS scores (68 is average; 80+ is good). Low scores with good task
  results usually mean wording problems, not layout problems.
- Update `heuristic-evaluation.md` with what real users found (add a column).
