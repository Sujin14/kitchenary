# Kitchenary

Learn it. Shop it. Cook it. A free Android cooking companion for India.

## Milestone status

| Milestone | Scope | Status |
| --- | --- | --- |
| M0 | Foundation: theme (light and dark), routing, Provider, fonts, icon | done |
| M1 | Recipes: TheMealDB search, categories, details, random recipe | done |
| M1.1 | go_router, flutter_screenutil, shimmer skeletons | done |
| M2 | Save, history, own recipes, profile, onboarding, legal pages | done |
| M3 | Cooking mode, ingredient scaler | built, needs testing |
| M4 | Timers and local notifications | built, needs testing |
| M5 | Shopping list and grocery app links | built, needs testing |
| M6 | Offline cache, dark-mode polish, release checklist | built, needs testing |

## Libraries

`provider` (state), `go_router` (navigation), `flutter_screenutil` (responsive sizes),
`shimmer` (skeleton loading), `hive_ce` + `hive_ce_flutter` (on-device storage), `wakelock_plus` (screen on while cooking),
`cached_network_image`, `http`, `url_launcher`.

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

## Before publishing

- Replace `AppConstants.supportEmail` (shown in the Privacy Policy and Terms).
- Have a lawyer review `lib/core/constants/legal_content.dart`, publish the same
  Privacy Policy at a public URL (Play Console asks for a link), and re-read it
  whenever a feature that touches data or permissions is added.

## On-device data

Saved recipes, history, your own recipes and settings are stored with Hive as
JSON strings (`LocalStore` interface, `HiveLocalStore` implementation). Nothing
leaves the phone. "Erase my data" on the Profile screen clears it all.

## Timers

Cooking mode finds times in a step ("simmer 10 minutes") and offers a
one-tap timer; the timer icon in the top bar starts a quick preset. Timers
keep running when you leave cooking mode and ring through a local
notification (no server). Asking for the notification permission happens when
the first timer starts. After adding the packages run
`dart run tool/configure_android.dart` once: it adds the notification
permissions and the Java desugaring the plugin needs.

## Shopping list

The Shopping tab keeps a list on the phone. "Add to shopping list" on a
recipe adds its ingredients at the chosen servings (names already on the list
are skipped); items can also be typed in. Tick items off, swipe to remove,
copy the list, or tap "Order online" for a guided order: pick one of Blinkit,
Zepto, Swiggy Instamart or BigBasket, then go item by item (search it in the
store, add it to the cart, come back, next) so everything ends up in one cart
and one order. The store icon on an item searches a store for just that item.
The stores offer no way for an app to fill a cart in one go, so this is as
close to one order as an independent app gets. The store addresses are in
`lib/core/constants/grocery_stores.dart` and are not confirmed with the stores:
**test each one on a phone before every release** and fix them there.

## Offline use

Recipes you load are kept on the phone (feeds, searches and full recipes, up
to 300 entries, oldest dropped first). Without internet the Home feed shows the
saved copy with a notice, recipes you have opened before still open, and
"surprise me" picks from them. Full recipes are served from the phone first.
"Erase my data" clears this too. Saved and history recipes only open offline if
they were opened online at least once.

## Release

See `RELEASE.md` for the full checklist. The one that can stop you: TheMealDB's
free key is not allowed for apps published on a store.

## Servings and amounts

TheMealDB does not say how many people a recipe feeds, so its recipes are treated
as written for 4 (`Recipe.defaultServings`). Your own recipes carry the number you
enter. The servings stepper rescales the leading number of each measure
(`QuantityScaler`); text like "to taste" is left as it is.

## Recipe data

Recipes come from [TheMealDB](https://www.themealdb.com/api.php) using the free
test key `1`. Read their terms before a public release; a supporter key can be
passed with `--dart-define=MEALDB_API_KEY=...`. All access is behind
`RecipeService`, so the source can be replaced in one file.

## Fonts

Fraunces and DM Sans are bundled in `assets/fonts/` (SIL Open Font License,
text in `assets/fonts/OFL.txt`).
