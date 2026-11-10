import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/controllers/history_controller.dart';
import 'package:kitchenary/controllers/own_recipes_controller.dart';
import 'package:kitchenary/controllers/saved_recipes_controller.dart';
import 'package:kitchenary/controllers/settings_controller.dart';
import 'package:kitchenary/controllers/shopping_list_controller.dart';
import 'package:kitchenary/core/constants/storage_keys.dart';
import 'package:kitchenary/core/theme/app_theme.dart';
import 'package:kitchenary/services/memory_local_store.dart';
import 'package:kitchenary/services/photo_cache_service.dart';
import 'package:kitchenary/services/recipe_cache.dart';
import 'package:kitchenary/services/recipe_list_repository.dart';
import 'package:kitchenary/services/settings_repository.dart';
import 'package:kitchenary/services/shopping_list_repository.dart';
import 'package:kitchenary/views/widgets/profile/erase_data_tile.dart';
import 'package:provider/provider.dart';

import 'helpers/fake_photo_cache_service.dart';

void main() {
  late MemoryLocalStore store;
  late SettingsController settings;
  late ShoppingListController shopping;

  setUp(() {
    store = MemoryLocalStore();
    settings = SettingsController(SettingsRepository(store));
    shopping = ShoppingListController(
      ShoppingListRepository(store, StorageKeys.shoppingList),
    );
  });

  Future<void> pumpTile(WidgetTester tester, PhotoCacheService photos) {
    return tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<RecipeCache>(create: (_) => RecipeCache(store)),
          Provider<PhotoCacheService>.value(value: photos),
          ChangeNotifierProvider.value(value: settings),
          ChangeNotifierProvider.value(value: shopping),
          ChangeNotifierProvider(
            create: (_) => SavedRecipesController(
              RecipeListRepository(store, StorageKeys.savedRecipes),
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => HistoryController(
              RecipeListRepository(store, StorageKeys.history),
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => OwnRecipesController(
              RecipeListRepository(store, StorageKeys.ownRecipes),
            ),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (_, _) => MaterialApp(
            theme: AppTheme.light,
            home: const Scaffold(body: EraseDataTile()),
          ),
        ),
      ),
    );
  }

  Future<void> eraseAndConfirm(WidgetTester tester, {required bool confirm}) async {
    await tester.tap(find.text('Erase my data'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(confirm ? 'Erase' : 'Cancel'));
    await tester.pumpAndSettle();
  }

  testWidgets('erasing clears cached photos after the other data', (
    tester,
  ) async {
    await settings.setUserName('Asha');
    await shopping.addCustom('Onions');
    var dataGoneBeforePhotos = false;
    final photos = FakePhotoCacheService(
      onClear: () => dataGoneBeforePhotos =
          shopping.items.isEmpty && !settings.hasName,
    );

    await pumpTile(tester, photos);
    await eraseAndConfirm(tester, confirm: true);

    expect(photos.clearCalls, 1);
    expect(dataGoneBeforePhotos, isTrue);
    expect(find.text('Your data was erased'), findsOneWidget);
  });

  testWidgets('cancelling keeps cached photos', (tester) async {
    final photos = FakePhotoCacheService();

    await pumpTile(tester, photos);
    await eraseAndConfirm(tester, confirm: false);

    expect(photos.clearCalls, 0);
  });
}
