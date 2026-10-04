import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:kitchenary/core/constants/app_constants.dart';
import 'package:kitchenary/services/local_store.dart';

/// [LocalStore] backed by a Hive box. Values are JSON strings, so no
/// generated adapters are needed.
final class HiveLocalStore implements LocalStore {
  HiveLocalStore._(this._box);

  final Box<String> _box;

  /// Opens (and creates, on first run) the box. Call once from `main`.
  static Future<HiveLocalStore> open() async {
    await Hive.initFlutter();
    final box = await Hive.openBox<String>(AppConstants.storageBox);
    return HiveLocalStore._(box);
  }

  @override
  String? read(String key) => _box.get(key);

  @override
  Future<void> write(String key, String value) => _box.put(key, value);

  @override
  Future<void> remove(String key) => _box.delete(key);
}
