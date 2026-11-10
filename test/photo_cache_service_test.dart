import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/services/cache_manager_photo_cache_service.dart';

// Records emptyCache calls; can be told to fail.
class _FakeCacheManager implements BaseCacheManager {
  _FakeCacheManager({this.fail = false});

  final bool fail;
  int emptyCalls = 0;

  @override
  Future<void> emptyCache() async {
    emptyCalls++;
    if (fail) throw Exception('disk error');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('clear empties the image cache', () async {
    final manager = _FakeCacheManager();
    await CacheManagerPhotoCacheService(manager).clear();
    expect(manager.emptyCalls, 1);
  });

  test('clear does not throw when the cache cannot be emptied', () async {
    final manager = _FakeCacheManager(fail: true);
    await expectLater(CacheManagerPhotoCacheService(manager).clear(), completes);
    expect(manager.emptyCalls, 1);
  });
}
