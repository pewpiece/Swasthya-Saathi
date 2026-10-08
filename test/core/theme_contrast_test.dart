import 'package:care_companion/core/theme/app_theme.dart';
import 'package:care_companion/core/theme/contrast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('contrast helper matches known WCAG values', () {
    expect(contrastRatio(Colors.black, Colors.white), closeTo(21, 0.01));
    expect(contrastRatio(Colors.white, Colors.white), closeTo(1, 0.001));
  });

  // WCAG 2.2 AA: 4.5:1 for normal text, 3:1 for large text and UI shapes.
  final textPairs = <String, (Color, Color)>{
    'body on page': (AppColors.ink, AppColors.cream),
    'body on card': (AppColors.ink, AppColors.card),
    'secondary on page': (AppColors.inkSoft, AppColors.cream),
    'secondary on card': (AppColors.inkSoft, AppColors.card),
    'button label': (Colors.white, AppColors.green),
    'outlined button label': (AppColors.greenDark, AppColors.cream),
    'selected choice': (AppColors.ink, AppColors.greenSoft),
    'nav selected': (AppColors.greenDark, AppColors.greenSoft),
    'in range tier': (AppColors.inRangeFg, AppColors.inRangeBg),
    'caution tier': (AppColors.cautionFg, AppColors.cautionBg),
    'urgent tier': (AppColors.urgentFg, AppColors.urgentBg),
    'urgent on white': (AppColors.urgentFg, Colors.white),
  };
  textPairs.forEach((name, pair) {
    test('text contrast >= 4.5:1: $name', () {
      expect(contrastRatio(pair.$1, pair.$2), greaterThanOrEqualTo(4.5));
    });
  });

  test('UI outlines and icons >= 3:1 against their background', () {
    expect(contrastRatio(AppColors.outline, AppColors.card),
        greaterThanOrEqualTo(3));
    expect(contrastRatio(AppColors.green, AppColors.cream),
        greaterThanOrEqualTo(3));
  });

  test('text theme: body >= 18sp, buttons >= 56dp', () {
    final t = AppTheme.light(nepali: false);
    expect(t.textTheme.bodyMedium!.fontSize, greaterThanOrEqualTo(18));
    expect(t.textTheme.bodyLarge!.fontSize, greaterThanOrEqualTo(18));
    expect(t.textTheme.bodySmall!.fontSize, greaterThanOrEqualTo(18));
    for (final style in [
      t.filledButtonTheme.style,
      t.outlinedButtonTheme.style,
      t.textButtonTheme.style,
    ]) {
      expect(style!.minimumSize!.resolve({})!.height, greaterThanOrEqualTo(56));
    }
  });

  test('every tier has a distinct icon (never colour alone)', () {
    const t = TierStyles();
    expect({t.inRange.icon, t.outOfRange.icon, t.urgent.icon}.length, 3);
  });

  test('Nepali theme uses the Devanagari font first', () {
    expect(AppTheme.light(nepali: true).textTheme.bodyMedium!.fontFamily,
        'NotoSansDevanagari');
  });
}
