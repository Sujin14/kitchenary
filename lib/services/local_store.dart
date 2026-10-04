/// A tiny on-device key-value store (strings only).
///
/// Reads are synchronous because the store is opened before the app starts.
/// Controllers and repositories depend on this interface, never on Hive.
abstract interface class LocalStore {
  String? read(String key);
  Future<void> write(String key, String value);
  Future<void> remove(String key);
}
