import 'package:care_companion/data/photo_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

Future<void> tapText(WidgetTester t, String text) async {
  await t.ensureVisible(find.text(text).first);
  await t.tap(find.text(text).first);
  await t.pumpAndSettle();
}

void main() {
  const tall = Size(411, 1800);

  group('profile photo', () {
    appTest('add from the gallery, save, remove; old file is deleted', (tester) async {
      final photos = FakePhotoStore();
      final db = await pumpApp(tester, size: tall, photos: photos);
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();
      await tapText(tester, 'About him');
      expect(find.text('Choose from gallery'), findsOneWidget);
      expect(find.text('Remove photo'), findsNothing);

      await tapText(tester, 'Choose from gallery');
      expect(photos.asked, [PhotoSource.gallery]);
      expect(find.text('Remove photo'), findsOneWidget);
      await tapText(tester, 'Done');
      expect((await db.select(db.patients).getSingle()).photoPath, 'photo_1.jpg');

      await tapText(tester, 'About him');
      await tapText(tester, 'Remove photo');
      await tapText(tester, 'Done');
      expect((await db.select(db.patients).getSingle()).photoPath, isNull);
      expect(photos.removed, ['photo_1.jpg']);
    });

    appTest('camera works, cancelling changes nothing', (tester) async {
      final photos = FakePhotoStore(picks: null);
      final db = await pumpApp(tester, size: tall, photos: photos);
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();
      await tapText(tester, 'About him');
      await tapText(tester, 'Take a photo');
      expect(photos.asked, [PhotoSource.camera]);
      await tapText(tester, 'Done');
      expect((await db.select(db.patients).getSingle()).photoPath, isNull);
    });

    appTest('avatar has a spoken label', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpApp(tester);
      expect(find.bySemanticsLabel(RegExp('Photo of Ram')), findsOneWidget);
      handle.dispose();
    });
  });

  group('privacy screen', () {
    appTest('is on by default; the switch turns it off and tells the phone', (tester) async {
      final calls = <MethodCall>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('org.carecompanion/privacy'),
        (call) async {
          calls.add(call);
          return null;
        },
      );
      addTearDown(() => tester.binding.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('org.carecompanion/privacy'), null));

      final db = await pumpApp(tester, size: tall);
      expect((await db.select(db.appSettingsTable).getSingle()).privacyScreen, isTrue);
      expect(calls.last.arguments, true);

      await tester.tap(find.descendant(
          of: find.byType(NavigationBar), matching: find.text('Settings')));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Hide the app in screenshots and recent apps'), 300,
          scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();
      expect(find.textContaining('screenshots are blocked'), findsOneWidget);
      await tapText(tester, 'Hide the app in screenshots and recent apps');
      expect(find.textContaining('screenshots work'), findsOneWidget);
      expect((await db.select(db.appSettingsTable).getSingle()).privacyScreen, isFalse);
      expect(calls.last.arguments, false);
    });
  });
}
