import 'package:kitchenary/services/local_store.dart';

/// [LocalStore] that keeps everything in memory. Used in tests.
final class MemoryLocalStore implements LocalStore {
  final Map<String, String> data = {};

  @override
  String? read(String key) => data[key];

  @override
  Future<void> write(String key, String value) async => data[key] = value;

  @override
  Future<void> remove(String key) async => data.remove(key);
}
