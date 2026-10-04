# Kitchenary

Learn it. Shop it. Cook it. A free Android cooking companion for India.

## Milestone status

| Milestone | Scope | Status |
| --- | --- | --- |
| M0 | Foundation: theme (light and dark), routing, Provider, fonts, icon | done |
| M1 | Recipes: TheMealDB search, categories, details, random recipe | done |
| M2 | Save, history, own recipes, profile, onboarding, legal pages | next |
| M3 | Cooking mode, ingredient scaler | planned |
| M4 | Timers and local notifications | planned |
| M5 | Shopping list and grocery app links | planned |
| M6 | Offline cache, dark-mode polish, release checklist | planned |

## First run

From this folder:

1. `flutter create --org app.kitchenary --project-name kitchenary --platforms=android .`
2. `dart run tool/configure_android.dart`
3. `flutter pub get`
4. `flutter analyze` and `flutter test`
5. `flutter run`

`flutter create` adds the `android/` folder. It may also add
`test/widget_test.dart` (a sample test for a different app): delete that file.
If it changed `lib/main.dart` or `pubspec.yaml`, restore ours from the zip.

## Recipe data

Recipes come from [TheMealDB](https://www.themealdb.com/api.php) using the free
test key `1`. Read their terms before a public release; a supporter key can be
passed with `--dart-define=MEALDB_API_KEY=...`. All access is behind
`RecipeService`, so the source can be replaced in one file.

## Fonts

Fraunces and DM Sans are bundled in `assets/fonts/` (SIL Open Font License,
text in `assets/fonts/OFL.txt`).
