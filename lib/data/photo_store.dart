import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Where the profile photo comes from.
enum PhotoSource { camera, gallery }

/// Keeps the one profile photo in the app's private folder (no other app can
/// read it, it is not in the phone's gallery, and it never leaves the phone).
/// Tests replace this with a fake.
class PhotoStore {
  Future<Directory> _dir() async {
    final base = await getApplicationDocumentsDirectory();
    final d = Directory('${base.path}/photos');
    if (!await d.exists()) await d.create(recursive: true);
    return d;
  }

  /// Lets the user take/choose a picture, shrinks it, and stores a private
  /// copy. Returns the stored file name, or null when cancelled.
  Future<String?> pick(PhotoSource source) async {
    final picked = await ImagePicker().pickImage(
      source: source == PhotoSource.camera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (picked == null) return null;
    final dir = await _dir();
    // A new name every time, so the screen never shows an old cached picture.
    final name = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
    await File(picked.path).copy('${dir.path}/$name');
    try {
      await File(picked.path).delete(); // the picker's temporary copy
    } catch (_) {}
    return name;
  }

  /// Full path of a stored photo, or null when it does not exist.
  Future<String?> pathOf(String? name) async {
    if (name == null || name.isEmpty || name.contains('/')) return null;
    final f = File('${(await _dir()).path}/$name');
    return await f.exists() ? f.path : null;
  }

  Future<void> remove(String? name) async {
    final path = await pathOf(name);
    if (path != null) await File(path).delete();
  }

  /// Deletes every stored photo ("Delete all data").
  Future<void> removeAll() async {
    final d = await _dir();
    await for (final e in d.list()) {
      if (e is File) await e.delete();
    }
  }
}

final photoStoreProvider = Provider((ref) => PhotoStore());

/// Full path of the stored photo for a file name (null = no photo).
final photoPathProvider = FutureProvider.family<String?, String?>(
  (ref, name) => ref.watch(photoStoreProvider).pathOf(name),
);
