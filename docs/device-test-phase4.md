# Phase 4: testing reminders on a real phone

Automated tests use a pretend phone. **Only a real phone can prove that
reminders arrive.** Please do these steps and write down what happened.
Use a test phone or test data, not real medicines.

## Get the app on the phone
1. GitHub -> repo **pewpiece/CareCompanion** -> **Actions** -> newest
   "Build Android APK" run (green tick).
2. At the bottom, under **Artifacts**, download **care-companion-debug-apk**
   (it has the "Load demo data" button) or **care-companion-release-apk**.
3. Unzip, tap the `.apk`, allow "Install unknown apps" for your browser/files app.

## Before you start
- Phone date, time and time zone on **automatic**.
- Battery saver **off**.
- Write down: phone brand + model, Android version.

## The checks (tick each, note the time it took)
| # | Do this | Expected | OK? |
|---|---|---|---|
| 1 | Open the app, finish setup. Tap **Settings -> Reminders** | Four reminders: Morning medicine 8:00 AM, Night medicine 9:00 PM, Measure again (Saturday 9:00 AM), Monthly check (day 1, 9:00 AM) | |
| 2 | Tap **Allow notifications** and accept the phone's question | The red/green card changes to "Reminders are on..." or asks for exact times | |
| 3 | If asked, tap **Allow exact times** and switch on "Alarms & reminders" for CareCompanion, then come back | Card says "Reminders are on and will arrive on time" | |
| 4 | Tap **Send a test reminder now** | A notification appears at the top within 2 seconds | |
| 5 | Tap **Test reminder in 1 minute**, then **press the phone's home button and lock the screen** | After about 1 minute the phone shows the test reminder (sound/vibration), even though the app is closed | |
| 6 | Tap that notification | The app opens | |
| 7 | Change **Morning medicine** to 3 minutes from now (big + buttons). Save. Close the app completely (swipe it away) | At that minute the reminder "Time to give ... his morning medicine." appears | |
| 8 | **Restart the phone.** Do NOT open the app. Wait for the next reminder time (set one for ~5 minutes after the restart) | The reminder still appears after the restart | |
| 9 | Switch to **Nepali** in Settings. Set a reminder 2 minutes ahead | The reminder text is in Nepali | |
| 10 | Turn a reminder **Off** (its big On/Off box) and wait past its time | Nothing appears | |
| 11 | Delete a reminder | It does not come back, and no notification appears | |
| 12 | Change the phone time zone or clocks forward one day (optional) | Reminders still arrive at the right *local* time | |

## If a reminder is late or missing
- On Xiaomi / Oppo / Vivo / Realme / Samsung phones: Settings -> Battery ->
  allow CareCompanion to run in the background (sometimes called "auto-start"
  or "unrestricted").
- Check that **Notifications** are on for the app (Settings -> Apps ->
  CareCompanion -> Notifications).
- Tell me the brand, Android version, which step failed, and the clock time.

## What to report back
Phone model, Android version, and for each row above: worked / did not work,
and any message you saw.
