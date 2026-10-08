// GENERATED from assets/guidance/*.json texts - keep in sync with the ARB files.
// Test `guidance_content_test.dart` fails if a textKey in a JSON file is missing here.
import '../../l10n/app_localizations.dart';

/// Resolves a guidance `textKey` (from assets/guidance/*.json) to text.
/// Returns null for an unknown key so callers can fail loudly in tests.
String? guidanceTextOrNull(AppL10n l, String key) {
  switch (key) {
    case 'gTipSitSlowly':
      return l.gTipSitSlowly;
    case 'gTipRegularMeals':
      return l.gTipRegularMeals;
    case 'gTipFluids':
      return l.gTipFluids;
    case 'gTipWalk':
      return l.gTipWalk;
    case 'gMealSteamedVeg':
      return l.gMealSteamedVeg;
    case 'gMealCurd':
      return l.gMealCurd;
    case 'gMealEgg':
      return l.gMealEgg;
    case 'gMealSoftDalBhat':
      return l.gMealSoftDalBhat;
    case 'gMealGreensSoup':
      return l.gMealGreensSoup;
    case 'gMealKhichadi':
      return l.gMealKhichadi;
    case 'gEasyFried':
      return l.gEasyFried;
    case 'gMealDalBhatMoreVeg':
      return l.gMealDalBhatMoreVeg;
    case 'gMealRotiDhido':
      return l.gMealRotiDhido;
    case 'gEasySugarChiya':
      return l.gEasySugarChiya;
    case 'gEasySweets':
      return l.gEasySweets;
    case 'gEasySalt':
      return l.gEasySalt;
    case 'gEasyAchar':
      return l.gEasyAchar;
    case 'gEasyNoodles':
      return l.gEasyNoodles;
  }
  return null;
}
