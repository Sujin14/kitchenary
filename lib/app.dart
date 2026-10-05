import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/controllers/history_controller.dart';
import 'package:kitchenary/controllers/home_controller.dart';
import 'package:kitchenary/controllers/own_recipes_controller.dart';
import 'package:kitchenary/controllers/saved_recipes_controller.dart';
import 'package:kitchenary/controllers/settings_controller.dart';
import 'package:kitchenary/controllers/timers_controller.dart';
import 'package:kitchenary/core/constants/app_constants.dart';
import 'package:kitchenary/core/constants/storage_keys.dart';
import 'package:kitchenary/core/navigation/app_router.dart';
import 'package:kitchenary/core/theme/app_theme.dart';
import 'package:kitchenary/services/alarm_sound_service.dart';
import 'package:kitchenary/services/local_notification_service.dart';
import 'package:kitchenary/services/local_store.dart';
import 'package:kitchenary/services/mealdb_recipe_service.dart';
import 'package:kitchenary/services/notification_service.dart';
import 'package:kitchenary/services/platform_alarm_sound_service.dart';
import 'package:kitchenary/services/recipe_list_repository.dart';
import 'package:kitchenary/services/recipe_service.dart';
import 'package:kitchenary/services/screen_awake_service.dart';
import 'package:kitchenary/services/settings_repository.dart';
import 'package:kitchenary/services/url_launcher_service.dart';
import 'package:kitchenary/services/wakelock_screen_awake_service.dart';
import 'package:provider/provider.dart';

/// Root widget: wires services and controllers (Provider), screen scaling
/// (ScreenUtil), routing (go_router) and the theme.
class KitchenaryApp extends StatelessWidget {
  const KitchenaryApp({required this.store, super.key});

  /// The opened on-device store (see `HiveLocalStore`).
  final LocalStore store;

  /// Layout is designed at this size (logical pixels); everything scales.
  static const Size designSize = Size(390, 844);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider<RecipeService>(
          create: (_) => MealDbRecipeService(),
          dispose: (_, service) => service.dispose(),
        ),
        Provider<UrlLauncherService>(
          create: (_) => const UrlLauncherService(),
        ),
        Provider<ScreenAwakeService>(
          create: (_) => const WakelockScreenAwakeService(),
        ),
        Provider<NotificationService>(
          create: (_) => LocalNotificationService(),
        ),
        Provider<AlarmSoundService>(
          create: (_) => const PlatformAlarmSoundService(),
        ),
        // Controllers
        ChangeNotifierProvider<SettingsController>(
          create: (_) => SettingsController(SettingsRepository(store)),
        ),
        ChangeNotifierProvider<SavedRecipesController>(
          create: (_) => SavedRecipesController(
            RecipeListRepository(store, StorageKeys.savedRecipes),
          ),
        ),
        ChangeNotifierProvider<HistoryController>(
          create: (_) => HistoryController(
            RecipeListRepository(store, StorageKeys.history),
          ),
        ),
        ChangeNotifierProvider<OwnRecipesController>(
          create: (_) => OwnRecipesController(
            RecipeListRepository(store, StorageKeys.ownRecipes),
          ),
        ),
        ChangeNotifierProvider<TimersController>(
          create: (context) => TimersController(
            context.read<NotificationService>(),
            context.read<AlarmSoundService>(),
          ),
        ),
        ChangeNotifierProvider<HomeController>(
          create: (context) => HomeController(context.read<RecipeService>()),
        ),
      ],
      child: ScreenUtilInit(
        designSize: designSize,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) => MaterialApp.router(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: context.select<SettingsController, ThemeMode>(
            (settings) => settings.themeMode,
          ),
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
