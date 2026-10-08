import 'package:care_companion/data/db/app_database.dart';
import 'package:care_companion/data/enums.dart';
import 'package:care_companion/data/repositories/reading_repository.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../helpers/fake_gateway.dart';
import '../helpers/pump_app.dart';

/// Runs Flutter's own accessibility checks on the screen that is showing:
///  - every tap target is at least 48 x 48 dp,
///  - every tap target has a label a screen reader can speak,
///  - text contrast meets WCAG AA (4.5:1, large text 3:1).
/// Returns a list of problems (empty = pass) so one run reports everything.
Future<List<String>> audit(WidgetTester tester) async {
  final problems = <String>[];
  final checks = <String, AccessibilityGuideline>{
    'tap target size (48dp)': androidTapTargetGuideline,
    'tap target label': labeledTapTargetGuideline,
    'text contrast': textContrastGuideline,
  };
  for (final e in checks.entries) {
    final handle = tester.ensureSemantics();
    try {
      final result = await e.value.evaluate(tester);
      if (!result.passed) problems.add('${e.key}: ${result.reason}');
    } finally {
      handle.dispose();
    }
  }
  return problems;
}

void main() {
  testWidgets('SELF-TEST: the audit really catches bad widgets', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Column(children: [
          const SizedBox(height: 100), // the checker skips things touching the screen edge
          // too small, and no label
          Semantics(
            button: true,
            onTap: () {},
            child: const SizedBox(width: 20, height: 20, child: ColoredBox(color: Colors.black)),
          ),
          // pale grey text on white
          const Text('hard to read', style: TextStyle(color: Color(0xFFDDDDDD), fontSize: 16)),
        ]),
      ),
    ));
    await tester.pumpAndSettle();
    final problems = await audit(tester);
    expect(problems.any((p) => p.startsWith('tap target size')), isTrue, reason: '$problems');
    expect(problems.any((p) => p.startsWith('tap target label')), isTrue, reason: '$problems');
    expect(problems.any((p) => p.startsWith('text contrast')), isTrue, reason: '$problems');
  });

  const phone = Size(411, 891);

  Future<void> visit(WidgetTester tester, String path) async {
    final router = GoRouter.of(tester.element(find.byType(Scaffold).first));
    router.push(path);
    await tester.pumpAndSettle();
  }

  // Shared fixture: a full profile so every screen has something on it.
  Future<void> fixture(AppDatabase db) async {
    await enableDiabetes(db);
    await enableHypertension(db);
    await addContact(db, 'Dr Test', '9800000000');
    await addMed(db, 'Test tablet', {DoseSlot.morning, DoseSlot.night});
    final repo = ReadingRepository(db);
    for (var i = 1; i <= 5; i++) {
      await repo.save(
          patientId: 1, kind: 'blood_sugar', unit: 'mg/dL',
          measuredAt: DateTime(2025, 4, 14 - i, 9), value: 90.0 + i * 25, tag: 'tagFasting');
      await repo.save(
          patientId: 1, kind: 'blood_pressure', unit: 'mmHg',
          measuredAt: DateTime(2025, 4, 14 - i, 9), systolic: 120 + i * 5, diastolic: 80 + i * 2, pulse: 70);
    }
  }

  final screens = <String, String>{
    'Home': '',
    'Profile hub': '/profile',
    'Medicines (tab)': 'tab:1',
    'History (tab)': 'tab:2',
    'Settings (tab)': 'tab:3',
    'Reminders': '/reminders',
    'Reminder form': '/reminder/new',
    'Add reading chooser': '/reading/new',
    'Blood sugar form': '/reading/new/blood_sugar',
    'Blood pressure form': '/reading/new/blood_pressure',
    'Medicine form': '/medicine/new',
    'Contact form': '/contact/new',
    'Wizard step (about him)': '/profile/edit/0',
    'Wizard step (doctor ranges)': '/profile/edit/4',
    'Doctor report': '/report',
    'How to use': '/help',
    'PIN settings': '/pin',
    'Set PIN': '/pin/set',
    'Your data': '/data',
    'Disclaimer': '/settings/disclaimer',
  };

  for (final entry in screens.entries) {
    appTest('accessibility guidelines: ${entry.key}', (tester) async {
      await pumpApp(tester, size: phone, gateway: FakeGateway(), beforeStart: fixture);
      if (entry.value.startsWith('tab:')) {
        final i = int.parse(entry.value.substring(4));
        await tester.tap(find.descendant(
            of: find.byType(NavigationBar), matching: find.byType(NavigationDestination)).at(i));
        await tester.pumpAndSettle();
      } else if (entry.value.isNotEmpty) {
        await visit(tester, entry.value);
      }
      final problems = await audit(tester);
      expect(problems, isEmpty, reason: '${entry.key}:\n${problems.join('\n')}');
    });
  }

  // The result screens in each tier.
  for (final v in [(120.0, 'in range'), (200.0, 'outside range'), (400.0, 'urgent')]) {
    appTest('accessibility guidelines: result screen (${v.$2})', (tester) async {
      final db = await pumpApp(tester, size: phone, beforeStart: fixture);
      final id = await ReadingRepository(db).save(
          patientId: 1, kind: 'blood_sugar', unit: 'mg/dL',
          measuredAt: DateTime(2025, 4, 14, 9), value: v.$1, tag: 'tagFasting');
      await visit(tester, '/reading/$id');
      final problems = await audit(tester);
      expect(problems, isEmpty, reason: '${v.$2}:\n${problems.join('\n')}');
    });
  }

  appTest('accessibility guidelines: result screen (no ranges)', (tester) async {
    final db = await pumpApp(tester, size: phone, beforeStart: (db) => enableDiabetes(db, withRange: false));
    final id = await ReadingRepository(db).save(
        patientId: 1, kind: 'blood_sugar', unit: 'mg/dL',
        measuredAt: DateTime(2025, 4, 14, 9), value: 120);
    await visit(tester, '/reading/$id');
    final problems = await audit(tester);
    expect(problems, isEmpty, reason: problems.join('\n'));
  });

  appTest('accessibility guidelines: first launch (welcome)', (tester) async {
    await pumpApp(tester, size: phone, disclaimerAccepted: false, withPatient: false);
    final problems = await audit(tester);
    expect(problems, isEmpty, reason: problems.join('\n'));
  });

  appTest('accessibility guidelines: setup wizard', (tester) async {
    await pumpApp(tester, size: phone, withPatient: false);
    final problems = await audit(tester);
    expect(problems, isEmpty, reason: problems.join('\n'));
  });

  appTest('accessibility guidelines: PIN lock screen', (tester) async {
    await pumpApp(tester, size: phone, beforeStart: (db) async {
      await db.updateSettings(const AppSettingsTableCompanion(
          pinHash: Value('x'), pinSalt: Value('y')));
    });
    expect(find.byIcon(Icons.lock), findsOneWidget);
    final problems = await audit(tester);
    expect(problems, isEmpty, reason: problems.join('\n'));
  });

  appTest('accessibility guidelines: Nepali Home and Settings', (tester) async {
    final db = await pumpApp(tester, size: phone, beforeStart: fixture);
    await db.updateSettings(const AppSettingsTableCompanion(
        language: Value(AppLanguage.ne), digitStyle: Value(DigitStyle.devanagari)));
    await tester.pumpAndSettle();
    var problems = await audit(tester);
    expect(problems, isEmpty, reason: 'Home (ne):\n${problems.join('\n')}');
    await tester.tap(find.descendant(
        of: find.byType(NavigationBar), matching: find.byType(NavigationDestination)).at(3));
    await tester.pumpAndSettle();
    problems = await audit(tester);
    expect(problems, isEmpty, reason: 'Settings (ne):\n${problems.join('\n')}');
  });
}
