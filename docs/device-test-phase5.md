# Phase 5: testing History and the doctor report on your phone

Use the newest APK from GitHub (Actions -> newest run -> Artifacts). The debug
app has "Load demo data (testing only)" on the first screen: use it, then
type your own *test* ranges in Profile -> Doctor's numbers, so the chart shows
a shaded band.

| # | Do this | Expected | OK? |
|---|---|---|---|
| 1 | Add 4-5 readings (sugar and/or pressure) on different values | They appear on the **History** tab | |
| 2 | Open **History** | A chart with dots and a line, a grey-green shaded band for the doctor's range, dashed urgent lines, a summary, and the list below | |
| 3 | Tap **Last 4 weeks**, **Last 3 months**, and (if both conditions are on) **Blood pressure** | Chart and numbers change; blood pressure shows two lines (round dots solid, square dots dashed) | |
| 4 | Set the phone to the largest text size and look at History again | Nothing is cut off; the chart numbers stay readable | |
| 5 | Tap a reading in the list, then the bin icon, then **Keep it**, then the bin and **Delete** | It asks first; after Delete it is gone from the list | |
| 6 | **Home -> Doctor report** | 2 weeks is already selected; it says how many readings and medicines it will include | |
| 7 | Tap **Share PDF**, choose WhatsApp / Drive / Gmail / "Save to files" | The PDF is created in a few seconds and the share sheet opens | |
| 8 | Open the received PDF | 2-3 pages: summary, doctor's ranges, chart + table per measure, medicines and doses table, disclaimer at the bottom of every page | |
| 9 | Tap **Preview or print** | A preview opens; "Save as PDF" works | |
| 10 | Put a Nepali name or note in the profile, then make the report | The Nepali name shows correctly (not broken letters) | |
| 11 | Switch the app to Nepali + BS dates and make the report again | The report is still in English; dates show AD with BS in brackets | |

Time yourself: from Home to the share sheet should take **under 1 minute**.

Please report: phone model, which step failed, and (for the PDF) a screenshot
of any page that looks wrong.
