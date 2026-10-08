# Clinician review of the guidance content

Until a doctor or dietitian approves them, **all food and tip content is marked
`"reviewed_by_clinician": false`** and the app shows "Not yet reviewed by a
clinician" under each list. The app also never gives treatment, dosing or
medicine-change advice, and the tier (in range / outside / urgent) comes only
from numbers the family typed in from their own doctor.

## What needs review
Everything in `assets/guidance/*.json` (18 items today): `general.json`,
`diabetes.json`, `hypertension.json`. For every item, the text shown is in
`lib/l10n/app_en.arb` / `app_ne.arb` under the item's `textKey`.

Please check, for the Nepal context and an 85-year-old:
1. Is each food idea safe and sensible as *general* advice? Any that could
   harm someone with kidney, heart or swallowing problems?
2. Are the "go easy on" items worded gently ("go easy on", never "avoid")?
3. Is it right that **low** readings get *no* food advice (only "tell his
   doctor" and the doctor's own plan)? Should something be added?
4. Is the soft-food list enough for chewing problems?
5. Fluids: "unless his doctor has limited fluids" - is that enough?
6. Nepali wording: clear, respectful, correct (a native speaker should read it).

## How to approve (developer step, after sign-off)
1. For each approved item, change `"reviewed_by_clinician": false` to `true` in
   its JSON file. Edit the text in the ARB files if the reviewer changed it.
2. Run `flutter test`. (One test currently asserts that nothing is reviewed.
   Replace it with a test that checks the reviewer's list: the sign-off table
   below should match the files.)
3. The label disappears automatically for a list when *every* item in it is
   reviewed.

## Sign-off record (fill in)
| Item id | Approved (Y/N) | Changes | Reviewer (name, role) | Date |
|---|---|---|---|---|
| gTipSitSlowly | | | | |
| gTipRegularMeals | | | | |
| gTipFluids | | | | |
| gTipWalk | | | | |
| gMealSteamedVeg | | | | |
| gMealCurd | | | | |
| gMealEgg | | | | |
| gMealSoftDalBhat | | | | |
| gMealGreensSoup | | | | |
| gMealKhichadi | | | | |
| gEasyFried | | | | |
| gMealDalBhatMoreVeg | | | | |
| gMealRotiDhido | | | | |
| gEasySugarChiya | | | | |
| gEasySweets | | | | |
| gEasySalt | | | | |
| gEasyAchar | | | | |
| gEasyNoodles | | | | |
