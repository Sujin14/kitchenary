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
import 'package:kitchenary/views/screens/profile_screen.dart';
import 'package:kitchenary/views/widgets/profile/settings_section.dart';
import 'package:provider/provider.dart';

import 'helpers/fake_photo_cache_service.dart';

void main() {
  Future<void> pumpProfile(WidgetTester tester, {required bool dark}) {
    // A phone at the design size, so rows below the fold need scrolling.
    tester.view
      ..physicalSize = const Size(1170, 2532)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final store = MemoryLocalStore();
    return tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<RecipeCache>(create: (_) => RecipeCache(store)),
          Provider<PhotoCacheService>(create: (_) => FakePhotoCacheService()),
          ChangeNotifierProvider(
            create: (_) => SettingsController(SettingsRepository(store)),
          ),
          ChangeNotifierProvider(
            create: (_) => ShoppingListController(
              ShoppingListRepository(store, StorageKeys.shoppingList),
            ),
          ),
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
            theme: dark ? AppTheme.dark : AppTheme.light,
            home: const ProfileScreen(),
          ),
        ),
      ),
    );
  }

  final notices = find.text('Open-source notices');

  testWidgets('Open-source notices sits in ABOUT between About and Version', (
    tester,
  ) async {
    await pumpProfile(tester, dark: false);
    await tester.ensureVisible(find.text('Version'));
    await tester.pumpAndSettle();

    final aboutCard = find.byWidgetPredicate(
      (w) => w is SettingsSection && w.title == 'ABOUT',
    );
    expect(find.descendant(of: aboutCard, matching: notices), findsOneWidget);

    double top(String text) => tester.getTopLeft(find.text(text)).dy;
    expect(top('About Kitchenary'), lessThan(top('Open-source notices')));
    expect(top('Open-source notices'), lessThan(top('Version')));

    // Five rows, so exactly four dividers between them.
    expect(
      find.descendant(of: aboutCard, matching: find.byType(Divider)),
      findsNWidgets(4),
    );
  });

  for (final dark in [false, true]) {
    testWidgets(
      'tapping Open-source notices opens the licence page '
      '(${dark ? 'dark' : 'light'})',
      (tester) async {
        await pumpProfile(tester, dark: dark);
        await tester.ensureVisible(notices);
        await tester.pumpAndSettle();
        await tester.tap(notices);
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(find.byType(LicensePage), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
