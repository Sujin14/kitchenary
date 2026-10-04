# Kitchenary: rules for AI coding agents

Kitchenary is a free Flutter cooking app for India (Android first): recipes from
TheMealDB, step-by-step cooking mode, timers, and links to grocery apps.

## Architecture (MVC with Provider)

- `lib/models/` (M): plain data classes. No Flutter widgets, no I/O.
- `lib/controllers/` (C): `ChangeNotifier` classes. The only thing views watch.
- `lib/views/screens/` (V): thin screens. They ONLY compose widgets from
  `lib/views/widgets/`. Never define a widget class inside a screen file.
- `lib/views/widgets/<feature>/`: one widget per file.
- `lib/services/`: all network, disk and OS access, behind interfaces
  (e.g. `RecipeService`). Controllers depend on interfaces, never on `http`.
- `lib/core/`: theme, constants, routing, extensions, utilities.

## Hard rules

1. **Colours:** raw colour values exist ONLY in `lib/core/theme/app_colors.dart`.
   Widgets use `context.palette.<token>`. Never use `Colors.*` or `Color(0x..)`
   elsewhere. Every screen must work in light and dark.
2. **One widget per file**; screens contain no widget classes.
3. **Navigation by route name** (`AppRoutes`), so widgets never import screens.
4. **State** with `provider` only. No other state-management package.
5. **Imports:** `package:kitchenary/...` only (no relative imports), sorted.
6. **No secrets in source.** Build-time values use `--dart-define`.
7. **Free only:** no paid services, no ads, no analytics SDKs.
8. Every new controller and service gets unit tests in `test/`.
9. After every change run `flutter analyze` and `flutter test`; both must pass.

## Commands

    flutter create --org app.kitchenary --project-name kitchenary --platforms=android .
    dart run tool/configure_android.dart
    # delete test/widget_test.dart if flutter create generated it
    flutter pub get
    flutter analyze
    flutter test
    flutter run
