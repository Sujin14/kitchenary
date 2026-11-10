import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kitchenary/services/photo_cache_service.dart';

// [PhotoCacheService] backed by the cache that `cached_network_image` uses
// by default ([DefaultCacheManager]).
class CacheManagerPhotoCacheService implements PhotoCacheService {
  CacheManagerPhotoCacheService([BaseCacheManager? cacheManager])
      : _cacheManager = cacheManager ?? DefaultCacheManager();

  final BaseCacheManager _cacheManager;

  @override
  Future<void> clear() async {
    try {
      await _cacheManager.emptyCache();
    } catch (error) {
      // A file that cannot be deleted must not stop the rest of the erase.
      debugPrint('Could not empty the photo cache: $error');
    }
  }
}
