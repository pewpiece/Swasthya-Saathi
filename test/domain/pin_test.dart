import 'dart:math';

import 'package:care_companion/domain/pin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a PIN is exactly 4 digits (Latin or Devanagari)', () {
    expect(isValidPin('1234'), isTrue);
    expect(isValidPin('१२३४'), isTrue);
    expect(normalizePin('१२३४'), '1234');
    for (final bad in ['', '123', '12345', 'abcd', '12 4', '12.4', null]) {
      expect(isValidPin(bad), isFalse, reason: '$bad');
    }
  });

  test('hash is salted, repeatable and never contains the PIN', () {
    final s1 = newSalt(Random(1));
    final s2 = newSalt(Random(2));
    expect(s1, isNot(s2));
    final h = hashPin('1234', s1);
    expect(h, hashPin('1234', s1));
    expect(h, isNot(hashPin('1234', s2)), reason: 'different salt, different hash');
    expect(h, isNot(hashPin('1235', s1)));
    expect(h.contains('1234'), isFalse);
    expect(h.length, 64);
  });

  test('matching works with either digit script and rejects bad input', () {
    final salt = newSalt();
    final h = hashPin('0420', salt);
    expect(pinMatches('0420', salt, h), isTrue);
    expect(pinMatches('०४२०', salt, h), isTrue);
    expect(pinMatches('0421', salt, h), isFalse);
    expect(pinMatches('420', salt, h), isFalse);
  });

  group('PinThrottle', () {
    final t0 = DateTime(2026, 10, 8, 9);
    test('wrong tries are allowed up to the limit, then it locks', () {
      final th = PinThrottle(maxFailures: 5, lockSeconds: 30);
      for (var i = 0; i < 4; i++) {
        expect(th.record(correct: false, now: t0), PinResult.wrong);
      }
      expect(th.record(correct: false, now: t0), PinResult.lockedOut);
      expect(th.isLocked(t0), isTrue);
      expect(th.secondsLeft(t0), 31);
    });
    test('even the right PIN is refused while locked; afterwards it works', () {
      final th = PinThrottle(maxFailures: 2, lockSeconds: 30);
      th.record(correct: false, now: t0);
      th.record(correct: false, now: t0);
      expect(th.record(correct: true, now: t0.add(const Duration(seconds: 10))), PinResult.lockedOut);
      expect(th.secondsLeft(t0.add(const Duration(seconds: 10))), greaterThan(0));
      expect(th.isLocked(t0.add(const Duration(seconds: 31))), isFalse);
      expect(th.record(correct: true, now: t0.add(const Duration(seconds: 31))), PinResult.ok);
    });
    test('a correct PIN resets the count', () {
      final th = PinThrottle(maxFailures: 3);
      th.record(correct: false, now: t0);
      th.record(correct: false, now: t0);
      expect(th.record(correct: true, now: t0), PinResult.ok);
      expect(th.record(correct: false, now: t0), PinResult.wrong);
      expect(th.record(correct: false, now: t0), PinResult.wrong);
    });
  });
}
