// The on-device cache of recipe photos downloaded for offline viewing.
abstract interface class PhotoCacheService {
  // Deletes every cached photo.
  Future<void> clear();
}
