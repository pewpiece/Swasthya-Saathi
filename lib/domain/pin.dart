import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

import '../core/dates/digits.dart';
import '../data/enums.dart';

const pinLength = 4;

/// A PIN is exactly 4 digits (Latin or Devanagari typed, stored as Latin).
bool isValidPin(String? text) =>
    text != null && RegExp(r'^\d{4}$').hasMatch(convertDigits(text, DigitStyle.latin));

String normalizePin(String text) => convertDigits(text, DigitStyle.latin);

String newSalt([Random? random]) {
  final r = random ?? Random.secure();
  return base64UrlEncode([for (var i = 0; i < 16; i++) r.nextInt(256)]);
}

/// Salted, slowed-down SHA-256. The PIN itself is never stored. With only
/// 10,000 possible PINs this is a privacy lock, not strong security (the
/// database is not encrypted); the README says so.
String hashPin(String pin, String salt) {
  var digest = sha256.convert(utf8.encode('$salt:${normalizePin(pin)}'));
  for (var i = 0; i < 2000; i++) {
    digest = sha256.convert([...digest.bytes, ...utf8.encode(salt)]);
  }
  return digest.toString();
}

bool pinMatches(String pin, String salt, String hash) =>
    isValidPin(pin) && hashPin(pin, salt) == hash;

enum PinResult { ok, wrong, lockedOut }

/// Slows down guessing: after [maxFailures] wrong tries in a row the PIN is
/// refused for [lockSeconds] seconds.
class PinThrottle {
  PinThrottle({this.maxFailures = 5, this.lockSeconds = 30});
  final int maxFailures;
  final int lockSeconds;
  int _failures = 0;
  DateTime? _lockedUntil;

  int secondsLeft(DateTime now) {
    final until = _lockedUntil;
    if (until == null || !until.isAfter(now)) return 0;
    return until.difference(now).inSeconds + 1;
  }

  bool isLocked(DateTime now) => secondsLeft(now) > 0;

  /// Call with the result of comparing the typed PIN.
  PinResult record({required bool correct, required DateTime now}) {
    if (isLocked(now)) return PinResult.lockedOut;
    if (correct) {
      _failures = 0;
      _lockedUntil = null;
      return PinResult.ok;
    }
    _failures++;
    if (_failures >= maxFailures) {
      _failures = 0;
      _lockedUntil = now.add(Duration(seconds: lockSeconds));
      return PinResult.lockedOut;
    }
    return PinResult.wrong;
  }
}
