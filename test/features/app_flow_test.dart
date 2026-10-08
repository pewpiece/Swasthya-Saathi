import 'package:care_companion/data/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

void main() {
  appTest('first launch shows the disclaimer; accepting opens Home',
      (tester) async {
    final db = await pumpApp(tester, disclaimerAccepted: false);
    expect(find.text('This app is not medical advice'), findsOneWidget);
    expect(find.text('Home'), findsNothing); // no nav yet: must accept first

    await tester.tap(find.text('I understand'));
    await tester.pumpAndSettle();

    expect(find.text('This app is not medical advice'), findsNothing);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect((await db.getSettings()).disclaimerAccepted, isTrue);
  });

  appTest('the four tabs are reachable and labelled', (tester) async {
    await pumpApp(tester);
    for (final label in ['Medicines', 'History', 'Settings', 'Home']) {
      await tester.tap(find.descendant(
          of: find.byType(NavigationBar), matching: find.text(label)));
      await tester.pumpAndSettle();
      expect(find.text(label), findsWidgets);
    }
  });

  appTest('Settings: switching to Nepali updates the whole UI',
      (tester) async {
    final db = await pumpApp(tester);
    await tester.tap(find.text('Settings').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('नेपाली (Nepali)'));
    await tester.pumpAndSettle();

    expect((await db.getSettings()).language, AppLanguage.ne);
    expect(find.text('सेटिङ'), findsWidgets);
    expect(find.text('भाषा'), findsOneWidget);
    expect(find.text('गृहपृष्ठ'), findsOneWidget); // nav label
  });

  appTest('Settings: BS date style and Devanagari digits update preview',
      (tester) async {
    // Tall viewport so the whole list is built (it is a lazy ListView).
    await pumpApp(tester, size: const Size(411, 2000));
    await tester.tap(find.text('Settings').last);
    await tester.pumpAndSettle();
    expect(find.text("Today's date: 14 Apr 2025"), findsOneWidget);

    await tester.tap(find.text('BS (Nepali calendar)'));
    await tester.pumpAndSettle();
    expect(find.text("Today's date: 1 Baisakh 2082 BS"), findsOneWidget);

    await tester.tap(find.text('Nepali numbers (१ २ ३)'));
    await tester.pumpAndSettle();
    expect(find.text("Today's date: १ Baisakh २०८२ BS"), findsOneWidget);
  });

  appTest('selected choice is marked by icon and semantics, not colour',
      (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Settings').last);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.radio_button_checked), findsWidgets);
    final handle = tester.ensureSemantics();
    expect(
      tester.getSemantics(find.text('English')),
      isSemantics(
        label: 'English',
        isButton: true,
        hasSelectedState: true,
        isSelected: true,
        isInMutuallyExclusiveGroup: true,
        hasTapAction: true,
      ),
    );
    handle.dispose();
  });

  appTest('settings disclaimer page is reachable from Settings',
      (tester) async {
    await pumpApp(tester, size: const Size(411, 2400)); // tall: whole list built
    await tester.tap(find.text('Settings').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('This app is not medical advice'));
    await tester.tap(find.text('This app is not medical advice'));
    await tester.pumpAndSettle();
    expect(find.textContaining('does not replace his doctor'), findsOneWidget);
  });

  appTest('choice rows in Settings are at least 56dp high', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Settings').last);
    await tester.pumpAndSettle();
    final row = find.ancestor(
        of: find.text('BS (Nepali calendar)'), matching: find.byType(InkWell));
    expect(tester.getSize(row.first).height, greaterThanOrEqualTo(56));
  });
}
