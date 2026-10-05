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
3. **Navigation with `go_router`.** Routes live in `AppRouter`; widgets navigate
   through `context.openRecipe(...)`, `context.goHome()`, `context.popOrHome()`
   (`core/navigation/app_navigation.dart`) so they never import screens.
3a. **Storage:** controllers use `RecipeListRepository` / `SettingsRepository`
   on top of the `LocalStore` interface. Never import `hive` outside
   `hive_local_store.dart`. Tests use `MemoryLocalStore`.
3b. **Device features** (keeping the screen awake, timer notifications) go
   behind a service interface, like `ScreenAwakeService`, so tests use a fake.
4. **State** with `provider` only. No other state-management package.
4a. **Sizing with `flutter_screenutil`:** use `.w` (width), `.h` (height),
   `.r` (radius, icon box, square sizes) and `.sp` (font size) for every size,
   padding and radius (design size 390x844). A widget using them cannot be
   `const`, and neither can its parents.
4b. **Loading uses `shimmer` skeletons that mirror the real layout.** Every
   screen section that loads has a `<Name>Skeleton` twin built from
   `SkeletonBox` inside one `ShimmerScope`, sharing sizes with the real widget.
   Never use a bare spinner for a screen or list.
5. **Dart style:** wildcard parameters (`(_, _) =>`), `const` for locals that can
   be const, trailing commas. **Imports:** `package:kitchenary/...` only (no relative imports), sorted.
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
