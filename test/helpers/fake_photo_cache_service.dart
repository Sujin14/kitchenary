import 'package:kitchenary/services/photo_cache_service.dart';

// Counts how often the photo cache was cleared.
class FakePhotoCacheService implements PhotoCacheService {
  FakePhotoCacheService({this.onClear});

  // Runs when [clear] is called, e.g. to check what was erased before it.
  final void Function()? onClear;

  int clearCalls = 0;

  @override
  Future<void> clear() async {
    clearCalls++;
    onClear?.call();
  }
}
