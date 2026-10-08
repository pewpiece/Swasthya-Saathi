import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/photo_store.dart';
import '../../l10n/app_localizations.dart';

/// Round profile picture; falls back to the first letter of the name.
class PatientAvatar extends ConsumerWidget {
  const PatientAvatar({super.key, required this.name, this.photo, this.radius = 20});

  final String name;

  /// Stored photo file name (Patient.photoPath).
  final String? photo;
  final double radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final scheme = Theme.of(context).colorScheme;
    final path = ref.watch(photoPathProvider(photo)).value;
    final initial = name.trim().isEmpty ? '' : name.trim().characters.first.toUpperCase();
    return Semantics(
      image: true,
      label: l.photoOf(name),
      excludeSemantics: true,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        backgroundImage: path == null ? null : FileImage(File(path)),
        child: path == null
            ? (initial.isEmpty
                ? Icon(Icons.person, size: radius * 1.2)
                : Text(initial,
                    style: TextStyle(fontSize: radius * 0.95, fontWeight: FontWeight.w700)))
            : null,
      ),
    );
  }
}
