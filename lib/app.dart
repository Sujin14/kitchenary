import 'package:flutter/material.dart';
import 'package:kitchenary/controllers/home_controller.dart';
import 'package:kitchenary/core/constants/app_constants.dart';
import 'package:kitchenary/core/navigation/app_router.dart';
import 'package:kitchenary/core/navigation/app_routes.dart';
import 'package:kitchenary/core/theme/app_theme.dart';
import 'package:kitchenary/services/mealdb_recipe_service.dart';
import 'package:kitchenary/services/recipe_service.dart';
import 'package:kitchenary/services/url_launcher_service.dart';
import 'package:provider/provider.dart';

/// Root widget: wires services and controllers (Provider) and the theme.
class KitchenaryApp extends StatelessWidget {
  const KitchenaryApp({super.key});

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
        // Controllers
        ChangeNotifierProvider<HomeController>(
          create: (context) => HomeController(context.read<RecipeService>()),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
